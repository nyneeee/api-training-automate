*** Settings ***
Resource     ../../arcadia.automate.buffet/APIBuffet/RequestLibrary_APICommonKeywords.robot
Resource     ../../Resources/Keywords/compare_data.resource
Library      ../../CustomLibraryAPI/lib_api.py

*** Keywords ***
Set Default Api Header 
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

Set Api Body Request
    [Documentation]    Owner : Patipan.w  
    [Tags]    keyword_action
    [Arguments]    ${path}
    ${body_request}    Load Json From File    file_name=${path}    encoding=UTF-8
    Set Test Variable    ${body_request}    ${body_request}

Send Request Api
    [Documentation]    Owner : Patipan.w
    [Tags]    keyword_action
    [Arguments]    ${method}    ${verify_ecode}    ${url}    
    ...    ${path_body_request}=${None}     
    ...    ${ignore_ssl_certificate}=${False}
    ...    ${timeout}=${request_Api_timeout}
    ${method}    Convert To Upper Case     ${method}
    Set Default Api Header
    IF  $path_body_request != $None    Set Api Body Request   ${path_body_request}
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