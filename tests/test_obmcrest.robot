*** Settings ***
Documentation		This suite will verifiy all OpenBMC rest interfaces
...					Details of valid interfaces can be found here...
...					https://github.com/openbmc/docs/blob/master/rest-api.md

Resource		../lib/rest_client.robot


*** Variables ***


*** Test Cases ***
Good connection for testing
    ${content}=    Read Properties     /
    ${c}=          get from List       ${content}      0
    Should Be Equal    ${c}     /org

Get an object with no properties 
    ${content}=    Read Properties     /org/openbmc/inventory
    Should Be Empty     ${content}

Get a Property
    ${resp}=   Read Attribute      /org/openbmc/inventory/system/chassis/motherboard/cpu0      is_fru
    Should Be Equal    ${resp}     ${1}

Get a null Property
    ${resp} =    OpenBMC Get Request    /org/openbmc/inventory/attr/is_fru
    Should Be Equal As Strings    ${resp.status_code}    ${HTTP_NOT_FOUND}
    ${jsondata}=    To Json    ${resp.content}
    Should Be Equal     ${jsondata['data']['description']}      The specified property cannot be found: ''is_fru''

get directory listing /
    ${resp} =   openbmc get request     /
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json     ${resp.content}
    list should contain value           ${json['data']}         /org
    should be equal as strings          ${json['status']}       ok

get directory listing /org/
    ${resp} =   openbmc get request     /org/
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    list should contain value           ${json['data']}     /org/openbmc
    should be equal as strings          ${json['status']}       ok

get invalid directory listing /i/dont/exist/
    ${resp} =   openbmc get request     /i/dont/exist/
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

put directory listing /
    ${resp} =   openbmc put request     /
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

put directory listing /org/
    ${resp} =   openbmc put request     /org/
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

put invalid directory listing /i/dont/exist/
    ${resp} =   openbmc put request     /i/dont/exist/
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

post directory listing /
    ${resp} =   openbmc post request    /
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

post directory listing /org/
    ${resp} =   openbmc post request    /org/
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

post invalid directory listing /i/dont/exist/
    ${resp} =   openbmc post request    /i/dont/exist/
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

delete directory listing /
    ${resp} =   openbmc delete request  /
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

delete directory listing /org/
    ${resp} =   openbmc delete request  /
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

delete invalid directory listing /org/nothere/
    ${resp} =   openbmc delete request  /org/nothere/
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings          ${json['status']}   error

get list names /
    ${resp} =   openbmc get request     /list
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    list should contain value       ${json['data']}         /org/openbmc/inventory
    should be equal as strings      ${json['status']}       ok

get list names /org/
    ${resp} =   openbmc get request     /org/list
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    list should contain value       ${json['data']}         /org/openbmc/inventory
    should be equal as strings      ${json['status']}       ok

get invalid list names /i/dont/exist/
    ${resp} =   openbmc get request     /i/dont/exist/list
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

put list names /
    ${resp} =   openbmc put request     /list
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

put list names /org/
    ${resp} =   openbmc put request     /org/list
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

put invalid list names /i/dont/exist/
    ${resp} =   openbmc put request     /i/dont/exist/list
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

post list names /
    ${resp} =   openbmc post request    /list
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

post list names /org/
    ${resp} =   openbmc post request    /org/list
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

post invalid list names /i/dont/exist/
    ${resp} =   openbmc post request    /i/dont/exist/list
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

delete list names /
    ${resp} =   openbmc delete request  /list
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

delete list names /org/
    ${resp} =   openbmc delete request  /list
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

delete invalid list names /org/nothere/
    ${resp} =   openbmc delete request  /org/nothere/list
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

get names /
    ${resp} =   openbmc get request     /enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    list should contain value       ${json['data']}         /org/openbmc/inventory
    should be equal as strings      ${json['status']}       ok

get names /org/
    ${resp} =   openbmc get request     /org/enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    list should contain value       ${json['data']}         /org/openbmc/inventory
    should be equal as strings      ${json['status']}       ok

get invalid names /i/dont/exist/
    ${resp} =   openbmc get request     /i/dont/exist/enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

put names /
    ${resp} =   openbmc put request     /enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

put names /org/
    ${resp} =   openbmc put request     /org/enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

put invalid names /i/dont/exist/
    ${resp} =   openbmc put request     /i/dont/exist/enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

post names /
    ${resp} =   openbmc post request    /enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

post names /org/
    ${resp} =   openbmc post request    /org/enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

post invalid names /i/dont/exist/
    ${resp} =   openbmc post request    /i/dont/exist/enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

delete names /
    ${resp} =   openbmc delete request  /enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

delete names /org/
    ${resp} =   openbmc delete request  /enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

delete invalid names /org/nothere/
    ${resp} =   openbmc delete request  /org/nothere/enumerate
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

get method org/openbmc/records/events/action/acceptTestMessage
    ${resp} =   openbmc get request     org/openbmc/records/events/action/acceptTestMessage
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

get invalid method /i/dont/exist/
    ${resp} =   openbmc get request     /i/dont/exist/action/foo
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

put method org/openbmc/records/events/action/acceptTestMessage
    ${resp} =   openbmc put request     org/openbmc/records/events/action/acceptTestMessage
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

put invalid method /i/dont/exist/
    ${resp} =   openbmc put request     /i/dont/exist/action/foo
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

post method power/getPowerState no args
    ${fan_uri}=     Get Power Control Interface
    ${data} =   create dictionary   data=@{EMPTY}
    ${resp} =   openbmc post request    ${fan_uri}/action/getPowerState      data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok

post method org/openbmc/records/events/action/acceptTestMessage invalid args
    ${data} =   create dictionary   foo=bar
    ${resp} =   openbmc post request    org/openbmc/records/events/action/acceptTestMessage      data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_BAD_REQUEST}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

post method org/openbmc/sensors/host/BootCount with args
    ${uri} =     Set Variable   /org/openbmc/sensors/host/BootCount
    ${COUNT}=   Set Variable    ${3}
    @{count_list} =   Create List     ${COUNT}
    ${data} =   create dictionary   data=@{count_list}
    ${resp} =   openbmc post request    ${uri}/action/setValue      data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok
    ${content}=     Read Attribute      ${uri}   value
    Should Be Equal     ${content}      ${COUNT}

delete method org/openbmc/records/events/action/acceptTestMessage
    ${resp} =   openbmc delete request  org/openbmc/records/events/action/acceptTestMessage
    should be equal as strings      ${resp.status_code}     ${HTTP_METHOD_NOT_ALLOWED} 
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error

delete invalid method /org/nothere/
    ${resp} =   openbmc delete request  /org/nothere/action/foomethod
    should be equal as strings      ${resp.status_code}     ${HTTP_NOT_FOUND}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       error
    
post method org/openbmc/records/events/action/acceptTestMessage no args 
    ${data} =   create dictionary   data=@{EMPTY}
    ${resp} =   openbmc post request    org/openbmc/records/events/action/acceptTestMessage      data=${data}
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}
    ${json} =   to json         ${resp.content}
    should be equal as strings      ${json['status']}       ok

***keywords***
Get Power Control Interface
    ${resp}=    OpenBMC Get Request     /org/openbmc/control/
    should be equal as strings      ${resp.status_code}     ${HTTP_OK}     msg=Unable to get any controls - /org/openbmc/control/
    ${jsondata}=   To Json    ${resp.content}
    log     ${jsondata}
    : FOR    ${ELEMENT}    IN    @{jsondata["data"]}
    \   log     ${ELEMENT}
    \   ${found}=   Get Lines Matching Pattern      ${ELEMENT}      *control/power*
    \   Return From Keyword If     '${found}' != ''     ${found}