*** Settings ***
Library    String
Library    OperatingSystem
Library    Collections
Library    DateTime


*** Keywords ***
Verify Value Should Contain
    [Documentation]    Owner : Rukpong
    ...    | ```$full_value``` | **<any not dict>** |
    ...    | ```$expected_value_contain``` | **<any>** |
    ...    *Example*: Verify Value Should Contain | _<full value>_ | _<expected value contain>_ |
    [Tags]    keyword_action
    [Arguments]    ${full_value}    ${expected_value_contain}
    ${type_full_value}    Check Variable Type    ${full_value}
    IF    "${type_full_value}" == "<class 'dict'>" or "${type_full_value}" == "<class 'robot.utils.dotdict.DotDict'>"
        Fail    msg=This keyword is not support dictionary type.
    END
    IF    "${type_full_value}" == "<class 'list'>"
        ${item}    Set Variable       ${expected_value_contain}
        List Should Contain Value    ${full_value}    ${item}    msg=Item: '${item}' is not contain in list.
        Log    Item: '${item}' is contain in list.
    ELSE
        Should Contain    ${full_value}    ${expected_value_contain}
        ...    msg=Full text: '${full_value}' has not contain by text: '${expected_value_contain}'.
        ...    values=${False}
        Log    Full text: '${full_value}' has contain text: '${expected_value_contain}'
    END

Check Variable Type
    [Documentation]    Owner: Nakarin
    ...    = Detail =
    ...    | Checking type fo variable and return type |
    ...    = Arguments =
    ...    | ```${var}``` | **<any>** |
    ...    = Example =
    ...    | Set Test Actual Result |  |  |  |  | `${1}` |
    ...    | <type 'int'> |
    ...    | Set Test Actual Result |  |  |  |  | `Hello, World` |
    ...    | <type 'str'> |
    [Tags]    keyword_action
    [Arguments]    ${var}
    ${type}    Evaluate    type($var)
    Log        ${type}
    RETURN     ${type}

Variable Should Be Null
    [Documentation]    Owner : Rukpong
    ...                This keyword using for check none type
    ...                and return status (True, False)
    [Tags]    keyword_action
    [Arguments]    ${variable}
    ${status_null}    Evaluate    str(type($variable)) == "<class 'NoneType'>"
    RETURN    ${status_null}

Compare Date Should Be Equal
    [Documentation]    Owner : Rukpong
    ...                Support date format by "%d/%m/%Y"
    ...                Compare date1 and date2 should be equal
    [Tags]    keyword_action
    [Arguments]    ${date1}    ${date2}
    Check Variable Type    $var
    ${date1}    IF    "${date1}" == "${EMPTY}"    Set Variable    ${0}    ELSE    Set Variable    ${date1}
    ${date2}    IF    "${date2}" == "${EMPTY}"    Set Variable    ${0}    ELSE    Set Variable    ${date2}
    ${date1_unix_second}    Convert Date    ${date1}    epoch    date_format=%d/%m/%Y
    ${date2_unix_second}    Convert Date    ${date2}    epoch    date_format=%d/%m/%Y
    IF     ${date1_unix_second} != ${date2_unix_second}
        Fail    msg=Invalid date compare: ${date1} != ${date2}
    END

Compare Date Should Be More Than
    [Documentation]    Owner : Rukpong
    ...                Support date format by "%d/%m/%Y"
    ...                Compare date1 and date2 should be more than
    [Tags]    keyword_action
    [Arguments]    ${date1}    ${date2}
    Check Variable Type    $var
    ${date1}    IF    "${date1}" == "${EMPTY}"    Set Variable    ${0}    ELSE    Set Variable    ${date1}
    ${date2}    IF    "${date2}" == "${EMPTY}"    Set Variable    ${0}    ELSE    Set Variable    ${date2}
    ${date1_unix_second}    Convert Date    ${date1}    epoch    date_format=%d/%m/%Y
    ${date2_unix_second}    Convert Date    ${date2}    epoch    date_format=%d/%m/%Y
    IF     ${date1_unix_second} <= ${date2_unix_second}
        Fail    msg=Invalid date compare: ${date1} >= ${date2}
    END

Compare Date Should Be Less Than
    [Documentation]    Owner : Rukpong
    ...                Support date format by "%d/%m/%Y"
    ...                Compare date1 and date2 should be less than
    [Tags]    keyword_action
    [Arguments]    ${date1}    ${date2}
    Check Variable Type    $var
    ${date1}    IF    "${date1}" == "${EMPTY}"    Set Variable    ${0}    ELSE    Set Variable    ${date1}
    ${date2}    IF    "${date2}" == "${EMPTY}"    Set Variable    ${0}    ELSE    Set Variable    ${date2}
    ${date1_unix_second}    Convert Date    ${date1}    epoch    date_format=%d/%m/%Y
    ${date2_unix_second}    Convert Date    ${date2}    epoch    date_format=%d/%m/%Y
    IF    ${date1_unix_second} >= ${date2_unix_second}
        Fail    msg=Invalid date compare: ${date1} >= ${date2}
    END

# Documentation

Set Test Provisioning Data
    [Documentation]    Owner : Rukpong
    ...    | ```$data``` | **<str>** |
    ...    *Example*: Set Test Provisioning Data | _<provisioning_data>_ |
    [Tags]    keyword_action
    [Arguments]    ${data}
    ${status}    Run Keyword And Return Status    Variable Should Exist    ${DOC_PROVISIONING_DATA}
    ${provisioning_data}      Set Variable If     ${status} == ${False}    ${EMPTY}    ${DOC_PROVISIONING_DATA}${\n}
    ${provisioning_detail}    Set Variable        ${provisioning_data}${data}
    Set Test Variable         ${DOC_PROVISIONING_DATA}    ${provisioning_detail}

Set Test Actual Result
    [Documentation]    Owner : Rukpong
    ...    | ```$data``` | **<str>** |
    ...    *Example*: Set Test Actual Result | _<actual result>_ |
    [Tags]    keyword_action
    [Arguments]    ${data}
    ${status}    Run Keyword And Return Status    Variable Should Exist    ${DOC_ACTUAL_RESULT}
    ${actual_result_data}      Set Variable If    ${status} == ${False}         ${EMPTY}    ${DOC_ACTUAL_RESULT}${\n}
    ${actual_result_detail}    Set Variable       ${actual_result_data}${data}
    Set Test Variable          ${DOC_ACTUAL_RESULT}    ${actual_result_detail}

Set Test Documentation Detail
    [Documentation]     Owner : Rukpong
    ...    = Detail =
    ...    | append provisioning data and actual result to documentation detail |
    ...    =  Result =
    ...    | ** Provisioning data ** |
    ...    | provisioning data <str> |
    ...    | ** Actual Result ** |
    ...    | actual result <str> |
    [Tags]    keyword_action
    ${status}    Run Keyword And Return Status    Should Contain    ${TEST_DOCUMENTATION}    Provisioning data
    IF    ${status} == ${False}
        ${header_provisioning_data}    Set Variable    ${\n}***Provisioning data***${\n}
    ELSE
        ${header_provisioning_data}    Set Variable    ${\n}
    END
    Set Test Documentation         ${header_provisioning_data}     append=True
    Set Test Documentation         ${DOC_PROVISIONING_DATA}        append=True
    ${header_actual_result}        Set Variable                    ${\n}***Actual Result***${\n}
    Set Test Documentation         ${header_actual_result}         append=True
    Set Test Documentation         ${DOC_ACTUAL_RESULT}            append=True

# Command keyword

Change Date Format
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    [Arguments]    ${date}    ${result_format}    ${date_format}=${None}
    ${os}    Evaluate    sys.platform    modules=sys
    ${result_format}    IF    '${os}' == 'win32'    Replace String    ${result_format}    -    \#
    ${type}    Check Variable Type    ${date}
    IF    "${type}" != "<class 'datetime.datetime'>" and "${date_format}" == "${None}"
        FAIL    msg=Cannot get date_format for none datetime variable
    ELSE
        ${date}    Convert Date    date=${date}    result_format=${result_format}    date_format=${date_format}
    END
    RETURN    ${date}

# DEPRECATED keyword

Do Manual Testing
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_action    deprecated
    ${msg_deprecated}    Catenate    This keyword 'Do Manual Testing' was DEPRECATED!!
    ...    The keyword 'Verify Value Should Be Equal' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    TRY
        List Should Not Contain Value    ${TEST_TAGS}    ManualTest
    EXCEPT
        Skip    msg=Do manual testing
    END

Robot Wait Time
    [Documentation]    Owner: Nakarin
    ...    Use for demand robot to wait with time(DateTime Library format)
    ...    Support format of DateTime Library.
    ...    *** Conditions ***
    ...    - Use for only case with wait more than 1 min
    ...    - Substitute for "Sleep"
    ...    - Use with custom keyword "Check Wait Time"
    ...    *** Example ***
    ...    Wait For Time    5min   ==>   The robot will use keyword wait for 5 min and do nothing
    [Tags]    keyword_action    deprecated
    [Arguments]    ${time_}    ${timeout}=10s
    ${msg_deprecated}    Catenate    This keyword 'Robot Wait Time' was DEPRECATED!!
    ...    The keyword 'Verify Value Should Be Equal' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    ${current_time}       Get Current Date    result_format=%H:%M:%S
    ${current_time}       Convert Time        ${current_time}
    ${expected_time}      Add Time To Time    ${current_time}       ${time_}
    Wait Until Keyword Succeeds   ${time_}    ${timeout}    Check Wait Time    ${expected_time}

Check Wait Time
    [Documentation]    Owner: Nakarin
    ...    Use in keyword "Robot Wait" with "Wait Until Keyword Succeeds".
    ...    For check the expected wait time
    [Tags]    keyword_command    robot:private    deprecated
    [Arguments]    ${expected_time}
    ${msg_deprecated}    Catenate    This keyword 'Check Wait Time' was DEPRECATED!!
    ...    The keyword 'Verify Value Should Be Equal' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    ${current_time}    Get Current Date    result_format=%H:%M:%S
    ${current_time}    Convert Time        ${current_time}
    ${result}          Evaluate            ${expected_time} - ${current_time}
    Should Be True     ${result} <= 0

Verify Value Should Be Equal
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${actual_value}    ${expected_value}
    ${msg_deprecated}    Catenate    This keyword 'Verify Value Should Be Equal' was DEPRECATED!!
    ...    The keyword 'Verify Value Should Be Equal' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    Should Be Equal As Strings    ${actual_value}    ${expected_value}
    ...    msg=Actual value: '${actual_value}' is not equal expected value: '${expected_value}'.
    ...    values=${False}
    Log    Actual value: '${actual_value}' is equal expected value: '${expected_value}'.

Verify Value Should Be Equal By Lower Case
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${actual_value}    ${expected_value}
    ${msg_deprecated}    Catenate    This keyword 'Verify Value Should Be Equal By Lower Case' was DEPRECATED!!
    ...    The keyword 'Verify Value Should Be Equal By Lower Case' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    ${actual_value_lower}      Convert To Lower Case    ${actual_value}
    ${expected_value_lower}    Convert To Lower Case    ${expected_value}
    Should Be Equal As Strings    ${actual_value_lower}    ${expected_value_lower}
    ...    msg=Actual value: '${actual_value_lower}' is not equal expected value: '${expected_value_lower}'.
    ...    values=${False}
    Log    Actual value: '${actual_value_lower}' is equal expected value: '${expected_value_lower}'.

Verify Value Should Not Be Equal
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${actual_value}    ${expected_value}
    ${msg_deprecated}    Catenate    This keyword 'Verify Value Should Not Be Equal' was DEPRECATED!!
    ...    The keyword 'Verify Value Should Not Be Equal' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    Should Not Be Equal As Strings    ${actual_value}    ${expected_value}
    ...    msg=Actual value: '${actual_value}' is equal expected value: '${expected_value}'.
    ...    values=${False}
    Log    Actual value: '${actual_value}' is not equal expected value: '${expected_value}'.

Verify Number Should Be Equal
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${actual_number}    ${expected_number}
    ${msg_deprecated}    Catenate    This keyword 'Verify Number Should Be Equal' was DEPRECATED!!
    ...    The keyword 'Verify Number Should Be Equal' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    ${actual_number}      Convert String To Number    ${actual_number}
    ${expected_number}    Convert String To Number    ${expected_number}
    Should Be Equal As Numbers    ${actual_number}    ${expected_number}
    ...    msg=Actual number: '${actual_number}' is not equal expected number: '${expected_number}'.
    ...    values=${False}
    Log    Actual number: '${actual_number}' is equal expected number: '${expected_number}'.

Convert String To Number
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command    deprecated
    [Arguments]    ${string_number}
    ${msg_deprecated}    Catenate    This keyword 'Convert String To Number' was DEPRECATED!!
    ...    The keyword 'Convert String To Number' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    ${string_number}    Convert To String    ${string_number}
    ${number}           Remove String        ${string_number}    ,
    RETURN    ${number}

Verify Item Should Contain List
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${list}    ${expect_item_in_list}
    ${msg_deprecated}    Catenate    This keyword 'Verify Item Should Contain List' was DEPRECATED!!
    ...    Use keyword 'Verify Value Should Contain' instead.
    Log     ${msg_deprecated}    level=WARN
    Should Contain    ${list}    ${expect_item_in_list}    msg=Item: '${expect_item_in_list}' is not contain in list.
    ...    values=${False}
    Log    Item: '${expect_item_in_list}' is contain in list.

Verify Should Match Regexp
    [Documentation]     Onwer : Rukpong
    [Tags]      keyword_action    deprecated
    [Arguments]     ${message_validate}     ${format_regexp}
    ${msg_deprecated}    Catenate    This keyword 'Verify Should Match Regexp' was DEPRECATED!!
    ...    The keyword 'Verify Should Match Regexp' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    Should Match Regexp    ${message_validate}    ${format_regexp}
    ...    msg=Message: '${message_validate}' is not match pattern regexp: '${format_regexp}'.\
    ...    values=${False}
    Log    Message: '${message_validate}' is match pattern regexp: '${format_regexp}'.

Verify Lists Should Be Equal
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_communicate    deprecated
    [Arguments]    ${actual_list}    ${expect_list}
    ${msg_deprecated}    Catenate    This keyword 'Verify Lists Should Be Equal' was DEPRECATED!!
    ...    The keyword 'Verify Lists Should Be Equal' should be grouped separately with its own keywords.
    Log     ${msg_deprecated}    level=WARN
    Lists Should Be Equal    ${actual_list}    ${expect_list}    msg=Lists: ${actual_list} != ${expect_list}.
    ...    values=${False}
    Log    actual list and expect list is equal. (${expect_list})

# Notification Output Report

Send Result Notification
    [Documentation]    Owner : Nakarin
    ...    == \*Keyword DREPLICATE!! ==
    [Tags]    keyword_action    deprecated
    Log    Send Result Notification keyword was DREPLICATE!!    level=WARN
    ${path}      Join Path    ${CURDIR}    ./notification_config.yaml
    ${status}    Run Keyword And Return Status
    ...          File Should Exist    ${path}
    IF    ${status} == ${False}    Pass Execution    Do not have config file for sending notification
    Import Variables    ${path}
    ${notification_config}    Get Variable Value    $notification_config
    Log Many   &{notification_config}
    IF    $notification_config.user == ${None} or $notification_config.platform == ${None}
        Pass Execution    Do not have user or platform config for send the notification
    END
    ${schema}    Get Notification Schema    ${notification_config}
    ${verify_ssl_certificate}    Get Variable Value    $verify_ssl_certificate    ${False}
    Import Library    RequestsLibrary
    IF    $notification_config.alert == ${True}
        POST    url=${schema.url}
        ...     headers=${schema.header}
        ...     json=${schema.body}
        ...     proxies=${schema.proxy}
        ...     verify=${verify_ssl_certificate}
    END

Get Notification Schema
    [Documentation]    Owner : Nakarin
    ...    == \*Keyword DREPLICATE!! ==
    [Arguments]    ${schema}
    [Tags]    keyword_command    deprecated
    Log    Get Notification Schema keyword was DREPLICATE!!    level=WARN
    ${test_site}    Get Variable Value    $TEST_SITE
    ${proxy_status}       Get Variable Value       $FLAG_SET_PROXY_UI    ${None}
    IF    ${proxy_status} == ${True}
        ${proxy}          Get Variable Value       $proxy_api    ${None}
    ELSE
        ${proxy}          Set Variable             ${None}
    END
    ${header}             Create Dictionary        Content-type=application/json
    ${pass}               Get Variable Value       $TEST_PASS
    ${fail}               Get Variable Value       $TEST_FAIL
    ${skip}               Get Variable Value       $TEST_SKIP
    ${test_suite_name}    Set Notification Test Suite Name
    ${hour}               Get Variable Value       $NOTIFICATION_TIME
    ${string}             Convert To Lower Case    ${schema.platform}
    IF    '${string}' == 'slack'
        IF    '${schema.user}' == 'JenkinsTest'
            ${url}     Set Variable If    800 < ${hour} < 1830
            ...    ${schema.webhook.slack.jenkins[1]}    ${schema.webhook.slack.jenkins[0]}
        ELSE
            ${url}     Set Variable    ${schema.webhook.slack.others[0]}
        END
        ${body_schema}    Catenate    ===================================${\n}
        ...    Test by: ${schema.user}${\n}Suite name: ${test_suite_name}${\n}
        ...    Test Site: ${test_site}${\n}
        ...    PASS: ${pass}${\n}
        ...    FAIL: ${fail}${\n}
        ...    SKIP: ${skip}${\n}
        ...    ===================================
        ${body_schema}    Convert To String    ${body_schema}
        Log               ${body_schema}
        ${body}           Create Dictionary    text=${body_schema}
    ELSE
        Log    ${string} platform was not support
    END
    ${schemas}     Create Dictionary    url=${url}    header=${header}    body=${body}    proxy=${proxy}
    RETURN    ${schemas}

Set Notification Test Suite Name
    [Documentation]    Owner : Nakarin
    ...    == \*Keyword DREPLICATE!! ==
    [Tags]     keyword_command    deprecated
    Log    Set Notification Test Suite Name was DREPLICATE!!    level=WARN
    Log        ${SUITE_NAME}
    ${name}    Split String    ${SUITE_NAME}    .
    RETURN     ${name}[-1]
