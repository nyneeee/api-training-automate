*** Settings ***
Library    String


*** Keywords ***
Robot Import Resource
    [Documentation]    Owner : Rukpong
    [Tags]    keyword_command
    [Arguments]    ${current_dir}
    ${suite}    Split String From Right    ${SUITE_NAME}    .    1
    ${suite}    Replace String    ${suite}[-1]    ${SPACE}    _
    ${testsuites}    Get Variable Value    ${Testsuites.${suite}}    ${EMPTY}
    ${path}     Split String    ${current_dir}    Testsuites
    ${status}    Run Keyword And Return Status    Should Not Be Empty    ${testsuites}
    IF    ${status}
        FOR    ${import_path}    IN    @{testsuites}
            ${import_full_path}    Set Variable    ${path}[0]${import_path}
            Import Resource    ${import_full_path}
        END
    END
