*** Settings ***
Resource    ../Resources/Keywords/commomKeyword.resource
Resource    ../Resources/Keywords/api_common.resource
Resource    ../Resources/TestSite/URL/url_cpc_api.resource
Variables   ../Config/configs_header.yml
Variables   ../Config/configs_url.yml

*** Test Cases ***
CPC_API_1_1_001 Security Authentication
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - "secretKey active"
    ...    ==>
    [Tags]    1
    Set Body API        schema_body=${1_body_authentication}
    Send Request API    url=${url_authentication}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success                            ${1_response_security_authentication}
    Verify Value Response By Key                          $..statusCode           20000
    Verify Value Response By Key                          $..statusDesc           Success
    Should Have Value In Json                             ${response.json()}      $..data.accessToken
    Verify Match Regexp Value Response By Key             $..data.accessToken     .+
    ${token}     Get Value Response By Key                $..data.accessToken   
    Set Suite Variable                                    ${TOKEN}                ${token}
    Log Many                                              ${TOKEN}
    Write Response To Json File   