*** Settings ***
Resource                ../lib/resource.txt

Library                 OperatingSystem

*** Keywords ***

Wait For Host To Ping
    [Arguments]     ${host}
    Wait Until Keyword Succeeds     ${OPENBMC_REBOOT_TIMEOUT}min    5 sec   Ping Host   ${host}

Ping Host
    [Arguments]     ${host}
    ${RC}   ${output} =     Run and return RC and Output    ping -c 4 ${host}
    Log     RC: ${RC}\nOutput:\n${output}
    Should be equal     ${RC}   ${0}

Get Boot Progress
    ${state} =     Read Attribute    /org/openbmc/sensors/host/BootProgress    value
    [return]  ${state}

Is Power On
    ${state} =    Get Boot Progress
    Should be equal   ${state}     FW Progress, Starting OS

Is Power Off
    ${state} =    Get Boot Progress
    Should be equal   ${state}     Off

Power On Host
    @{arglist}=   Create List
    ${args}=     Create Dictionary    data=@{arglist}
    ${resp}=   Call Method    /org/openbmc/control/chassis0/    powerOn    data=${args}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    Wait Until Keyword Succeeds	  3 min    	10 sec    Is Power On

Power Off Host
    @{arglist}=   Create List
    ${args}=     Create Dictionary    data=@{arglist}
    ${resp}=   Call Method    /org/openbmc/control/chassis0/    powerOff   data=${args}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    Wait Until Keyword Succeeds	  1 min    	10 sec    Is Power Off
