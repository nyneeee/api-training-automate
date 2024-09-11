*** Settings ***
# Resource     ../../TestSite/url_cpc_api.resource
Resource     ../../arcadia.automate.buffet/APIBuffet/RequestLibrary_APICommonKeywords.robot
Resource     ../../Resources/Keywords/compare_data.resource
Library      ../../CustomLibraryAPI/lib_api.py

*** Keywords ***
Set API Header Default
    [Documentation]    Owner : Suthasinee    
    [Tags]    keyword_action
    [Arguments]        ${content_type}=application/json
    ...                ${user_agent}=PostmanRuntime/7.32.3      
    Set Content API Header   $..Content-Type        ${content_type}    
    Set Content API Header   $..User-Agent          ${user_agent} 
    IF  '${testsite}' == 'Test'          Set Content API Header    $..Host       sit-cpc.az.intra.ais
    IF  '${testsite}' == 'Production'    Set Content API Header    $..Host       cpc.cloud.ais.th

Set Header Validate Token
    [Documentation]    Owner : Worrapong    Edit : Attapon.b
    [Tags]    keyword_action
    Set API Header Default        
    ${token_authen}    Get Variable Value    ${TOKEN}
    IF    $token_authen == None
        Set Schema API Body    ${1_body_authentication}
        ${api_header}   Get Variable Value    $API_HEADER 
        ${api_body}     Get Variable Value    $API_BODY
        Send Request    POST    url=${url_authentication}    
        ...    headers=${api_header}              body=${api_body}    
        ...    expected_status=200                verify=${ignore_ssl_certificate}
        ${token}     Get Value Response By Key    $..data.accessToken 
        Set Test Variable    ${token_authen}      ${token}
        Log Many    ${token_authen}
    END
    Set Content API Header    $..authorization    Bearer ${token_authen}

Get Keys From Json Data
    [Documentation]    Owner : Suthasinee    
    [Tags]    keyword_command
    [Arguments]   ${json_data}
    ${json_data}        Set Variable    ${json_data}
    @{all_keys}         Create List
    FOR    ${key_parant}    IN    @{json_data.keys()}
        ${value}    Get From Dictionary    ${json_data}    ${key_parant} 
        Log    ${key_parant}: ${value}
        Append To List    ${all_keys}    ${key_parant}
        ${value_type}    Evaluate    type($value)
        IF    "${value_type}" == "<class 'list'>"
            ${status_list}  Run Keyword And Return Status     Should Not Be Empty   ${value}[0]
            IF  ${status_list} == ${True}   
                ${key}    Get Keys From Json Data   ${value}[0] 
                ${count_key}  Get Length   ${key}    
                FOR    ${i}    IN RANGE    ${count_key}
                    ${new_key}    Set Variable    ${key_parant}.${key}[${i}]
                    Append To List    ${all_keys}    ${new_key}
                END
            ELSE   
                CONTINUE
            END
        ELSE
            CONTINUE
        END
    END
    RETURN    ${all_keys}

Extract All Json Keys
    [Documentation]    Owner : Suthasinee    
    [Tags]    keyword_command
    [Arguments]    ${json_data}
    ${json_data_str}    Evaluate                  json.dumps($json_data)
    ${response_actual}  Get Variable Value        $RESPONSE.json()
    ${json_data}        Set Variable              ${response_actual}
    ${parent_key}       Set Variable              ${EMPTY}
    ${all_keys}         Get Keys From Json Data   ${json_data}
    @{list_key}         Create List
    FOR    ${key}    IN    @{all_keys}
        Log    ${key}
        Append To List  ${list_key}  ${key}
    END
    RETURN   @{list_key}

Verify Response Schema Structure 
    [Documentation]    Owner : Suthasinee    
    [Tags]    keyword_action
    [Arguments]        ${response_schema} 
    Set Schema Response           ${response_schema}
    ${response_actual}            Get Variable Value        $RESPONSE.json()
    ${response_expect}            Get Variable Value        $RESPONSE_SCHEMA
    ${key_response_full}          Extract All Json Keys     ${response_actual}
    ${key_response_expect}        Extract All Json Keys     ${response_expect}
    List Should Contain Sub List  ${key_response_full}      ${key_response_expect}  
    
Set Request API Body
    [Documentation]    Owner : Patipan.w
    ...    Receive [Argument] key and value or append=True to Used in \${API_BODY}
    ...    append=False to create new variable $\{API_BODY}
    ...    Set API Body for send request
    ...    type=Binary, Boolean, Bytes, Hex, Integer, Number, Octal, String (default type is String)
    ...    support type follow keyword 'Convert To ...' in BuiltIn library
    [Tags]    keyword_action
    [Arguments]    ${key_path}    ${value}    ${convert_type}=String    ${index_list}=${None}    ${append}=True
    ${keyword_convert_value}     Set Variable    Convert To ${convert_type}
    ${value}    Run Keyword    ${keyword_convert_value}    ${value}
    ${schema}    Get Variable Value    $API_BODY
    ${json_schema}    Set Json Schema             ${schema}         ${append}
    IF    ${index_list} == ${None}
        ${json_object}    Add Value To Json Schema    ${json_schema}    ${key_path}    ${value}
    ELSE
        ${key_path}     Remove String    ${key_path}    $..
        ${key_exist}    Run Keyword And Return Status
        ...    Verify Key Exist In Dictionary    ${json_schema}[${index_list}]    ${key_path}
        IF    ${key_exist} == ${True}
            Update Value To Json    ${json_schema}[${index_list}]    ${key_path}    ${value}
            ${json_object}    Set Variable    ${json_schema}
        ELSE
            FAIL    msg=Argument "index_list" will support by only key exist in dictionary.
        END
    END
    Set Test Variable    \${API_BODY}    ${json_object}

Verify Json Schema Success
    [Documentation]    Owner : Kachain.a    Editor: Patipan.w, Suthasinee
    [Arguments]    ${file_response_json}
    Set Schema Response        ${file_response_json}
    Log Schema Json            $RESPONSE.json()
    Log Schema Json            $RESPONSE_SCHEMA
    Validate Json Schema And Return Error    json_object=${response.json()}    schema=${RESPONSE_SCHEMA}

Verify Json Schema Success For Test
    [Documentation]    Owner : Patipan.w
    [Arguments]    ${file_response}
    Set Schema Response        ${file_response}
    ${json_response_test}    Load Json From File    ${mockup_response_response_json}    encoding=UTF-8
    Validate Json Schema And Return Error      json_object=${json_response_test}    schema=${RESPONSE_SCHEMA}

API For Clear Cache
    [Documentation]    Owner : Kachain.a
    Set Suite Header Validate Token
    IF  '${testsite}' == 'Test'          Set Suite Content API Header    $..Host       sit-cpc.cdc.ais.th
    IF  '${testsite}' == 'Production'    Set Suite Content API Header    $..Host       cpc.cloud.ais.th
    Set Suite Body API        schema_body=${body_clear_cache}
    Send Suite Request API    url=${url_clear_cache}
    ...                       expected_status=200

Set Suite Content API Header
    [Documentation]    Owner: Kachain.a
    ...    Receive [Argument] key and value or append=True to Used in \${API_HEADER}
    ...    append=False to create new variable $\{API_HEADER}
    ...    Set API Body for send request
    ...    type=Binary, Boolean, Bytes, Hex, Interger, Number, Octal, String (default type is String)
    ...    support type follow keyword 'Convert To ...' in BuiltIn library
    [Tags]    keyword_action
    [Arguments]    ${key}    ${value}    ${convert_type}=String    ${append}=${True}
    ${value}     Check Variable And Convert Type    ${value}    ${convert_type}
    ${schema}    Get Variable Value    $SUITE_API_HEADER
    ${json_schema}    Set Json Schema             ${schema}         ${append}
    ${json_object}    Add Value To Json Schema    ${json_schema}    ${key}    ${value}
    Set Suite Variable    \${SUITE_API_HEADER}    ${json_object}

Set Suite Body API
    [Documentation]    Owner : Kachain.a
    [Tags]    keyword_action
    [Arguments]    ${schema_body}    ${jsonfile}=${True}
    ${body_json_schema}    Load Json Value       ${schema_body}    ${jsonfile}
    Set Suite Variable     \${SUITE_API_BODY}    ${body_json_schema}  
    Log Many    ${SUITE_API_BODY}

Send Suite Request API
    [Documentation]    Owner : Kachain.a
    ...    $write_res : pre , post
    ...    $region : asse , asea
    ...    $testsite : Test , Production
    [Tags]    keyword_action
    [Arguments]    ${url}    ${expected_status}=200       
    ...    ${method}=POST
    ${api_header}            Get Variable Value     $SUITE_API_HEADER
    ${api_body}              Get Variable Value     $SUITE_API_BODY
    Send Suite Request    ${method}    
    ...    url=${url}    
    ...    headers=${api_header}             
    ...    body=${api_body}    
    ...    expected_status=${expected_status}
    ...    verify=${ignore_ssl_certificate}

Send Suite Request
    [Documentation]    Owner : Kachain.a
    [Tags]    keyword_action
    [Arguments]    ${request}
    ...    ${url}
    ...    ${headers}=${None}
    ...    ${body}=${None}
    ...    ${expected_status}=200
    ...    ${timeout}=${None}
    ...    ${verify}=${None}
    Set Suite Proxy
    Set Suite Url        ${url}
    Set Suite Header     ${headers}    ${request}
    Set Suite Body       ${body}
    Request Suite Api    ${request}    ${expected_status}    ${timeout}    ${verify}
    ${type_request}        Get Suite Request Type
    ${message_request}     Get Variable Value    $MESSAGE_REQUEST
    ${message_response}    Get Variable Value    $MESSAGE_RESPONSE
    Log Many    === Request ${type_request} ===${\n}${message_request}    === Response ===${\n}${message_response}

Set Suite Proxy
    [Documentation]    Owner : Kachain.a
    ...    check variable \${FLAG_SET_PROXY_API} to setting status proxy (True, False)
    ...    and check variable \${PROXY_API} to set value for proxy (dict value http domain)
    ...    proxy is not set value proxy will use default value = \${None}
    [Tags]    keyword_command
    ${set_proxy}              Get Variable Value    $FLAG_SET_PROXY_API    ${False}
    IF    ${set_proxy} == ${True}
        ${proxy_api_value}    Get Variable Value    $PROXY_API    ${None}
    ELSE
        ${proxy_api_value}    Set Variable          ${None}
        Log    Variable '$FLAG_SET_PROXY_API' is not found. It is not set proxy to request API.
    END
    Set Suite Variable    \${SUITE_PROXY}    ${proxy_api_value}

Set Suite Url
    [Documentation]    Owner : Kachain.a
    [Tags]    keyword_command
    [Arguments]    ${url}
    Set Suite Variable    \${SUITE_URL_REQUEST}    ${url}

Set Suite Header
    [Documentation]    Owner : Kachain.a
    ...    request header is not allow value \${None}. Except type request = GET
    ...    check header type json for set send request to type json
    [Tags]    keyword_command
    [Arguments]    ${headers}    ${type_request}
    ${headers}         Check Type And Convert To Json    ${headers}
    ${type_request}    Convert To Upper Case             ${type_request}
    IF    ${headers} != ${None}
        Verify Key Exist In Dictionary           ${headers}    $..Content-Type
        ${header_type}    Get Value From Json    ${headers}    $..Content-Type
        IF    "${header_type}[0]" == "application/json"
            Set Suite Variable    \${SUITE_CONTENT_TYPE}    json
        ELSE
            Set Suite Variable    \${SUITE_CONTENT_TYPE}    data
        END
    END
    Set Suite Variable    \${SUITE_HEADERS_REQUEST}    ${headers}

Set Suite Body
    [Documentation]    Owner : Kachain.a
    [Tags]    keyword_command
    [Arguments]    ${body}
    ${body}    Check Type And Convert To Json    ${body}
    Set Suite Variable    \${SUITE_BODY_REQUEST}        ${body}

Get Suite Request Type
    [Documentation]    Owner : Kachain.a
    [Tags]    keyword_command
    ${response}              Get Variable Value    $RESPONSE
    ${response_request}      Convert To String     ${response.request}
    @{text_request}          Split String          ${response_request}    ${SPACE}
    ${match_request_type}    Get Regexp Matches    ${text_request}[-1]    \\w+
    ${type_request}          Set Variable          ${match_request_type}[0]
    Set Suite Variable        \${TYPE_REQUEST}      ${type_request}
    RETURN    ${type_request}

Request Suite Api
    [Documentation]    Owner : Kachain.a
    ...    check header type json for set send request to type json
    ...    keyword request argument will match with header type (json, data)
    [Tags]    keyword_command
    [Arguments]    ${request}    ${expected_status}    ${timeout}    ${verify}
    ${content_type}       Get Variable Value    $SUITE_CONTENT_TYPE
    ${url_request}        Get Variable Value    $SUITE_URL_REQUEST
    ${headers_request}    Get Variable Value    $SUITE_HEADERS_REQUEST
    ${body_request}       Get Variable Value    $SUITE_API_BODY
    ${proxy}              Get Variable Value    $SUITE_PROXY    ${None}
    IF    ${timeout} == ${None}
        ${request_api_timeout}    Get Variable Value    $Api.RequestTimeout    60
    ELSE
        ${request_api_timeout}    Set Variable          ${timeout}
    END
    IF    "${content_type}" == "json"
        ${response}    Run Keyword
        ...    ${request}    url=${url_request}    headers=${headers_request}    json=${body_request}
        ...    expected_status=${expected_status}
        ...    proxies=${proxy}
        ...    timeout=${request_api_timeout}
        ...    verify=${verify}
    ELSE
        ${response}    Run Keyword
        ...    ${request}    url=${url_request}    headers=${headers_request}    data=${body_request}
        ...    expected_status=${expected_status}
        ...    proxies=${proxy}
        ...    timeout=${request_api_timeout}
        ...    verify=${verify}
    END
    Set Suite Variable    ${RESPONSE}    ${response}
    Set Message Suite Request Response

Set Message Suite Request Response
    [Documentation]    Owner : Kachain.a
    ...    set message for log request response
    ...    variable \${LOG_REQUEST} and \${LOG_RESPONSE} will setting to 1 line for log to provision data (report)
    ...    and variable \${MESSAGE_REQUEST} and \${MESSAGE_RESPONSE} will log to keyword request API
    [Tags]    keyword_command
    ${type_request}        Get Suite Request Type
    ${url_request}         Get Variable Value     $SUITE_URL_REQUEST
    ${headers_request}     Get Variable Value     $SUITE_HEADERS_REQUEST
    ${body_request}        Get Variable Value     $SUITE_API_BODY
    &{message_request}     Create Dictionary
    Set To Dictionary      ${message_request}     URL=${url_request}
    Set To Dictionary      ${message_request}     Header=${headers_request}
    Set To Dictionary      ${message_request}     Body=${body_request}
    ${log_request}         Set Variable
    ...    Request ${type_request}${\n}URL: ${url_request}${\n}Header: ${headers_request}${\n}Body: ${body_request}
    Set Suite Variable      \${LOG_REQUEST}        ${log_request}
    ${response}            Get Variable Value     $RESPONSE
    &{message_response}    Create Dictionary
    Set To Dictionary      ${message_response}    URL=${response.url}
    Set To Dictionary      ${message_response}    Header=${response.headers}
    TRY
        ${response_body_json}    Convert String To JSON    ${response.text}
    EXCEPT
        ${response_body_json}    Set Variable              ${response.text}
    END
    Set To Dictionary      ${message_response}    Body=${response_body_json}
    ${log_response}        Set Variable
    ...    Response${\n}URL: ${response.url}${\n}Header: ${response.headers}${\n}Body: ${response_body_json}
    Set Suite Variable      \${LOG_RESPONSE}       ${log_response}
    &{message_request_response}    Create Dictionary    request=${message_request}    response=${message_response}
    ${request}     Set Format Json 4 Indent        ${message_request_response}[request]
    ${response}    Set Format Json 4 Indent        ${message_request_response}[response]
    Set Suite Variable      \${MESSAGE_REQUEST}     ${request}
    Set Suite Variable      \${MESSAGE_RESPONSE}    ${response}

Check Type
    [Documentation]    Owner : Patipan.w  
    [Tags]    keyword_action
    [Arguments]    ${value}
    ${type_value}    Evaluate    type($value)
    [Return]    ${type_value}

Log Response Json
    [Documentation]    Owner : Patipan.w
    [Tags]    keyword_action
    [Arguments]    ${json}
    ${json}    Convert Json File To Json Formatter    ${json}
    Log Many    ${json}

Convert Json File To Json Formatter
    [Documentation]    Owner : Patipan.w  
    [Tags]    keyword_action
    [Arguments]    ${json_file}
    ${json_formatter}    Evaluate    json.dumps(${json_file}, indent=4, ensure_ascii=False)    json
    [Return]    ${json_formatter}

Get Value List In String From Json
    [Documentation]    Owner : Patipan.w 
    [Tags]    keyword_action
    [Arguments]    ${json_obj}    ${json_path}    
    ${value}          Get Value From Json    ${json_obj}    ${json_path}
    ${type}           Check Type             ${value}
    ${split_item}     Split String           ${value}[0]    ,
    ${split_item}     Convert To List        ${split_item}
    [Return]      ${split_item}

Get List Key And Count From Json
    [Documentation]    Owner : Patipan.w 
    ...    Get list "key" from "response" and create "list" 
    ...    ${json_path} Config path : "./Resources/Response/file.json" 
    [Tags]    keyword_action
    [Arguments]    ${json_path}    ${json_object}=${EMPTY}    
    IF  "${json_object}" == "${EMPTY}"
            @{values}	Get Value From Json    ${response.json()}	${json_path}
    ELSE
        @{values}	Get Value From Json    ${json_object}	${json_path}
    END
    Log Response Json    ${values}
    ${count}         Get Length    ${values[${0}]}
    ${type_value}    Evaluate      type(${values[${0}]})
    [Return]      ${count}

Set Body API
    [Documentation]    Owner : Patipan.w
    [Tags]    keyword_action
    [Arguments]    ${schema_body}
    Set API Header default
    Set Schema API Body    ${schema_body}        
    Log Many    ${API_BODY}

Send Request API
    [Documentation]    Owner : Patipan.w
    ...    for check ecode $ecode.new_feature is "New Feature API"
    ...    $write_res : pre , post
    ...    $region : asse , asea
    ...    $testsite : Test , Production
    [Tags]    keyword_action
    [Arguments]    ${url}    ${expected_status}       
    ...    ${method}=POST    ${skip_verify_new_feature}=${False}
    ${api_header}            Get Variable Value     $API_HEADER
    ${api_body}              Get Variable Value     $API_BODY
    IF    ${skip_verify_new_feature} == ${False}
            &{dic_ecode}             Create Dictionary To Verify Ecode        ${expected_status}
            @{list_verify_ecode}     Get Dictionary Values    ${dic_ecode}    sort_keys=${False}
            FOR  ${ecode}  IN    @{list_verify_ecode}
                    ${status}    Run Keyword And Return Status     Send Request    ${method}    
                    ...    url=${url}    
                    ...    headers=${api_header}             
                    ...    body=${api_body}    
                    ...    expected_status=${ecode}
                    ...    verify=${ignore_ssl_certificate}  
                    IF    ${status} == ${True}    BREAK
            END
            IF    ${status} == ${False}    Fail Message Error Unknown Ecode    &{dic_ecode}
            Check New Feature Api And Return Status
            Set Test Variable        ${expected_status}       ${expected_status}
    ELSE
        ${status}    Run Keyword And Return Status     Send Request    ${method}    
        ...    url=${url}    
        ...    headers=${api_header}             
        ...    body=${api_body}    
        ...    expected_status=${expected_status}
        ...    verify=${ignore_ssl_certificate}
        IF    ${status} == ${False}    Fail Message Error Unknown Ecode    ${expected_status}
        ${value_region}       Convert To Upper Case    ${region}
        ${value_testsite}     Convert To Upper Case    ${testsite}
        ${write_res_upper}    Convert To Upper Case    ${write_res}
        ${message}    Catenate
        ...    ${\n}'[${write_res_upper}][REGION - ${value_region}][SITE - ${value_testsite}] - ${TEST_NAME}'
        ...    ${\n}---> SKIP - Check New Feature Api
        ...    ${\n}---> Ecode: $Response("${response.status_code}")
        ...    ${\n}---> Verify Json Schema.
        Set Test Variable    ${expected_status}       ${expected_status}
        Set Test Variable    ${log_message}           ${message}
        Set Test Variable    ${log_level}             INFO
        Log    ${log_message}    level=${log_level}    console=${True}
    END

Verify Response Should Be Equal Expected
    [Documentation]    Owner : Patipan.w
    [Tags]    keyword_action
    [Arguments]    ${path_expected}
    ${expect_result}    Load Json From File    ${path_expected}
    Log Schema Json    msg=Expect Result       json_object=${expect_result}
    Log Schema Json    msg=Response Json       json_object=${response.json()}
    Json Response Should Be Equal              response_1=${response.json()}    response_2=${expect_result}
    ${expect_result}           Evaluate        json.dumps(${expect_result}, indent=4, ensure_ascii=False)      json
    ${actual_json_response}    Evaluate        json.dumps(${response.json()}, indent=4, ensure_ascii=False)    json
    ${message_result}    Catenate
    ...    ${\n}**** Expect Result ****
    ...    ${\n}---> Json response: "${expect_result}"
    ...    ${\n}
    ...    ${\n}**** Actual Result ****
    ...    ${\n}---> Json response: "${actual_json_response}"
    Log Many    ${message_result}    

Set Suite Header Validate Token
    [Documentation]    Owner : Worrapong    Edit : Attapon.b
    [Tags]    keyword_action
    Set Suite API Header Default       
    ${token_authen}    Get Variable Value    ${TOKEN}
    IF    $token_authen == $None
        Set Suite Schema API Body    ${1_body_authentication}
        ${api_header}   Get Variable Value    $SUITE_API_HEADER 
        ${api_body}     Get Variable Value    $SUITE_API_BODY
        Send Suite Request    POST    url=${url_authentication}    
        ...    headers=${api_header}              body=${api_body}    
        ...    expected_status=200                verify=${ignore_ssl_certificate}
        ${token}     Get Value Response By Key    $..data.accessToken 
        Set Suite Variable    ${token_authen}      ${token}
        Log Many    ${token_authen}
    END
    Set Suite Content API Header    $..authorization    Bearer ${token_authen}

Set Suite API Header Default
    [Documentation]    Owner : Kachain.a    
    [Tags]    keyword_action
    [Arguments]        ${content_type}=application/json
    ...                ${user_agent}=PostmanRuntime/7.32.3      
    Set Suite Content API Header   $..Content-Type        ${content_type}    
    Set Suite Content API Header   $..User-Agent          ${user_agent} 
    IF  '${testsite}' == 'Test'          Set Suite Content API Header    $..Host       sit-cpc.cdc.ais.th
    IF  '${testsite}' == 'Production'    Set Suite Content API Header    $..Host       cpc.cloud.ais.th

Set Suite Schema API Body
    [Documentation]    Owner : Kachain.a
    ...    Use for import API Body schema
    ...    *** Support ***
    ...    Json File or variable as String and Dictionary Type
    [Tags]    keyword_action
    [Arguments]    ${body_json}    ${jsonfile}=${True}
    ${body_json_schema}    Load Json Value    ${body_json}    ${jsonfile}
    Set Suite Variable    \${API_SUITE_BODY}    ${body_json_schema}