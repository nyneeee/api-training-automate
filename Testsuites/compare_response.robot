*** Settings ***
Resource    ../Resources/Keywords/compare_data.resource

*** Test Cases ***
Compare Data
    [Documentation]    Owner : Patipan.w
    ...    Step 1  : Verify "schema" and write response json file "pre-test"
    ...    command : robot -d "log" -v "testsite:Production" -v "log_response_site:Pre-Test"  cpc_api.robot
    ...    ==>
    ...    Step 2  : Verify "schema" and write response json file "post-test"
    ...    command : robot -d "log" -v "testsite:Production" -v "log_response_site:Post-Test"  cpc_api.robot
    ...    ==>
    ...    Step 3  : Compare 2 json file response "pre-test" and "post-test"
    ...    command : robot -d "log" compare_response.robot
    ...    ==>
    [Tags]    Compare
    Compare Data Response Json File