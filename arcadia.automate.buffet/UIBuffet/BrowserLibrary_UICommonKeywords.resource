*** Settings ***
Documentation    Improvement keyword Support Robotframework 5.0+
Library     String
Library     Collections
Library     OperatingSystem
Library     Browser
Resource    ../RobotBuffet/BuiltinLibrary_CommonKeywords.resource


*** Variables ***
&{window_fullscreen_size}       width=1366    height=768


*** Keywords ***
# Set up browser
Set Proxy Browser
    [Documentation]    Owner : Rukpong
    ...    check variable \${FLAG_SET_PROXY_UI} to setting status proxy (True, False)
    ...    and check variable \${PROXY_UI} to set value for proxy (dict value http domain)
    ...    proxy is not set value proxy will use default value = \${None}
    [Tags]    keyword_command    robot:private    deprecated
    ${msg_deprecated}    Catenate    This keyword 'Set Proxy Browser' was DEPRECATED!!
    ...    Use keyword 'Set Proxy New Browser' instead.
    Log     ${msg_deprecated}    level=WARN
    ${set_proxy}    Get Variable Value    $FLAG_SET_PROXY_UI    ${False}
    IF    ${set_proxy} == ${True}
        ${proxy_ui_value}    Get Variable Value    $PROXY_UI    ${None}
    ELSE
        ${proxy_ui_value}    Set Variable          ${None}
        Log    Variable '$FLAG_SET_PROXY_UI' is not found. It is not set proxy to browser.
    END
    RETURN    ${proxy_ui_value}

Set Proxy New Browser
    [Documentation]    Owner : Nakarin
    ...    To set proxy please set $Uat.SetProxy to be True in variable in testsite.yaml file and
    ...    add the key of proxy $username and $password or other into $Uat.Proxy .
    ...    Please see readme.md for more information
    [Tags]    keyword_command    robot:private
    ${test_site}    Get Variable Value    $TestSite
    IF    '${test_site}' == '${None}'
        Log    The variable '$TestSite' is invalid or does not exist in the 'default_config.yaml' file. The browser cannot running in different site or setting some config.
        ...    level=ERROR
    END
    ${set_proxy}    Get Variable Value    $${test_site}.SetProxy    ${False}
    IF    ${set_proxy} == ${True}
        ${proxy_ui_value}    Get Variable Value    $${test_site}.Proxy
        IF    '${proxy_ui_value}' == '${None}'
            Fail    msg=Cannot setting proxy in browser, there's no '$${test_site}.Proxy' value in 'testsite.yaml' file
        END
    ELSE
        ${proxy_ui_value}    Set Variable    ${None}
        Log    Variable '$${test_site}.SetProxy' is not found. It is not set proxy to browser.
    END
    RETURN    ${proxy_ui_value}

Set Up Browser Fullscreen
    [Documentation]    Owner : Rukpong
    ...    browser=chromium (Google Chrome, Microsoft Edge (since 2020), Opera)
    ...    browser=firefox (Mozilla Firefox)
    ...    browser=webkit (Apple Safari, Mail, AppStore on MacOS and iOS)
    [Tags]    keyword_action
    [Arguments]    ${browser}=chromium           ${headless}=${False}
    ...    ${ignore_ssl_certificate}=${False}    ${downloads_path}=${None}
    ...    ${browser_timeout_new_context}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Set Up Browser Fullscreen' was DEPRECATED!!
    ...    Use keyword 'Open New Browser' instead.
    Log     ${msg_deprecated}    level=WARN
    ${proxy_ui}    Set Proxy New Browser
    Set Default Permission
    ${location}    Set Default Geolocation
    ${active_context}           Create List
    ${active_context_list}      Get Variable Value    $CONTEXT_LIST    ${active_context}
    ${active_context_length}    Get Length            ${active_context_list}
    IF    ${active_context_length} == 0
        New Browser
        ...    browser=${browser}
        ...    headless=${headless}
        ...    proxy=${proxy_ui}
        ...    downloadsPath=${downloads_path}
        ${id_context}    New Context
        ...    acceptDownloads=${True}
        ...    ignoreHTTPSErrors=${ignore_ssl_certificate}
        ...    viewport=${window_fullscreen_size}
        ...    permissions=${PERMISSIONS}
        ...    geolocation=${location}
    ELSE
        ${id_context}    New Context
        ...    acceptDownloads=${True}
        ...    ignoreHTTPSErrors=${ignore_ssl_certificate}
        ...    viewport=${window_fullscreen_size}
        ...    permissions=${PERMISSIONS}
        ...    geolocation=${location}
    END
    ${status}    Run Keyword And Return Status    Variable Should Be Null    ${browser_timeout_new_context}
    IF    ${status} == ${True}
        Set All Default Timeout
    ELSE
        Set All Default Timeout    ${browser_timeout_new_context}
    END
    Append To List    ${active_context_list}    ${id_context}
    Set Suite Variable    \${CONTEXT_LIST}    ${active_context_list}
    RETURN    ${id_context}

Open New Browser
    [Documentation]    Owner : Nakarin
    ...    browser=chromium (Google Chrome, Microsoft Edge (since 2020), Opera)
    ...    browser=firefox (Mozilla Firefox)
    ...    browser=webkit (Apple Safari, Mail, AppStore on MacOS and iOS)
    ...    To set the responsive size please add key $Viewport.width and $Viewport.height into buffet_config.yaml file
    ...    Please see readme.md file for more information
    [Tags]    keyword_action
    [Arguments]    ${url}
    ...    ${browser}=chromium
    ...    ${browser_timeout_new_context}=${None}
    ${proxy_ui}    Set Proxy New Browser
    Set Default Permission
    ${location}    Set Default Geolocation
    ${accept_download}    ${file_download_path}    Set Default File Downloading Path
    ${headless}    Set Default Browser Headless
    ${ssl}         Set Validate SSL Certificate
    ${viewport}    Set Browser Screen Size
    ${active_context}           Create List
    ${active_context_list}      Get Variable Value    $CONTEXT_LIST    ${active_context}
    ${active_context_length}    Get Length            ${active_context_list}
    IF    ${active_context_length} == 0
        New Browser
        ...    browser=${browser}
        ...    headless=${headless}
        ...    proxy=${proxy_ui}
        ...    downloadsPath=${file_download_path}
    END
    ${id_context}    New Context
    ...    acceptDownloads=${accept_download}
    ...    ignoreHTTPSErrors=${ssl}
    ...    viewport=${viewport}
    ...    permissions=${permissions}
    ...    geolocation=${location}
    ${timeout}    Set Variable If    ${active_context_length} != 0    ${browser_timeout_new_context}    ${None}
    Set All Default Timeout    ${timeout}
    Append To List    ${active_context_list}    ${id_context}
    ${current_context_index}    Get Length      ${active_context_list}
    Set Suite Variable    \${CONTEXT_LIST}      ${active_context_list}
    Set Suite Variable    \${CURRENT_CONTEXT_INDEX}    ${current_context_index}
    New Page    ${url}

Set All Default Timeout
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_action    robot:private
    [Arguments]    ${timeout_new_context}=${None}
    ${browser_timeout}       Get Variable Value    ${timeout_new_context.browser_timeout }      ${None}
    ${assertion_timeout}     Get Variable Value    ${timeout_new_context.assertion_timeout}     ${None}
    ${screenshot_timeout}    Get Variable Value    ${timeout_new_context.screenshot_timeout}    ${None}
    Set Default Browser Timeout       ${browser_timeout}
    Set Default Assertion Timeout     ${assertion_timeout}
    Set Default Screenshot Timeout    ${screenshot_timeout}

Close Browser Context
    [Documentation]    Owner : Rukpong
    ...    arguments "context_index" to define index from context list for remove 'active_context_list'
    ...    context_index is support argument 'ALL' for clear data in list 'active_context_list'
    ...    argument: $context_index default is 'all', and it can set index for remove context by id (index number)
    [Tags]    keyword_action
    [Arguments]    ${context_index}=all
    ${context_argument}    Convert To String        ${context_index}
    IF    "${context_argument.lower()}" == "all"
        ${active_context_list}    Create List
        Close Context    ALL
    ELSE
        ${active_context_list}    Get Variable Value    $CONTEXT_LIST
        Close Context       ${active_context_list}[${${context_index} - 1}]
        Remove From List    ${active_context_list}    ${context_index}
    END
    Set Suite Variable    \${CONTEXT_LIST}    ${active_context_list}

Switch Browser Context
    [Documentation]    Owner : Rukpong    Editor: Nakarin
    ...    arguments "context_index" to define index from context list for prepare switch context to index
    ...    To swtich context please use index start from 1 to current index
    [Tags]    keyword_action
    [Arguments]    ${context_index}
    ${active_context_list}      Get Variable Value    $CONTEXT_LIST
    Switch Context        ${active_context_list}[${${context_index} - 1}]
    Set Suite Variable    ${CURRENT_CONTEXT_INDEX}    ${context_index}

# Verify selector

Verify Text On Selector
    [Documentation]    Owner : Rukpong    Editor: Nakarin
    ...    check text in selector (support empty string)
    ...    $old_text: support case text update in same selector. it is will check text change (setting from keyword 'Set Retry Assertions For')
    ...    *** Optinal ***
    ...    $ignore_case: for Upper and Lower String
    ...    $strip_spaces: (Boolean, LEADING, TRAILING) for remove all space from String
    ...    $collapse_spaces: for convert whitespace to ' '
    [Tags]    keyword_action
    [Arguments]    ${selector}                  ${expect_text}              ${old_text}=${None}
    ...            ${ignore_case}=${False}      ${strip_spaces}=${False}    ${collapse_spaces}=${False}
    Check Element Visible                       ${selector}
    ${expect_text}    Convert To String         ${expect_text}
    ${old_text}       Convert To String         ${old_text}
    ${actual_text}    Get Text From Selector    ${selector}       ${old_text}
    Should Be Equal As Strings                  ${actual_text}    ${expect_text}
    ...    values=${False}
    ...    ignore_case=${ignore_case}
    ...    strip_spaces=${strip_spaces}
    ...    collapse_spaces=${collapse_spaces}
    ...    msg=The text of element '${selector}' should have been '${expect_text}' but in fact it was '${actual_text}'.

Verify Text Not Equal On Selector
    [Documentation]    Owner : Nakarin
    ...    check text in selector (support empty string)
    ...    support case text update in same selector. it is will check text change (setting from keyword 'Set Retry Assertions For')
    ...    *** Optinal ***
    ...    ignore_case for Upper and Lower String
    ...    strip_spaces(Boolean, LEADING, TRAILING) for remove all space from String
    ...    collapse_spaces for convert whitespace to ' '
    [Tags]    keyword_action
    [Arguments]    ${selector}        ${expect_text}              ${old_text}=${None}
    ...    ${ignore_case}=${False}    ${strip_spaces}=${False}    ${collapse_spaces}=${False}
    Check Element Visible                       ${selector}
    ${expect_text}    Convert To String         ${expect_text}
    ${old_text}       Convert To String         ${old_text}
    ${actual_text}    Get Text From Selector    ${selector}       ${old_text}
    Should Not Be Equal As Strings              ${actual_text}    ${expect_text}
    ...    values=${False}
    ...    ignore_case=${ignore_case}
    ...    strip_spaces=${strip_spaces}
    ...    collapse_spaces=${collapse_spaces}
    ...    msg=The text of element '${selector}' should not equal '${expect_text}' but in fact it was '${actual_text}' == '${expect_text}'.

Verify Text Should Match Regexp On Selector
    [Documentation]    Owner: Nakarin
    ...    Check text match with Regexp in selector
    [Tags]    keyword_action
    [Arguments]    ${selector}    ${pattern}    ${old_text}=${None}
    Check Element Visible    ${selector}
    ${pattern}     Convert To String     ${pattern}
    ${old_text}    Convert To String     ${old_text}
    ${text}    Get Text From Selector    ${selector}    ${old_text}
    Should Match Regexp    ${text}       ${pattern}
    ...    values=${False}
    ...    msg=The text of selector '${selector}' should not match with '${pattern}' but text was '${text}'

Verify Number On Selector
    [Documentation]    Owner : Rukpong    Editor: Nakarin
    ...    check text in selector (support empty string) for convert to number and validate should be equal
    ...    support case text update in same selector. it is will check text change (setting from keyword 'Set Retry Assertions For')
    ...    Change logic of getting number string and convert it to number type
    [Tags]    keyword_action
    [Arguments]    ${selector}    ${expect_number_text}    ${decimal_digits}=${None}    ${old_number}=${None}
    Check Element Visible        ${selector}
    ${expect_string_number}    Convert To String    ${expect_number_text}
    ${expect_number_text}      Remove String        ${expect_string_number}    ,
    ${old_number_status}       Run Keyword And Return Status    Variable Should Be Null    ${old_number}
    IF    ${old_number_status} == ${True}
        ${actual_number_text}    Get Text    ${selector}    matches    \\d+
    ELSE
        ${actual_number_text}    Get Text    ${selector}    !=    ${old_number}
    END
    ${actual_number_text}    Remove String        ${actual_number_text}    ,
    ${actual_number}         Convert To Number    ${actual_number_text}    ${decimal_digits}
    ${expect_number}         Convert To Number    ${expect_number_text}    ${decimal_digits}
    Should Be Equal As Numbers    ${actual_number}    ${expect_number}
    ...    values=${False}
    ...    msg=The number of element '${selector}' should have been '${expect_number}' but in fact it was '${actual_number}'.

Verify Attribute On Selector
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    check value attribute in selector
    ...    Editor note: Add assertion for using in value not changed case
    [Tags]    keyword_action
    [Arguments]    ${selector}    ${attribute}    ${expect_value}    ${old_value}=${None}
    Check Element Visible    ${selector}
    ${expect_value}     Convert To String    ${expect_value}
    ${has_old_value}    Run Keyword And Return Status    Variable Should Be Null    ${old_value}
    IF    ${has_old_value} == ${True}
        ${actual_value}    Get Attribute    ${selector}    ${attribute}
    ELSE
        ${actual_value}    Get Attribute    ${selector}    ${attribute}    !=    ${old_value}
    END
    Should Be Equal As Strings    ${actual_value}    ${expect_value}
    ...    values=${False}
    ...    msg=The text of attribute element '${selector}' should have been '${expect_value}' but in fact it was '${actual_value}'.

Verify Attribute Should Match Regexp On Selector
    [Documentation]    Owner: Nakarin
    ...    Check attribute match with Regexp in selector
    [Tags]    keyword_action
    [Arguments]   ${selector}    ${attribute}    ${pattern}    ${old_value}=${None}
    Check Element Visible    ${selector}
    ${pattern}      Convert To String     ${pattern}
    ${has_old_value}    Run Keyword And Return Status    Variable Should Be Null    ${old_value}
    IF    ${has_old_value} == ${True}
        ${actual_value}    Get Attribute    ${selector}    ${attribute}
    ELSE
        ${actual_value}    Get Attribute    ${selector}    ${attribute}    !=    ${old_value}
    END
    Should Match Regexp    ${actual_value}  ${pattern}
    ...    values=${False}
    ...    msg=The text of selector '${selector}' should not match with '${pattern}' but actual value was '${actual_value}'

Verify Text Contain On Selector
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    check text contain in selector (not support empty string)
    ...    Editor note: Add support with ignore_case, strip_spaces and collapse_spaces
    [Tags]    keyword_action
    [Arguments]    ${selector}    ${expect_text}    ${ignore_case}=${False}    ${strip_spaces}=${False}    ${collapse_spaces}=${False}
    Check Element Visible         ${selector}
    ${actual_text}    Get Text    ${selector}    matches    .+
    Should Contain     ${actual_text}    ${expect_text}
    ...    ignore_case=${ignore_case}
    ...    strip_spaces=${strip_spaces}
    ...    collapse_spaces=${collapse_spaces}
    ...    values=${False}
    ...    msg=The text of element '${selector}' should contain '${expect_text}' but in fact it was '${actual_text}' not contain '${expect_text}'.

Verify Text Exist On Selector
    [Documentation]    Owner : Rukpong
    ...    check only text exist in selector
    [Tags]    keyword_action
    [Arguments]    ${selector}
    Check Element Visible         ${selector}
    ${actual_text}    Get Text    ${selector}    matches    .+
    ...    message=The text of element '${selector}' should has text exist but in fact it has no text.

Verify Text On Selector If Visible
    [Documentation]    Owner : Rukpong
    ...    check selector is visible and validate value in the selector.
    ...    state is not visible will skip validate.
    [Tags]    keyword_command
    [Arguments]    ${selector}        ${expect_text}              ${old_text}=${None}
    ...    ${ignore_case}=${False}    ${strip_spaces}=${False}    ${collapse_spaces}=${False}
    ...    ${timeout}=${None}
    ${status_state}    Run Keyword And Return Status
    ...    Verify State On Selector    ${selector}    visible    timeout=${timeout}
    IF    ${status_state} == ${True}
        Verify Text On Selector    ${selector}    ${expect_text}
        ...    old_text=${old_text}
        ...    ignore_case=${ignore_case}
        ...    strip_spaces=${strip_spaces}
        ...    collapse_spaces=${collapse_spaces}
    END

Verify State On Selector
    [Documentation]    Owner : Rukpong
    ...    set timeout from variable "\${wait_state_timeout}".
    ...    (default wait for element state timeout = 2s)
    ...    variable \${expect_state} can setting state
    ...    support state follow Browser library such = visible, hidden, enabled, disabled, selected, stable and etc.
    [Tags]    keyword_action
    [Arguments]    ${selector}    ${expect_state}    ${timeout}=${None}
    ${wait_state_timeout}      Get Variable Value    $Browser.WaitStateTimeout        2s
    ${wait_timeout}            Set Variable If       "${timeout}" == "${None}"    ${wait_state_timeout}    ${timeout}
    ${timeout_value}           Remove String         ${wait_state_timeout}    second    s
    Wait For Elements State    ${selector}
    ...    state=${expect_state}
    ...    timeout=${wait_timeout}
    ...    message=The state of element '${selector}' should have been '${expect_state}' but in fact state is invalid as '${expect_state}' in ${timeout_value} second(s).${\n}Tip: Use variable "$Browser.WaitStateTimeout" in "buffet_config.yaml" for increasing the timeout.

Verify Element Count In Selectors
    [Documentation]    Owner : Rukpong
    ...    variable "\${selectors}" has many elements for count elements.
    ...    variable "\${expect_element_count}" will compare with "\${element_count}".
    [Tags]    keyword_action
    [Arguments]    ${selectors}    ${expect_element_count}
    ${element_count}    Get Element Count     ${selectors}    ==    ${expect_element_count}
    ...    message=The count of element '${selectors}' should have been '${expect_element_count}' but in fact count of element is invalid as '${expect_element_count}'.

# Take screenshot

Take Screenshot Failure
    [Documentation]    Owner : Rukpong
    ...    set timeout from variable "\${screenshot_timeout}". (default timeout is 1 second)
    ...    get image name for case fail and take screenshot.
    [Tags]    keyword_action
    Log    'Take Screenshot Failure' keyword was DREPLICATE!! Use 'Browser Take Screenshot' keywords instead.
    ...    level=WARN
    ${take_screenshot_timeout}    Get Variable Value           $SCREENSHOT_TIMEOUT    5s
    ${screenshot_name}            Get Image Screenshot Name    fail
    Take Screenshot    ${screenshot_name}    timeout=${take_screenshot_timeout}
    Log    Error: Tried to take screenshot, but no page was open.    level=WARN

Take Screenshot Pass
    [Documentation]    Owner : Rukpong
    ...    set timeout from variable "\${screenshot_timeout}". (default timeout is 1 second)
    ...    get image name for case pass and take screenshot.
    [Tags]    keyword_action
    Log    'Take Screenshot Pass' keyword was DREPLICATE!! Use 'Browser Take Screenshot' keywords instead.
    ...    level=WARN
    ${take_screenshot_timeout}    Get Variable Value           $SCREENSHOT_TIMEOUT    5s
    ${screenshot_name}            Get Image Screenshot Name    pass
    Take Screenshot    ${screenshot_name}    timeout=${take_screenshot_timeout}

Browser Take Screenshot
    [Documentation]    Owner : Rukpong
    ...                $screenshot_name: pass, fail, or name image (default is 'pass' value)
    [Tags]    keyword_action
    [Arguments]    ${screenshot_name}=pass
    ${screenshot_path_name}    Get Image Screenshot Name    ${screenshot_name}
    ${page_list}               Get Page Ids
    ${page_length}             Get Length                   ${page_list}
    IF    ${page_length} != 0
        ${take_screenshot_timeout}    Get Variable Value    $SCREENSHOT_TIMEOUT    5s
        Take Screenshot    ${screenshot_path_name}    timeout=${take_screenshot_timeout}
    ELSE
        ${suite_name_screenshot}    Get Variable Value    $SUITE_NAME_SCREENSHOT
        Log    Error: Tried to take screenshot, but no page was open. At suite name '${suite_name_screenshot}'.
        ...    level=WARN
    END

# Command keyword

Get Image Screenshot Name
    [Documentation]    Owner : Rukpong
    ...    check case fail on suite setup (It is not run testcase) \${TEST_NAME} is not found.
    ...    split case status test pass/fail and bring state to set image name
    [Tags]    keyword_command    robot:private
    [Arguments]    ${screenshot_name}
    ${status}    Run Keyword And Return Status    Variable Should Exist    ${TEST_NAME}
    ...    msg=No testcase run. Variable 'TEST_NAME' is not found.
    @{spilt_suite_name}         Split String    ${SUITE_NAME}    .
    ${feature_name}             Set Variable    ${spilt_suite_name}[-1]
    ${suite_name_screenshot}    Set Variable    ${feature_name}
    IF    ${status} == ${True}
        @{split_code_testcase}    Split String    ${TEST_NAME}    ${SPACE}
        ${code_testcase}          Set Variable    ${split_code_testcase}[0]
        ${suite_name_screenshot}    Set Variable    ${suite_name_screenshot}-${code_testcase}
        Set Test Variable    \${SUITE_NAME_SCREENSHOT}    ${feature_name}-${code_testcase}
    END
    IF         "${screenshot_name}" == "fail"
        ${name}    Set Variable    ${OUTPUT_DIR}/fail-screenshot-${suite_name_screenshot}-{index}
    ELSE IF    "${screenshot_name}" == "pass"
        ${name}    Set Variable    ${OUTPUT_DIR}/pass-screenshot-${suite_name_screenshot}-{index}
    ELSE
        ${name}    Set Variable    ${OUTPUT_DIR}/screenshot-${suite_name_screenshot}-${screenshot_name}-{index}
    END
    RETURN    ${name}

Check Element Visible
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command    robot:private
    [Arguments]    ${selector}
    ${wait_state_timeout}      Get Variable Value    $Browser.WaitStateTimeout    2s
    ${timeout_value}           Remove String         ${wait_state_timeout}    second    s
    Wait For Elements State    ${selector}    visible    ${wait_state_timeout}
    ...    message=Element "${selector}" did not appear in ${timeout_value} second(s).${\n}Tip: Use variable "Browser.WaitStateTimeout" in "buffet_config.yaml" for increasing the timeout.

Get Text From Selector
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command    robot:private
    [Arguments]    ${selector}    ${old_text}=${None}
    ${old_text_status}    Run Keyword And Return Status    Variable Should Be Null    ${old_text}
    IF    ${old_text_status} == ${True}
        ${actual_text}    Get Text    ${selector}
    ELSE
        ${actual_text}    Get Text    ${selector}    !=    ${old_text}
    END
    RETURN    ${actual_text}

Set Default Browser Timeout
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_command    robot:private
    [Arguments]    ${timeout}=${None}
    Log    ${timeout}
    IF    '${timeout}' == '${None}'
        ${status}    Run Keyword And Return Status
        ...    Variable Should Exist    $Browser.BrowserTimeout
        IF    ${status} == ${False}
            Log    The variable '$Browser.BrowserTimeout' is invalid or does not exist in the 'buffet_config.yaml' file. The browser timeout has been set to the default timeout of 10 second.
            ...    level=WARN
        END
        ${browser_timeout}     Get Variable Value     $Browser.BrowserTimeout    10s
    ELSE
        ${browser_timeout}    Set Variable    ${timeout}
    END
    Set Browser Timeout    ${browser_timeout}
    Set Global Variable    \${BROWSER_TIMEOUT}    ${browser_timeout}

Set Default Assertion Timeout
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_command    robot:private
    [Arguments]    ${timeout}=${None}
    IF    '${timeout}' == '${None}'
        ${status}    Run Keyword And Return Status
        ...    Variable Should Exist    $Browser.AssertionTimeout
        IF    ${status} == ${False}
            Log    The variable '$Browser.AssertionTimeout' is invalid or does not exist in the 'buffet_config.yaml' file. The assertion timeout has been set to the default timeout of 2 seconds.
            ...    level=WARN
        END
        ${assertion_timeout}        Get Variable Value       $Browser.AssertionTimeout    2s
    ELSE
        ${assertion_timeout}    Set Variable    ${timeout}
    END
    Set Retry Assertions For    ${assertion_timeout}
    Set Global Variable         \${ASSERTION_TIMEOUT}    ${assertion_timeout}

Set Default Screenshot Timeout
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_command    robot:private
    [Arguments]    ${timeout}=${None}
    IF    '${timeout}' == '${None}'
        ${status}    Run Keyword And Return Status
        ...    Variable Should Exist    $Browser.ScreenshotTimeout
        IF    ${status} == ${False}
            Log    The variable '$Browser.ScreenshotTimeout' is invalid or does not exist in the 'buffet_config.yaml' file. The screenshot timeout has been set to the default timeout of 2 seconds.
            ...    level=WARN
        END
        ${screenshot_timeout}    Get Variable Value    $Browser.ScreenshotTimeout    2s
    ELSE
        ${screenshot_timeout}    Set Variable    ${timeout}
    END
    Set Global Variable    \${SCREENSHOT_TIMEOUT}    ${screenshot_timeout}

Set Default Geolocation
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    ${location}       Get Variable Value    $Browser.Location
    ${permissions}    Get Variable Value    $PERMISSIONS
    IF  ${location} != ${None} and ${permissions} == ${None}
        ${permissions}    Create List    geolocation
    ELSE IF    ${location} != ${None} and ${permissions} != ${None}
        ${status}    Run Keyword And Return Status
        ...          List Should Contain Value           ${permissions}    geolocation
        IF    ${status} == ${False}    Append To List    ${permissions}    geolocation
    ELSE
        Log    Geolocation Permission Decline
    END
    Set Global Variable    ${PERMISSIONS}
    RETURN    ${location}

Set Default Permission
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    ${permissions}          Get Variable Value    $PERMISSION
    ${permission_config}    Get Variable Value    $Browser.Permissions
    IF    ${permissions} == ${None}
        ${permissions}    Set Variable         ${permission_config}
    ELSE
        ${permissions}    Combine Lists        ${permissions}    ${permission_config}
        ${permissions}    Remove Duplicates    ${permissions}
    END
    Set Global Variable    ${PERMISSIONS}

Set Default File Downloading Path
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    ${status}    Run Keyword And Return Status
    ...          Variable Should Exist    $Browser.DownloadPath
    IF    ${status} == ${False}
        ${path}    Set Variable    ${None}
        ${accept_download}    Set Variable    ${False}
    ELSE
        ${download_path}    Get Variable Value    $Browser.DownloadPath    Downloads
        ${path}    Join Path    ${CURDIR}    ../../    ${download_path}
        ${accept_download}    Set Variable    ${True}
    END
    RETURN    ${accept_download}    ${path}

Set Default Browser Headless
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    ${status}      Run Keyword And Return Status
    ...            Variable Should Exist    $Browser.Headless
    ${headless}    Get Variable Value       $Browser.Headless    ${False}
    IF    ${status} == ${False}
        Log    The variable '$Browser.Headless' is invalid or does not exist in the 'buffet_config.yaml' file. The browser will have problems when running in CI/CD pipeline.
        ...    level=ERROR
    END
    RETURN    ${headless}

Set Validate SSL Certificate
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    ${test_site}    Get Variable Value    $TestSite
    IF    '${test_site}' == '${None}'
        Log    The variable '$TestSite' is invalid or does not exist in the 'default_config.yaml' file. or browser cannot ignore Ssl certificate.
        ...    level=ERROR
        ${ignore_ssl_certificate}    Set Variable    ${None}
    ELSE
        ${status}       Run Keyword And Return Status
        ...             Variable Should Exist    $${test_site}.IgnoreSslCertificate
        IF    ${status} == ${False}
            Log    The variable '$${test_site}.IgnoreSslCertificate' is invalid or does not exist in the 'testsite.yaml' file. The browser cannot running when there is no SSL certificate.
            ...    level=WARN
        ELSE
            ${ignore_ssl_certificate}    Get Variable Value    $${test_site}.IgnoreSslCertificate    ${False}
        END
    END
    RETURN    ${ignore_ssl_certificate}

Set Browser Screen Size
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    ${status}      Run Keyword And Return Status
    ...            Variable Should Exist    $Browser.Viewport
    ${viewport}    Get Variable Value     $Browser.Viewport    &{window_fullscreen_size}
    IF    ${status} == ${False}
        Log    ${\n}The variable '$Browser.Viewport' is invalid or does not exist in the 'buffet_config.yaml' file. The browser will using default viewport ${window_fullscreen_size}.
    END
    RETURN    ${viewport}
