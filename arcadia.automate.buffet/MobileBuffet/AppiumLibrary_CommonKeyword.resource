*** Settings ***
Documentation    Support Appium Library Version 2.0 or later
Library    Collections
Library    String
Library    OperatingSystem
Library    AppiumLibrary
Resource    ../RobotBuffet/BuiltinLibrary_CommonKeywords.resource


*** Keywords ***
# Set up
Open Android Application
    [Documentation]    Owner : Rukpong
    ...                $TimeoutDriverUiautomator = default 20000 ms (it can setting on config file)
    [Tags]    keyword_action
    [Arguments]    ${application_name}
    ${capacibility}    Get Variable Value      ${MobileDevice.Android.${application_name}.Config}
    ${capacibility}    Check Android Config    ${capacibility}
    Set Default Appium Timeout
    ${status}    Run Keyword And Return Status
    ...    Variable Should Exist    ${CONTEXT}
    IF    ${status} == ${True}
        @{context}    Get Variable Value    $CONTEXT
    ELSE
        @{context}    Create List
    END
    ${new_context}    Open Application
    ...    remote_url=${MobileDevice.Android.${application_name}}[RemoteUrl]
    ...    alias=${MobileDevice.Android.${application_name}}[Alias]
    ...    &{capacibility}
    ${page_height}    ${page_width}    Get Mobile Screen Size
    ${current_context}    Create Dictionary
    Set To Dictionary    ${current_context}
    ...    context=${new_context}
    ...    page_height=${page_height}
    ...    page_width=${page_width}
    Append To List    ${context}    ${current_context}
    ${current_context_index}    Get Length    ${context}
    Set Suite Variable    \${CONTEXT}
    Set Suite Variable    \${CURRENT_CONTEXT_INDEX}

Check Android Config
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    [Arguments]    ${capacibility}
    Dictionary Should Contain Key    ${capacibility}    platformName
    Dictionary Should Contain Key    ${capacibility}    platformVersion
    Dictionary Should Contain Key    ${capacibility}    deviceName
    Dictionary Should Contain Key    ${capacibility}    appPackage
    Dictionary Should Contain Key    ${capacibility}    appActivity
    Dictionary Should Contain Key    ${capacibility}    automationName
    RETURN    ${capacibility}

Open IOS Application
    [Documentation]    Owner : Rukpong
    ...                $TimeoutDriverUiautomator = default 20000 ms (it can setting on config file)
    [Tags]    keyword_action
    [Arguments]    ${application_name}
    ${capacibility}    Get Variable Value      ${MobileDevice.iOS.${application_name}.Config}
    ${capacibility}    Check IOS Config        ${capacibility}
    Set Default Appium Timeout
    ${status}    Run Keyword And Return Status
    ...    Variable Should Exist    ${CONTEXT}
    IF    ${status} == ${True}
        @{context}    Get Variable Value    $CONTEXT
    ELSE
        @{context}    Create List
    END
    ${new_context}    Open Application
    ...    remote_url=${MobileDevice.iOS.${application_name}}[RemoteUrl]
    ...    alias=${MobileDevice.iOS.${application_name}}[Alias]
    ...    &{capacibility}
    ${page_height}    ${page_width}    Get Mobile Screen Size
    ${current_context}    Create Dictionary
    Set To Dictionary    ${current_context}
    ...    context=${new_context}
    ...    page_height=${page_height}
    ...    page_width=${page_width}
    Append To List    ${context}    ${current_context}
    ${current_context_index}    Get Length    ${context}
    Set Suite Variable    \${CONTEXT}
    Set Suite Variable    \${CURRENT_CONTEXT_INDEX}

Check IOS Config
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    [Arguments]    ${capacibility}
    Dictionary Should Contain Key    ${capacibility}    platformName
    Dictionary Should Contain Key    ${capacibility}    platformVersion
    Dictionary Should Contain Key    ${capacibility}    deviceName
    Dictionary Should Contain Key    ${capacibility}    udid
    Dictionary Should Contain Key    ${capacibility}    app
    Dictionary Should Contain Key    ${capacibility}    automationName
    RETURN    ${capacibility}

Switch To Mobile Device
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_action
    [Arguments]    ${index}
    Switch Application    ${index}
    Set Suite Variable    ${CURRENT_CONTEXT}    ${index}

# Image

Mobile Capture Page Screenshot
    [Documentation]    Owner : Rukpong
    ...                $verify_point_fullname for custom image name
    ...                example: /your/path/screenshot-feature-test001$verify_point_fullname-1.png
    [Tags]    keyword_action
    [Arguments]    ${verify_point_fullname}=${EMPTY}
    ${has_test_name}        Run Keyword And Return Status    Variable Should Exist    ${TEST_NAME}
    ...    msg=No testcase run. Variable 'TEST_NAME' is not found.
    @{split_suite_name}     Split String               ${SUITE_NAME}    .
    ${feature_name}         Set Variable               ${split_suite_name}[-1]
    ${screenshot_index}     Get Variable Value         $SCREENSHOT_INDEX    ${0}
    Set Global Variable     \${SCREENSHOT_INDEX}       ${screenshot_index.__add__(1)}
    ${status}    Run Keyword And Return Status    Should Be Empty    ${verify_point_fullname}
    IF    ${status} == ${True}
        ${split_ext_file}       Split String From Right    ${verify_point_fullname}    .    1
        ${length_split_ext_file}    Get Length    ${split_ext_file}
        IF    ${length_split_ext_file} < 2
            Fail    msg=The argument '$actual_image_fullname' should have an image name with a file extension. (example .png)
        END
        ${image_name}    Set Variable    -${split_ext_file}[0]
    ELSE
        ${image_name}    Set Variable    ${verify_point_fullname}
    END
    IF    ${has_test_name} == ${True}
        @{split_code_testcase}    Split String    ${TEST_NAME}    ${SPACE}
        ${code_testcase}          Set Variable    ${split_code_testcase}[0]
        ${screenshot_name}        Set Variable    ${OUTPUT_DIR}${/}screenshot-${feature_name}-${code_testcase}${image_name}-${screenshot_index}
    ELSE
        ${screenshot_name}        Set Variable    ${OUTPUT_DIR}${/}screenshot-${feature_name}${image_name}-${screenshot_index}
    END
    Capture Page Screenshot    ${screenshot_name}.png

Mobile Capture Mobile Element Screenshot
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    $output_screenshot_path set child path from $OUTPUT_DIR
    ...    example: outout default path is /your/path/screenshot.png
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${output_screenshot_path}=${EMPTY}    ${timeout}=${None}
    Import Library    ${CURDIR}${/}..${/}Library${/}image.py
    ${status}    Run Keyword And Return Status    Should Be Empty    ${output_screenshot_path}
    ${output_screenshot_path}    Set Variable If    ${status} == ${True}    ${OUTPUT_DIR}${/}crop-screenshot.png    ${output_screenshot_path}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    Capture Mobile Element          ${locator}    ${output_screenshot_path}

Mobile Compare Image At Element
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    $referance_image_path = full path for source image
    ...    $actual_image = image for compare to referance_image (with extension example .png)
    ...    $different_percent = acceptance percent for different image. It can 1-100. (default is 3)
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action
    [Arguments]    ${referance_image_path}    ${locator}    ${actual_image_fullname}=${EMPTY}    ${different_percent}=3    ${timeout}=${None}
    IF    ${different_percent} < 1 or ${different_percent} > 100    Fail    msg=Different percent should value between 1 - 100.
    Import Library       ${CURDIR}${/}..${/}Library${/}image.py
    ${status}    Run Keyword And Return Status    Should Be Empty    ${actual_image_fullname}
    IF    ${status} == ${True}
        ${actual_image_fullname}    Set Variable    actual_image.png
        ${output_different_name}    Set Variable    diff_point.png
    ELSE
        ${split_ext_file}           Split String From Right    ${actual_image_fullname}    .    1
        ${length_split_ext_file}    Get Length                 ${split_ext_file}
        IF    ${length_split_ext_file} < 2
            Fail    msg=The argument '$actual_image_fullname' should have an image name with a file extension. (example .png)
        END
        ${output_different_name}    Set Variable    diff_${split_ext_file}[0].png
    END
    ${actual_image_path}            Set Variable    ${OUTPUT_DIR}${/}actual${/}${TEST_NAME}${/}${actual_image_fullname}
    Check Page Contain Mobile Element    ${locator}      ${timeout}
    Capture Mobile Element          ${locator}      ${actual_image_path}
    Compare Images     base_image=${referance_image_path}
    ...    actual_image=${actual_image_path}
    ...    output_image_name=${output_different_name}
    ...    tolerance=${different_percent}

# Action

Click On Element
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${timeout}=${None}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    Click Element    ${locator}

Click On Specific Element
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${timeout}=${None}
    Check Page Contain Mobile Element    ${locator}   ${timeout}
    ${element_location}       Get Element Location    ${locator}
    ${element_size}           Get Element Size        ${locator}
    ${half_element_width}     Evaluate    ${element_size}[width]/2
    ${half_element_height}    Evaluate    ${element_size}[height]/2
    ${x_position}             Evaluate    ${element_location}[x]+${half_element_width}
    ${y_position}             Evaluate    ${element_location}[y]+${half_element_height}
    @{position}         Create List    ${x_position}    ${y_position}
    @{position_list}    Create List    ${position}
    Tap With Positions    ${200}    @{position_list}

Click On Screen
    [Documentation]    Owner : Rukpong
    ...                $section = define 9 parts of the screen (1-9)
    ...                section1 = top left    | section2 = top middle    | section3 = top right
    ...                section4 = left center | section5 = center screen | section6 = right center
    ...                section7 = bottom left | section8 = bottom middle | section9 = bottom right
    [Tags]    keyword_action
    [Arguments]    ${section}=1
    IF    ${section} < 1 or ${section} > 9    Fail    msg=Section should value between 1 - 9.
    ${page_height}    Set Variable    $CONTEXT[${CURRENT_CONTEXT}][height]
    ${page_width}     Set Variable    $CONTEXT[${CURRENT_CONTEXT}][width]
    # ${page_height}    Get Window Height
    # ${page_width}     Get Window Width
    ${x_section}         Evaluate    ${page_width}/3
    ${x_half_section}    Evaluate    ${x_section}/2
    ${x_1}               Evaluate    int(${x_section} - ${x_half_section})
    ${x_2}               Evaluate    int((${x_section}*2) - ${x_half_section})
    ${x_3}               Evaluate    int((${x_section}*3) - ${x_half_section})
    ${y_section}         Evaluate    ${page_height}/3
    ${y_half_section}    Evaluate    ${y_section}/2
    ${y_1}               Evaluate    int(${y_section} - ${y_half_section})
    ${y_2}               Evaluate    int((${y_section}*2) - ${y_half_section})
    ${y_3}               Evaluate    int((${y_section}*3) - ${y_half_section})
    @{position_section_1}    Create List    ${x_1}    ${y_1}
    @{position_section_2}    Create List    ${x_2}    ${y_1}
    @{position_section_3}    Create List    ${x_3}    ${y_1}
    @{position_section_4}    Create List    ${x_1}    ${y_2}
    @{position_section_5}    Create List    ${x_2}    ${y_2}
    @{position_section_6}    Create List    ${x_3}    ${y_2}
    @{position_section_7}    Create List    ${x_1}    ${y_3}
    @{position_section_8}    Create List    ${x_2}    ${y_3}
    @{position_section_9}    Create List    ${x_3}    ${y_3}
    @{position_list}         Create List    ${position_section_${section}}
    Tap With Positions    ${200}    @{position_list}

Click On Position
    [Documentation]    Owner : Rukpong
    ...                set point x, y for specific point on screen
    [Tags]    keyword_action
    [Arguments]    ${x_point}    ${y_point}
    @{position_point}    Create List    ${x_point}    ${y_point}
    @{position_list}     Create List    ${position_point}
    Tap With Positions    ${200}    @{position_list}

Input Text On Element
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${input_text}    ${timeout}=${None}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    AppiumLibrary.Input Text    ${locator}    ${input_text}

Get Text On Element
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${timeout}=${None}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    ${text}    AppiumLibrary.Get Text    ${locator}
    RETURN    ${text}

Swipe On Screen
    [Documentation]    Owner : Rukpong
    ...    $direction = down, up, right, left (default direction is down)
    ...    $ratio = default is 0.2 (20 percent from edge of the screen) (0.01 ~ 0.49)
    ...    $duration_time_swipe = time for action swipe (default is 1000 ms) unit is ms.
    [Tags]    keyword_action
    [Arguments]    ${direction}=down    ${ratio}=${0.2}    ${duration_time_swipe}=1000
    Check Ratio Point Swipe    ${ratio}
    ${page_height}    Set Variable    $CONTEXT[${CURRENT_CONTEXT}][height]
    ${page_width}     Set Variable    $CONTEXT[${CURRENT_CONTEXT}][width]
    # ${page_height}    Get Window Height
    # ${page_width}     Get Window Width
    ${top}       Evaluate    ${page_height} * ${ratio}
    ${bottom}    Evaluate    ${page_height} * (1-${ratio})
    ${left}      Evaluate    ${page_width} * ${ratio}
    ${right}     Evaluate    ${page_width} * (1-${ratio})
    Swipe Direction    ${direction}    ${top}    ${bottom}    ${left}    ${right}    ${duration_time_swipe}

Swipe On Element
    [Documentation]    Owner : Rukpong
    ...    $direction = down, up, right, left (default direction is down)
    ...    $ratio = default is 0.01 (1 percent from edge of the screen: an element that is too small may cause inaccurate calculations.) (0.01 ~ 0.49)
    ...    $duration_time_swipe = time for action swipe (default is 1000 ms) unit is ms.
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${direction}=down    ${ratio}=${0.01}    ${duration_time_swipe}=1000    ${timeout}=${None}
    Check Ratio Point Swipe    ${ratio}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    ${element_location}            Get Element Location    ${locator}
    ${element_size}                Get Element Size        ${locator}
    ${ratio_vetical_element}       Evaluate                ${element_size}[height] * ${ratio}
    ${ratio_horizontal_element}    Evaluate                ${element_size}[width] * ${ratio}
    ${top}             Evaluate    ${element_location}[y] + ${ratio_vetical_element}
    ${bottom}          Evaluate    (${element_location}[y]+${element_size}[height]) - ${ratio_vetical_element}
    ${left}            Evaluate    ${element_location}[x] + ${ratio_horizontal_element}
    ${right}           Evaluate    (${element_location}[x]+${element_size}[width]) - ${ratio_horizontal_element}
    Swipe Direction    ${direction}    ${top}    ${bottom}    ${left}    ${right}    ${duration_time_swipe}

Swipe To Element
    [Documentation]    Owner : Rukpong
    ...    $locator = target element
    ...    $timeout = time for validate element vibisle. (default validate 2 seconds)
    ...    $time_limit = time for loop check element. (default time loop 20 seconds)
    ...    $direction = down, up, right, left (default direction is down)
    ...    $ratio = default is 0.2 (20 percent from edge of the screen) (0.01 ~ 0.49)
    ...    $duration_time_swipe = time for action swipe (default is 1000 ms) unit is ms.
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Arguments]    ${locator}    ${timeout}=2s    ${time_limit}=20s    ${direction}=down    ${ratio}=${0.2}    ${duration_time_swipe}=1000
    [Tags]    keyword_action
    Check Ratio Point Swipe    ${ratio}
    ${element_visible}    Set Variable    ${False}
    WHILE    ${element_visible} != ${True}    limit=${time_limit}
        Swipe On Screen    ${direction}    ${ratio}    ${duration_time_swipe}
        ${element_visible}    Run Keyword And Return Status    Check Page Contain Mobile Element    ${locator}    ${timeout}
    END
    IF    ${element_visible} == ${False}    Fail    msg=Element locator '${locator}' did not match any elements after ${time_limit} loop seconds

Swipe Section On Screen
    [Documentation]    Owner : Rukpong
    ...                $section = define 4 parts of the screen (1-4)
    ...                section1 = top left    | section2 = top right
    ...                section3 = bottom left | section4 = bottom right
    [Tags]    keyword_action
    [Arguments]    ${section}=1    ${direction}=down    ${ratio}=${0.1}    ${duration_time_swipe}=1000
    Check Ratio Point Swipe    ${ratio}
    ${page_height}    Set Variable    $CONTEXT[${CURRENT_CONTEXT}][height]
    ${page_width}     Set Variable    $CONTEXT[${CURRENT_CONTEXT}][width]
    # ${page_height}    Get Window Height
    # ${page_width}     Get Window Width
    ${point_vertical}      Evaluate    (${page_height}/2) * ${ratio}
    ${point_horizontal}    Evaluate    (${page_width}/2) * ${ratio}
    IF    ${section} == 1
        ${top}       Set Variable    ${point_vertical}
        ${bottom}    Evaluate        (${page_height}/2) - ${point_vertical}
        ${left}      Set Variable    ${point_horizontal}
        ${right}     Evaluate        (${page_width}/2) - ${point_horizontal}
    ELSE IF    ${section} == 2
        ${top}       Set Variable    ${point_vertical}
        ${bottom}    Evaluate        (${page_height}/2) - ${point_vertical}
        ${left}      Evaluate        (${page_width}/2) + ${point_horizontal}
        ${right}     Evaluate        ${page_width} - ${point_horizontal}
    ELSE IF    ${section} == 3
        ${top}       Evaluate        (${page_height}/2) + ${point_vertical}
        ${bottom}    Evaluate        ${page_height} - ${point_vertical}
        ${left}      Set Variable    ${point_horizontal}
        ${right}     Evaluate        (${page_width}/2) - ${point_horizontal}
    ELSE IF    ${section} == 4
        ${top}       Evaluate        (${page_height}/2) + ${point_vertical}
        ${bottom}    Evaluate        ${page_height} - ${point_vertical}
        ${left}      Evaluate        (${page_width}/2) + ${point_horizontal}
        ${right}     Evaluate        ${page_width} - ${point_horizontal}
    ELSE
        Fail    msg=Section `${section}` is not support on this keyword.
    END
    Swipe Direction    ${direction}    ${top}    ${bottom}    ${left}    ${right}    ${duration_time_swipe}

Swipe 2 Section Horizontal On Screen
    [Documentation]    Owner : Rukpong
    ...                $section = define 2 parts of the horizontal screen (1-2)
    ...                section1 = top
    ...                section2 = bottom
    [Tags]    keyword_action
    [Arguments]    ${section}=top    ${direction}=down    ${ratio}=${0.1}    ${duration_time_swipe}=1000
    Check Ratio Point Swipe    ${ratio}
    ${page_height}    Set Variable    $CONTEXT[${CURRENT_CONTEXT}][height]
    ${page_width}     Set Variable    $CONTEXT[${CURRENT_CONTEXT}][width]
    # ${page_height}    Get Window Height
    # ${page_width}     Get Window Width
    ${point_vertical}      Evaluate    (${page_height}/2) * ${ratio}
    ${point_horizontal}    Evaluate    ${page_width} * ${ratio}
    IF    "${section}" == "top"
        ${top}       Set Variable    ${point_vertical}
        ${bottom}    Evaluate        (${page_height}/2) - ${point_vertical}
        ${left}      Set Variable    ${point_horizontal}
        ${right}     Evaluate        ${page_width} - ${point_horizontal}
    ELSE IF    "${section}" == "bottom"
        ${top}       Evaluate        (${page_height}/2) + ${point_vertical}
        ${bottom}    Evaluate        ${page_height} - ${point_vertical}
        ${left}      Set Variable    ${point_horizontal}
        ${right}     Evaluate        ${page_width} - ${point_horizontal}
    ELSE
        Fail    msg=Section `${section}` is not support on this keyword.
    END
    Swipe Direction    ${direction}    ${top}    ${bottom}    ${left}    ${right}    ${duration_time_swipe}

Swipe 2 Section Vertical On Screen
    [Documentation]    Owner : Rukpong
    ...                $section = define 2 parts of the verical screen (1-2)
    ...                section1 = left | section2 = right
    [Tags]    keyword_action
    [Arguments]    ${section}=left    ${direction}=down    ${ratio}=${0.1}    ${duration_time_swipe}=1000
    Check Ratio Point Swipe    ${ratio}
    ${page_height}    Set Variable    $CONTEXT[${CURRENT_CONTEXT}][height]
    ${page_width}     Set Variable    $CONTEXT[${CURRENT_CONTEXT}][width]
    # ${page_height}    Get Window Height
    # ${page_width}     Get Window Width
    ${point_vertical}      Evaluate    ${page_height} * ${ratio}
    ${point_horizontal}    Evaluate    (${page_width}/2) * ${ratio}
    IF    "${section}" == "left"
        ${top}       Set Variable    ${point_vertical}
        ${bottom}    Evaluate        ${page_height} - ${point_vertical}
        ${left}      Set Variable    ${point_horizontal}
        ${right}     Evaluate        (${page_width}/2) - ${point_horizontal}
    ELSE IF    "${section}" == "right"
        ${top}       Set Variable    ${point_vertical}
        ${bottom}    Evaluate        ${page_height} - ${point_vertical}
        ${left}      Evaluate        (${page_width}/2) + ${point_horizontal}
        ${right}     Evaluate        ${page_width} - ${point_horizontal}
    ELSE
        Fail    msg=Section `${section}` is not support on this keyword.
    END
    Swipe Direction    ${direction}    ${top}    ${bottom}    ${left}    ${right}    ${duration_time_swipe}

Swipe On Specific Point Screen
    [Documentation]    Owner : Rukpong
    ...                $start_point = dictionary value that contain key (x, y)
    ...                $end_point = dictionary value that contain key (x, y)
    ...                default speed swipe duration = 1000ms
    [Tags]    keyword_action
    [Arguments]    ${start_point}    ${end_point}    ${duration_time_swipe}=1000
    Check Specific Point X Y    Start point    ${start_point}
    Check Specific Point X Y    End point      ${end_point}
    Swipe    ${start_point}[x]    ${start_point}[y]    ${end_point}[x]    ${end_point}[y]    duration=${duration_time_swipe}

# Verify

Verify Mobile Locator Is Visible
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${locator}    ${timeout}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Verify Mobile Locator Is Visible' was DEPRECATED!!
    ...    Use keyword 'Verify State On Mobile Locator' instead.
    Log     ${msg_deprecated}    level=WARN
    Check Page Visible Mobile Element    ${locator}    ${timeout}

Verify Mobile Locator Is Not Visible
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${locator}    ${timeout}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Verify Mobile Locator Is Not Visible' was DEPRECATED!!
    ...    Use keyword 'Verify State On Mobile Locator' instead.
    Log     ${msg_deprecated}    level=WARN
    Check Page Not Contain Mobile Element    ${locator}    ${timeout}

Verify Mobile Locator Is Contain Page
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${locator}    ${timeout}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Verify Mobile Locator Is Contain Page' was DEPRECATED!!
    ...    Use keyword 'Verify State On Mobile Locator' instead.
    Log     ${msg_deprecated}    level=WARN
    Check Page Contain Mobile Element    ${locator}    ${timeout}

Verify Mobile Locator Is Not Contain Page
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${locator}    ${timeout}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Verify Mobile Locator Is Not Contain Page' was DEPRECATED!!
    ...    Use keyword 'Verify State On Mobile Locator' instead.
    Log     ${msg_deprecated}    level=WARN
    Check Page Not Contain Mobile Element    ${locator}    ${timeout}

Verify Mobile Locator Is Placed On Screen
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_action    deprecated
    [Arguments]    ${locator}    ${timeout}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Verify Mobile Locator Is Placed On Screen' was DEPRECATED!!
    ...    Use keyword 'Verify State On Mobile Locator' instead.
    Log     ${msg_deprecated}    level=WARN
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    Check Element Place On Screen    ${locator}

Verify State On Mobile Locator
    [Documentation]    Owner : Nakarin
    ...    Support state = visible, contain, not contain and Place On Screen
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${state}    ${timeout}=${None}
    IF    "${state}" == "Placed On Screen"
        Check Page Contain Mobile Element    ${locator}    ${timeout}
        Check Element Place On Screen    ${locator}
    ELSE
        ${keyword}    Catenate    SEPARATOR=${SPACE}
        ...    Check Page
        ...    ${state}
        ...    Mobile Element
        TRY
            Run Keyword    ${keyword}    ${locator}    ${timeout}
        EXCEPT    No keyword with name '${keyword}' found.    type=LITERAL
            Fail    msg=State '${state}' was not supported
        END
    END

# Verify text

Verify Text Should Be Equal On Mobile Locator
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action    deprecated
    [Arguments]    ${locator}    ${expect_text}    ${timeout}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Verify Text Should Be Equal On Mobile Locator' was DEPRECATED!!
    ...    Use keyword 'Verify Text On Moblie Locator' instead.
    Log     ${msg_deprecated}    level=WARN
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    AppiumLibrary.Element Text Should Be    ${locator}    ${expect_text}

Verify Text On Mobile Locator
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${expect_text}    ${timeout}=${None}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    AppiumLibrary.Element Text Should Be    ${locator}    ${expect_text}

Verify Text Should Not Be Equal On Mobile Locator
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action    deprecated
    [Arguments]    ${locator}    ${expect_text}    ${timeout}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Verify Text Should Not Be Equal On Mobile Locator' was DEPRECATED!!
    ...    Use keyword 'Verify Text Not Equal On Mobile Locator' instead.
    Log     ${msg_deprecated}    level=WARN
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    ${text}    AppiumLibrary.Get Text    ${locator}
    Should Not Be Equal As Strings    ${text}    ${expect_text}

Verify Text Not Equal On Mobile Locator
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_action
    [Arguments]    ${locator}         ${expect_text}              ${timeout}=${None}
    ...    ${ignore_case}=${False}    ${strip_spaces}=${False}    ${collapse_spaces}=${False}
    Check Page Contain Mobile Element           ${locator}    ${timeout}
    ${actual_text}    AppiumLibrary.Get Text    ${locator}
    Should Not Be Equal As Strings              ${actual_text}    ${expect_text}
    ...    values=${False}
    ...    ignore_case=${ignore_case}
    ...    strip_spaces=${strip_spaces}
    ...    collapse_spaces=${collapse_spaces}
    ...    msg=The text of element '${locator}' should not equal '${expect_text}' but in fact it was '${actual_text}' == '${expect_text}'.

Verify Text Should Match On Mobile Locator
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action    deprecated
    [Arguments]    ${locator}    ${pattern}    ${timeout}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Verify Text Should Match On Mobile Locator' was DEPRECATED!!
    ...    Use keyword 'Verify Text Should Match Regexp On Mobile Locator' instead.
    Log     ${msg_deprecated}    level=WARN
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    ${text}    AppiumLibrary.Get Text    ${locator}
    Should Match Regexp    ${text}    ${pattern}

Verify Text Should Match Regexp On Mobile Locator
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${pattern}    ${timeout}=${None}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    ${text}    AppiumLibrary.Get Text    ${locator}
    Should Match Regexp    ${text}    ${pattern}
    ...    msg=The text of element '${locator}' should not match with '${pattern}' but text was '${text}'

Verify Text Should Contain On Mobile Locator
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${expect_text_contain}    ${timeout}=${None}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    Element Should Contain Text    ${locator}    ${expect_text_contain}

Verify Text Should Not Contain On Mobile Locator
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${expect_text_contain}    ${timeout}=${None}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    Element Should Not Contain Text    ${locator}    ${expect_text_contain}

Verify Attribute Should Be Equal On Mobile Locator
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    Change "Check Mobile Element Visible" to "Check Page Contain Mobile Element"
    [Tags]    keyword_action    deprecated
    [Arguments]    ${locator}    ${attribute}    ${expect_value}    ${timeout}=${None}
    ${msg_deprecated}    Catenate    This keyword 'Verify Attribute Should Be Equal On Mobile Locator' was DEPRECATED!!
    ...    Use keyword 'Verify Attribute On Mobile Locator' instead.
    Log     ${msg_deprecated}    level=WARN
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    IF    "${attribute.lower()}" == "value"
        Element Value Should Be    ${locator}    ${expect_value}
    ELSE
        ${value}    Get Element Attribute    ${locator}    ${attribute}
        Should Be Equal As Strings    ${value}    ${expect_value}
        ...    msg=The value of attribute element '${locator}' should have been '${expect_value}' but in fact it was '${value}'.
        ...    values=${False}
        Log    Verifying element '${locator}' contains exactly value '${value}'.
    END

Verify Attribute On Mobile Locator
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_action
    [Arguments]    ${locator}    ${attribute}    ${expect_value}    ${timeout}=${None}
    Check Page Contain Mobile Element    ${locator}    ${timeout}
    IF    "${attribute.lower()}" == "value"
        Element Value Should Be    ${locator}    ${expect_value}
    ELSE
        ${value}    Get Element Attribute    ${locator}    ${attribute}
        Should Be Equal As Strings    ${value}    ${expect_value}
        ...    msg=The value of attribute element '${locator}' should have been '${expect_value}' but in fact it was '${value}'.
        ...    values=${False}
        Log    Verifying element '${locator}' contains exactly value '${value}'.
    END

# Command keyword

Check Page Visible Mobile Element
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_command    robot:private
    [Arguments]    ${locator}    ${timeout}
    ${variable_status}    Variable Should Be Null    ${timeout}
    ${visible_timeout}    Set Variable If    ${variable_status} == ${True}    ${WAIT_STATE_TIMEOUT}    ${timeout}
    WHILE    ${True}
    ...    limit=${visible_timeout}
    ...    on_limit_message="The state of element '${locator}' should have been 'visible' but in fact state is invalid as 'visible' in ${visible_timeout} second(s).${\n}Tip: Use variable "$WaitStateTimeout" in "buffet_config.yaml" for increasing the timeout."
        ${status}    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    locator=${locator}    timeout=1s
        IF    ${status} == ${True}    BREAK
    END

Check Page Contain Mobile Element
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_command    robot:private
    [Arguments]    ${locator}    ${timeout}
    ${variable_status}    Variable Should Be Null    ${timeout}
    ${page_contain_timeout}    Set Variable If    ${variable_status} == ${True}    ${WAIT_STATE_TIMEOUT}    ${timeout}
    WHILE    ${True}
    ...    limit=${page_contain_timeout}
    ...    on_limit_message="The state of element '${locator}' should have been 'contain' but in fact state is invalid as 'visible' in ${page_contain_timeout} second(s).${\n}Tip: Use variable "$WaitStateTimeout" in "buffet_config.yaml" for increasing the timeout."
        ${status}    Run Keyword And Return Status
        ...    Wait Until Page Contains Element    locator=${locator}    timeout=1s
        IF    ${status} == ${True}    BREAK
    END

Check Page Not Contain Mobile Element
    [Documentation]    Owner : Nakarin
    [Tags]    keyword_command    robot:private
    [Arguments]    ${locator}    ${timeout}
    ${variable_status}    Variable Should Be Null    ${timeout}
    ${visible_timeout}    Set Variable If    ${variable_status} == ${True}    ${WAIT_STATE_TIMEOUT}    ${timeout}
    WHILE    ${True}
    ...    limit=${visible_timeout}
    ...    on_limit_message="The state of element '${locator}' should have been 'visible' but in fact state is invalid as 'visible' in ${visible_timeout} second(s).${\n}Tip: Use variable "$WaitStateTimeout" in "buffet_config.yaml" for increasing the timeout."
        ${status}    Run Keyword And Return Status
        ...    Wait Until Page Does Not Contain Element    locator=${locator}    timeout=1s
        IF    ${status} == ${True}    BREAK
    END

Swipe Direction
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command    robot:private
    [Arguments]    ${direction}    ${top}    ${bottom}    ${left}    ${right}    ${duration_time_swipe}
    IF    "${direction}" == "right"
        ${y_value}    Evaluate    (${top}+${bottom}) / 2
        Swipe    ${right}      ${y_value}    ${left}       ${y_value}    duration=${duration_time_swipe}
    ELSE IF    "${direction}" == "left"
        ${y_value}    Evaluate    (${top}+${bottom}) / 2
        Swipe    ${left}       ${y_value}    ${right}      ${y_value}    duration=${duration_time_swipe}
    ELSE IF    "${direction}" == "up"
        ${x_value}    Evaluate    (${left}+${right}) / 2
        Swipe    ${x_value}    ${top}        ${x_value}    ${bottom}     duration=${duration_time_swipe}
    ELSE
        ${x_value}    Evaluate    (${left}+${right}) / 2
        Swipe    ${x_value}    ${bottom}     ${x_value}    ${top}        duration=${duration_time_swipe}
    END

Capture Mobile Element
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command    robot:private
    [Arguments]    ${locator}    ${output_screenshot_path}
    Import Library    ${CURDIR}${/}..${/}Library${/}image.py
    ${platform}    Get Capability    platformName
    ${platform}    Convert To Lower Case    ${platform}
    IF    "${platform}" == "ios"
        ${ratio_image}    Set Variable    2
    ELSE IF    "${platform}" == "android"
        ${ratio_image}    Set Variable    1
    ELSE
        ${ratio_image}    Set Variable    1
    END
    ${element_location}    Get Element Location    ${locator}
    ${element_size}        Get Element Size        ${locator}
    ${left}      Evaluate    int((${element_location}[x])*${ratio_image})
    ${right}     Evaluate    int((${element_location}[x]+${element_size}[width])*${ratio_image})
    ${top}       Evaluate    int((${element_location}[y])*${ratio_image})
    ${bottom}    Evaluate    int((${element_location}[y]+${element_size}[height])*${ratio_image})
    ${screenshot_path}      Set Variable    ${output_screenshot_path}
    Check Parent Path Exist    ${screenshot_path}
    Capture Page Screenshot    ${screenshot_path}
    Crop Image    ${left}    ${top}    ${right}    ${bottom}    ${screenshot_path}    ${output_screenshot_path}

Check Parent Path Exist
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command    robot:private
    [Arguments]    ${path}
    ${parent_path}    Split String From Right    ${path}    ${/}    1
    ${status}    Run Keyword And Return Status    Directory Should Exist    ${parent_path}[0]
    IF    ${status} == ${False}    Create Directory    ${parent_path}[0]

Check Ratio Point Swipe
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command    robot:private
    [Arguments]    ${ratio}
    IF    ${ratio} < 0.01 or ${ratio} > 0.49    Fail    msg=Ratio from each edge of the screen should value between 0.01 ~ 0.49.

Check Specific Point X Y
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command    robot:private
    [Arguments]    ${target}    ${point_value}
    Dictionary Should Contain Key    ${point_value}    x
    ...    msg=${target} value `${point_value}` does not contain key 'x'. Point value should have both key 'x' and 'y' values.
    Dictionary Should Contain Key    ${point_value}    y
    ...    msg=${target} value `${point_value}` does not contain key 'y'. Point value should have both key 'x' and 'y' values.

Check Element Place On Screen
    [Documentation]    Owner : Rukpong    Editor : Nakarin
    ...    Change Get Windows Height and Width to Get Variable Value
    [Tags]    keyword_command    robot:private
    [Arguments]    ${locator}
    ${page_height}    Set Variable    $CONTEXT[${CURRENT_CONTEXT_INDEX}][height]
    ${page_width}     Set Variable    $CONTEXT[${CURRENT_CONTEXT_INDEX}][width]
    # ${page_height}    Get Window Height
    # ${page_width}     Get Window Width
    ${element_location}        Get Element Location    ${locator}
    ${element_size}            Get Element Size        ${locator}
    ${point_element_left}      Set Variable            ${element_location}[x]
    ${point_element_top}       Set Variable            ${element_location}[y]
    ${point_element_right}     Evaluate                ${element_location}[x] + ${element_size}[width]
    ${point_element_bottom}    Evaluate                ${element_location}[y] + ${element_size}[height]
    IF    ${point_element_right} <= 0 or ${point_element_bottom} <= 0
        Fail    This locator `${locator}` is out of the screen.
    ELSE IF    ${point_element_right} >= ${page_width} or ${point_element_top} >= ${page_height}
        Fail    This locator `${locator}` is out of the screen.
    ELSE
        Log    This locator `${locator}` is on the screen.
    END

Set Default Appium Timeout
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    ${status}      Run Keyword And Return Status
    ...            Variable Should Exist    $WaitAppiumStateTimeout
    ${timeout}     Get Variable Value       $WaitAppiumStateTimeout    20s
    IF    ${status} == ${False}
        Log    The variable '$WaitStateTimeout' is invalid or does not exist in the 'buffet_config.yaml' file.
        ...    level=WARN
    END
    Set Global Variable    ${WAIT_STATE_TIMEOUT}    ${timeout}

Get Mobile Screen Size
    [Documentation]    Owner: Nakarin
    [Tags]    keyword_command    robot:private
    ${page_height}    Get Window Height
    ${page_width}     Get Window Width
    RETURN    ${page_height}    ${page_width}
