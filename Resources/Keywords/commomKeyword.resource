*** Settings ***
Resource     ../../resource_init.resource

*** Keywords ***
Send Request API
    [Documentation]    Owner : Patipan.w
    [Arguments]    ${method}    ${verify_ecode}    ${url}    
    ...    ${path_body_request}=${None}     
    ...    ${ignore_ssl_certificate}=${True}
    ...    ${timeout}=${request_Api_timeout}
    ${method}    Convert To Upper Case     ${method}
    Set Default API Header
    IF  $path_body_request != $None    Set API Body Request   ${path_body_request}
    ...    ELSE    Set Test Variable       ${body_request}        ${path_body_request}
    ${response}    Run Keyword    ${method}    url=${url}    headers=${json_header}    json=${body_request}
    ...    expected_status=${verify_ecode}     timeout=${timeout}    verify=${ignore_ssl_certificate}
    ${msg_header}        Evaluate    json.dumps(${json_header}, indent=4, ensure_ascii=False)       json
    ${msg_body}          Evaluate    json.dumps(${body_request}, indent=4, ensure_ascii=False)      json
    ${msg_response}      Evaluate    json.dumps(${response.json()}, indent=4, ensure_ascii=False)   json    
    ${output_result}     Catenate
    ...    ${\n}**** Request ****
    ...    ${\n}Method: ${method}
    ...    ${\n}URL: ${url}
    ...    ${\n}Headers: ${msg_header}
    ...    ${\n}Body: ${msg_body}
    ...    ${\n}Verify Ecode: ${verify_ecode}
    ...    ${\n}
    ...    ${\n}**** Response ****
    ...    ${\n}---> ${msg_response}
    Log Many    ${output_result}
    Set Test Variable    ${response}    ${response}

Set Default API Header 
    [Documentation]    Owner : Patipan.w    
    [Arguments]    ${header}=${parameter_header_default}    
    &{default_header}    Create Dictionary
    ${count}             Get Length                item=${header}
    ${list_key}          Get Dictionary Keys       dictionary=${header}
    FOR  ${index}  IN RANGE    1    ${count} + 1
            ${key}       Get From List          list_=${list_key}               index=${index - 1}
            ${value}     Get From Dictionary    dictionary=${header}            key=${key}
            Set To Dictionary                   dictionary=${default_header}    ${key}=${value}
    END
    ${json_header}    Set Variable          ${default_header}
    Set Test Variable    ${json_header}     ${json_header}
    Log Many    ${json_header}

Set API Body Request
    [Documentation]    Owner : Patipan.w  
    [Arguments]    ${path}
    ${body_request}    Load Json From File    file_name=${path}    encoding=UTF-8
    Set Test Variable    ${body_request}    ${body_request}

Get List Key And Count From Json
    [Documentation]    Owner : Patipan.w 
    ...    Get list "key" from "response" and create "list" 
    ...    ${json_path} Config path : "./Resources/Response/file.json" 
    ...    ${type} Support ["ArrayObject", "Object"]
    [Tags]    keyword_action
    [Arguments]    ${json_path}    ${json_object}=${EMPTY}    
    IF  "${json_object}" == "${EMPTY}"
            @{values}	Get Value From Json    ${response.json()}	${json_path}
    ELSE
        @{values}	Get Value From Json    ${json_object}	${json_path}
    END
    ${value_type}    Check Type    @{values}
    IF    "${value_type}" == "<class 'dict'>"
            ${count}         Get Length    ${values}
            ${type_value}    Evaluate      type(${values})
    ELSE IF    "${value_type}" == "<class 'list'>"
                 ${count}         Get Length    ${values[${0}]}
                 ${type_value}    Evaluate      type(${values[${0}]})
    ELSE
        Fail    msg=No Support Type == "${value_type}",
    END
    Log Response Json    ${values}
    [Return]             ${count}

Log Response Json
    [Documentation]    Owner : Patipan.w
    [Tags]    keyword_action
    [Arguments]    ${json}
    ${json_formatter}    Evaluate    json.dumps(${json}, indent=4, ensure_ascii=False)    json
    Log Many    ${json_formatter}

Check Type
    [Documentation]    Owner : Patipan.w  
    [Tags]    keyword_action
    [Arguments]    ${value}
    ${type_value}    Evaluate    type($value)
    [Return]    ${type_value}