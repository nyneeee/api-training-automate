*** Settings ***
Resource     ../../resource_init.resource

*** Keywords ***
Convert Value To Upper Case
    [Documentation]    Owner : Patipan.w  
    [Arguments]    ${value}=${None}
    IF  $value != $None
            ${value_upper}    Convert To Upper Case    ${value}
            ${log_message}     Catenate
            ...    ${\n}Convert Success.
            ...    ${\n}Result Before Convert == "${value}".
            ...    ${\n}Result After Convert == "${value_upper}".
            Log     ${log_message}     console=${True}
    ELSE
        Fail    msg=Fail no value in arguments "${value}".
    END
    RETURN    ${value_upper}

Convert Value ${value} To Lower Case
    [Documentation]    Owner : Patipan.w  
    ${value_lower}    Convert To Lower Case   ${value}
    ${status}    Run Keyword And Return Status    Should Not Be Empty    ${value_lower}        
    IF  ${status} == ${True}    Log    Convert Success.     console=${True}
    ...    ELSE    Fail    msg=Fail no value in arguments "${value}".
    RETURN    ${value_lower}

Verify GET ${type} User
    [Documentation]    Owner : Patipan.w  
    ...    Multiple conditions: and / or
    ...    ${Type} support : Single / List
    ${type_upper}    Convert To Upper Case    ${type}
    ${count_user}    Get List Key And Count From Json    $.data
    IF  ("${type_upper}" == "LIST" and "${count_user}" >= "1") or ("${type_upper}" == "SINGLE" and "${count_user}" == "1")
            Log    Success Data Type is "${Type}" and value == "${count_user}".
    ELSE IF    ("${type_upper}" == "LIST" and "${count_user}" == "0") or ("${type_upper}" == "SINGLE" and "${count_user}" == "0")
                 Fail    Data Not Found.
    ELSE
        Fail    Type is "${Type}" but get $.data == "${count_user}".
    END    