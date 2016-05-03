*** Settings ***
Documentation          This suite is used for testing eventlog association.

Resource        ../lib/rest_client.robot
Resource        ../lib/utils.robot

Library         BuiltIn
Library         Collections
Library         SSHLibrary

*** Variables ***

${SYSTEM_SHUTDOWN_TIME}           1min

${WAIT_FOR_SERVICES_UP}           3min

${CREATE_ERROR_SINGLE_FRU}        busctl call org.openbmc.records.events /org/openbmc/records/events org.openbmc.recordlog acceptHostMessage sssay "Error" "Testing failure" "/org/openbmc/inventory/system/chassis/motherboard/dimm1" 1 1

${CREATE_ERROR_INVALID_FRU}       busctl call org.openbmc.records.events /org/openbmc/records/events org.openbmc.recordlog acceptHostMessage sssay "Error" "Testing with invalid FRU" "abc" 1 1

${CREATE_ERROR_NO_FRU}            busctl call org.openbmc.records.events /org/openbmc/records/events org.openbmc.recordlog acceptHostMessage sssay "Error" "Testing with no fru" "" 1 1

${CREATE_ERROR_VIRTUAL_SENSOR}    busctl call org.openbmc.records.events /org/openbmc/records/events org.openbmc.recordlog acceptHostMessage sssay "Error" "Testing with a virtual sensor" "/org/openbmc/inventory/system/systemevent " 1 1

${DIMM1_URI}                      /org/openbmc/inventory/system/chassis/motherboard/dimm1

${DIMM2_URI}                      /org/openbmc/inventory/system/chassis/motherboard/dimm2

${DIMM3_URI}                      /org/openbmc/inventory/system/chassis/motherboard/dimm3

&{NIL}                            data=@{EMPTY}

*** Test Cases ***

Create error log on single FRU
    [Documentation]     ***GOOD PATH***
    ...                 Create an error log on single FRU and verify
    ...                 its association.\n

    Clear all logs

    Open Connection And Log In
    ${output}=      Execute Command    ${CREATE_ERROR_SINGLE_FRU}

    ${log_list} =     Get EventList
    ${association_uri} =    catenate    SEPARATOR=   ${log_list[0]}   /fru

    ${association_content} =     Read Attribute    ${association_uri}    endpoints
    Should Contain     ${association_content}    ${DIMM1_URI}

    ${dimm1_event} =     Read Attribute     ${DIMM1_URI}/event   endpoints
    Should Contain     ${dimm1_event}    ${log_list[0]}


Create error log on two FRU
    [Documentation]     ***GOOD PATH***
    ...                 Create an error log on two FRUs and verify
    ...                 its association.\n

    ${log_uri} =      Create a test log
    ${association_uri} =    catenate    SEPARATOR=   ${log_uri}   /fru

    ${association_content} =     Read Attribute    ${association_uri}    endpoints
    Should Contain     ${association_content}    ${DIMM3_URI}
    Should Contain     ${association_content}    ${DIMM2_URI}

    ${dimm3_event} =     Read Attribute     ${DIMM3_URI}/event   endpoints
    Should Contain     ${dimm3_event}    ${log_uri}

    ${dimm2_event} =     Read Attribute     ${DIMM2_URI}/event   endpoints
    Should Contain     ${dimm2_event}    ${log_uri}


Create multiple error logs
    [Documentation]     ***GOOD PATH***
    ...                 Create multiple error logs and verify 
    ...                 their association.\n

    : FOR    ${INDEX}    IN RANGE    1    4
        \    Log    ${INDEX}
        \    ${log_uri} =      Create a test log
        \    ${association_uri} =    catenate    SEPARATOR=   ${log_uri}   /fru

        \    ${association_content} =     Read Attribute    ${association_uri}    endpoints
        \    Should Contain     ${association_content}    ${DIMM3_URI}
        \    Should Contain     ${association_content}    ${DIMM2_URI}

        \    ${dimm3_event} =     Read Attribute     ${DIMM3_URI}/event   endpoints
        \    Should Contain     ${dimm3_event}    ${log_uri}

        \    ${dimm2_event} =     Read Attribute     ${DIMM2_URI}/event   endpoints
        \    Should Contain     ${dimm2_event}    ${log_uri}


Delete error log
    [Documentation]     ***BAD PATH***
    ...                 Delete an error log and verify that its 
    ...                 association is also removed.\n

    ${log_uri1} =      Create a test log
    ${association_uri1} =    catenate    SEPARATOR=   ${log_uri1}   /fru

    ${log_uri2} =      Create a test log

    ${del_uri} =  catenate    SEPARATOR=   ${log_uri1}   /action/delete
    ${resp} =    openbmc post request     ${del_uri}    data=${NIL}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}

    ${resp} =     openbmc get request     ${association_uri1}
    ${jsondata} =    to json    ${resp.content}
    Should Contain     ${jsondata['message']}    404 Not Found

    ${dimm3_event} =     Read Attribute      ${DIMM3_URI}/event   endpoints
    Should Not Contain     ${dimm3_event}    ${log_uri1}

    ${dimm2_event} =     Read Attribute      ${DIMM2_URI}/event   endpoints
    Should Not Contain     ${dimm2_event}    ${log_uri1}


Association with invalid FRU
    [Documentation]     ***BAD PATH***
    ...                 Create an error log on invalid FRU and verify 
    ...                 that its does not have any association.\n

    Clear all logs

    Open Connection And Log In
    ${output}=      Execute Command    ${CREATE_ERROR_INVALID_FRU}
    ${log_list} =     Get EventList
    ${association_uri} =    catenate    SEPARATOR=   ${log_list[0]}   /fru

    ${resp} =     openbmc get request     ${association_uri}
    ${jsondata} =    to json    ${resp.content}
    Should Contain     ${jsondata['message']}    404 Not Found


Assocition with no FRU error event
    [Documentation]     ***BAD PATH***
    ...                 Create an error log on no FRU and verify
    ...                 that its does not have any association.\n

    Clear all logs

    Open Connection And Log In
    ${output}=      Execute Command    ${CREATE_ERROR_NO_FRU}
    ${log_list} =     Get EventList
    ${association_uri} =    catenate    SEPARATOR=   ${log_list[0]}   /fru

    ${resp} =     openbmc get request     ${association_uri}
    ${jsondata} =    to json    ${resp.content}
    Should Contain     ${jsondata['message']}    404 Not Found


Association with virtual sensor
    [Documentation]     ***GOOD PATH***
    ...                 Create an error log on virtual sensor and
    ...                 verify its association.\n

    Clear all logs

    Open Connection And Log In
    ${output}=      Execute Command    ${CREATE_ERROR_VIRTUAL_SENSOR}
    ${log_list} =     Get EventList
    ${association_uri} =    catenate    SEPARATOR=   ${log_list[0]}   /fru

    ${association_content} =     Read Attribute    ${association_uri}    endpoints
    Should Contain     ${association_content}    /org/openbmc/inventory/system/systemevent

Association unchanged after reboot
    [Documentation]     ***GOOD PATH***
    ...                 This test case is to verify that error log association
    ...                 does not change after open bmc reboot.\n

    ${pre_reboot_log_uri} =      Create a test log
    ${association_uri} =    catenate    SEPARATOR=   ${pre_reboot_log_uri}   /fru
    ${pre_reboot_association_content} =     Read Attribute    ${association_uri}    endpoints

    Open Connection And Log In
    ${output}=      Execute Command    /sbin/reboot
    Sleep   ${SYSTEM_SHUTDOWN_TIME}
    Wait For Host To Ping   ${OPENBMC_HOST}
    Sleep   ${WAIT_FOR_SERVICES_UP}

    ${post_reboot_association_content} =     Read Attribute    ${association_uri}    endpoints
    Should Be Equal        ${pre_reboot_association_content}    ${pre_reboot_association_content}

    ${post_reboot_dimm3_event} =     Read Attribute      ${DIMM3_URI}/event   endpoints
    Should Contain     ${post_reboot_dimm3_event}    ${pre_reboot_log_uri}
    ${post_reboot_dimm2_event} =     Read Attribute      ${DIMM2_URI}/event   endpoints
    Should Contain     ${post_reboot_dimm2_event}    ${pre_reboot_log_uri}

*** Keywords ***

Get EventList
    ${resp} =   openbmc get request     /org/openbmc/records/events/
    should be equal as strings    ${resp.status_code}    ${HTTP_OK}
    ${jsondata} =    to json    ${resp.content}
    [return]    ${jsondata['data']}

Create a test log
    [arguments]
    ${data} =   create dictionary   data=@{EMPTY}
    ${resp} =   openbmc post request     /org/openbmc/records/events/action/acceptTestMessage    data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    ${LOGID} =    convert to integer    ${json['data']}
    ${uri}=     catenate    SEPARATOR=   /org/openbmc/records/events/   ${LOGID}
    [return]  ${uri}

Open Connection And Log In
    Open connection     ${OPENBMC_HOST}
    Login   ${OPENBMC_USERNAME}    ${OPENBMC_PASSWORD}

Clear all logs
    ${resp} =   openbmc post request     /org/openbmc/records/events/action/clear    data=${NIL}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${resp} =   openbmc get request     /org/openbmc/records/events/
    ${json} =   to json         ${resp.content}
    Should Be Empty     ${json['data']}
