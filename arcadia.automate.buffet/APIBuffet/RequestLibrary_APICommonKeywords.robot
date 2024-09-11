*** Settings ***
Library     String
Library     Collections
Library     RequestsLibrary
Library     JSONLibrary


*** Keywords ***
# Improvement keyword not include setting timeout (Support Robotframework 5)
# Send request
Set Proxy
    [Documentation]    Owner : Rukpong
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
    Set Test Variable    \${PROXY}    ${proxy_api_value}

Set Url
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command
    [Arguments]    ${url}
    Set Test Variable    \${URL_REQUEST}    ${url}

Set Header
    [Documentation]    Owner : Rukpong
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
            Set Test Variable    \${CONTENT_TYPE}    json
        ELSE
            Set Test Variable    \${CONTENT_TYPE}    data
        END
    END
    Set Test Variable    \${HEADERS_REQUEST}    ${headers}

Set Body
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command
    [Arguments]    ${body}
    ${body}    Check Type And Convert To Json    ${body}
    Set Test Variable    \${BODY_REQUEST}        ${body}

Check Type And Convert To Json
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command
    [Arguments]    ${value}
    ${type_value}    Evaluate    type($value)
    IF    "${type_value}" == "<class 'str'>"
        ${json_object}    Convert String To Json    ${value}
    ELSE
        ${json_object}    Set Variable              ${value}
    END
    RETURN    ${json_object}

Send Request
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action
    [Arguments]    ${request}
    ...    ${url}
    ...    ${headers}=${None}
    ...    ${body}=${None}
    ...    ${expected_status}=200
    ...    ${timeout}=${None}
    ...    ${verify}=${None}
    Set Proxy
    Set Url        ${url}
    Set Header     ${headers}    ${request}
    Set Body       ${body}
    Request Api    ${request}    ${expected_status}    ${timeout}    ${verify}
    ${type_request}        Get Request Type
    ${message_request}     Get Variable Value    $MESSAGE_REQUEST
    ${message_response}    Get Variable Value    $MESSAGE_RESPONSE
    Log Many    === Request ${type_request} ===${\n}${message_request}    === Response ===${\n}${message_response}

Request Api
    [Documentation]    Owner : Rukpong
    ...    check header type json for set send request to type json
    ...    keyword request argument will match with header type (json, data)
    [Tags]    keyword_command
    [Arguments]    ${request}    ${expected_status}    ${timeout}    ${verify}
    ${content_type}       Get Variable Value    $CONTENT_TYPE
    ${url_request}        Get Variable Value    $URL_REQUEST
    ${headers_request}    Get Variable Value    $HEADERS_REQUEST
    ${body_request}       Get Variable Value    $BODY_REQUEST
    ${proxy}              Get Variable Value    $PROXY    ${None}
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
    Set Test Variable    ${RESPONSE}    ${response}
    Set Message Request Response

Set Message Request Response
    [Documentation]    Owner : Rukpong
    ...    set message for log request response
    ...    variable \${LOG_REQUEST} and \${LOG_RESPONSE} will setting to 1 line for log to provision data (report)
    ...    and variable \${MESSAGE_REQUEST} and \${MESSAGE_RESPONSE} will log to keyword request API
    [Tags]    keyword_command
    ${type_request}        Get Request Type
    ${url_request}         Get Variable Value     $URL_REQUEST
    ${headers_request}     Get Variable Value     $HEADERS_REQUEST
    ${body_request}        Get Variable Value     $BODY_REQUEST
    &{message_request}     Create Dictionary
    Set To Dictionary      ${message_request}     URL=${url_request}
    Set To Dictionary      ${message_request}     Header=${headers_request}
    Set To Dictionary      ${message_request}     Body=${body_request}
    ${log_request}         Set Variable
    ...    Request ${type_request}${\n}URL: ${url_request}${\n}Header: ${headers_request}${\n}Body: ${body_request}
    Set Test Variable      \${LOG_REQUEST}        ${log_request}
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
    Set Test Variable      \${LOG_RESPONSE}       ${log_response}
    &{message_request_response}    Create Dictionary    request=${message_request}    response=${message_response}
    ${request}     Set Format Json 4 Indent        ${message_request_response}[request]
    ${response}    Set Format Json 4 Indent        ${message_request_response}[response]
    Set Test Variable      \${MESSAGE_REQUEST}     ${request}
    Set Test Variable      \${MESSAGE_RESPONSE}    ${response}

# Log message
Set Format Json 4 Indent
    [Documentation]    Owner : Rukpong
    ...    set format log json data will add indent = 4 for easier debug log request API
    [Tags]    keyword_command
    [Arguments]    ${json_object}
    ${json_format}    Evaluate    json.dumps(${json_object}, indent=4, ensure_ascii=False)    json
    RETURN    ${json_format}

Log Schema Json
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action
    [Arguments]    ${json_object}    ${msg}=Schema json
    ${json_format}    Set Format Json 4 Indent    ${json_object}
    Log Many    ${msg}    ${json_format}

Log All Variables Run Robot
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action
    ${json}    Get Variables
    Log    ${json}
    ${key_suite_metadata}    Catenate    &    {    SUITE_METADATA    }
    Remove From Dictionary    ${json}    ${key_suite_metadata}
    Log Schema Json    ${json}

# Get data
Get Request Type
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command
    ${response}              Get Variable Value    $RESPONSE
    ${response_request}      Convert To String     ${response.request}
    @{text_request}          Split String          ${response_request}    ${SPACE}
    ${match_request_type}    Get Regexp Matches    ${text_request}[-1]    \\w+
    ${type_request}          Set Variable          ${match_request_type}[0]
    Set Test Variable        \${TYPE_REQUEST}      ${type_request}
    RETURN    ${type_request}

Get Value Response By Key
    [Documentation]    Owner : Rukpong
    ...    get value in response by key in dictionary json response
    ...    argument response_key with get 'key' from dictionary json response or
    ...    support multi-response_key (separator key by . and specify index list)
    ...    *response will use RESPONSE from latest API Request
    ...    set variable RESPONSE.json() to dictionary
    [Tags]    keyword_action
    [Arguments]    ${response_key}
    ${response_key}      Remove String         ${response_key}    $..
    ${response_json}     Get Variable Value    $RESPONSE.json()
    &{response_value}    Set Variable          ${response_json}
    ${value}    Set Variable    ${response_value.${response_key}}
    RETURN    ${value}

Get Value Response Headers By Key
    [Documentation]    Owner : Rukpong
    ...    get value in header response by key in dictionary json response
    ...    argument response_key with get 'key' from dictionary json response
    ...    *Response will use header response from latest API Request
    [Tags]    keyword_action
    [Arguments]    ${key}
    ${key}      Remove String    ${key}    $..
    ${response_headers}    Get Variable Value    $RESPONSE.headers
    ${header_value}        Set Variable          ${response_headers}
    ${value}    Set Variable     ${header_value['${key}']}
    RETURN    ${value}

Get Value Json By Key
    [Documentation]    Owner : Rukpong
    ...    get value in response by key in dictionary json_data
    ...    argument key with get 'key' from dictionary json response or
    ...    support multi-response_key (separator key by . and specify index list)
    [Tags]    keyword_action
    [Arguments]    ${json_data}    ${key}
    ${key}      Remove String    ${key}    $..
    &{json}     Set Variable     ${json_data}
    ${value}    Set Variable     ${json.${key}}
    RETURN    ${value}

# Set data
Set Schema API Header
    [Documentation]    Owner : Rukpong
    ...    Use for import API Header Schema
    ...    *** Support ***
    ...    Json File or Variable as String and Dictionary Type
    [Tags]    keyword_action
    [Arguments]    ${header_json}    ${jsonfile}=${True}
    ${header_json_schema}    Load Json Value    ${header_json}    ${jsonfile}
    Set Test Variable    \${API_HEADER}    ${header_json_schema}

Set Content API Header
    [Documentation]    Owner: Nakarin | Edit : Rukpong
    ...    Receive [Argument] key and value or append=True to Used in \${API_HEADER}
    ...    append=False to create new variable $\{API_HEADER}
    ...    Set API Body for send request
    ...    type=Binary, Boolean, Bytes, Hex, Interger, Number, Octal, String (default type is String)
    ...    support type follow keyword 'Convert To ...' in BuiltIn library
    [Tags]    keyword_action
    [Arguments]    ${key}    ${value}    ${convert_type}=String    ${append}=${True}
    ${value}     Check Variable And Convert Type    ${value}    ${convert_type}
    ${schema}    Get Variable Value    $API_HEADER
    ${json_schema}    Set Json Schema             ${schema}         ${append}
    ${json_object}    Add Value To Json Schema    ${json_schema}    ${key}    ${value}
    Set Test Variable    \${API_HEADER}    ${json_object}

Set Schema API Body
    [Documentation]    Owner : Rukpong
    ...    Use for import API Body schema
    ...    *** Support ***
    ...    Json File or variable as String and Dictionary Type
    [Tags]    keyword_action
    [Arguments]    ${body_json}    ${jsonfile}=${True}
    ${body_json_schema}    Load Json Value    ${body_json}    ${jsonfile}
    Set Test Variable    \${API_BODY}    ${body_json_schema}

Set Content API Body
    [Documentation]    Owner : Rukpong
    ...    Receive [Argument] key and value or append=True to Used in \${API_BODY}
    ...    append=False to create new variable $\{API_BODY}
    ...    Set API Body for send request
    ...    type=Binary, Boolean, Bytes, Hex, Interger, Number, Octal, String (default type is String)
    ...    support type follow keyword 'Convert To ...' in BuiltIn library
    [Tags]    keyword_action
    [Arguments]    ${key_path}    ${value}    ${convert_type}=String    ${index_list}=${None}    ${append}=True
    ${value}     Check Variable And Convert Type    ${value}    ${convert_type}
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

Set Schema Response
    [Documentation]    Owner : Rukpong
    ...    Use for import Response Schema
    ...    *** Support ***
    ...    Json File or Variable as String and Dictionary Type
    [Tags]    keyword_action
    [Arguments]    ${response_json}    ${jsonfile}=${True}
    ${response_json_schema}    Load Json Value    ${response_json}    ${jsonfile}
    Set Test Variable    \${RESPONSE_SCHEMA}    ${response_json_schema}

Set Response Value
    [Documentation]    Owner : Rukpong
    ...    Receive [Argument] key and value or append=True to Used in \${RESPONSE_SCHEMA}
    ...    append=False to create new variable $\{RESPONSE_SCHEMA}
    ...    Set API Body for send request
    ...    type=Binary, Boolean, Bytes, Hex, Interger, Number, Octal, String (default type is String)
    ...    support type follow keyword 'Convert To ...' in BuiltIn library
    [Tags]    keyword_action
    [Arguments]    ${key_path}    ${value}    ${convert_type}=String    ${append}=${True}
    ${value}     Check Variable And Convert Type    ${value}    ${convert_type}
    ${schema}    Get Variable Value    $RESPONSE_SCHEMA
    ${json_schema}    Set Json Schema             ${schema}         ${append}
    ${json_object}    Add Value To Json Schema    ${json_schema}    ${key_path}    ${value}
    Set Test Variable    \${RESPONSE_SCHEMA}    ${json_object}

Load Json Value
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command
    [Arguments]    ${json_value}    ${jsonfile}
    IF    ${jsonfile} == ${True}
        ${json_schema}    Load Json From File    ${json_value}    encoding=UTF-8
    ELSE
        ${type_value}    Evaluate    type($json_value)
        IF    "${type_value}" == "<class 'str'>"
            ${json_schema}    Convert String To JSON    ${json_value}
        ELSE
            ${json_schema}    Set Variable    ${json_value}
        END
    END
    RETURN    ${json_schema}

Check Variable And Convert Type
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command
    [Arguments]    ${value}    ${convert_type}
    ${type_value}    Evaluate    type($value)
    IF    "${type_value}" != "<class 'NoneType'>"
        ${condition_check_type}    Catenate
        ...    "${type_value}" != "<class 'list'>" and
        ...    "${type_value}" != "<class 'dict'>" and
        ...    "${type_value}" != "<class 'robot.utils.dotdict.DotDict'>"
        IF    ${condition_check_type} == ${True}
            ${keyword_convert_value}    Set Variable    Convert To ${convert_type}
            ${value}    Run Keyword    ${keyword_convert_value}    ${value}
        END
    END
    RETURN    ${value}

Set Json Schema
    [Documentation]    Owner : Rukpong
    ...    variable \${schema} is no value will create new schema
    ...    or append = True will create new schema
    [Tags]    keyword_command
    [Arguments]    ${schema}    ${append}
    IF    ${schema} != ${None} and ${append} == ${True}
        ${schema}    Set Variable    ${schema}
    ELSE
        ${schema}    Create Dictionary
    END
    RETURN    ${schema}

Add Value To Json Schema
    [Documentation]    Owner : Rukpong
    ...    check key exist and add key=value to json_schema
    ...    support checking parent key exist. It will add parent key and key=value (support 1 parent key)
    [Tags]    keyword_command
    [Arguments]    ${json_schema}    ${key_path}    ${value}
    ${key_path}     Remove String    ${key_path}    $..
    ${key_exist}    Run Keyword And Return Status    Verify Key Exist In Dictionary    ${json_schema}    ${key_path}
    IF    ${key_exist} == ${True}
        ${json_schema}    Update Value To Json    ${json_schema}    ${key_path}    ${value}
    ELSE
        @{key_split}     Split String From Right    ${key_path}    .    1
        ${length_key}    Get Length                 ${key_split}
        IF    ${length_key} > 1
            ${path}    Set Variable    ${key_split}[0]
            ${key}     Set Variable    ${key_split}[-1]
            ${key_parent_exist}    Run Keyword And Return Status
            ...    Verify Key Exist In Dictionary    ${json_schema}    ${path}
            IF    ${key_parent_exist} == ${True}
                Set To Dictionary    ${json_schema}[${path}]    ${key}=${value}
            ELSE
                &{new_dict}    Create Dictionary    ${key}=${value}
                Set To Dictionary    ${json_schema}    ${path}=${new_dict}
            END
        ELSE
            Set To Dictionary    ${json_schema}    ${key_path}=${value}
        END
    END
    RETURN    ${json_schema}

# Verify
Verify Response Status Code
    [Documentation]    Owner : Rukpong
    ...    compare status code with response status code
    ...    should be equal as integer and return message if error
    ...    actual response status code: 'response.status_code' is not equal expected response status code: 'status_code'
    ...    *response will use RESPONSE from latest API Request
    [Tags]    keyword_action
    [Arguments]    ${status_code}
    ${message}    Validate Status Code    ${status_code}
    Log    ${message}

Validate Status Code
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command
    [Arguments]    ${status_code}
    ${status_code}    Convert To Integer    ${status_code}
    ${response_status_code}    Get Variable Value    $RESPONSE.status_code
    Should Be Equal As Integers    ${response_status_code}    ${status_code}    values=${False}
    ...    msg=Validate assertion: Actual response status code: '${response_status_code}' != Expected response status code: '${status_code}'.
    RETURN    Validate is correct: Actual response status code: '${response_status_code}' = Expected response status code: '${status_code}'.

Verify Value Response By Key
    [Documentation]    Owner : Rukpong
    ...    compare value with response value
    ...    should be equal as string and return message if error
    ...    *response will use RESPONSE from latest API Request
    [Tags]    keyword_action
    [Arguments]    ${response_key}      ${expected_value}
    ${response_key}    Remove String    ${response_key}    $..
    ${message}    Validate Equal Value Response By Key    ${response_key}    ${expected_value}
    Log    ${message}

Verify Match Regexp Value Response By Key
    [Documentation]    Owner : Rukpong
    ...    compare value with response value
    ...    should be equal as string and return message if error
    ...    *response will use RESPONSE from latest API Request
    [Tags]    keyword_action
    [Arguments]    ${response_key}     ${match_pattern}
    ${response_value}    Get Value Response By Key    ${response_key}
    ${value}    Convert To String      ${response_value}
    Should Match Regexp    ${value}    ${match_pattern}    msg=Validate assertion: Actual response value in key "${response_key}": 'value': "${response_value}" != is not match: "${match_pattern}".
    Log    Validate is correct: Actual response value in key "${response_key}": 'value': "${response_value}" = is match: "${match_pattern}".

Validate Equal Value Response By Key
    [Documentation]    Owner : Rukpong
    ...    support type value (str, nonetype, integer, float, bool)
    ...    check by type(value)
    [Tags]    keyword_action
    [Arguments]    ${response_key}    ${expected_value}
    ${value}    Get Value Response By Key    ${response_key}
    ${keyword_compare}    Check Compare Type    ${value}    ${expected_value}
    Run Keyword    ${keyword_compare}    ${value}    ${expected_value}    values=${False}
    ...    msg=Validate assertion: Actual value in key "${response_key}": '${value}' != Expected value: '${expected_value}'.
    RETURN    Validate is correct: Actual value in key "${response_key}": '${value}' = Expected value: '${expected_value}'.

Verify Response Value
    [Documentation]    Owner : Rukpong
    ...    verify resposne will compare response value with expect response schema
    ...    compare all key value in dict (all key value will be equal)
    ...    support key that no sorting
    [Tags]    keyword_action
    ${response_actual}    Get Variable Value    $RESPONSE.json()
    ${response_expect}    Get Variable Value    $RESPONSE_SCHEMA
    Verify Dictionary Should Be Equal    ${response_actual}    ${response_expect}

Verify Value Json By Key
    [Documentation]    Owner : Rukpong
    ...    compare value with value from json data
    ...    should be equal as string and return message if error
    [Tags]    keyword_action
    [Arguments]    ${json_data}    ${json_path}    ${expected_value}
    ${message}    Validate Equal Value Json By Key    ${json_data}    ${json_path}    ${expected_value}
    Log    ${message}

Verify Match Regexp Value Json By Key
    [Documentation]    Owner : Rukpong
    ...    compare value with response value
    ...    should be equal as string and return message if error
    ...    *response will use RESPONSE from latest API Request
    [Tags]    keyword_action
    [Arguments]    ${json_data}    ${json_path}    ${match_pattern}
    ${value}    Get Value Json By Key    ${json_data}    ${json_path}
    ${value}    Convert To String        ${value}
    Should Match Regexp    ${value}      ${match_pattern}
    ...    msg=Validate assertion: Actual response value in json path "${json_path}": 'value' is "${value}" != is not match: "${match_pattern}".
    Log    Validate is correct: Actual response value in json path "${json_path}": 'value' is "${value}" = is match: "${match_pattern}".


Validate Equal Value Json By Key
    [Documentation]    Owner : Rukpong
    ...    support type value (str, nonetype, integer, float, bool)
    ...    check by type(value)
    [Tags]    keyword_command
    [Arguments]    ${json_data}    ${key}    ${expected_value}
    ${value}    Get Value Json By Key    ${json_data}    ${key}
    ${keyword_compare}    Check Compare Type    ${value}    ${expected_value}
    Run Keyword    ${keyword_compare}    ${value}    ${expected_value}    values=${False}
    ...    msg=Validate assertion: Actual value in key "${key}": '${value}' != Expected value: '${expected_value}'.
    RETURN    Validate is correct: Actual value in key "${key}": '${value}' = Expected value: '${expected_value}'.

Verify Key Exist In Dictionary
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action
    [Arguments]    ${json_data}    ${path_key}
    ${path_key}     Remove String              ${path_key}    $..
    ${value}    Get Value From Json    ${json_data}    ${path_key}
    ${value_length}    Get Length    ${value}
    IF    ${value_length} == 0    FAIL    Validate assertion: Key "${path_key}" != not exist in Dictionary.
    Log    Validate is correct: Key "${path_key}" is exist in Dictionary = "${value}"

Verify Dictionary Should Be Equal
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action
    [Arguments]    ${actual_dict}    ${expect_dict}
    Dictionaries Should Be Equal    ${actual_dict}    ${expect_dict}    values=${True}
    ...    msg=Validate assertion: Actual dictionary != Expect dictionary.
    Log Schema Json    ${expect_dict}
    ...    msg=Validate is correct: Actual dictionary = Expect dictionary. Follow schema json

# Other keyword
Check Compare Type
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command
    [Arguments]    ${value}    ${expected_value}
    ${type_value}    Evaluate    type($value)
    IF    "${type_value}" == "<class 'str'>" or "${type_value}" == "<class 'NoneType'>"
        ${keyword_compare}    Set Variable    Should Be Equal As Strings
    ELSE IF    "${type_value}" == "<class 'int'>"
        ${keyword_compare}    Set Variable    Should Be Equal As Integers
    ELSE IF    "${type_value}" == "<class 'float'>"
        ${keyword_compare}    Set Variable    Should Be Equal As Numbers
    ELSE IF    "${type_value}" == "<class 'bool'>"
        ${keyword_compare}    Set Variable    Should Be Equal As Strings
    ELSE
        ${keyword_compare}    Set Variable    Should Be Equal
    END
    RETURN    ${keyword_compare}

Convert Variable Type To Dot Dict
    [Documentation]    Owner: Nakarin
    ...    Converting Variable type to Dot Dict type by recieving
    ...    [Arguments] value by ***SUPPORT TYPE*** then
    ...    Return \${dot_dict} value as type(<class 'robot.utils.dotdict.DotDict'>)
    ...    *** SUPPORT ***
    ...    <class 'str'>, <class 'dict'>
    ...    Fail if [Arguments] type was not supported
    [Tags]    keyword_command
    [Arguments]    ${variable}
    ${variable_type}    Evaluate    type($variable)
    IF    "${variable_type}" != "<class 'str'>" and "${variable_type}" != "<class 'dict'>"
        Fail    "Variable type is not support"
    END
    IF    "${variable_type}" == "<class 'str'>"
        ${dictionary}    Convert String To Json    ${variable}
    ELSE
        ${dictionary}    Set Variable              ${variable}
    END
    @{keys}        Get Dictionary Keys    ${dictionary}    sort_keys=False
    ${dot_dict}    Create Dictionary
    FOR    ${key}    IN    @{keys}
        Set To Dictionary    ${dot_dict}    ${key}=${dictionary}[${key}]
    END
    RETURN    ${dot_dict}
