*** Settings ***
Resource    ../../arcadia.automate.buffet/APIBuffet/RequestLibrary_APICommonKeywords.robot 
Library     String
Library     Collections
Library     RequestsLibrary
Library     JSONLibrary    
Library     OperatingSystem
Library      ../../CustomLibraryAPI/lib_compare.py
Variables    ../../Config/configs_site.yml

*** Variables ***
&{other_ecode}          new_feature=404
${url_mock_404}         https://reqres.in/api/users/23

*** Keywords ***
Create Dictionary To Verify Ecode
    [Documentation]    Owner : Patipan.w  
    [Tags]    keyword_action
    [Arguments]    ${status_code}
    &{dic_ecode}    Create Dictionary    
    ...    new_feature=${other_ecode.new_feature}   
    ...    expected_status=${status_code}
    [Return]    ${dic_ecode}

Fail Message Error Unknown Ecode
    [Documentation]    Owner : Patipan.w 
    [Arguments]    ${status_code}
    ${value_region}       Convert To Upper Case    ${region}
    ${value_testsite}     Convert To Upper Case    ${testsite}
    ${write_res_upper}    Convert To Upper Case    ${write_res}
    Should Not Be Empty    ${status_code}    
    ${error}     Catenate
    ...     ${\n}'[${write_res_upper}][REGION - ${value_region}][SITE - ${value_testsite}] - ${TEST_NAME}'
    ...     ${\n}---> Message == "Unknown Status Code"
    ...     ${\n}---> Support "Status Code" == "${status_code}"
    Fail    ${error}

Write Response To Json File
    [Documentation]    Owner : Patipan.w
    ...    Keyword for get response data to compare
    ...    $write_res : pre , post
    ...    $output_file format example : 
    ...    - "pre_response_asse"
    ...    - "post_response_asse"
    ...    - "pre_response_asea"
    ...    - "post_response_asea"
    [Tags]    keyword_action
    IF    ("${write_res}" == "pre" or "${write_res}" == "post")
            IF    ("${response.status_code}" == "${expected_status}")
                            Log Schema Json    ${response.json()}
                            ${json_content}    Evaluate    json.dumps($response.json())
            ELSE IF    ("${response.status_code}" == "${other_ecode.new_feature}")
                            ${ecode}           Set Variable    {"ecode": "${response.status_code}"}
                            ${ecode}    Convert String To Json    ${ecode}
                            ${json_content}    Evaluate    json.dumps($ecode)
            END
            ${output_file}    Set Variable           ${OUTPUTDIR}${/}..${/}${write_res}_response_${region}${/}${TEST_NAME}_response.json
            Create File       ${output_file}         ${json_content}     
            ${json_file}      Load Json From File    ${OUTPUTDIR}${/}..${/}${write_res}_response_${region}${/}${TEST_NAME}_response.json
            Log Many          ${json_file}
    ELSE
        ${error}    Catenate
        ...     ${\n}---> Fail: Unknown Arguments "$write_res".
        ...     ${\n}---> arg "$write_res" is support ['pre', 'post'] and receive "$write_res" arg = "${write_res}".
        Fail    ${error}    
    END

Get Data Response From Json File
    [Documentation]    Owner : Patipan.w
    ...    Keyword for get data from json file to compare
    ...    ${section_test} is support : "pre", "post"
    [Tags]    keyword_action
    [Arguments]    ${section_test}
    IF    ("${section_test}" == "pre" or "${section_test}" == "post")
            ${json_files}     Create List 
            ${file_list} =    List Files In Directory     ${OUTPUTDIR}${/}..${/}${section_test}_response_${region}${/}
            FOR  ${file}  IN   @{file_list}
                    IF    '${file}'.endswith('.json')    Append To List     ${json_files}    ${file}
                    ...    ELSE    Fail    msg=Not json file.
            END
            Log Many    Files: ${json_files}
    ELSE
        ${error}    Catenate
        ...     ${\n}---> Fail: Unknown Arguments "$section_test".
        ...     ${\n}---> arg "$section_test" is support ['pre', 'post'] and receive "$section_test" arg = "${section_test}".
        Fail    ${error}    
    END
    [Return]    ${json_files}

Json Response Should Be Equal
    [Documentation]    Owner : Patipan.w
    [Tags]    keyword_action
    [Arguments]    ${response_1}    ${response_2}
    ${status}    ${message}    Compare Values Should Be Equal      ${response_1}    ${response_2}
    IF    ${status} == ${False}    Fail    ---> Message: "${message}"    console=${True}
    ...    ELSE    Log    ---> Message: "${message}"    console=${True}

Check New Feature Api Compare
    [Documentation]    Owner : Patipan.w
    [Tags]    keyword_action
    [Arguments]    ${name_api_pre}    ${name_api_post}    ${value_region}    ${value_testsite}    ${path_file_pre_test_check_other_ecode.new_feature}
    ${ecode_pre_test}    Get Value From Json    ${path_file_pre_test_check_other_ecode.new_feature}    $.ecode
    ${ecode_pre_test}    Set Variable           ${ecode_pre_test}[0]
    Should Be True    int(${ecode_pre_test}) == int(${other_ecode.new_feature})
    ${skip_new_feature_compare_message}    Catenate
    ...    ${\n}'*** [Skip - Compare Json Schema][New Feature API][REGION - ${value_region}][SITE - ${value_testsite}] ***'
    ...    ${\n}---> 'Ecode: $Pre-Test("${ecode_pre_test}")'.
    ...    ${\n}---> '[New Feature API][Pre-Test][REGION - ${value_region}]  - ${name_api_pre}'.
    ...    ${\n}---> '[New Feature API][Post-Test][REGION - ${value_region}] - ${name_api_post}'.
    Log    ${skip_new_feature_compare_message}    level=WARN    console=${True}

Compare Data Response Json File
    [Documentation]    Owner : Patipan.w
    ...    Keyword for compare response json file
    ...    "Should Be Equal" และ "Should Be True" ปิดใช้งาน เนื่องจากไม่สามารถ Verify ในกรณีที่ Response ยาวเกิน 400 บรรทัด
    ...    - ใช้ "Compare Values Should Be Equal" แทน
    [Tags]    keyword_action
    @{list_file_pre_test}       Get Data Response From Json File    section_test=pre
    @{list_file_post_test}      Get Data Response From Json File    section_test=post
    ${Length_file_pre_test}             Get Length       ${list_file_pre_test}
    ${Length_file_post_test}            Get Length       ${list_file_post_test}
    Should Be True    int(${Length_file_pre_test}) == int(${Length_file_post_test})
    ${value_region}      Convert To Upper Case    ${region}
    ${value_testsite}    Convert To Upper Case    ${testsite}
    FOR  ${index}  IN RANGE    1    ${Length_file_pre_test}+1
         ${json_file_pre_test}       Load Json From File      ${OUTPUTDIR}${/}..${/}pre_response_${region}${/}${list_file_pre_test}[${index - 1}]
         ${json_file_post_test}      Load Json From File      ${OUTPUTDIR}${/}..${/}post_response_${region}${/}${list_file_post_test}[${index - 1}]
         IF  ("${list_file_pre_test}[${index - 1}]" != "CPC_API_1_1_001 Security Authentication_response.json")
                 IF    ("${list_file_pre_test}[${index - 1}]" == "${list_file_post_test}[${index - 1}]")
                           ${message_compare}    Catenate
                           ...    ${\n}'[Compare][REGION - ${value_region}][SITE - ${value_testsite}] - Response'
                           ...    ${\n}---> Pre-Test-${value_region}:  "${list_file_pre_test}[${index - 1}]"
                           ...    ${\n}---> Post-Test-${value_region}: "${list_file_post_test}[${index - 1}]"
                           Log    ${message_compare}    console=${True}
                           ${status_new_feature}    Run Keyword And Return Status     Check New Feature Api Compare    
                           ...    name_api_pre=${list_file_pre_test}[${index - 1}]    
                           ...    name_api_post=${list_file_post_test}[${index - 1}]
                           ...    value_region=${value_region}
                           ...    value_testsite=${value_testsite}
                           ...    path_file_pre_test_check_other_ecode.new_feature=${json_file_pre_test}
                           IF    ${status_new_feature} == ${False}    Json Response Should Be Equal    response_1=${json_file_pre_test}    response_2=${json_file_post_test}
                 ELSE
                     ${message_fail}    Catenate
                     ...    ${\n}'[Fail][REGION - ${value_region}][SITE - ${value_testsite}]'
                     ...    ${\n}File names don't match, cannot be compared. ("${list_file_pre_test}[${index - 1}]" != "${list_file_post_test}[${index - 1}]")
                     ...    ${\n}Pre-Test-${value_region}:  "${list_file_pre_test}[${index - 1}]"
                     ...    ${\n}Post-Test-${value_region}: "${list_file_post_test}[${index - 1}]"
                     Fail   ${message_fail}
                 END
         ELSE    
             ${message_compare}    Catenate
             ...    ${\n}'*** [Skip - Compare because new generate "token"][REGION - ${value_region}][SITE - ${value_testsite}] ***'
             ...    ${\n}---> Pre-Test-${value_region}:  "${list_file_pre_test}[${index - 1}]"
             ...    ${\n}---> Post-Test-${value_region}: "${list_file_post_test}[${index - 1}]"
             Log    ${message_compare}    level=WARN    console=${True}
         END
         Log                      ${list_file_pre_test}[${index - 1}]
         Log Schema Json          ${json_file_pre_test}     msg=Pre-Test-${value_region}-SITE-${value_testsite}
         Log Schema Json          ${json_file_post_test}    msg=Post-Test-${value_region}-SITE-${value_testsite}
    END

Check New Feature Api And Return Status
    [Documentation]    Owner : Patipan.w
    ...    ทางทีม TC ต้องการ "Log to console" ในกรณีที่มี "New Feature"
    ...    แล้วยิง API ไปที่ "SIT ตัวเก่า" ที่ยังไม่ได้ทำการ "Deploy New Feature" ตอน CI/CD แล้วจะได้รับ ecode "xxx"
    ...    จะให้ทำการ "Log to console" หรือ "Fail" ออกมาแสดง
    ...    $write_res : pre , post
    ...    $region : asse , asea
    ...    $testsite : Test , Production
    [Tags]    keyword_action
    ${value_region}       Convert To Upper Case    ${region}
    ${value_testsite}     Convert To Upper Case    ${testsite}
    ${write_res_upper}    Convert To Upper Case    ${write_res}
    IF  ("${response.status_code}" == "${expected_status}") and ("${write_res_upper}" == "PRE" or "${write_res_upper}" == "POST")
            ${message}    Catenate
            ...    ${\n}'[${write_res_upper}][REGION - ${value_region}][SITE - ${value_testsite}] - ${TEST_NAME}'
            ...    ${\n}---> Ecode: $Response("${response.status_code}") != $Ecode-New-Feature("${other_ecode.new_feature}").
            ...    ${\n}---> Verify Json Schema.
            Set Test Variable    ${status_new_feature}    ${False}
            Set Test Variable    ${log_message}           ${message}
            Set Test Variable    ${log_level}             INFO
    ELSE IF    ("${response.status_code}" == "${other_ecode.new_feature}") and ("${write_res_upper}" == "PRE")
                ${message}    Catenate
                ...    ${\n}'[${write_res_upper}][REGION - ${value_region}][SITE - ${value_testsite}][New Feature API] - ${TEST_NAME}'
                ...    ${\n}---> Ecode: $Response("${response.status_code}") == $Ecode-New-Feature("${other_ecode.new_feature}").
                ...    ${\n}---> Skip Verify Json Schema.
                Set Test Variable    ${status_new_feature}    ${True}
                Set Test Variable    ${log_message}           ${message}
                Set Test Variable    ${log_level}             WARN
    ELSE IF    ("${response.status_code}" == "${other_ecode.new_feature}") and ("${write_res_upper}" == "POST")
                ${error}    Catenate
                ...     ${\n}'[${write_res_upper}][REGION - ${value_region}][SITE - ${value_testsite}][ERROR ${other_ecode.new_feature}] - ${TEST_NAME}'
                ...     ${\n}---> Status code response == "${other_ecode.new_feature}"
                ...     ${\n}---> "Data not found" or "New feature api" or "Deploy not complete"
                ...     ${\n}---> Please check "domain" in file "./Config/configs_site.yml".
                ...     ${\n}---> Please check "path" in file "./TestSite/url_cpc_api.resource".
                Fail    ${error}
    ELSE
        ${error}    Catenate
        ...     ${\n}---> Fail: Unknown Arguments "$write_res" or $ecode_response.
        ...     ${\n}---> arg "$write_res" is support ['pre', 'post'] and receive "$write_res" arg = "${write_res}".
        ...     ${\n}---> $ecode_response is support ['${expected_status}', '${other_ecode.new_feature}'] and receive ecode response = "${response.status_code}".
        Fail    ${error}    
    END
    Log         ${log_message}    level=${log_level}    console=${True}
    [Return]    ${status_new_feature}    ${log_message}    ${log_level}

# ! -------------------- Main 404 --------------------- !
Set Body 404
    [Documentation]    Owner : Patipan.w
    [Tags]    Mockup
    Set API Header default       
    
Send Request 404
    [Documentation]    Owner : Patipan.w
    [Tags]    Mockup
    [Arguments]    ${method}=GET   ${url}=${url_mock_404}
    ${api_header}     Get Variable Value        $API_HEADER
    ${api_body}     Get Variable Value     $API_BODY
    @{list_ecode}     Get Dictionary Values     dictionary=${ecode}
    FOR  ${ecode}  IN    @{list_ecode}
             ${status}    Run Keyword And Return Status     Send Request    ${method}    
             ...    url=${url}    
             ...    headers=${api_header}             
             ...    body=${api_body}    
             ...    expected_status=${ecode}
             ...    verify=${ignore_ssl_certificate}  
             IF    ${status} == ${True}    BREAK
    END
    IF    ${status} == ${False}    Fail Message Error Unknown Ecode  
    Check New Feature Api And Return Status

Verify Data 404 Not Found
    [Tags]    Mockup
    IF    ${status_new_feature} == ${True}
              Log    ${log_message}    level=${log_level}    console=${True}
    ELSE
        Log    ${log_message}    level=${log_level}    console=${True}
        Verify Value Response By Key    $..statusCode    20000
        Verify Value Response By Key    $..statusDesc    Success
        Verify Json Schema Success      ${xxx}
    END 