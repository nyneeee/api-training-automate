*** Settings ***
Library    OperatingSystem
Resource    ../Resources/Keywords/compare_data.resource
Resource    ../Resources/Keywords/api_common.resource
Resource    ../Resources/TestSite/URL/url_cpc_api.resource
Variables   ../Resources/TestSite/URL/api_parameter.yml
# Suite Teardown    API For Clear Cache

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

CPC_API_1_1_001 Security Authentication (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - "secretKey not active"
    ...    ==>
    [Tags]    1.2    Conditions         
    Set Body API        schema_body=${1_2_body_authentication}
    Send Request API    url=${url_authentication}
    ...                 expected_status=401
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${1_2_response_security_authentication}

CPC_API_1_1_002 Security Validate Token
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - "token active"
    ...    - "statusCode": "20000"
    ...    ==>
    [Tags]    2         
    Set Header Validate Token
    Send Request API    url=${url_validate_token}
    ...                 method=GET
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${2_response_security_validate_token}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Verify Value Response By Key    $..data          validated
    Write Response To Json File
    # Log     ${RESPONSE.content}     console=yes
    # Should Be Equal As Strings        ${RESPONSE.content}      validated

CPC_API_1_1_002 Security Validate Token (Conditions_Test_Case_1)
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - "token does not exist"
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]    2.1    Conditions    
    Set API Header Default
    Set Content API Header    $..authorization    ${set_token.test_case_2_1_authentication}
    Send Request API          url=${url_validate_token}
    ...                       method=GET
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${2_1_response_security_validate_token}

CPC_API_1_1_002 Security Validate Token (Conditions_Test_Case_2)
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - "token expire"
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    2.2    Conditions    
    Set API Header Default    
    Set Content API Header    $..authorization    ${set_token.test_case_2_2_authentication}
    Send Request API          url=${url_validate_token}
    ...                       method=GET
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${2_2_response_security_validate_token}

CPC_API_1_1_003 Get Promotion Shelves
    [Documentation]    Owner : Suthasinee    Edit : Worrapong, Patipan.w
    [Tags]   3
    Set API Header Default
    Set Body API        schema_body=${3_body_get_promotion_shelves}
    Send Request API    url=${url_get_promotion_shelves}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${3_response_get_promotion_shelves}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_003 Get Promotion Shelves (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId not mapping shelf
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - not found data
    ...    ==>
    [Tags]   3.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${3_1_body_get_promotion_shelves}
    Send Request API    url=${url_get_promotion_shelves}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${3_1_response_get_promotion_shelves}

CPC_API_1_1_003 Get Promotion Shelves (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    select *
    ...    from SIT_CPC.SUBSCRIBER s 
    ...    join SIT_CPC.SHELF_SUBSCRIBERS ss on ss.SUBSCRIBER_ID = s.ID 
    ...    JOIN SIT_CPC.SHELF s2 on s2.ID = ss.SHELF_ID 
    ...    WHERE s.UUID = 'POAlEsZQlTYiwO3XKXN3bJOHVpgcrM8CObrm6F0MFbxgXPInYx7L3u5xm3HVOOU7HfJX08WbFKBMuG8X' --fixed for automate test
    ...    ==>
    ...    *** Condition ***
    ...     - userId having mapping shelf
    ...     UUID = 'POAlEsZQlTYiwO3XKXN3bJOHVpgcrM8CObrm6F0MFbxgXPInYx7L3u5xm3HVOOU7HfJX08WbFKBMuG8X' --fixed for automate test
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.length = 1
    ...     2. data[0].sanitizedName = "shelf-for-automate-test"
    ...     3. data[0].subShelves.length = 2
    ...    ==>
    [Tags]   3.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${3_2_body_get_promotion_shelves}
    Send Request API    url=${url_get_promotion_shelves}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${3_2_response_get_promotion_shelves}

CPC_API_1_1_003 Get Promotion Shelves (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    select *
    ...    from SIT_CPC.SUBSCRIBER s 
    ...    join SIT_CPC.SHELF_SUBSCRIBERS ss on ss.SUBSCRIBER_ID = s.ID 
    ...    JOIN SIT_CPC.SHELF s2 on s2.ID = ss.SHELF_ID 
    ...    WHERE s.UUID = 'POAlEsZQlTYiwO3XKXN3bJOHVpgcrM8CObrm6F0MFbxgXPInYx7L3u5xm3HVOOU7HfJX08WbFKBMuG8X' --fixed for automate test
    ...     - fixed for automate test
    ...    ==>
    ...    *** Condition ***
    ...     - userId default language
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.length = 1
    ...    2. data[0].title= "shelf-for-automate-test"
    ...    ==>
    [Tags]   3.3.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${3_3_1_body_get_promotion_shelves}
    Send Request API    url=${url_get_promotion_shelves}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${3_3_1_response_get_promotion_shelves}

CPC_API_1_1_003 Get Promotion Shelves (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    select *
    ...    from SIT_CPC.SUBSCRIBER s 
    ...    join SIT_CPC.SHELF_SUBSCRIBERS ss on ss.SUBSCRIBER_ID = s.ID 
    ...    JOIN SIT_CPC.SHELF s2 on s2.ID = ss.SHELF_ID 
    ...    JOIN SIT_CPC.SHELF_LANGUAGE sl on sl.SHELF_ID = s2.ID and sl.LANG_ID = 2
    ...    WHERE s.UUID = 'POAlEsZQlTYiwO3XKXN3bJOHVpgcrM8CObrm6F0MFbxgXPInYx7L3u5xm3HVOOU7HfJX08WbFKBMuG8X' --fixed for automate test
    ...     - fixed for automate test
    ...    ==>
    ...    *** Condition ***
    ...     - userId set language
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data[0].title= "shelf-title-en"
    ...    2. data[0].subShelves[0].title= "shelf-title-en"
    ...    3. data[0].subShelves[1].title= "shelf-title-en"
    ...    ==>
    [Tags]   3.3.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${3_3_2_body_get_promotion_shelves}
    Send Request API    url=${url_get_promotion_shelves}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${3_3_2_response_get_promotion_shelves}

CPC_API_1_1_004 Get All Catalog Configurations by Code
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   4        
    Set API Header Default
    Set Body API        schema_body=${4_body_get_all_catalog_configurations_by_cosde}
    Send Request API    url=${url_get_all_catalog_configurations_by_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${4_response_get_all_catalog_configurations_by_code}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success  
    Write Response To Json File  

CPC_API_1_1_004 Get All Catalog Configurations by Code (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    - SELECT * 
    ...    FROM SIT_CPC.CPC_CONFIG_CATALOG ccc 
    ...    where ccc.CODE = 'P7777782'
    ...    ==>
    ...    *** Condition ***
    ...    - catalog config not active
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - data.length = 0
    ...    ==>
    [Tags]   4.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${4_1_body_get_all_catalog_configurations_by_code}
    Send Request API    url=${url_get_all_catalog_configurations_by_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${4_1_response_get_all_catalog_configurations_by_code}

CPC_API_1_1_004 Get All Catalog Configurations by Code (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT * 
    ...    FROM SIT_CPC.CPC_CONFIG_CATALOG ccc 
    ...    where ccc.CODE = 'P7777781'
    ...    ==>
    ...    *** Condition ***
    ...    - catalog config  active
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    1.data.length = 5
    ...    2.total = 15
    ...    ==>
    [Tags]   4.2    Conditions                
    Set API Header Default
    Set Body API        schema_body=${4_2_body_get_all_catalog_configurations_by_code}
    Send Request API    url=${url_get_all_catalog_configurations_by_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${4_2_response_get_all_catalog_configurations_by_code}

CPC_API_1_1_004 Get All Catalog Configurations by Code (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - catalog config filter by offset-max
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    1.data.length = 10
    ...    2.total = 15
    ...    ==>
    [Tags]   4.3.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${4_3_1_body_get_all_catalog_configurations_by_code}
    Send Request API    url=${url_get_all_catalog_configurations_by_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${4_3_1_response_get_all_catalog_configurations_by_code}

CPC_API_1_1_004 Get All Catalog Configurations by Code (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - catalog config filter by offset-max
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    1.data.length = 5
    ...    2.total = 15
    ...    ==>
    [Tags]   4.3.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${4_3_2_body_get_all_catalog_configurations_by_code}
    Send Request API    url=${url_get_all_catalog_configurations_by_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${4_3_2_response_get_all_catalog_configurations_by_code}

CPC_API_1_1_005 Get All Packages by Criterias
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   5       
    Set API Header Default
    Set Body API        schema_body=${5_body_get_all_packages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${5_response_get_all_packages_by_criterias}
    Verify Value Response By Key        $..status        2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File  

CPC_API_1_1_005 Get All Packages by Criterias (Conditions_Test_Case_1_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by orderType,chargeType,productClass
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.length = max (10)
    ...    2. data.any((item)=> item.customAttributes.isChangeOwner == true) ** isChangeOwner ของทุก package ต้องเท่ากับ true
    ...    3. data.any((item)=> item.customAttributes.productClass == "Main")  ** productClass ของทุก package = Main
    ...    4. data.any((item)=> item.customAttributes.chargeType== "Post-paid")  ** chargeType ของทุก package = Post-paid
    ...    ==>
    [Tags]   5.1.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${5_1_1_body_get_all_pasckages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(10)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_isChangeOwner}    Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.isChangeOwner
         ${value_productClass}     Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.productClass
         ${value_chargeType}       Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.chargeType      
         Should Be Equal As Strings     ${value_isChangeOwner}[0]    true  
         Should Be Equal As Strings     ${value_productClass}[0]     Main
         Should Be Equal As Strings     ${value_chargeType}[0]       Post-paid 
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_isChangeOwner: "$.data[${index - 1}].customAttributes.isChangeOwner"
         ...    ${\n}---> json_path_productClass: "$.data[${index - 1}].customAttributes.productClass"
         ...    ${\n}---> json_path_chargeType: "$.data[${index - 1}].customAttributes.chargeType"
         ...    ${\n}---> condition: All "isChangeOwner" is "true"
         ...    ${\n}---> condition: All "productClass" is "Main"
         ...    ${\n}---> condition: All "chargeType" is "Post-paid"
         ...    ${\n}---> "isChangeOwner" == "${value_isChangeOwner}[0]"
         ...    ${\n}---> "productClass" == "${value_productClass}[0]"
         ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
         Log    ${result}
    END

CPC_API_1_1_005 Get All Packages by Criterias (Conditions_Test_Case_1_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by orderType,chargeType,productClass
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.length = max (10)
    ...    2. data.any((item)=> item.customAttributes.isNewRegistration== true) ** isNewRegistrationของทุก package ต้องเท่ากับ true
    ...    3. data.any((item)=> item.customAttributes.productClass == "Main")  ** productClass ของทุก package = Main
    ...    4. data.any((item)=> item.customAttributes.chargeType== "Pre-paid")  ** chargeType ของทุก package = Pre-paid
    ...    ==>
    [Tags]   5.1.2    Conditions      
    Set API Header Default
    Set Body API        schema_body=${5_1_2_body_get_all_pasckages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(10)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_isNewRegistration}    Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.isNewRegistration
         ${value_productClass}         Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.productClass
         ${value_chargeType}           Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.chargeType      
         Should Be Equal As Strings     ${value_isNewRegistration}[0]    true  
         Should Be Equal As Strings     ${value_productClass}[0]         Main
         Should Be Equal As Strings     ${value_chargeType}[0]           Pre-paid
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_isNewRegistration: "$.data[${index - 1}].customAttributes.isNewRegistration"
         ...    ${\n}---> json_path_productClass: "$.data[${index - 1}].customAttributes.productClass"
         ...    ${\n}---> json_path_chargeType: "$.data[${index - 1}].customAttributes.chargeType"
         ...    ${\n}---> condition: All "isNewRegistration" is "true"
         ...    ${\n}---> condition: All "productClass" is "Main"
         ...    ${\n}---> condition: All "chargeType" is "Pre-paid"
         ...    ${\n}---> "isNewRegistration" == "${value_isNewRegistration}[0]"
         ...    ${\n}---> "productClass" == "${value_productClass}[0]"
         ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
         Log    ${result}
    END

CPC_API_1_1_005 Get All Packages by Criterias (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by productPackageGroup
    ...    ==>
    ...    *** Expect Result ***
    ...    - data.any((item)=> item.customAttributes.productPkg== "3G_SmartPhone F1P Package") 
    ...    ** productPkg ของทุก package ต้องเท่ากับ 3G_SmartPhone F1P Package
    ...    ==>
    [Tags]   5.2.1    Conditions  
    Set API Header Default
    Set Body API        schema_body=${5_2_1_body_get_all_pasckages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_productPkg}    Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.productPkg
         Should Be Equal As Strings     ${value_productPkg}[0]    3G_SmartPhone F1P Package  
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_productPkg: "$.data[${index - 1}].customAttributes.productPkg"
         ...    ${\n}---> condition: All "productPkg" is "3G_SmartPhone F1P Package"
         ...    ${\n}---> "productPkg" == "${value_productPkg}[0]"
         Log    ${result}
    END

CPC_API_1_1_005 Get All Packages by Criterias (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by productPackageGroup
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length  = 0
    ...    ==>
    [Tags]   5.2.2    Conditions   
    Set API Header Default
    Set Body API        schema_body=${5_2_2_body_get_all_pasckages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${5_2_2_response_get_all_pasckages_by_criterias}

CPC_API_1_1_005 Get All Packages by Criterias (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by minimumPrice, maximumPrice
    ...    ==>
    ...    *** Expect Result ***
    ...    - data.any((item)=> item.customAttributes.priceInclVat >= 400 && tem.customAttributes.priceInclVat <= 499) 
    ...    ** priceInclVat  ของทุก package อยู่ในช่วง minimumPrice -> maximumPrice
    ...    ==>
    [Tags]   5.3.1    Conditions   
    Set API Header Default
    Set Body API        schema_body=${5_3_1_body_get_all_pasckages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_priceInclVat}    Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.priceInclVat
         Should Be True    float(${value_priceInclVat}[0]) >= float(400) and float(${value_priceInclVat}[0]) <= float(499)
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_priceInclVat: "$.data[${index - 1}].customAttributes.priceInclVat"
         ...    ${\n}---> condition = data.any((item)=> item.customAttributes.priceInclVat >= 400 && tem.customAttributes.priceInclVat <= 499)
         ...    ${\n}---> condition("priceInclVat(${value_priceInclVat}[0])" >= 400 and "priceInclVat(${value_priceInclVat}[0])" <= 499)
         ...    ${\n}---> "priceInclVat" == "${value_priceInclVat}[0]"
         Log    ${result}
    END

CPC_API_1_1_005 Get All Packages by Criterias (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by minimumPrice, maximumPrice
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.any((item)=> item.customAttributes.priceInclVat  <= 99) 
    ...    ** priceInclVat  ของทุก package อยู่ในช่วง minimumPrice -> maximumPrice
    ...    ==>
    [Tags]   5.3.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${5_3_2_body_get_all_pasckages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_priceInclVat}    Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.priceInclVat
         Should Be True    float(${value_priceInclVat}[0]) <= float(99)
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_priceInclVat: "$.data[${index - 1}].customAttributes.priceInclVat"
         ...    ${\n}---> condition = data.any((item)=> item.customAttributes.priceInclVat  <= 99)
         ...    ${\n}---> condition("priceInclVat(${value_priceInclVat}[0])" <= 99)
         ...    ${\n}---> "priceInclVat" == "${value_priceInclVat}[0]"
         Log    ${result}
    END

CPC_API_1_1_005 Get All Packages by Criterias (Conditions_Test_Case_3_3)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by minimumPrice, maximumPrice
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.any((item)=> item.customAttributes.priceInclVat  >= 599) 
    ...    ** priceInclVat  ของทุก package อยู่ในช่วง minimumPrice -> maximumPrice
    ...    ==>
    [Tags]   5.3.3    Conditions       
    Set API Header Default
    Set Body API        schema_body=${5_3_3_body_get_all_pasckages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_priceInclVat}    Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.priceInclVat
         Should Be True    float(${value_priceInclVat}[0]) >= float(599)
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_priceInclVat: "$.data[${index - 1}].customAttributes.priceInclVat"
         ...    ${\n}---> condition = data.any((item)=> item.customAttributes.priceInclVat  >= 599) 
         ...    ${\n}---> condition("priceInclVat(${value_priceInclVat}[0])" >= 599)
         ...    ${\n}---> "priceInclVat" == "${value_priceInclVat}[0]"
         Log    ${result}
    END

CPC_API_1_1_005 Get All Packages by Criterias (Conditions_Test_Case_4_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset-max
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length  = 5
    ...    ==>
    [Tags]   5.4.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${5_4_1_body_get_all_pasckages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}       Get List Key And Count From Json        $.data
    ${body_max}    Get Value From Json     ${API_BODY}     $.max
    Should Be True    int(${count}) == int(${body_max}[0])
    ${result}    Catenate
    ...    ${\n}---> body_max: ${body_max}
    ...    ${\n}---> "$data_length(${count})" == "$body_max(${body_max}[0])"
    Log    ${result}

CPC_API_1_1_005 Get All Packages by Criterias (Conditions_Test_Case_4_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset-max
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length  = total - (offset-1)
    ...    ==>
    [Tags]   5.4.2    Conditions              
    Set API Header Default
    Set Body API        schema_body=${5_4_2_body_get_all_pasckages_by_criterias}
    Send Request API    url=${url_get_all_packages_by_criterias}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    ${total}    Get Value From Json     ${response.json()}    $.total
    ${body_offset}    Get Value From Json     ${API_BODY}     $.offset
    ${data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${count}) == int(${data_length})
    ${result}    Catenate
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_data_length == "${count}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> data_length: int(${total}[0] - (${body_offset}[0] - 1) == "${data_length}"
    ...    ${\n}---> "$data_length(${data_length})" == "$resp_data_length(${count})"
    Log    ${result}

CPC_API_1_1_006 Get All Promotions by Shelf
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   6    
    Set API Header Default
    Set Body API        schema_body=${6_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${6_response_get_all_promotions_by_shelf}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - shelf not mapping item
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   6.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${6_1_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${6_1_response_get_all_promotions_by_shelf}

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - shelf having mapping item
    ...    ==>
    ...    *** Expect Result ***
    ...     1.data.length = 2 (config ไว้แค่ 2 pack)
    ...     2.data.any(item=> item.customAttributes.productClass == "Main")
    ...    ** productClass ของทุก package เป็น Main
    ...    ==>
    [Tags]   6.2    Conditions  
    Set API Header Default
    Set Body API        schema_body=${6_2_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(2)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_productClass}         Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.productClass
         Should Be Equal As Strings    ${value_productClass}[0]         Main
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_productClass: "$.data[${index - 1}].customAttributes.productClass"
         ...    ${\n}---> condition: All "productClass" is "Main"
         ...    ${\n}---> "productClass" == "${value_productClass}[0]"
         Log    ${result}
    END

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (orderType)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.length = 2 (config ไว้แค่ 2 pack)
    ...     2. data.any(item=> item.customAttributes.isNewRegistration == true) 
    ...    ** isNewRegistration ของทุก package เป็น true
    ...    ==>
    [Tags]   6.3.1    Conditions  
    Set API Header Default
    Set Body API        schema_body=${6_3_1_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(2)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_isNewRegistration}     Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.isNewRegistration
         Should Be Equal As Strings     ${value_isNewRegistration}[0]    true  
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_isNewRegistration: "$.data[${index - 1}].customAttributes.isNewRegistration"
         ...    ${\n}---> condition: All "isNewRegistration" is "true"
         ...    ${\n}---> "isNewRegistration" == "${value_isNewRegistration}[0]"
         Log    ${result}
    END

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (orderType)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.length = 1 
    ...     2. data.any(item=> item.customAttributes.isRenew== true) 
    ...    ** isRenew ของทุก package เป็น true
    ...    ==>
    [Tags]   6.3.2    Conditions   
    Set API Header Default
    Set Body API        schema_body=${6_3_2_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(1)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_isRenew}     Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.isRenew
         Should Be Equal As Strings     ${value_isRenew}[0]    true  
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_isRenew: "$.data[${index - 1}].customAttributes.isRenew"
         ...    ${\n}---> condition: All "isRenew" is "true"
         ...    ${\n}---> "isRenew" == "${value_isRenew}[0]"
         Log    ${result}
    END

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_3_3)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (productClass)
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   6.3.3    Conditions  
    Set API Header Default
    Set Body API        schema_body=${6_3_3_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${6_3_3_response_get_all_promotions_by_shelf}

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_3_4)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (productClass)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.length = 2 (config ไว้แค่ 2 pack)
    ...     2. data.any(item=> [On-Top Extra ,On-Top].includes(item.customAttributes.productClass)) 
    ...    ** productClass ของทุก package เป็น On-Top Extra หรือ On-Top
    ...    ==>
    [Tags]   6.3.4    Conditions 
    Set API Header Default
    Set Body API        schema_body=${6_3_4_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(2)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_productClass}     Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.productClass
         Should Be True    str("${value_productClass}[0]") == str("On-Top Extra") or str("${value_productClass}[0]") == str("On-Top")
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_productClass: "$.data[${index - 1}].customAttributes.productClass"
         ...    ${\n}---> condition: All "productClass" is "On-Top Extra" or "On-Top"
         ...    ${\n}---> "productClass" == "${value_productClass}[0]"
         Log    ${result}
    END

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_3_5)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (billingSystem)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.length = 2 (config ไว้แค่ 2 pack)
    ...     2. data.any(item=> item.customAttributes.billingSystem== "IRB") 
    ...    ** billingSystemของทุก package เป็น IRB
    ...    ==>
    [Tags]   6.3.5    Conditions 
    Set API Header Default
    Set Body API        schema_body=${6_3_5_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(2)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_billingSystem}     Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.billingSystem
         Should Be Equal As Strings     ${value_billingSystem}[0]    IRB 
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_billingSystem: "$.data[${index - 1}].customAttributes.billingSystem"
         ...    ${\n}---> condition: All "billingSystem" is "IRB"
         ...    ${\n}---> "billingSystem" == "${value_billingSystem}[0]"
         Log    ${result}
    END

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_3_6)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (billingSystem)
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   6.3.6    Conditions   
    Set API Header Default
    Set Body API        schema_body=${6_3_6_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${6_3_6_response_get_all_promotions_by_shelf}

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_3_7)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (orderType,productClass, billingSystem)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.length = 1 
    ...     2. data.any(item=> item.customAttributes.isRenew== true) ** isRenew ของทุก package เป็น true
    ...     3. data.any(item=> item.customAttributes.billingSystem== "IRB") ** billingSystemของทุก package เป็น IRB
    ...    ==>
    [Tags]   6.3.7    Conditions    
    Set API Header Default
    Set Body API        schema_body=${6_3_7_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(1)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_isRenew}           Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.isRenew
         ${value_billingSystem}     Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.billingSystem
         Should Be Equal As Strings     ${value_isRenew}[0]          true
         Should Be Equal As Strings     ${value_billingSystem}[0]    IRB
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_isRenew: "$.data[${index - 1}].customAttributes.isRenew"
         ...    ${\n}---> json_path_billingSystem: "$.data[${index - 1}].customAttributes.billingSystem"
         ...    ${\n}---> condition: All "isRenew" is "true"
         ...    ${\n}---> condition: All "billingSystem" is "IRB"
         ...    ${\n}---> "isRenew" == "${value_isRenew}[0]"
         ...    ${\n}---> "billingSystem" == "${value_billingSystem}[0]"
         Log    ${result}
    END

CPC_API_1_1_006 Get All Promotions by Shelf (Conditions_Test_Case_3_8)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (orderType,productClass, billingSystem)
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   6.3.8    Conditions   
    Set API Header Default
    Set Body API        schema_body=${6_3_8_body_get_all_promotions_by_shelf}
    Send Request API    url=${url_get_all_promotions_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${6_3_8_response_get_all_promotions_by_shelf}

CPC_API_1_1_007 Get Term & Condition for My Channel
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   7            
    Set API Header Default
    Set Body API        schema_body=${7_body_get_term_and_condition_for_my_channel}
    Send Request API    url=${url_get_condition}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${7_response_get_term_and_condition_for_my_channel}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File  

CPC_API_1_1_007 Get Term & Condition for My Channel (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT * 
    ...    FROM SIT_CPC.[CONDITION] c 
    ...    ==>
    ...    *** Condition ***
    ...     - conditionCode not active
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data = null หรือ data = {}
    ...    ==>
    [Tags]   7.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${7_1_body_get_term_and_condition_for_my_channel}
    Send Request API    url=${url_get_condition}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${7_1_response_get_term_and_condition_for_my_channel}

CPC_API_1_1_007 Get Term & Condition for My Channel (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - conditionCode active
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.conditionText ต้องไม่เท่ากับ null 
    ...    //Object.keys(data).length > 0 
    ...    ==>
    [Tags]   7.2    Conditions  
    Set API Header Default
    Set Body API        schema_body=${7_2_body_get_term_and_condition_for_my_channel}
    Send Request API    url=${url_get_condition}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json     $.data
    @{values}	           Get Value From Json       ${response.json()}	   $.data
    ${body_conditionCode}  Get Value From Json       ${API_BODY}           $.conditionCode
    &{key_value}   Set Variable    ${values[${0}]}
    Should Be True    int(${count}) > int(0)
    ${value_conditionText}         Get Value From Json          ${response.json()}    $.data.conditionText
    Should Not Be Empty            ${value_conditionText}[0]    msg=$.data.conditionText is "null" or "none".
    Should Be Equal As Strings     ${body_conditionCode}[0]     ${key_value.conditionCode}
    ${result}    Catenate
    ...    ${\n}---> condition: $.data.conditionText not "null"
    ...    ${\n}---> "conditionCode" == "${key_value.conditionCode}"
    ...    ${\n}---> "conditionText" == "${value_conditionText}[0]"
    ...    ${\n}---> Object.keys(data).length == "${count}" 
    Log    ${result}

CPC_API_1_1_007 Get Term & Condition for My Channel (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT * 
    ...    FROM SIT_CPC.[CONDITION] c 
    ...    join SIT_CPC.CONDITION_LANGUAGE cl on cl.CONDITION_ID = c.ID 
    ...    ==>
    ...    *** Condition ***
    ...     - conditionCode default language
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.conditionText = "<font face=\"Arial\">CONDITION_TEST_LANG - Text</font>"
    ...    ==>
    [Tags]   7.3.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${7_3_1_body_get_term_and_condition_for_my_channel}
    Send Request API    url=${url_get_condition}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${7_3_1_response_get_term_and_condition_for_my_channel}

CPC_API_1_1_007 Get Term & Condition for My Channel (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - conditionCode set language
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.conditionText = "<font face=\"Arial\">CONDITION_TEST_LANG - EN</font>"
    ...    ==>
    [Tags]   7.3.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${7_3_2_body_get_term_and_condition_for_my_channel}
    Send Request API    url=${url_get_condition}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${7_3_2_response_get_term_and_condition_for_my_channel}

CPC_API_1_1_007 Get Term & Condition for My Channel (Conditions_Test_Case_3_3)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - conditionCode set language
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.conditionText = "<font face=\"Arial\">CONDITION_TEST_LANG - TH</font>"
    ...    ==>
    [Tags]   7.3.3    Conditions        
    Set API Header Default
    Set Body API        schema_body=${7_3_3_body_get_term_and_condition_for_my_channel}
    Send Request API    url=${url_get_condition}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${7_3_3_response_get_term_and_condition_for_my_channel}

CPC_API_1_1_008 Get Package Service Content VDO
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   8             
    Set API Header Default
    Set Body API        schema_body=${8_body_get_package_service_content_vdo}
    Send Request API    url=${url_get_package_service_content_vdo}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${8_response_get_package_service_content_vdo}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File  

CPC_API_1_1_008 Get Package Service Content VDO (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.ITEM_CONTENT_VDO
    ...    ==>
    ...    *** Condition ***
    ...     - ServiceContentVdo not config from PLM
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length == 0
    ...    ==>
    [Tags]   8.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${8_1_body_get_package_service_content_vdo}
    Send Request API    url=${url_get_package_service_content_vdo}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${8_1_response_get_package_service_content_vdo}

CPC_API_1_1_008 Get Package Service Content VDO (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.ITEM_CONTENT_VDO
    ...    ==>
    ...    *** Condition ***
    ...     - ServiceContentVdo  config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length > 0
    ...    ==>
    [Tags]   8.2    Conditions  
    Set API Header Default
    Set Body API        schema_body=${8_2_body_get_package_service_content_vdo}
    Send Request API    url=${url_get_package_service_content_vdo}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_009 Get Package Service Internet
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   9        
    Set API Header Default
    Set Body API        schema_body=${9_body_get_package_service_internet}
    Send Request API    url=${url_get_package_service_internet}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${9_response_get_package_service_internet}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File  

CPC_API_1_1_009 Get Package Service Internet (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service Internet not config from PLM
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   9.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${9_1_body_get_package_service_internet}
    Send Request API    url=${url_get_package_service_internet}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${9_1_response_get_package_service_internet}

CPC_API_1_1_009 Get Package Service Internet (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service Internet  config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length > 0
    ...    ==>
    [Tags]   9.2    Conditions   
    Set API Header Default
    Set Body API        schema_body=${9_2_body_get_package_service_internet}
    Send Request API    url=${url_get_package_service_internet}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_010 Get Package Service MMS
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   10        
    Set API Header Default
    Set Body API        schema_body=${10_body_get_package_service_mms}
    Send Request API    url=${url_get_package_service_mms}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${10_response_get_package_service_mms}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File 

CPC_API_1_1_010 Get Package Service MMS (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service MMS not config from PLM
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   10.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${10_1_body_get_package_service_mms}
    Send Request API    url=${url_get_package_service_mms}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${10_1_response_get_package_service_mms}

CPC_API_1_1_010 Get Package Service MMS (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.ITEM_MMS im 
    ...    order by im.LAST_UPDATED desc
    ...    ==>
    ...    *** Condition ***
    ...     - Service MMS  config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length > 0
    ...    ==>
    [Tags]   10.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${10_2_body_get_package_service_mms}
    Send Request API    url=${url_get_package_service_mms}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_011 Get Package Service SMS
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   11        
    Set API Header Default
    Set Body API        schema_body=${11_body_get_package_service_sms}
    Send Request API    url=${url_get_package_service_sms}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${11_response_get_package_service_sms}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File 

CPC_API_1_1_011 Get Package Service SMS (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service SMS not config from PLM
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   11.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${11_1_body_get_package_service_sms}
    Send Request API    url=${url_get_package_service_sms}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${11_1_response_get_package_service_sms}

CPC_API_1_1_011 Get Package Service SMS (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service SMS  config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length > 0
    ...    ==>
    [Tags]   11.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${11_2_body_get_package_service_sms}
    Send Request API    url=${url_get_package_service_sms}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_012 Get Package Service Vertical Apps
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   12        
    Set API Header Default
    Set Body API        schema_body=${12_body_get_package_vertical_apps}
    Send Request API    url=${url_get_package_service_vertical_apps}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${12_response_get_package_vertical_apps}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File 

CPC_API_1_1_012 Get Package Service Vertical Apps (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service Vertical Apps not config from PLM
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   12.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${12_1_body_get_package_vertical_apps}
    Send Request API    url=${url_get_package_service_vertical_apps}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${12_1_response_get_package_vertical_apps}

CPC_API_1_1_012 Get Package Service Vertical Apps (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service Vertical Apps  config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length > 0
    ...    ==>
    [Tags]   12.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${12_2_body_get_package_vertical_apps}
    Send Request API    url=${url_get_package_service_vertical_apps}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_013 Get Package Service Voice
    [Documentation]    Owner : Worrapong  Edit : Attapon, Patipan.w
    [Tags]   13        
    Set API Header Default
    Set Body API        schema_body=${13_body_get_package_service_voice}
    Send Request API    url=${url_get_package_service_voice}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${13_response_get_package_service_voice}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File 

CPC_API_1_1_013 Get Package Service Voice (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service Voice not config from PLM
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   13.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${13_1_body_get_package_service_voice}
    Send Request API    url=${url_get_package_service_voice}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${13_1_response_get_package_service_voice}

CPC_API_1_1_013 Get Package Service Voice (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service Voice  config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length > 0
    ...    ==>
    [Tags]   13.2    Conditions    fail    
    Set API Header Default
    Set Body API        schema_body=${13_2_body_get_package_service_voice}
    Send Request API    url=${url_get_package_service_voice}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_014 Get Package Service Voice Free Number
    [Documentation]    Owner : Worrapong  Edit : Attapon, Patipan.w
    [Tags]   14        
    Set API Header Default
    Set Body API        schema_body=${14_body_get_package_service_voice_free_number}
    Send Request API    url=${url_get_package_service_voice_free_number}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${14_response_get_package_service_voice_free_number}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File 

CPC_API_1_1_014 Get Package Service Voice Free Number (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service Voice FN not config from PLM
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   14.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${14_1_body_get_package_service_voice_free_number}
    Send Request API    url=${url_get_package_service_voice_free_number}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${14_1_response_get_package_service_voice_free_number}

CPC_API_1_1_014 Get Package Service Voice Free Number (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service Voice FN  config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length > 0
    ...    ==>
    [Tags]   14.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${14_2_body_get_package_service_voice_free_number}
    Send Request API    url=${url_get_package_service_voice_free_number}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_015 Get Package Service WIFI
    [Documentation]    Owner : Worrapong  Edit : Attapon, Patipan.w
    [Tags]   15        
    Set API Header Default
    Set Body API        schema_body=${15_body_get_package_service_wift}
    Send Request API    url=${url_get_package_service_wifi}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${15_response_get_package_service_wift}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File 

CPC_API_1_1_015 Get Package Service WIFI (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service WIFI not config from PLM
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   15.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${15_1_body_get_package_service_wift}
    Send Request API    url=${url_get_package_service_wifi}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${15_1_response_get_package_service_wift}

CPC_API_1_1_015 Get Package Service WIFI (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - Service WIFI config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length > 0
    ...    ==>
    [Tags]   15.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${15_2_body_get_package_service_wift}
    Send Request API    url=${url_get_package_service_wifi}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   16    
    Set API Header Default
    Set Body API        schema_body=${16_body_get_all_promotions_by_shelf_for_pre_paid}
    Send Request API    url=${url_get_all_promotions_by_shelf_prepaid}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${16_response_get_all_promotions_by_shelf_for_pre_paid}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - shelf not mapping item
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   16.1   Conditions       
    Set API Header Default
    Set Body API        schema_body=${16_1_body_get_all_promotions_by_shelf_for_pre_paid}
    Send Request API    url=${url_get_all_promotions_by_shelf_prepaid}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${16_1_response_get_all_promotions_by_shelf_for_pre_paid}

CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - shelf having mapping item
    ...    ==>
    ...    *** Expect Result ***
    ...      1. data.any(item=> item.customAttributes.chargeType== "Pre-paid") 
    ...    ** chargeType ของทุก package เป็น Pre-paid
    ...    ==>
    [Tags]   16.2   Conditions   
    Set API Header Default
    Set Body API        schema_body=${16_2_body_get_all_promotions_by_shelf_for_pre_paid}
    Send Request API    url=${url_get_all_promotions_by_shelf_prepaid}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_chargeType}     Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.chargeType
         Should Be Equal As Strings     ${value_chargeType}[0]    Pre-paid 
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_chargeType: "$.data[${index - 1}].customAttributes.chargeType"
         ...    ${\n}---> condition: All "chargeType" is "Pre-paid"
         ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
         Log    ${result}
    END

CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (orderType)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.any(item=> item.customAttributes.chargeType== "Pre-paid") ** chargeType ของทุก package เป็น Pre-paid
    ...     2. data.any(item=> item.customAttributes.isNewRegistration == true) ** isNewRegistration ของทุก package เป็น true
    ...    ==>
    [Tags]   16.3.1   Conditions   
    Set API Header Default
    Set Body API        schema_body=${16_3_1_body_get_all_promotions_by_shelf_for_pre_paid}
    Send Request API    url=${url_get_all_promotions_by_shelf_prepaid}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_chargeType}            Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.chargeType
         ${value_isNewRegistration}     Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.isNewRegistration
         Should Be Equal As Strings     ${value_chargeType}[0]           Pre-paid
         Should Be Equal As Strings     ${value_isNewRegistration}[0]    true 
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_chargeType: "$.data[${index - 1}].customAttributes.chargeType"
         ...    ${\n}---> json_path_isNewRegistration: "$.data[${index - 1}].customAttributes.isNewRegistration"
         ...    ${\n}---> condition: All "chargeType" is "Pre-paid"
         ...    ${\n}---> condition: All "isNewRegistration" is "true"
         ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
         ...    ${\n}---> "isNewRegistration" == "${value_isNewRegistration}[0]"
         Log    ${result}
    END

CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (productClass)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.any(item=> item.customAttributes.chargeType== "Pre-paid") ** chargeType ของทุก package เป็น Pre-paid
    ...     2. data.any(item=> [On-Top Extra ,On-Top].includes(item.customAttributes.productClass)) ** productClass ของทุก package เป็น On-Top Extra หรือ On-Top
    ...    ==>
    [Tags]   16.3.2   Conditions   
    Set API Header Default
    Set Body API        schema_body=${16_3_2_body_get_all_promotions_by_shelf_for_pre_paid}
    Send Request API    url=${url_get_all_promotions_by_shelf_prepaid}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_chargeType}            Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.chargeType
         ${value_productClass}          Get Value From Json    ${response.json()}    $.data[${index - 1}].customAttributes.productClass
         Should Be Equal As Strings     ${value_chargeType}[0]           Pre-paid
         Should Be True                 str("${value_productClass}[0]") == str("On-Top Extra") or str("${value_productClass}[0]") == str("On-Top")
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_chargeType: "$.data[${index - 1}].customAttributes.chargeType"
         ...    ${\n}---> json_path_productClass: "$.data[${index - 1}].customAttributes.productClass"
         ...    ${\n}---> condition: All "chargeType" is "Pre-paid"
         ...    ${\n}---> condition: All "productClass" is "On-Top Extra" or "On-Top"
         ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
         ...    ${\n}---> "productClass" == "${value_productClass}[0]"
         Log    ${result}
    END

CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_3)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (billingSystem)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.any(item=> item.customAttributes.chargeType== "Pre-paid") ** chargeType ของทุก package เป็น Pre-paid
    ...     2. data.any(item=> item.customAttributes.billingSystem== "CBS") *** เส้นนี้ขอแก้เงื่อนไขเป็นมี "CBS" อยู่ใน billingSystem นะคะ 1 pack อาจจะมีมากว่า 1 billingSystem 
    ...    ==>
    [Tags]   16.3.3   Conditions    
    Set API Header Default
    Set Body API        schema_body=${16_3_3_body_get_all_promotions_by_shelf_for_pre_paid}
    Send Request API    url=${url_get_all_promotions_by_shelf_prepaid}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_chargeType}            Get Value From Json                   ${response.json()}    $.data[${index - 1}].customAttributes.chargeType
         ${value_billingSystem}         Get Value List In String From Json    ${response.json()}    $.data[${index - 1}].customAttributes.billingSystem
         Should Be Equal As Strings     ${value_chargeType}[0]          Pre-paid
         List Should Contain Value      ${value_billingSystem}          CBS
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_chargeType: "$.data[${index - 1}].customAttributes.chargeType"
         ...    ${\n}---> json_path_billingSystem: "$.data[${index - 1}].customAttributes.billingSystem"
         ...    ${\n}---> condition: All "chargeType" is "Pre-paid" 
         ...    ${\n}---> condition: All "billingSystem" is "CBS" *** เส้นนี้ขอแก้เงื่อนไขเป็นมี "CBS" อยู่ใน billingSystem นะคะ 1 pack อาจจะมีมากว่า 1 billingSystem 
         ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
         ...    ${\n}---> "billingSystem" == "${value_billingSystem}"
         Log    ${result}
    END

CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_4)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (orderType,productClass, billingSystem)
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.any(item=> item.customAttributes.chargeType== "Pre-paid") ** chargeType ของทุก package เป็น Pre-paid
    ...    2. data.any(item=> item.customAttributes.isNewRegistration == true) ** isNewRegistration ของทุก package เป็น true
    ...    3. data.any(item=> item.customAttributes.billingSystem== "CBS") *** เส้นนี้ขอแก้เงื่อนไขเป็นมี "CBS" อยู่ใน billingSystem นะคะ 1 pack อาจจะมีมากว่า 1 billingSystem 
    ...    4. data.any(item=> [On-Top Extra ,On-Top].includes(item.customAttributes.productClass)) ** productClass ของทุก package เป็น On-Top Extra หรือ On-Top
    ...    ==>
    [Tags]   16.3.4   Conditions    
    Set API Header Default
    Set Body API        schema_body=${16_3_4_body_get_all_promotions_by_shelf_for_pre_paid}
    Send Request API    url=${url_get_all_promotions_by_shelf_prepaid}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_chargeType}            Get Value From Json                    ${response.json()}    $.data[${index - 1}].customAttributes.chargeType
         ${value_isNewRegistration}     Get Value From Json                    ${response.json()}    $.data[${index - 1}].customAttributes.isNewRegistration
         ${value_billingSystem}         Get Value List In String From Json     ${response.json()}    $.data[${index - 1}].customAttributes.billingSystem
         ${value_productClass}          Get Value From Json                    ${response.json()}    $.data[${index - 1}].customAttributes.productClass
         Should Be Equal As Strings     ${value_chargeType}[0]           Pre-paid
         Should Be Equal As Strings     ${value_isNewRegistration}[0]    true 
         List Should Contain Value      ${value_billingSystem}           CBS
         Should Be True                 str("${value_productClass}[0]") == str("On-Top Extra") or str("${value_productClass}[0]") == str("On-Top")
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_chargeType: "$.data[${index - 1}].customAttributes.chargeType"
         ...    ${\n}---> json_path_isNewRegistration: "$.data[${index - 1}].customAttributes.isNewRegistration"
         ...    ${\n}---> json_path_billingSystem: "$.data[${index - 1}].customAttributes.billingSystem"
         ...    ${\n}---> json_path_productClass: "$.data[${index - 1}].customAttributes.productClass"
         ...    ${\n}---> condition: All "chargeType" is "Pre-paid"
         ...    ${\n}---> condition: All "isNewRegistration" is "true"
         ...    ${\n}---> condition: All "billingSystem" is "CBS" *** เส้นนี้ขอแก้เงื่อนไขเป็นมี "CBS" อยู่ใน billingSystem นะคะ 1 pack อาจจะมีมากว่า 1 billingSystem 
         ...    ${\n}---> condition: All "productClass" is "On-Top Extra" or "On-Top"
         ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
         ...    ${\n}---> "isNewRegistration" == "${value_isNewRegistration}[0]"
         ...    ${\n}---> "billingSystem" == "${value_billingSystem}"
         ...    ${\n}---> "productClass" == "${value_productClass}[0]"
         Log    ${result}
    END

CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_5)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - userId query by parameters (orderType,productClass, billingSystem)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. data.any(item=> item.customAttributes.chargeType== "Pre-paid") ** chargeType ของทุก package เป็น Pre-paid
    ...     2. data.any(item=> item.customAttributes.isChangePromotion== true) ** isChangePromotion ของทุก package เป็น true
    ...     3. data.any(item=> item.customAttributes.billingSystem== "CBS") *** เส้นนี้ขอแก้เงื่อนไขเป็นมี "CBS" อยู่ใน billingSystem นะคะ 1 pack อาจจะมีมากว่า 1 billingSystem 
    ...     4. data.any(item=> [On-Top Extra ,On-Top].includes(item.customAttributes.productClass)) ** productClass ของทุก package เป็น On-Top Extra หรือ On-Top
    ...    ==>
    [Tags]   16.3.5   Conditions    
    Set API Header Default
    Set Body API        schema_body=${16_3_5_body_get_all_promotions_by_shelf_for_pre_paid}
    Send Request API    url=${url_get_all_promotions_by_shelf_prepaid}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_chargeType}            Get Value From Json                   ${response.json()}    $.data[${index - 1}].customAttributes.chargeType
         ${value_isChangePromotion}     Get Value From Json                   ${response.json()}    $.data[${index - 1}].customAttributes.isChangePromotion
         ${value_billingSystem}         Get Value List In String From Json    ${response.json()}    $.data[${index - 1}].customAttributes.billingSystem
         ${value_productClass}          Get Value From Json                   ${response.json()}    $.data[${index - 1}].customAttributes.productClass
         Should Be Equal As Strings     ${value_chargeType}[0]           Pre-paid
         Should Be Equal As Strings     ${value_isChangePromotion}[0]    true 
         List Should Contain Value      ${value_billingSystem}           CBS
         Should Be True                 str("${value_productClass}[0]") == str("On-Top Extra") or str("${value_productClass}[0]") == str("On-Top")
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_chargeType: "$.data[${index - 1}].customAttributes.chargeType"
         ...    ${\n}---> json_path_isChangePromotion: "$.data[${index - 1}].customAttributes.isChangePromotion"
         ...    ${\n}---> json_path_billingSystem: "$.data[${index - 1}].customAttributes.billingSystem"
         ...    ${\n}---> json_path_productClass: "$.data[${index - 1}].customAttributes.productClass"
         ...    ${\n}---> condition: All "chargeType" is "Pre-paid"
         ...    ${\n}---> condition: All "isChangePromotion" is "true"
         ...    ${\n}---> condition: All "billingSystem" is "CBS" *** เส้นนี้ขอแก้เงื่อนไขเป็นมี "CBS" อยู่ใน billingSystem นะคะ 1 pack อาจจะมีมากว่า 1 billingSystem 
         ...    ${\n}---> condition: All "productClass" is "On-Top Extra" or "On-Top"
         ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
         ...    ${\n}---> "isChangePromotion" == "${value_isChangePromotion}[0]"
         ...    ${\n}---> "billingSystem" == "${value_billingSystem}"
         ...    ${\n}---> "productClass" == "${value_productClass}[0]"
         Log    ${result}
    END

# CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_6)
#     [Documentation]    Owner : Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...     - userId query by parameters (orderFeeAmount)
#     ...    ==>
#     ...    *** Expect Result ***
#     ...     - ** Cancel เนื่องจาก Pre-paid ไม่มี package ให้ test 7/4/2567 **
#     ...    ==>
#     [Tags]   16.3.6   Conditions    Cancel

# CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_7)
#     [Documentation]    Owner : Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...     - userId query by parameters (location)
#     ...    ==>
#     ...    *** Expect Result ***
#     ...     - ** Cancel เนื่องจาก Pre-paid ไม่มี package ให้ test 7/4/2567 **
#     ...    ==>
#     [Tags]   16.3.7   Conditions    Cancel

# CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_8)
#     [Documentation]    Owner : Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...     - userId query by parameters (location, province)
#     ...    ==>
#     ...    *** Expect Result ***
#     ...     - ** Cancel เนื่องจาก Pre-paid ไม่มี package ให้ test 7/4/2567 **
#     ...    ==>
#     [Tags]   16.3.8   Conditions    Cancel

# CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_9)
#     [Documentation]    Owner : Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...     - userId query by parameters (location, province, district, subDistrict)
#     ...    ==>
#     ...    *** Expect Result ***
#     ...     - ** Cancel เนื่องจาก Pre-paid ไม่มี package ให้ test 7/4/2567 **
#     ...    ==>
#     [Tags]   16.3.9   Conditions    Cancel

# CPC_API_1_1_016 Get All Promotions by Shelf for Pre-paid (Conditions_Test_Case_3_10)
#     [Documentation]    Owner : Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...     - userId query by parameters (location, province, district, subDistrict)
#     ...    ==>
#     ...    *** Expect Result ***
#     ...     - ** Cancel เนื่องจาก Pre-paid ไม่มี package ให้ test 7/4/2567 **
#     ...    ==>
#     [Tags]   16.3.10   Conditions    Cancel

CPC_API_1_1_017 Get Promotion Product Rules
    [Documentation]    Owner : Worrapong    Edit : Patipan.w
    [Tags]   17        
    Set API Header Default
    Set Body API        schema_body=${17_body_get_promotion_product_rules}
    Send Request API    url=${url_get_promotion_product_rules}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${17_response_get_promotion_product_rules}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File 

CPC_API_1_1_017 Get Promotion Product Rules (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - promotion not coonfig rules from SFF
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - data.length = 0
    ...    ==>
    [Tags]   17.1   Conditions   
    Set API Header Default
    Set Body API        schema_body=${17_1_body_get_promotion_product_rules}
    Send Request API    url=${url_get_promotion_product_rules}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${17_1_response_get_promotion_product_rules}

CPC_API_1_1_017 Get Promotion Product Rules (Conditions_Test_Case_2)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT SF.PRODUCT_CD, SF.ROW_ID AS ROWID_PRODUCT, SFR.ROW_ID AS ROWID_PRODUCT_RULE
    ...    		, SFR.RULE_SET, SFR.RULE_TYPE, SFR.RULE_VALUE, SF.CHARGE_TYPE, SFR.ACTIVE_FLG
    ...    		, SFR.MODIFICATION_NUM, SFR.RULE_START_DT AS START_RULE, SFR.RULE_END_DT AS END_RULE
    ...    FROM SIT_CPC.SFF_PRODUCT SF
    ...    JOIN SIT_CPC.SFF_PRODUCT_RULE SFR ON SF.ROW_ID = SFR.PRODUCT_ROW_ID
    ...    ==>
    ...    *** Condition ***
    ...     - promotion having coonfig rules from SFF
    ...    ==>
    ...    *** Expect Result ***
    ...    - data.length > 0
    ...    ==>
    [Tags]   17.2   Conditions
    Set API Header Default
    Set Body API        schema_body=${17_2_body_get_promotion_product_rules}
    Send Request API    url=${url_get_promotion_product_rules}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_017 Get Promotion Product Rules (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by ruleType (Exclude)
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.length > 0
    ...    2. data.any(d=> d.rules.any(r=> r.ruleType == "Exclude" )) 
    ...    ** ต้องพบ ruleType == "Exclude" เท่านั้น
    ...    ==>
    [Tags]   17.3.1   Conditions    
    Set API Header Default
    Set Body API        schema_body=${17_3_1_body_get_promotion_product_rules}
    Send Request API    url=${url_get_promotion_product_rules}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) > int(0)
    FOR  ${index_data}  IN RANGE    1    ${count_data} + 1
             ${count_rules}    Get List Key And Count From Json    $.data[${index_data - 1}].rules
             Should Be True    int(${count_rules}) > int(0)
             FOR  ${index_rules}  IN RANGE    1    ${count_rules} + 1
             ${value_ruleType}              Get Value From Json     ${response.json()}    $.data[${index_data - 1}].rules[${index_rules - 1}].ruleType          
             Should Be Equal As Strings     ${value_ruleType}[0]    Exclude
             ${result}    Catenate
             ...    ${\n}---> loop data: "${index_data}"
             ...    ${\n}---> loop rules: "${index_rules}"
             ...    ${\n}---> json_path_ruleType: "$.data[${index_data - 1}].rules[${index_rules - 1}].ruleType "
             ...    ${\n}---> condition: All "ruleType" is "Exclude"
             ...    ${\n}---> "ruleType" == "${value_ruleType}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_017 Get Promotion Product Rules (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by ruleType (Order Type - Allowed)
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.length > 0
    ...    2. data.any(d=> d.rules.any(r=> r.ruleType == "Order Type - Allowed" )) 
    ...    ** ต้องพบ ruleType == "Order Type - Allowed" เท่านั้น
    ...    ==>
    [Tags]   17.3.2   Conditions   
    Set API Header Default
    Set Body API        schema_body=${17_3_2_body_get_promotion_product_rules}
    Send Request API    url=${url_get_promotion_product_rules}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) > int(0)
    FOR  ${index_data}  IN RANGE    1    ${count_data} + 1
             ${count_rules}    Get List Key And Count From Json    $.data[${index_data - 1}].rules
             Should Be True    int(${count_rules}) > int(0)
             FOR  ${index_rules}  IN RANGE    1    ${count_rules} + 1
             ${value_ruleType}              Get Value From Json     ${response.json()}    $.data[${index_data - 1}].rules[${index_rules - 1}].ruleType          
             Should Be Equal As Strings     ${value_ruleType}[0]    Order Type - Allowed
             ${result}    Catenate
             ...    ${\n}---> loop data: "${index_data}"
             ...    ${\n}---> loop rules: "${index_rules}"
             ...    ${\n}---> json_path_ruleType: "$.data[${index_data - 1}].rules[${index_rules - 1}].ruleType "
             ...    ${\n}---> condition: All "ruleType" is "Order Type - Allowed"
             ...    ${\n}---> "ruleType" == "${value_ruleType}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_017 Get Promotion Product Rules (Conditions_Test_Case_3_3)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by ruleType (Age Verification Min, Age Verification Max)
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.length > 0
    ...    2. data.any(d=> d.rules.any(r=>  ["Age Verification Min", "Age Verification Max"].includes( r.ruleType )) 
    ...    ** ต้องพบ ruleType"Age Verification Min" หรือ  "Age Verification Max" เท่านั้น
    ...    ==>
    [Tags]   17.3.3   Conditions   
    Set API Header Default
    Set Body API        schema_body=${17_3_3_body_get_promotion_product_rules}
    Send Request API    url=${url_get_promotion_product_rules}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) > int(0)
    FOR  ${index_data}  IN RANGE    1    ${count_data} + 1
             ${count_rules}    Get List Key And Count From Json    $.data[${index_data - 1}].rules
             Should Be True    int(${count_rules}) > int(0)
             FOR  ${index_rules}  IN RANGE    1    ${count_rules} + 1
             ${value_ruleType}              Get Value From Json     ${response.json()}    $.data[${index_data - 1}].rules[${index_rules - 1}].ruleType          
             Should Be True                 str("${value_ruleType}[0]") == str("Age Verification Min") or str("${value_ruleType}[0]") == str("Age Verification Max")
             ${result}    Catenate
             ...    ${\n}---> loop data: "${index_data}"
             ...    ${\n}---> loop rules: "${index_rules}"
             ...    ${\n}---> json_path_ruleType: "$.data[${index_data - 1}].rules[${index_rules - 1}].ruleType "
             ...    ${\n}---> condition: All "ruleType" is "Age Verification Min" or "Age Verification Max"
             ...    ${\n}---> "ruleType" == "${value_ruleType}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_017 Get Promotion Product Rules (Conditions_Test_Case_3_4)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by ruleType not match
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - data.length = 0
    ...    ==>
    [Tags]   17.3.4   Conditions   
    Set API Header Default
    Set Body API        schema_body=${17_3_4_body_get_promotion_product_rules}
    Send Request API    url=${url_get_promotion_product_rules}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${17_3_4_response_get_promotion_product_rules}

CPC_API_1_1_018 Get Promotions
    [Documentation]    Owner : Worrapongs    Edit : Kachain.a
    [Tags]   18    
    Set API Header Default
    Set Body API        schema_body=${18_body_get_promotions}
    Send Request API    url=${url_get_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${18_response_get_promotions}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File 

CPC_API_1_1_018 Get Promotions (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - Subscriber not coonfig 
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - data.length == 0
    ...    ==>
    [Tags]   18.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${18_1_body_get_promotions}
    Send Request API    url=${url_get_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${18_1_response_get_promotions}

CPC_API_1_1_018 Get Promotions (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - Subscriber having coonfig shelf 
    ...       ** hard config**
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.data.length == 1
    ...    - 2.data[0].subShelves.length == 2
    ...    - 3."sanitizedName": "sub-1-shelf-for-automate-test" ต้องไม่มี items
    ...    - 4."sanitizedName": "sub-2-shelf-for-automate-test" มี item 2 ตัว
    ...    ==>
    [Tags]   18.2   Conditions    
    Set API Header Default
    Set Body API        schema_body=${18_2_body_get_promotions}
    Send Request API    url=${url_get_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}                Get List Key And Count From Json    $.data
    ${count_subShelves}          Get List Key And Count From Json    $.data[0].subShelves
    Should Be True    int(${count_data}) == int(1)
    Should Be True    int(${count_subShelves}) == int(2)
    FOR  ${index}  IN RANGE     ${count_subShelves}
         ${value_sanitizedName}       Get Value From Json    ${response.json()}    $.data[0].subShelves[${index}].sanitizedName
         ${count_items}               Get List Key And Count From Json             $.data[0].subShelves[${index}].items
         Log    sanitizedName : ${value_sanitizedName}[0]${\n}Length of items : ${count_items}
         IF  '${value_sanitizedName[0]}' == 'sub-1-shelf-for-automate-test'
             Should Be True    int(${count_items}) == int(0)
         ELSE IF  '${value_sanitizedName[0]}' == 'sub-2-shelf-for-automate-test'
             Should Be True    int(${count_items}) == int(2)
         END
         ${result}    Catenate
         ...    ${\n}---> loop index: "0"
         ...    ${\n}---> json_path_sanitizedName: "$.data[0].subShelves[${index}].sanitizedName"
         ...    ${\n}---> json_path_items: "$.data[0].subShelves[${index}].items
         ...    ${\n}---> condition: "sanitizedName": "sub-1-shelf-for-automate-test" ต้องไม่มี items
         ...    ${\n}---> condition: "sanitizedName": "sub-2-shelf-for-automate-test" มี item 2 ตัว
         ...    ${\n}---> "sanitizedName" == "${value_sanitizedName}[0]"
         ...    ${\n}---> "count_item" == "${count_items}"
         Log    ${result}
    END

CPC_API_1_1_018 Get Promotions (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - set language
    ...    ==>
    ...    *** Expect Result ***
    ...    - data[*].subShelves[*].title == "shelf-title-en"
    ...    ==>
    [Tags]   18.3.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${18_3_1_body_get_promotions}
    Send Request API    url=${url_get_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    FOR  ${index}  IN RANGE    ${count_data}
             ${count_subShelves}    Get List Key And Count From Json    $.data[${index}].subShelves
             FOR  ${index_subShelves}  IN RANGE    ${count_subShelves}
             ${value_title}                 Get Value From Json     ${response.json()}    $.data[${index}].subShelves[${index_subShelves}].title          
             Should Be Equal As Strings     ${value_title}[0]       shelf-title-en
             ${result}    Catenate
             ...    ${\n}---> loop index data: "${index}"
             ...    ${\n}---> loop index subShelves: "${index_subShelves}"
             ...    ${\n}---> json_path_title: "$.data[${index}].subShelves[${index_subShelves}].title"
             ...    ${\n}---> condition: All "title" is "shelf-title-en"
             ...    ${\n}---> "data[*].subShelves[*].title" == "${value_title}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_018 Get Promotions (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - set language
    ...    ==>
    ...    *** Expect Result ***
    ...    - data[*].subShelves[*].title == "shelf-title-th"
    ...    ==>
    [Tags]   18.3.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${18_3_2_body_get_promotions}
    Send Request API    url=${url_get_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    FOR  ${index}  IN RANGE    ${count_data}
             ${count_subShelves}    Get List Key And Count From Json    $.data[${index}].subShelves
             FOR  ${index_subShelves}  IN RANGE    ${count_subShelves}
             ${value_title}                 Get Value From Json     ${response.json()}    $.data[${index}].subShelves[${index_subShelves}].title          
             Should Be Equal As Strings     ${value_title}[0]       shelf-title-th
             ${result}    Catenate
             ...    ${\n}---> loop index data: "${index}"
             ...    ${\n}---> loop index subShelves: "${index_subShelves}"
             ...    ${\n}---> json_path_title: "$.data[${index}].subShelves[${index_subShelves}].title"
             ...    ${\n}---> condition: All "title" is "shelf-title-th"
             ...    ${\n}---> "data[*].subShelves[*].title" == "${value_title}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_018 Get Promotions (Conditions_Test_Case_4_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by parameters
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."sanitizedName": "sub-1-shelf-for-automate-test" มี item 2 ตัว
    ...    - 2."sanitizedName": "sub-2-shelf-for-automate-test" ต้องไม่มี items
    ...    ==>
    [Tags]   18.4.1   Conditions     
    Set API Header Default
    Set Body API        schema_body=${18_4_1_body_get_promotions}
    Send Request API    url=${url_get_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}                 Get List Key And Count From Json    $.data
    FOR  ${index_data}  IN RANGE    ${count_data}
        ${count_subShelves}       Get List Key And Count From Json             $.data[${index_data}].subShelves
        FOR  ${index_subShelves}  IN RANGE   ${count_subShelves}
            ${value_sanitizedName}      Get Value From Json     ${response.json()}    $.data[${index_data}].subShelves[${index_subShelves}].sanitizedName          
            ${count_items}              Get List Key And Count From Json              $.data[${index_data}].subShelves[${index_subShelves}].items
            Log    sanitizedName : ${value_sanitizedName}[0]${\n}Length of items : ${count_items}
            IF  '${value_sanitizedName[0]}' == 'sub-1-shelf-for-automate-test'
                Should Be True    int(${count_items}) == int(2)
            ELSE IF  '${value_sanitizedName[0]}' == 'sub-2-shelf-for-automate-test'
                Should Be True    int(${count_items}) == int(0)
            END
            ${result}    Catenate
            ...    ${\n}---> loop index data: "${index_data}"
            ...    ${\n}---> loop index subShelves: "${index_subShelves}"
            ...    ${\n}---> json_path_sanitizedName: "$.data[${index_data}].subShelves[${index_subShelves}].sanitizedName"
            ...    ${\n}---> json_path_items: "$.data[${index_data}].subShelves[${index_subShelves}].items
            ...    ${\n}---> condition: "sanitizedName": "sub-1-shelf-for-automate-test" มี item 2 ตัว
            ...    ${\n}---> condition: "sanitizedName": "sub-2-shelf-for-automate-test" ต้องไม่มี items
            ...    ${\n}---> "sanitizedName" == "${value_sanitizedName}[0]"
            ...    ${\n}---> "count_item" == "${count_items}"
            Log    ${result}
        END
    END

CPC_API_1_1_018 Get Promotions (Conditions_Test_Case_4_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by parameters
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."sanitizedName": "sub-1-shelf-for-automate-test" ต้องไม่มี items
    ...    - 2."sanitizedName": "sub-2-shelf-for-automate-test" มี item 2 ตัว
    ...    ==>
    [Tags]   18.4.2   Conditions    
    Set API Header Default
    Set Body API        schema_body=${18_4_2_body_get_promotions}
    Send Request API    url=${url_get_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}                 Get List Key And Count From Json    $.data
    FOR  ${index_data}  IN RANGE    ${count_data}
        ${count_subShelves}       Get List Key And Count From Json             $.data[${index_data}].subShelves
        FOR  ${index_subShelves}  IN RANGE   ${count_subShelves}
            ${value_sanitizedName}      Get Value From Json     ${response.json()}    $.data[${index_data}].subShelves[${index_subShelves}].sanitizedName          
            ${count_items}              Get List Key And Count From Json              $.data[${index_data}].subShelves[${index_subShelves}].items
            Log    sanitizedName : ${value_sanitizedName}[0]${\n}Length of items : ${count_items}
            IF  '${value_sanitizedName[0]}' == 'sub-1-shelf-for-automate-test'
                Should Be True    int(${count_items}) == int(0)
            ELSE IF  '${value_sanitizedName[0]}' == 'sub-2-shelf-for-automate-test'
                Should Be True    int(${count_items}) == int(2)
            END
            ${result}    Catenate
            ...    ${\n}---> loop index data: "${index_data}"
            ...    ${\n}---> loop index subShelves: "${index_subShelves}"
            ...    ${\n}---> json_path_sanitizedName: "$.data[${index_data}].subShelves[${index_subShelves}].sanitizedName"
            ...    ${\n}---> json_path_items: "$.data[${index_data}].subShelves[${index_subShelves}].items
            ...    ${\n}---> condition: "sanitizedName": "sub-1-shelf-for-automate-test" ต้องไม่มี items
            ...    ${\n}---> condition: "sanitizedName": "sub-2-shelf-for-automate-test"  มี item 2 ตัว
            ...    ${\n}---> "sanitizedName" == "${value_sanitizedName}[0]"
            ...    ${\n}---> "count_item" == "${count_items}"
            Log    ${result}
        END
    END

CPC_API_1_1_018 Get Promotions (Conditions_Tes_Case_4_3)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by parameters not match
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."sanitizedName": "sub-1-shelf-for-automate-test" ต้องไม่มี items
    ...    - 2."sanitizedName": "sub-2-shelf-for-automate-test" ต้องไม่มี items
    ...    ==>
    [Tags]   18.4.3   Conditions    
    Set API Header Default
    Set Body API        schema_body=${18_4_3_body_get_promotions}
    Send Request API    url=${url_get_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}                 Get List Key And Count From Json    $.data
    FOR  ${index_data}  IN RANGE    ${count_data}
        ${count_subShelves}       Get List Key And Count From Json             $.data[${index_data}].subShelves
        FOR  ${index_subShelves}  IN RANGE   ${count_subShelves}
            ${value_sanitizedName}      Get Value From Json     ${response.json()}    $.data[${index_data}].subShelves[${index_subShelves}].sanitizedName          
            ${count_items}              Get List Key And Count From Json              $.data[${index_data}].subShelves[${index_subShelves}].items
            Log    sanitizedName : ${value_sanitizedName}[0]${\n}Length of items : ${count_items}
            IF  '${value_sanitizedName[0]}' == 'sub-1-shelf-for-automate-test'
                Should Be True    int(${count_items}) == int(0)
            ELSE IF  '${value_sanitizedName[0]}' == 'sub-2-shelf-for-automate-test'
                Should Be True    int(${count_items}) == int(0)
            END
            ${result}    Catenate
            ...    ${\n}---> loop index data: "${index_data}"
            ...    ${\n}---> loop index subShelves: "${index_subShelves}"
            ...    ${\n}---> json_path_sanitizedName: "$.data[${index_data}].subShelves[${index_subShelves}].sanitizedName"
            ...    ${\n}---> json_path_items: "$.data[${index_data}].subShelves[${index_subShelves}].items
            ...    ${\n}---> condition: "sanitizedName": "sub-1-shelf-for-automate-test" ต้องไม่มี items
            ...    ${\n}---> condition: "sanitizedName": "sub-2-shelf-for-automate-test" ต้องไม่มี items
            ...    ${\n}---> "sanitizedName" == "${value_sanitizedName}[0]"
            ...    ${\n}---> "count_item" == "${count_items}"
            Log    ${result}
        END
    END

CPC_API_1_1_019 Get Promotions by Promotion Codes
    [Documentation]    Owner : Worrapong    Edit : Kachain.a
    [Tags]   19     
    Set API Header Default
    Set Body API        schema_body=${19_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${19_response_get_promotions_by_promotion_codes}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_1)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT ica.CUSTOM_ATTRIBUTES_ELT , i.PROMOTION_CODE 
    ...    FROM SIT_CPC.ITEM i 
    ...    join SIT_CPC.ITEM_CUSTOM_ATTRIBUTES ica on ica.CUSTOM_ATTRIBUTES = i.ID and ica.CUSTOM_ATTRIBUTES_IDX like '%EndDt%'
    ...    where i.PROMOTION_CODE  is not null
    ...    order by ica.CUSTOM_ATTRIBUTES_ELT desc
    ...    ==>
    ...    *** Condition ***
    ...     - find by promotionCodes
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length == 1
    ...    - 2. data[0].customAttributes.promotionCode == "P12021009"
    ...    ==>
    [Tags]   19.1.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${19_1_1_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(1)
    FOR  ${index}  IN RANGE     ${count}
         ${value_promotionCode}     Get Value From Json    ${response.json()}    $.data[0].customAttributes.promotionCode
         Should Be Equal As Strings     ${value_promotionCode}[0]    P12021009
         ${result}    Catenate
         ...    ${\n}---> loop index: "0"
         ...    ${\n}---> json_path_promotionCode: "$.data[0].customAttributes.promotionCode"
         ...    ${\n}---> condition: Value of key "promotionCode" == "P12021009"
         ...    ${\n}---> "promotionCode" == "${value_promotionCode}[0]"
         Log    ${result}
    END

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - find by promotionCodes not match
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length == 0
    ...    ==>
    [Tags]   19.1.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${19_1_2_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(0)
    Verify Response Should Be Equal Expected      path_expected=${19_1_2_response_get_promotions_by_promotion_codes}

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_3)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT ica.CUSTOM_ATTRIBUTES_ELT , i.FEATURE_CODE 
    ...    FROM SIT_CPC.ITEM i 
    ...    join SIT_CPC.ITEM_CUSTOM_ATTRIBUTES ica on ica.CUSTOM_ATTRIBUTES = i.ID and ica.CUSTOM_ATTRIBUTES_IDX like '%EndDt%'
    ...    where i.FEATURE_CODE  is not null
    ...    order by ica.CUSTOM_ATTRIBUTES_ELT desc
    ...    ==>
    ...    *** Condition ***
    ...     - find by featureCode
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length == 1
    ...    - 2. data[0].customAttributes.featureCode == "5700179"
    ...    ==>
    [Tags]   19.1.3    Conditions    
    Set API Header Default
    Set Body API        schema_body=${19_1_3_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(1)
    FOR  ${index}  IN RANGE     ${count}
         ${value_featureCode}     Get Value From Json    ${response.json()}    $.data[0].customAttributes.featureCode
         Should Be Equal As Strings     ${value_featureCode}[0]    5700179
         ${result}    Catenate
         ...    ${\n}---> loop index: "0"
         ...    ${\n}---> json_path_featureCode: "$.data[0].customAttributes.featureCode"
         ...    ${\n}---> condition: Value of key "featureCode" == "5700179"
         ...    ${\n}---> "featureCode" == "${value_featureCode}[0]"
         Log    ${result}
    END

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_4)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - find by featureCodes not match
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length == 0
    ...    ==>
    [Tags]   19.1.4    Conditions    
    Set API Header Default
    Set Body API        schema_body=${19_1_4_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(0)
    Verify Response Should Be Equal Expected      path_expected=${19_1_4_response_get_promotions_by_promotion_codes}

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_5)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT ica.CUSTOM_ATTRIBUTES_ELT , i.OFFERING_ID 
    ...    FROM SIT_CPC.ITEM i 
    ...    join SIT_CPC.ITEM_CUSTOM_ATTRIBUTES ica on ica.CUSTOM_ATTRIBUTES = i.ID and ica.CUSTOM_ATTRIBUTES_IDX like '%EndDt%'
    ...    where i.OFFERING_ID  is not null
    ...    order by ica.CUSTOM_ATTRIBUTES_ELT desc
    ...    ==>
    ...    *** Condition ***
    ...     - find by offeringIds
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length == 1
    ...    - 2. data[0].customAttributes.offeringId == "864571"
    ...    ==>
    [Tags]   19.1.5    Conditions    
    Set API Header Default
    Set Body API        schema_body=${19_1_5_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(1)
    FOR  ${index}  IN RANGE     ${count}
         ${value_offeringId}     Get Value From Json    ${response.json()}    $.data[0].customAttributes.offeringId
         Should Be Equal As Strings     ${value_offeringId}[0]    864571
         ${result}    Catenate
         ...    ${\n}---> loop index: "0"
         ...    ${\n}---> json_path_offeringId: "$.data[0].customAttributes.offeringId"
         ...    ${\n}---> condition: Value of key "offeringId" == "864571"
         ...    ${\n}---> "offeringId" == "${value_offeringId}[0]"
         Log    ${result}
    END

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_6)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - find by offeringIds not match
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length == 0
    ...    ==>
    [Tags]   19.1.6    Conditions    
    Set API Header Default
    Set Body API        schema_body=${19_1_6_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(0)
    Verify Response Should Be Equal Expected      path_expected=${19_1_6_response_get_promotions_by_promotion_codes}

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_7)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT ica.CUSTOM_ATTRIBUTES_ELT , i.OFFERING_CODE 
    ...    FROM SIT_CPC.ITEM i 
    ...    join SIT_CPC.ITEM_CUSTOM_ATTRIBUTES ica on ica.CUSTOM_ATTRIBUTES = i.ID and ica.CUSTOM_ATTRIBUTES_IDX like '%EndDt%'
    ...    where i.OFFERING_CODE  is not null
    ...    order by ica.CUSTOM_ATTRIBUTES_ELT desc
    ...    ==>
    ...    *** Condition ***
    ...     - find by offeringCodes
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length == 1
    ...    - 2. data[0].customAttributes.offeringCode == "O23029002"
    ...    ==>
    [Tags]   19.1.7    Conditions     
    Set API Header Default
    Set Body API        schema_body=${19_1_7_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(1)
    FOR  ${index}  IN RANGE     ${count}
         ${value_offeringCode}     Get Value From Json    ${response.json()}    $.data[0].customAttributes.offeringCode
         Should Be Equal As Strings     ${value_offeringCode}[0]    O23029002
         ${result}    Catenate
         ...    ${\n}---> loop index: "0"
         ...    ${\n}---> json_path_offeringCode: "$.data[0].customAttributes.offeringCode"
         ...    ${\n}---> condition: Value of key "offeringCode" == "O23029002"
         ...    ${\n}---> "offeringCode" == "${value_offeringCode}[0]"
         Log    ${result}
    END

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_8)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - find by offeringCodes not match
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length == 0
    ...    ==>
    [Tags]   19.1.8    Conditions    
    Set API Header Default
    Set Body API        schema_body=${19_1_8_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(0)
    Verify Response Should Be Equal Expected      path_expected=${19_1_8_response_get_promotions_by_promotion_codes}

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_9)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT ica.CUSTOM_ATTRIBUTES_ELT , i.PACKAGE_ID 
    ...    FROM SIT_CPC.ITEM i 
    ...    join SIT_CPC.ITEM_CUSTOM_ATTRIBUTES ica on ica.CUSTOM_ATTRIBUTES = i.ID and ica.CUSTOM_ATTRIBUTES_IDX like '%EndDt%'
    ...    where i.PACKAGE_ID  is not null
    ...    order by ica.CUSTOM_ATTRIBUTES_ELT desc
    ...    ==>
    ...    *** Condition ***
    ...     - find by packageIds
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length == 1
    ...    - 2. data[0].customAttributes.packageId == "3G376"
    ...    ==>
    [Tags]   19.1.9    Conditions    
    Set API Header Default
    Set Body API        schema_body=${19_1_9_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(1)
    FOR  ${index}  IN RANGE     ${count}
         ${value_packageId}     Get Value From Json    ${response.json()}    $.data[0].customAttributes.packageId
         Should Be Equal As Strings     ${value_packageId}[0]    3G376
         ${result}    Catenate
         ...    ${\n}---> loop index: "0"
         ...    ${\n}---> json_path_packageId: "$.data[0].customAttributes.packageId"
         ...    ${\n}---> condition: Value of key "packageId" == "3G376"
         ...    ${\n}---> "packageId" == "${value_packageId}[0]"
         Log    ${result}
    END

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_1_10)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - find by packageIds not match
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length == 0
    ...    ==>
    [Tags]   19.1.10    Conditions     
    Set API Header Default
    Set Body API        schema_body=${19_1_10_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(0)
    Verify Response Should Be Equal Expected      path_expected=${19_1_10_response_get_promotions_by_promotion_codes}

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT ica.CUSTOM_ATTRIBUTES_ELT , i.PROMOTION_CODE ,i.OFFERING_ID 
    ...    FROM SIT_CPC.ITEM i 
    ...    join SIT_CPC.ITEM_CUSTOM_ATTRIBUTES ica on ica.CUSTOM_ATTRIBUTES = i.ID and ica.CUSTOM_ATTRIBUTES_IDX like '%EndDt%'
    ...    where i.PROMOTION_CODE  is not null and i.OFFERING_ID  is not null
    ...    order by ica.CUSTOM_ATTRIBUTES_ELT desc
    ...    ==>
    ...    *** Condition ***
    ...     - find by promotionCodes and offeringIds (pack เดียวกัน)
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length == 1
    ...    - 2. data[0].customAttributes.promotionCode == "P210808132"
    ...    - 3. data[0].customAttributes.offeringId == "510040"
    ...    ==>
    [Tags]   19.2.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${19_2_1_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(1)
    FOR  ${index}  IN RANGE     ${count}
         ${value_promotionCode}      Get Value From Json    ${response.json()}    $.data[0].customAttributes.promotionCode
         ${value_offeringId}         Get Value From Json    ${response.json()}    $.data[0].customAttributes.offeringId
         Should Be Equal As Strings     ${value_promotionCode}[0]    P210808132
         Should Be Equal As Strings     ${value_offeringId}[0]       510040
         ${result}    Catenate
         ...    ${\n}---> loop index: "0"
         ...    ${\n}---> json_path_promotionCode: "$.data[0].customAttributes.promotionCode"
         ...    ${\n}---> json_path_offeringId: "$.data[0].customAttributes.offeringId"
         ...    ${\n}---> condition: Value of key "promotionCode" == "P210808132"
         ...    ${\n}---> condition: Value of key "offeringId" == "510040"
         ...    ${\n}---> "promotionCode" == "${value_promotionCode}[0]"
         ...    ${\n}---> "offeringId" == "${value_offeringId}[0]"
         Log    ${result}
    END

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - find by promotionCodes and offeringIds (ไม่ใช่ pack เดียวกัน)
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length == 2
    ...    - 2. ถ้า customAttributes.promotionCode == "P210808132" แล้ว customAttributes.offeringId != "590139"
    ...    ==>
    [Tags]   19.2.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${19_2_2_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(2)
    FOR  ${index}  IN RANGE     ${count}
         ${value_promotionCode}      Get Value From Json    ${response.json()}    $.data[${index}].customAttributes.promotionCode
         ${value_offeringId}         Get Value From Json    ${response.json()}    $.data[${index}].customAttributes.offeringId
         Log    ${value_promotionCode[0]} : ${value_offeringId[0]}    console=yes
         IF  '${value_promotionCode[0]}' == 'P210808132'
             Should Not Be Equal     ${value_offeringId[0]}    590139
         ELSE IF  '${value_promotionCode[0]}' == 'P210808131'
             Should Not Be Equal     ${value_offeringId[0]}    510040 
         END
         ${result}    Catenate
         ...    ${\n}---> loop index: "${index}"
         ...    ${\n}---> json_path_promotionCode: "$.data[${index}].customAttributes.promotionCode"
         ...    ${\n}---> json_path_offeringId: "$.data[${index}].customAttributes.offeringId"
         ...    ${\n}---> condition: Value of key "promotionCode" == "P210808132" and "offeringId" != "590139"
         ...    ${\n}---> condition: Value of key "promotionCode" == "P210808131" and "offeringId" != "510040"
         ...    ${\n}---> "promotionCode" == "${value_promotionCode}[0]"
         ...    ${\n}---> "offeringId" == "${value_offeringId}[0]"
         Log    ${result}
    END

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_2_3)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT ica.CUSTOM_ATTRIBUTES_ELT , i.PROMOTION_CODE ,i.OFFERING_CODE 
    ...    FROM SIT_CPC.ITEM i 
    ...    join SIT_CPC.ITEM_CUSTOM_ATTRIBUTES ica on ica.CUSTOM_ATTRIBUTES = i.ID and ica.CUSTOM_ATTRIBUTES_IDX like '%EndDt%'
    ...    where i.PROMOTION_CODE  is not null and i.OFFERING_CODE  is not null
    ...    order by ica.CUSTOM_ATTRIBUTES_ELT desc
    ...    ==>
    ...    *** Condition ***
    ...     - find by promotionCodes and offeringCode(pack เดียวกัน)
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length == 1
    ...    - 2. data[0].customAttributes.promotionCode == "P240122520"
    ...    - 3. data[0].customAttributes.offeringCode == "O2401P240122520"
    ...    ==>
    [Tags]   19.2.3    Conditions    
    Set API Header Default
    Set Body API        schema_body=${19_2_3_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(1)
    FOR  ${index}  IN RANGE     ${count}
         ${value_promotionCode}        Get Value From Json    ${response.json()}    $.data[0].customAttributes.promotionCode
         ${value_offeringCode}         Get Value From Json    ${response.json()}    $.data[0].customAttributes.offeringCode
         Should Be Equal As Strings     ${value_promotionCode}[0]      P240122520
         Should Be Equal As Strings     ${value_offeringCode}[0]       O2401P240122520
         ${result}    Catenate
         ...    ${\n}---> loop index: "0"
         ...    ${\n}---> json_path_promotionCode: "$.data[0].customAttributes.promotionCode"
         ...    ${\n}---> json_path_offeringCode: "$.data[0].customAttributes.offeringCode"
         ...    ${\n}---> condition: Value of key "promotionCode" == "P240122520"
         ...    ${\n}---> condition: Value of key "offeringCode" == "O2401P240122520"
         ...    ${\n}---> "promotionCode" == "${value_promotionCode}[0]"
         ...    ${\n}---> "offeringCode" == "${value_offeringCode}[0]"
         Log    ${result}
    END

CPC_API_1_1_019 Get Promotions by Promotion Codes (Conditions_Test_Case_2_4)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - find by promotionCodes and offeringCodes (ไม่ใช่ pack เดียวกัน
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length == 2
    ...    - 2. ถ้า customAttributes.promotionCode == "P12021009" แล้ว customAttributes.offeringCode != "O2401P240122601"
    ...    ==>
    [Tags]   19.2.4    Conditions    
    Set API Header Default
    Set Body API        schema_body=${19_2_4_body_get_promotions_by_promotion_codes}
    Send Request API    url=${url_get_promotions_by_promotion_codes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(2)
    FOR  ${index}  IN RANGE     ${count}
         ${value_promotionCode}      Get Value From Json    ${response.json()}    $.data[${index}].customAttributes.promotionCode
         ${value_offeringCode}         Get Value From Json    ${response.json()}    $.data[${index}].customAttributes.offeringCode
         Log    ${value_promotionCode[0]} : ${value_offeringCode[0]}    console=yes
         IF  '${value_promotionCode[0]}' == 'P12021009'
             Should Not Be Equal     ${value_offeringCode[0]}    O2401P240122601
         ELSE IF  '${value_promotionCode[0]}' == 'P240122601'
             Should Not Be Equal     ${value_offeringCode[0]}    O1202P12021009 
         END
         ${result}    Catenate
         ...    ${\n}---> loop index: "${index}"
         ...    ${\n}---> json_path_promotionCode: "$.data[${index}].customAttributes.promotionCode"
         ...    ${\n}---> json_path_offeringCode: "$.data[${index}].customAttributes.offeringCode"
         ...    ${\n}---> condition: Value of key "promotionCode" == "P12021009" and "offeringCode" != "O2401P240122601"
         ...    ${\n}---> condition: Value of key "promotionCode" == "P240122601" and "offeringCode" != "O1202P12021009"
         ...    ${\n}---> "promotionCode" == "${value_promotionCode}[0]"
         ...    ${\n}---> "offeringCode" == "${value_offeringCode}[0]"
         Log    ${result}
    END

CPC_API_1_1_020 Get Zones Of Package
    [Documentation]    Owner : Kachain.a
    [Tags]   20    
    Set API Header Default
    Set Body API        schema_body=${20_body_get_zones_of_package}
    Send Request API    url=${url_get_zones_of_package}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${20_response_get_zones_of_package}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_020 Get Zones Of Package (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - IR Zone not config from PLM
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length = 0
    ...    ==>
    [Tags]   20.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${20_1_body_get_zones_of_package}
    Send Request API    url=${url_get_zones_of_package}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${20_1_response_get_zones_of_package}

CPC_API_1_1_020 Get Zones Of Package (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.ITEM_ZONE iz 
    ...    order by iz.LAST_UPDATED desc
    ...    ==>
    ...    *** Condition ***
    ...    - IR Zone config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length > 0
    ...    ==>
    [Tags]   20.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${20_2_body_get_zones_of_package}
    Send Request API    url=${url_get_zones_of_package}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True      int(${count}) > int(0)
    Log    ---> Object.keys(data).length(${count}) > 0 

CPC_API_1_1_021 Update table Price Master
    [Documentation]    Owner : Worrapong   Edit: Kachain.a
    [Tags]   21    
    Set API Header Default
    Set Body API        schema_body=${21_body_update_table_price_master}
    Send Request API    url=${url_price_master}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${21_response_update_table_price_master}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_022 Sync Trades Daily for My Channel
    [Documentation]    Owner : Kachain.a
    [Tags]   22     
    Set API Header Default
    Set Body API        schema_body=${22_body_sync_trades_daily_for_my_channel}
    Send Request API    url=${url_sync_trades_daily}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${22_response_sync_trades_daily_for_my_channel}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_022 Sync Trades Daily for My Channel (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - date To Validate
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. statusCode = "2000"
    ...    - 2. timeToSyncTrade = "20240320154234"
    ...    ==>
    [Tags]   22.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${22_1_body_sync_trades_daily_for_my_channel}
    Send Request API    url=${url_sync_trades_daily}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${22_1_response_sync_trades_daily_for_my_channel}

CPC_API_1_1_022 Sync Trades Daily for My Channel (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - date To Validate
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - statusCode = "99999"
    ...    ==>
    [Tags]   22.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${22_2_body_sync_trades_daily_for_my_channel}
    Send Request API    url=${url_sync_trades_daily}
    ...                 expected_status=400
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${22_2_response_sync_trades_daily_for_my_channel}

CPC_API_1_1_023 Get All VAS Items by Shelf
    [Documentation]    Owner : Worrapong    Edit : Kachain.a
    [Tags]   23        
    Set API Header Default
    Set Body API        schema_body=${23_body_get_all_vas_items_by_shelf}
    Send Request API    url=${url_get_all_vas_items_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${23_response_get_all_vas_items_by_shelf}
    Verify Value Response By Key        $..statusCode    2000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_023 Get All VAS Items by Shelf (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - Vas package config active
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. data.length > 0
    ...    - 2. data.any(i=> i.prototype == "Vas_Package") prototype ของทุก package ต้องเป็น Vas_Package
    ...    ==>
    [Tags]   23.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${23_1_body_get_all_vas_items_by_shelf}
    Send Request API    url=${url_get_all_vas_items_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE     ${count}
         ${value_prototype}     Get Value From Json    ${response.json()}    $.data[${index}].prototype
         Should Be Equal As Strings     ${value_prototype}[0]    Vas_Package
         ${result}    Catenate
         ...    ${\n}---> loop index: "${index}"
         ...    ${\n}---> json_path_isNewRegistration: "$.data[${index}].prototype"
         ...    ${\n}---> condition: Value of key "prototype" == "Vas_Package"
         ...    ${\n}---> "prototype" == "${value_prototype}[0]"
         Log    ${result}
    END

CPC_API_1_1_023 Get All VAS Items by Shelf (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset-max
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length == 15
    ...    ==>
    [Tags]   23.2.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${23_2_1_body_get_all_vas_items_by_shelf}
    Send Request API    url=${url_get_all_vas_items_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}       Get List Key And Count From Json        $.data
    ${body_max}    Get Value From Json     ${API_BODY}     $.max
    Should Be True    int(${count}) == int(${body_max}[0])
    ${result}    Catenate
    ...    ${\n}---> body_max: ${body_max}
    ...    ${\n}---> "$data_length(${count})" == "$body_max(${body_max}[0])"
    Log    ${result}

CPC_API_1_1_023 Get All VAS Items by Shelf (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset-max
    ...    ==>
    ...    *** Expect Result ***
    ...     - data.length == max
    ...    ==>
    [Tags]   23.2.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${23_2_2_body_get_all_vas_items_by_shelf}
    Send Request API    url=${url_get_all_vas_items_by_shelf}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}       Get List Key And Count From Json        $.data
    ${body_max}    Get Value From Json     ${API_BODY}     $.max
    Should Be True    int(${count}) == int(${body_max}[0])
    ${result}    Catenate
    ...    ${\n}---> body_max: ${body_max}
    ...    ${\n}---> "$data_length(${count})" == "$body_max(${body_max}[0])"
    Log    ${result}

CPC_API_1_1_024 Get All Accessories by Category
    [Documentation]    Owner : Patipan.w    Edit : Kachain.a
    [Tags]   24        
    Set API Header Default
    Set Body API        schema_body=${24_body_get_all_accessories_by_category}
    Send Request API    url=${url_get_all_accessories_by_category}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${24_response_get_all_accessories_by_category}
    Verify Value Response By Key        $..status            20000
    Verify Value Response By Key        $..statusDesc        Success
    Write Response To Json File

CPC_API_1_1_025 Get All Accessories by Product
    [Documentation]    Owner : Patipan.w   Edit : Kachain.a
    [Tags]   25    
    Set API Header Default
    Set Body API        schema_body=${25_body_get_all_accessories_by_product}
    Send Request API    url=${url_get_all_accessories_by_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${25_response_get_all_accessories_by_product}
    Verify Value Response By Key        $..status            20000
    Verify Value Response By Key        $..statusDesc        Success
    Write Response To Json File

CPC_API_1_1_026 Get Accessory Categories
    [Documentation]    Owner : Patipan.w   Edit : Kachain.a
    [Tags]   26    
    Set API Header Default
    Set Body API        schema_body=${26_body_get_accessory_categories}
    Send Request API    url=${url_get_accessory_categories}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${26_response_get_accessory_categories}
    Verify Value Response By Key        $..status            20000
    Verify Value Response By Key        $..statusDesc        Success
    Write Response To Json File
    
CPC_API_1_1_027 Get Asp Banks
    [Documentation]    Owner : Kachain.a
    [Tags]   27     
    Set API Header Default
    Set Body API        schema_body=${27_body_get_asp_banks}
    Send Request API    url=${url_get_asp_banks}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${27_response_get_asp_banks}
    Verify Value Response By Key        $..statusCode    20000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_027 Get Asp Banks (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - location not config
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. statusCode = 20000
    ...    - 2. banks.length == 0
    ...    ==>
    [Tags]   27.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${27_1_body_get_asp_banks}
    Send Request API    url=${url_get_asp_banks}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.banks
    Should Be True    int(${count}) == int(0)
    Verify Response Should Be Equal Expected      path_expected=${27_1_response_get_asp_banks}

CPC_API_1_1_027 Get Asp Banks (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - location not config
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. statusCode = 20000
    ...    - 2. banks.length == 10
    ...    - 3. ต้องมี bank abb ดังต่อไปนี้
    ...       - CITI, SCB, KBNK, NBNK, BAY, FCC, KTC, UOB, BBL, KTB
    ...    ==>
    [Tags]   27.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${27_2_body_get_asp_banks}
    Send Request API    url=${url_get_asp_banks}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.banks
    Should Be True    int(${count}) == int(10)
    Verify Response Should Be Equal Expected      path_expected=${27_2_response_get_asp_banks}

CPC_API_1_1_028 Get Banks Promotion
    [Documentation]    Owner : Kachain.a
    [Tags]   28     
    Set API Header Default
    Set Body API        schema_body=${28_body_get_banks_promotion}
    Send Request API    url=${url_get_banks_promotion}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success          ${28_response_get_banks_promotion}
    Verify Value Response By Key        $..statusCode    20000
    Verify Value Response By Key        $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_028 Get Banks Promotion (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT
    ...    PPAY.BANK_ABBR,
    ...    PPAY.BANK_NAME_THAI AS NAME,
    ...    CI.URL AS IMAGE,
    ...    COALESCE(CI.PRIORITY, 999) AS PRIORITY
    ...    FROM SIT_CPC.CREDIT_CARD_MASTER AS PPAY
    ...    INNER JOIN SIT_CPC.CUSTOM_IMAGE AS CI ON UPPER(CI.CODE) = UPPER(PPAY.BANK_ABBR)
    ...    ORDER BY PRIORITY ASC
    ...    ==>
    ...    *** Condition ***
    ...    - ทุก location จะได้ result เหมือนกันขึ้นอยู่กับ config ใน cpc-admin
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.ต้องมี abb 24 ตัวดังนี้ [CITI, CITIREADY, SCB, KBNK, ACS
    ...    BAY, AEON, BBL, BOC, CIMB, COK, CT, FCC, GSB, HKSH, KTB, 
    ...    SCBSPEEDY, SCN, TCS, UOB, UOBCASHP,CICC,CTPL, TTB]
    ...    ==>
    [Tags]   28.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${28_1_body_get_banks_promotion}
    Send Request API    url=${url_get_banks_promotion}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${28_1_response_get_banks_promotion}

CPC_API_1_1_028 Get Banks Promotion (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT
    ...    PPAY.BANK_ABBR,
    ...    PPAY.BANK_NAME_THAI AS NAME,
    ...    CI.URL AS IMAGE,
    ...    COALESCE(CI.PRIORITY, 999) AS PRIORITY
    ...    FROM SIT_CPC.CREDIT_CARD_MASTER AS PPAY
    ...    INNER JOIN SIT_CPC.CUSTOM_IMAGE AS CI ON UPPER(CI.CODE) = UPPER(PPAY.BANK_ABBR)
    ...    ORDER BY PRIORITY ASC
    ...    ==>
    ...    *** Condition ***
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.ต้องมี abb 24 ตัวดังนี้ [CITI, CITIREADY, SCB, KBNK, ACS
    ...    BAY, AEON, BBL, BOC, CIMB, COK, CT, FCC, GSB, HKSH, KTB, 
    ...    SCBSPEEDY, SCN, TCS, UOB, UOBCASHP,CICC,CTPL TTB]
    ...    ==>
    [Tags]   28.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${28_2_body_get_banks_promotion}
    Send Request API    url=${url_get_banks_promotion}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${28_2_response_get_banks_promotion}

CPC_API_1_1_029 Get Installments For Partner
    [Documentation]    Owner : Patipan.w   Edit : Kachain.a
    [Tags]   29    
    Set API Header Default
    Set Body API        schema_body=${29_body_get_installments_for_partner}
    Send Request API    url=${url_get_installments_for_partner}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${29_response_get_installments_for_partner}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

# CPC_API_1_1_029 Get Promotions by Promotion Codes (Conditions_Test_Case_1_1)
#     [Documentation]    Owner : Kachain.a
#     ...    *** CMD SQL ***
#     ...    SELECT * FROM SIT_CPC.INST_PARTNER ip
#     ...    WHERE ip.BRAND is not null and ip.MODEL is not null and ip.COLOR is not null 
#     ...    ==>
#     ...    *** Condition ***
#     ...     - config by brand,model,color
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - ** Cancel เนื่องจากน่าจะเป็นเงื่อนไข config แบบเก่า ปัจจุบันไม่มีแล้ว 7/5/2567 **
#     ...    ==>
#     [Tags]   29.1.1    Conditions        Cancel

# CPC_API_1_1_029 Get Promotions by Promotion Codes (Conditions_Test_Case_1_2)
#     [Documentation]    Owner : Kachain.a
#     ...    *** CMD SQL ***
#     ...    SELECT * FROM SIT_CPC.INST_PARTNER ip  
#     ...    WHERE ip.BRAND is not null and ip.MODEL is not null and ip.COLOR is not null
#     ...    ==>
#     ...    *** Condition ***
#     ...     - config by brand,model,color
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - ** Cancel เนื่องจากน่าจะเป็นเงื่อนไข config แบบเก่า ปัจจุบันไม่มีแล้ว 7/5/2567 **
#     ...    ==>
#     [Tags]   29.1.2    Conditions        Cancel

# CPC_API_1_1_029 Get Promotions by Promotion Codes (Conditions_Test_Case_2_1)
#     [Documentation]    Owner : Kachain.a
#     ...    *** CMD SQL ***
#     ...    SELECT * FROM SIT_CPC.INST_PARTNER ip
#     ...    WHERE ip.BRAND is not null and ip.MODEL != 'ALL'
#     ...    ==>
#     ...    *** Condition ***
#     ...     - config by brand,model
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - ** Cancel เนื่องจากน่าจะเป็นเงื่อนไข config แบบเก่า ปัจจุบันไม่มีแล้ว 7/5/2567 **
#     ...    ==>
#     [Tags]   29.2.1    Conditions        Cancel

# CPC_API_1_1_029 Get Promotions by Promotion Codes (Conditions_Test_Case_2_2)
#     [Documentation]    Owner : Kachain.a
#     ...    *** CMD SQL ***
#     ...    SELECT * FROM SIT_CPC.INST_PARTNER ip 
#     ...    WHERE ip.BRAND is not null and ip.MODEL != 'ALL'
#     ...    ==>
#     ...    *** Condition ***
#     ...     - config by brand,model
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - ** Cancel เนื่องจากน่าจะเป็นเงื่อนไข config แบบเก่า ปัจจุบันไม่มีแล้ว 7/5/2567 **
#     ...    ==>
#     [Tags]   29.2.2    Conditions        Cancel

CPC_API_1_1_029 Get Installments For Partner (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.INST_PARTNER ip  
    ...    WHERE ip.BRAND != 'ALL'
    ...    ==>
    ...    *** Condition ***
    ...     - config by brand
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.ต้องมี bankGroupName 2 ตัวนี้ SCB, KBANK
    ...    - 2.bank ของ bankGroupName แต่ละตัวต้องมี length อย่างน้อย 1 แบ่งตาม installmentTerm
    ...    ==>
    [Tags]   29.3.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${29_3_1_body_get_installments_for_partner}
    Send Request API    url=${url_get_installments_for_partner}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    FOR  ${index}  IN RANGE    ${count_data}
             ${value_bankGroupName}     Get Value From Json    ${response.json()}    $.data[${index}].bankGroupName
             IF   '${index}' == '0'
                Should Be Equal As Strings     ${value_bankGroupName}[0]    SCB
                Log    ${value_bankGroupName}[0]
             ELSE IF  '${index}' == '1'
                Should Be Equal As Strings     ${value_bankGroupName}[0]    KBANK
                Log    ${value_bankGroupName}[0]
             END
             ${count_bank}    Get List Key And Count From Json    $.data[${index}].bank
             Should Be True    int(${count_bank}) >= int(1)
             ${list_installmentTerm}    Create List
             FOR  ${index_bank}  IN RANGE    ${count_bank}
                ${value_installmentTerm}     Get Value From Json    ${response.json()}    $.data[${index}].bank[${index_bank}].installmentTerm
                Log    ${value_installmentTerm}[0]
                List Should Not Contain Value    ${list_installmentTerm}    ${value_installmentTerm}[0]
                Append To List   ${list_installmentTerm}   ${value_installmentTerm}[0]
                Log    ${list_installmentTerm}
                ${result}    Catenate
                ...    ${\n}---> loop index data: "${index}"
                ...    ${\n}---> loop index bank: "${index_bank}"
                ...    ${\n}---> json_path_installmentTerm: "$.data[${index}].bank[${index_bank}].installmentTerm"
                ...    ${\n}---> condition: Value of key "installmentTerm" list not contain.
                ...    ${\n}---> "data[*].bank[*].installmentTerm" list not contain in "${list_installmentTerm}"
                Log    ${result}
             END
    END

CPC_API_1_1_029 Get Installments For Partner (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - config by brand
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.ต้องมี bankGroupName 2 ตัวนี้ SCB, KBANK
    ...    - 2.bank ของ bankGroupName แต่ละตัวต้องมี length อย่างน้อย 1 แบ่งตาม installmentTerm
    ...    ==>
    [Tags]   29.3.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${29_3_2_body_get_installments_for_partner}
    Send Request API    url=${url_get_installments_for_partner}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    FOR  ${index}  IN RANGE    ${count_data}
             ${value_bankGroupName}     Get Value From Json    ${response.json()}    $.data[${index}].bankGroupName
             IF   '${index}' == '0'
                Should Be Equal As Strings     ${value_bankGroupName}[0]    SCB
                Log    ${value_bankGroupName}[0]
             ELSE IF  '${index}' == '1'
                Should Be Equal As Strings     ${value_bankGroupName}[0]    KBANK
                Log    ${value_bankGroupName}[0]
             END
             ${count_bank}    Get List Key And Count From Json    $.data[${index}].bank
             Should Be True    int(${count_bank}) >= int(1)
             ${list_installmentTerm}    Create List
             FOR  ${index_bank}  IN RANGE    ${count_bank}
                ${value_installmentTerm}     Get Value From Json    ${response.json()}    $.data[${index}].bank[${index_bank}].installmentTerm
                Log    ${value_installmentTerm}[0]
                List Should Not Contain Value    ${list_installmentTerm}    ${value_installmentTerm}[0]
                Append To List   ${list_installmentTerm}   ${value_installmentTerm}[0]
                Log    ${list_installmentTerm}
                ${result}    Catenate
                ...    ${\n}---> loop index data: "${index}"
                ...    ${\n}---> loop index bank: "${index_bank}"
                ...    ${\n}---> json_path_installmentTerm: "$.data[${index}].bank[${index_bank}].installmentTerm"
                ...    ${\n}---> condition: Value of key "installmentTerm" list not contain.
                ...    ${\n}---> "data[*].bank[*].installmentTerm" list not contain in "${list_installmentTerm}"
                Log    ${result}
             END
    END

CPC_API_1_1_029 Get Installments For Partner (Conditions_Test_Case_4_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - config by ALL
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.ต้องมี bankGroupName ดังนี้
    ...      AEON, BAY, BBL, CITI BANK, KBANK, KBJ, KFCC, KTC, SCB, THIS SHOP, UOB, UMAY, SG Capital
    ...    - 2.bank ของ bankGroupName แต่ละตัวต้องมี length อย่างน้อย 1 แบ่งตาม installmentTerm
    ...    ==>
    [Tags]   29.4.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${29_4_1_body_get_installments_for_partner}
    Send Request API    url=${url_get_installments_for_partner}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    ${expect_bankGroupName}    Create List    AEON  BAY  BBL  CITI BANK  KBANK  KBJ  KFCC  KTC  SCB  THIS SHOP  UOB  UMAY  SG Capital
    ${actual_bankGroupName}    Create List
    FOR  ${index}  IN RANGE    ${count_data}
        ${value_bankGroupName}     Get Value From Json    ${response.json()}    $.data[${index}].bankGroupName
        Append To List   ${actual_bankGroupName}   ${value_bankGroupName}[0]
        Log    ${value_bankGroupName}[0]
        ${count_bank}    Get List Key And Count From Json    $.data[${index}].bank
        ${list_installmentTerm}    Create List
        FOR  ${index_bank}  IN RANGE    ${count_bank}
            ${value_installmentTerm}     Get Value From Json    ${response.json()}    $.data[${index}].bank[${index_bank}].installmentTerm
            Log    ${value_installmentTerm}[0]
            List Should Not Contain Value    ${list_installmentTerm}    ${value_installmentTerm}
            Append To List   ${list_installmentTerm}   ${value_installmentTerm}[0]
            Log    ${list_installmentTerm}
            ${result}    Catenate
            ...    ${\n}---> loop index data: "${index}"
            ...    ${\n}---> loop index bank: "${index_bank}"
            ...    ${\n}---> json_path_installmentTerm: "$.data[${index}].bank[${index_bank}].installmentTerm"
            ...    ${\n}---> condition: Value of key "installmentTerm" list not contain.
            ...    ${\n}---> "data[*].bank[*].installmentTerm" list not contain in "${list_installmentTerm}"
            Log    ${result}
        END
    END
    Lists Should Be Equal    ${expect_bankGroupName}    ${actual_bankGroupName}    ignore_order=True

CPC_API_1_1_029 Get Installments For Partner (Conditions_Test_Case_4_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - config by ALL
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.ต้องมี bankGroupName ดังนี้
    ...      AEON, BAY, BBL, CITI BANK, KBANK, KBJ, KFCC, KTC, SCB, THIS SHOP, UOB, UMAY, SG Capital
    ...    - 2.bank ของ bankGroupName แต่ละตัวต้องมี length อย่างน้อย 1 แบ่งตาม installmentTerm
    ...    ==>
    [Tags]   29.4.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${29_4_2_body_get_installments_for_partner}
    Send Request API    url=${url_get_installments_for_partner}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    ${expect_bankGroupName}    Create List    AEON  BAY  BBL  CITI BANK  KBANK  KBJ  KFCC  KTC  SCB  THIS SHOP  UOB  UMAY  SG Capital
    ${actual_bankGroupName}    Create List
    FOR  ${index}  IN RANGE    ${count_data}
        ${value_bankGroupName}     Get Value From Json    ${response.json()}    $.data[${index}].bankGroupName
        Append To List   ${actual_bankGroupName}   ${value_bankGroupName}[0]
        Log    ${value_bankGroupName}[0]
        ${count_bank}    Get List Key And Count From Json    $.data[${index}].bank
        ${list_installmentTerm}    Create List
        FOR  ${index_bank}  IN RANGE    ${count_bank}
            ${value_installmentTerm}     Get Value From Json    ${response.json()}    $.data[${index}].bank[${index_bank}].installmentTerm
            Log    ${value_installmentTerm}[0]
            List Should Not Contain Value    ${list_installmentTerm}    ${value_installmentTerm}
            Append To List   ${list_installmentTerm}   ${value_installmentTerm}[0]
            Log    ${list_installmentTerm}
            ${result}    Catenate
            ...    ${\n}---> loop index data: "${index}"
            ...    ${\n}---> loop index bank: "${index_bank}"
            ...    ${\n}---> json_path_installmentTerm: "$.data[${index}].bank[${index_bank}].installmentTerm"
            ...    ${\n}---> condition: Value of key "installmentTerm" list not contain.
            ...    ${\n}---> "data[*].bank[*].installmentTerm" list not contain in "${list_installmentTerm}"
            Log    ${result}
        END
    END
    Lists Should Be Equal    ${expect_bankGroupName}    ${actual_bankGroupName}    ignore_order=True

CPC_API_1_1_029 Get Installments For Partner (Conditions_Test_Case_5)
    [Documentation]    Owner : Sasina.i
    ...    ==>
    ...    *** Condition ***
    ...     Add properties ​
    ...     - prefix​
    ...    ==>
    ...    *** Expect Result ***
    ...    แต่ละ bank ของ bankGroupName ต้องมี feild prefix 
    ...    ==>
    [Tags]   29.5    Conditions    
    Set API Header Default
    Set Body API        schema_body=${29_5_body_get_installments_for_partner}
    Send Request API    url=${url_get_installments_for_partner}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    ${has_prefix}    Set Variable    False
    FOR  ${index}  IN RANGE    ${count_data}
        ${bank}    Get Value From Json    ${response.json()}    $.data[${index}].bank
        ${prefix}    Get Value From Json    ${bank}    $.bank[${index}].prefix
        Log    '${prefix}'
        IF    '${prefix}' != ''
            ${has_prefix}    Set Variable    True
        END
        
    END
    Should Be True    ${has_prefix} 

CPC_API_1_1_030 Get Brands Of Product
    [Documentation]    Owner : Patipan.w   Edit : Kachain.a
    [Tags]   30    
    Set API Header Default
    Set Body API        schema_body=${30_body_get_brands_of_product}
    Send Request API    url=${url_get_brands_of_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${30_response_get_brands_of_product}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_030 Get Brands Of Product (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT
    ...        BB.BRAND AS name
    ...        , (SELECT URL FROM SIT_CPC.CUSTOM_IMAGE I WHERE I.CODE = BB.BRAND  COLLATE SQL_Latin1_General_CP1_CS_AS ) AS imageUrl
    ...        ,  ISNULL((SELECT PRIORITY FROM SIT_CPC.CUSTOM_IMAGE I WHERE I.CODE = BB.BRAND  COLLATE SQL_Latin1_General_CP1_CS_AS), 9999) AS priority
    ...    FROM (
    ...        SELECT AA.BRAND, SUM(AA.STATUS) AS SUB_MODEL_ACTIVE FROM (
    ...            SELECT P.BRAND, P.MODEL, ISNULL(M.STATUS, 0) AS STATUS 
    ...            FROM SIT_CPC.PRODUCT_MST P
    ...            JOIN SIT_CPC.SUB_MODEL SB ON SB.MODEL = P.MODEL AND SB.BRAND = P.BRAND
    ...            JOIN SIT_CPC.MODEL_SUB_MODEL MSM ON MSM.SUB_MODEL_ID =  SB.ID
    ...            JOIN SIT_CPC.MODEL M ON M.ID = MSM.MODEL_SUB_MODELS_ID
    ...            WHERE P.PRODUCT_TYPE IN ('ACCESSORY')
    ...    --		AND P.PRODUCT_SUBTYPE IN (select value from string_split(@productSubtype,','))
    ...        ) AA
    ...        GROUP BY AA.BRAND
    ...        HAVING SUM(AA.STATUS) > 0
    ...    ) BB
    ...    ORDER BY PRIORITY, BB.BRAND;
    ...    ==>
    ...    *** Condition ***
    ...    - ** config ที่ cpc-admin เมนู Model
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. brands.length = 3
    ...    - 2. มี brand ดังนี้ APPLE, SAMSUNG, LAVA
    ...    ==>
    [Tags]   30.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${30_1_body_get_brands_of_product}
    Send Request API    url=${url_get_brands_of_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.brands
    Should Be True    int(${count}) == int(3)
    Verify Response Should Be Equal Expected      path_expected=${30_1_response_get_brands_of_product}

CPC_API_1_1_030 Get Brands Of Product (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    *** Condition ***
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    1. brands.length = 0
    ...    ==>
    [Tags]   30.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${30_2_body_get_brands_of_product}
    Send Request API    url=${url_get_brands_of_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.brands
    Should Be True    int(${count}) == int(0)
    Verify Response Should Be Equal Expected      path_expected=${30_2_response_get_brands_of_product}

CPC_API_1_1_031 Get Campaign By Trade Model
    [Documentation]    Owner : Patipan.w   Edit : Kachain.a
    [Tags]   31
    Set API Header Default
    Set Body API        schema_body=${31_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${31_response_get_campaign_by_trade_model}
    Verify Value Response By Key    $..status        20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_1_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - validate parameter required (parameter ไม่ครบ)
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   31.1.1    Conditions  
    Set API Header Default
    Set Body API        schema_body=${31_1_1_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${31_1_1_response_get_campaign_by_trade_model}

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_1_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - validate parameter matCode 
    ...     - parameter ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."status": "20000"
    ...     - 2.products มี length > 0
    ...    ==>
    [Tags]   31.1.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${31_1_2_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key       $..status        20000
    ${count}    Get List Key And Count From Json        $.products
    Should Be True      int(${count}) > int(0)
    Log    ---> Object.keys(products).length(${count}) > 0 

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_1_3)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - validate parameter matCode 
    ...     - parameter ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."status": "20000"
    ...     - 2.products มี length > 0
    ...    ==>
    [Tags]   31.1.3    Conditions
    Set API Header Default
    Set Body API        schema_body=${31_1_3_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key       $..status        20000
    ${count}    Get List Key And Count From Json        $.products
    Should Be True      int(${count}) > int(0)
    Log    ---> Object.keys(products).length(${count}) > 0 

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_1_4)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - validate parameter brand, model, color 
    ...     - parameter ไม่ครบ
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   31.1.4    Conditions
    Set API Header Default
    Set Body API        schema_body=${31_1_4_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${31_1_4_response_get_campaign_by_trade_model}

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by regularPrice **MOC
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."status": "20000"
    ...     - 2.products มี length = 1 (ที่ sit มี set  ไว้แค่ 4 trade อาจมีเปลี่ยนแปลงได้ ** "endDate": "2024-12-31" )
    ...     - **ข้อ 2 พี่มดบอกไม่ต้องเช็ค พี่ note ไว้เฉยๆ ว่า trade ที่มีข้อมูลจะ endDate 2024-12-31 ครับ
    ...     - 3.ใน products จะต้องมี trades[0].discounts[*].tradeDiscountId = 145677
    ...    ==>
    [Tags]   31.2.1    Conditions
    Set API Header Default
    Set Body API        schema_body=${31_2_1_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key       $..status        20000
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True       int(${count_products}) == int(1)
    FOR    ${index_products}  IN RANGE       ${count_products}
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${count_discounts}   Get List Key And Count From Json    $.products[${index_products}].trades[0].discounts
            FOR    ${index_discounts}  IN RANGE       ${count_discounts}
                ${value_tradeDiscountId}       Get Value From Json      ${response.json()}    $.products[${index_products}].trades[0].discounts[${index_discounts}].tradeDiscountId
                Should Be Equal As Integers    ${value_tradeDiscountId}[0]     ${145677}
                ${result}    Catenate
                ...    ${\n}---> loop products: "${index_products}"
                ...    ${\n}---> loop discounts: "${index_discounts}"
                ...    ${\n}---> json_path_tradeDiscountId: "$.products[${index_products}].trades[0].discounts[${index_discounts}].tradeDiscountId"
                ...    ${\n}---> condition: ใน products จะต้องมี trades[0].discounts[*].tradeDiscountId = 145677
                ...    ${\n}---> "tradeDiscountId" == "${value_tradeDiscountId}[0]"
                Log    ${result}
            END
    END

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by regularPrice **MOC
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   31.2.2    Conditions 
    Set API Header Default
    Set Body API        schema_body=${31_2_2_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${31_2_2_response_get_campaign_by_trade_model}

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_2_3)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by regularPrice ** Non MOC
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   31.2.3    Conditions 
    Set API Header Default
    Set Body API        schema_body=${31_2_3_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}        Get List Key And Count From Json    $.products
    ${list_tradeNo}    Create List    TP22054718  TP22054719  TP22054721  TP22054722  TP22054724  TP22054726  TP22064743
    FOR  ${index}  IN RANGE    ${count_products}
        ${count_trades}    Get List Key And Count From Json    $.products[${index}].trades
        FOR  ${index_trades}  IN RANGE    ${count_trades}
            ${value_tradeNo}     Get Value From Json    ${response.json()}    $.products[${index}].trades[${index_trades}].tradeNo
            List Should Not Contain Value    ${list_tradeNo}    ${value_tradeNo}[0]
            ${result}    Catenate
            ...    ${\n}---> loop index products: "${index}"
            ...    ${\n}---> loop index trades: "${index_trades}"
            ...    ${\n}---> json_path_installmentTerm: "$.products[${index}].trades[${index_trades}].tradeNo"
            ...    ${\n}---> condition: Value of key "tradeNo" : ${value_tradeNo}[0]
            ...    ${\n}---> "products[${index}].trades[${index_trades}].tradeNo" list not contain in "${list_tradeNo}"
            Log    ${result}
        END
    END

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by orderTypes 
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   31.3.1    Conditions 
    Set API Header Default
    Set Body API        schema_body=${31_3_1_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${31_3_1_response_get_campaign_by_trade_model}

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by orderTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...     - ใน products ทุกตัวจะต้องพบ "Convert Pre to Post" อยู่ใน criterias (trades[0].criterias[index].criteria) 
    ...    ==>
    [Tags]   31.3.2    Conditions
    Set API Header Default
    Set Body API        schema_body=${31_3_2_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE       1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_criteria}           Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].criteria
            List Should Contain Value    ${value_criteria}[0]    Convert Pre to Post
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_criteria: "$.products[${index_products - 1}].trades[0].criterias[*].criteria"
            ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ "Convert Pre to Post" อยู่ใน criterias (trades[0].criterias[*].criteria)"
            ...    ${\n}---> "criteria" == "${value_criteria}[0]"
            Log    ${result}
    END

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_4_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by chargeTypes 
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   31.4.1    Conditions
    Set API Header Default
    Set Body API        schema_body=${31_4_1_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${31_4_1_response_get_campaign_by_trade_model}

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_4_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by orderTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...     - ใน products ทุกตัวจะต้องพบ 
    ...     - 1."Existing" อยู่ใน criterias (trades[0].criterias[index].criteria) 
    ...     - 2."Pre-paid" อยู่ใน criterias (trades[0].criterias[index].chargeType)  
    ...    ==>
    [Tags]   31.4.2    Conditions
    Set API Header Default
    Set Body API        schema_body=${31_4_2_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE       1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_criteria}             Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].criteria
            ${value_chargeType}           Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].chargeType
            List Should Contain Value    ${value_criteria}[0]       Existing
            List Should Contain Value    ${value_chargeType}[0]     Pre-paid
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_criteria: "$.products[${index_products - 1}].trades[0].criterias[*].criteria"
            ...    ${\n}---> json_path_chargeType: "$.products[${index_products - 1}].trades[0].criterias[*].chargeType"
            ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ "Existing" อยู่ใน criterias (trades[0].criterias[*].criteria)"
            ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ "Pre-paid" อยู่ใน criterias (trades[0].criterias[*].chargeType)"
            ...    ${\n}---> "criteria" == "${value_criteria}[0]"
            ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
            Log    ${result}
    END

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_5_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by saleChannels  
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   31.5.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${31_5_1_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${31_5_1_response_get_campaign_by_trade_model}

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_5_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by orderTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...     - ใน products ทุกตัวจะต้องพบ "TELEWIZ" อยู่ใน channels (trades[0].channels[index].saleChannel) 
    ...    ==>
    [Tags]   31.5.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${31_5_2_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE       1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_saleChannel}           Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].channels[*].saleChannel
            List Should Contain Value    ${value_saleChannel}       TELEWIZ
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_saleChannel: "$.products[${index_products - 1}].trades[0].channels[*].saleChannel"
            ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ "TELEWIZ" อยู่ใน channels (trades[0].channels[index].saleChannel)"
            ...    ${\n}---> "saleChannel" == "${value_saleChannel}"
            Log    ${result}
    END

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_6_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by blacklistAcrossOper  
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   31.6.1    Conditions   
    Set API Header Default
    Set Body API        schema_body=${31_6_1_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${31_6_1_response_get_campaign_by_trade_model}

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_6_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by blacklistAcrossOper  
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1. products[index].campaigns[index].requireCheckBlacklistAcrossOper = 'Y'
    ...     - 2. products[index].trades[index].criterias[index].blacklistAcrossOper = ['1']
    ...    ==>
    [Tags]   31.6.2    Conditions   
    Set API Header Default
    Set Body API        schema_body=${31_6_2_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True       int(${count_products}) == int(1)
    FOR    ${index_products}  IN RANGE       ${count_products}
            ${count_campaigns}   Get List Key And Count From Json    $.products[${index_products}].campaigns
            Should Be True    int(${count_campaigns}) >= int(1)
            Log    Check Step 1 : products[index].campaigns[index].requireCheckBlacklistAcrossOper = 'Y'
            FOR    ${index_campaigns}  IN RANGE       ${count_campaigns}
                ${value_requireCheckBlacklistAcrossOper}       Get Value From Json      ${response.json()}    $.products[${index_products}].campaigns[${index_campaigns}].requireCheckBlacklistAcrossOper
                Should Be Equal As Strings    ${value_requireCheckBlacklistAcrossOper}[0]     Y
                ${result}    Catenate
                ...    ${\n}---> loop products: "${index_products}"
                ...    ${\n}---> loop campaigns: "${index_campaigns}"
                ...    ${\n}---> json_path_requireCheckBlacklistAcrossOper: "$.products[${index_products}].campaigns[${index_campaigns}].requireCheckBlacklistAcrossOper"
                ...    ${\n}---> condition: products[index].campaigns[index].requireCheckBlacklistAcrossOper == 'Y'
                ...    ${\n}---> "requireCheckBlacklistAcrossOper" == "${value_requireCheckBlacklistAcrossOper}[0]"
                Log    ${result}
            END
            Log    Check Step 2 : products[index].trades[index].criterias[index].blacklistAcrossOper = ['1']
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products}].trades
            Should Be True    int(${count_trades}) >= int(1)
            FOR    ${index_trades}  IN RANGE       ${count_trades}
                ${value_blacklistAcrossOper}      Get Value From Json      ${response.json()}      $.products[${index_products}].trades[${index_trades}].criterias[*].blacklistAcrossOper 
                List Should Contain Value    ${value_blacklistAcrossOper }[0]    1
                ${result}    Catenate
                ...    ${\n}---> loop products: "${index_products}"
                ...    ${\n}---> loop trades: "${index_trades}"
                ...    ${\n}---> json_path_blacklistAcrossOper: "$.products[${index_products}].trades[${index_trades}].criterias[*].blacklistAcrossOper "
                ...    ${\n}---> condition: products[index].trades[index].criterias[index].blacklistAcrossOper == ['1']
                ...    ${\n}---> "blacklistAcrossOper" == "${value_blacklistAcrossOper}[0]"
                Log    ${result}
            END
    END

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_7_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by aspFlag 
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   31.7.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${31_7_1_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${31_7_1_response_get_campaign_by_trade_model}

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_7_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by aspFlag 
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."status": "20000"
    ...     - 2.products มี length == 6 **ข้อมูลอาจจะเปลี่ยนตาม config จาก DT
    ...    ==>
    [Tags]   31.7.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${31_7_2_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key       $..status        20000
    ${count}    Get List Key And Count From Json        $.products
    Should Be True      int(${count}) == int(6)
    Log    ---> Object.keys(products).length(${count}) == 6 

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_8_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."status": "20000"
    ...     - 2.products มี length == maxRow
    ...    ==>
    [Tags]   31.8.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${31_8_1_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}       Get List Key And Count From Json        $.products
    ${body_max}    Get Value From Json     ${API_BODY}     $.max
    Should Be True    int(${count}) == int(${body_max}[0])
    ${result}    Catenate
    ...    ${\n}---> body_max: ${body_max}
    ...    ${\n}---> "$data_length(${count})" == "$body_max(${body_max}[0])"
    Log    ${result}

CPC_API_1_1_031 Get Campaign By Trade Model (Conditions_Test_Case_8_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."status": "20000"
    ...     - 2.products มี length == total - (offset-1) 
    ...    ==>
    [Tags]   31.8.2    Conditions         
    Set API Header Default
    Set Body API        schema_body=${31_8_2_body_get_campaign_by_trade_model}
    Send Request API    url=${url_get_campaign_by_trade_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${products_length}    Get List Key And Count From Json          $.products
    ${total}    Get Value From Json     ${response.json()}          $.total
    ${body_offset}    Get Value From Json     ${API_BODY}           $.offset
    ${value_status}   Get Value From Json     ${response.json()}    $.status
    ${data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${products_length}) == int(${data_length})
    Should Be Equal As Strings   ${value_status}[0]    20000
    ${result}    Catenate
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_products_length == "${products_length}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> data_length: int(${total}[0] - (${body_offset}[0] - 1) == "${data_length}"
    ...    ${\n}---> "$data_length(${data_length})" == "$resp_products_length(${products_length})"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_032 Get Catalog SubTypes By CatalogType
    [Documentation]    Owner : Patipan.w   Edit : Kachain.a
    [Tags]   32
    Set API Header Default
    Set Body API        schema_body=${32_body_get_catalog_subtypes_by_catalogtype}
    Send Request API    url=${url_get_catalog_subtypes_by_catalogtype}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${32_response_get_catalog_subtypes_by_catalogtype}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_032 Get Catalog SubTypes By CatalogType (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - verify parameter
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   32.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${32_1_body_get_catalog_subtypes_by_catalogtype}
    Send Request API    url=${url_get_catalog_subtypes_by_catalogtype}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${32_1_response_get_catalog_subtypes_by_catalogtype}

CPC_API_1_1_032 Get Catalog SubTypes By CatalogType (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - catalogType not active
    ...    ==>
    ...    *** Expect Result ***
    ...     - catalogSubTypes.length = 0
    ...    ==>
    [Tags]   32.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${32_2_body_get_catalog_subtypes_by_catalogtype}
    Send Request API    url=${url_get_catalog_subtypes_by_catalogtype}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.catalogSubTypes
    Should Be True    int(${count}) == int(0)
    Log    ---> Object.keys(catalogSubTypes).length(${count}) == 0

CPC_API_1_1_032 Get Catalog SubTypes By CatalogType (Conditions_Test_Case_3)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - catalogType active
    ...    ==>
    ...    *** Expect Result ***
    ...     - catalogSubTypes.length > 0
    ...    ==>
    [Tags]   32.3    Conditions     
    Set API Header Default
    Set Body API        schema_body=${32_3_body_get_catalog_subtypes_by_catalogtype}
    Send Request API    url=${url_get_catalog_subtypes_by_catalogtype}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.catalogSubTypes
    Should Be True    int(${count}) > int(0)
    Log    ---> Object.keys(catalogSubTypes).length(${count}) > 0 

CPC_API_1_1_032 Get Catalog SubTypes By CatalogType (Conditions_Test_Case_4_1)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT CATALOG_TYPE FROM SIT_CPC.DT_MT_CATALOG_MST
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     - catalogSubTypes.length = 5
    ...    ==>
    [Tags]   32.4.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${32_4_1_body_get_catalog_subtypes_by_catalogtype}
    Send Request API    url=${url_get_catalog_subtypes_by_catalogtype}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.catalogSubTypes
    Should Be True    int(${count}) == int(5)
    Log    ---> Object.keys(catalogSubTypes).length(${count}) == 5

CPC_API_1_1_032 Get Catalog SubTypes By CatalogType (Conditions_Test_Case_4_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     - catalogSubTypes.length = total - (offset-1)
    ...    ==>
    [Tags]   32.4.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${32_4_2_body_get_catalog_subtypes_by_catalogtype}
    Send Request API    url=${url_get_catalog_subtypes_by_catalogtype}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.catalogSubTypes
    ${total}    Get Value From Json     ${response.json()}    $.total
    ${body_offset}    Get Value From Json     ${API_BODY}     $.offset
    ${data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${count}) == int(${data_length})
    ${result}    Catenate
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_catalogSubTypes_length == "${count}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> catalogSubTypes_length: int(${total}[0] - (${body_offset}[0] - 1) == "${data_length}"
    ...    ${\n}---> "$catalogSubTypes_length(${data_length})" == "$resp_data_length(${count})"
    Log    ${result}

CPC_API_1_1_033 Get CatalogTypes
    [Documentation]    Owner : Kachain.a
    [Tags]   33    
    Set API Header Default
    Set Body API        schema_body=${33_body_get_catalogtypes}
    Send Request API    url=${url_get_catalogtypes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${33_response_get_catalogtypes}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_033 Get CatalogTypes (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - verify parameter
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   33.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${33_1_body_get_catalogtypes}
    Send Request API    url=${url_get_catalogtypes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${33_1_response_get_catalogtypes}

CPC_API_1_1_033 Get CatalogTypes (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     - catalogTypes.length = 2
    ...    ==>
    [Tags]   33.2.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${33_2_1_body_get_catalogtypes}
    Send Request API    url=${url_get_catalogtypes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.catalogTypes
    Should Be True    int(${count}) == int(2)
    Log    ---> Object.keys(catalogSubTypes).length(${count}) == 2

CPC_API_1_1_033 Get CatalogTypes (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     - catalogTypes.length = 2
    ...    ==>
    [Tags]   33.2.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${33_2_2_body_get_catalogtypes}
    Send Request API    url=${url_get_catalogtypes}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_catalogTypes}    Get List Key And Count From Json    $.catalogTypes
    ${total}    Get Value From Json     ${response.json()}    $.total
    ${body_offset}    Get Value From Json     ${API_BODY}     $.offset
    ${data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${count_catalogTypes}) == int(${data_length})
    ${result}    Catenate
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_catalogTypes_length == "${count_catalogTypes}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> catalogTypes_length: int(${total}[0] - (${body_offset}[0] - 1) == "${data_length}"
    ...    ${\n}---> "$catalogTypes_length(${data_length})" == "$resp_data_length(${count_catalogTypes})"
    Log    ${result}

CPC_API_1_1_034 Get Category By Catalog
    [Documentation]    Owner : Patipan.w   Edit : Kachain.a
    [Tags]   34 
    Set API Header Default
    Set Body API        schema_body=${34_body_get_category_by_catalog}
    Send Request API    url=${url_get_category_by_catalog}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${34_response_get_category_by_catalog}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_034 Get Category By Catalog (Conditions_Test_Case_1_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - validate parameter offset, max 
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   34.1.1    Conditions 
    Set API Header Default
    Set Body API        schema_body=${34_1_1_body_get_category_by_catalog}
    Send Request API    url=${url_get_category_by_catalog}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${34_1_1_response_get_category_by_catalog}

CPC_API_1_1_034 Get Category By Catalog (Conditions_Test_Case_1_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - validate parameter catalogType
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   34.1.2    Conditions 
    Set API Header Default
    Set Body API        schema_body=${34_1_2_body_get_category_by_catalog}
    Send Request API    url=${url_get_category_by_catalog}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${34_1_2_response_get_category_by_catalog}

CPC_API_1_1_034 Get Category By Catalog (Conditions_Test_Case_1_3)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - validate parameter catalogSubType
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   34.1.3    Conditions 
    Set API Header Default
    Set Body API        schema_body=${34_1_3_body_get_category_by_catalog}
    Send Request API    url=${url_get_category_by_catalog}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${34_1_3_response_get_category_by_catalog}

CPC_API_1_1_034 Get Category By Catalog (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - catalogType not active
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - categories.length = 0
    ...    ==>
    [Tags]   34.2    Conditions 
    Set API Header Default
    Set Body API        schema_body=${34_2_body_get_category_by_catalog}
    Send Request API    url=${url_get_category_by_catalog}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${34_2_response_get_category_by_catalog}

CPC_API_1_1_034 Get Category By Catalog (Conditions_Test_Case_3)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT CATALOG_TYPE ,CATALOG_SUB_TYPE 
    ...    FROM SIT_CPC.DT_MT_CATALOG_MST
    ...    ==>
    ...    *** Condition ***
    ...     - catalogType active
    ...    ==>
    ...    *** Expect Result ***
    ...     - categories.length > 0
    ...    ==>
    [Tags]   34.3    Conditions 
    Set API Header Default
    Set Body API        schema_body=${34_3_body_get_category_by_catalog}
    Send Request API    url=${url_get_category_by_catalog}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.categories
    Should Be True    int(${count}) > int(0)
    Log    ---> Object.keys(categories).length(${count}) > 0

CPC_API_1_1_034 Get Category By Catalog (Conditions_Test_Case_4_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     - categories.length = 5
    ...    ==>
    [Tags]   34.4.1    Conditions
    Set API Header Default
    Set Body API        schema_body=${34_4_1_body_get_category_by_catalog}
    Send Request API    url=${url_get_category_by_catalog}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.categories
    Should Be True    int(${count}) == int(5)
    Log    ---> Object.keys(categories).length(${count}) == 5

CPC_API_1_1_034 Get Category By Catalog (Conditions_Test_Case_4_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     - categories.length = total - (offset-1)
    ...    ==>
    [Tags]   34.4.2    Conditions 
    Set API Header Default
    Set Body API        schema_body=${34_4_2_body_get_category_by_catalog}
    Send Request API    url=${url_get_category_by_catalog}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.categories
    ${total}    Get Value From Json     ${response.json()}    $.total
    ${body_offset}    Get Value From Json     ${API_BODY}     $.offset
    ${categories_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${count}) == int(${categories_length})
    ${result}    Catenate
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_categories_length == "${count}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> categories_length: int(${total}[0] - (${body_offset}[0] - 1) == "${categories_length}"
    ...    ${\n}---> "$categories_length(${categories_length})" == "$resp_categories_length(${count})"
    Log    ${result}

CPC_API_1_1_035 Get Products By Criteria
    [Documentation]    Owner : Patipan.w   Edit : Kachain.a
    [Tags]   35    
    Set API Header Default
    Set Body API        schema_body=${35_body_get_products_by_criteria}
    Send Request API    url=${url_get_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${35_response_get_products_by_criteria}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_035 Get Products By Criteria (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT PRDMST.COMPANY,CMST.BRAND, CMST.MODEL, CMST.MARKETING_NAME, CMST.MATERIAL_CODE
    ...    , CMST.COLOR, CMST.PRODUCT_ID
    ...    , CAST( PRCMST.EFFECTIVE_DATE AS datetime) AS EFFECTIVE_DATE
    ...    , isnull(CMST.HTML_COLOR, PRDSPC.COLOR_CODE) AS COLOR_CODE 
    ...    , PRDMST.PRODUCT_TYPE, PRDMST.PRODUCT_SUBTYPE, CMST.CATEGORY
    ...    , PRCMST.INC_VAT , PRCMST.EXC_VAT , PRCMST.EXPIRE_DATE
    ...    , PRDSPC.THUMBNAIL, PRDSPC.PICTURE, CMST.CATALOG_TYPE ,CMST.CATALOG_SUB_TYPE
    ...    FROM SIT_CPC.[DT_MT_CATALOG_MST] CMST
    ...    INNER JOIN SIT_CPC.[PRODUCT_MST] PRDMST ON PRDMST.PRODUCT_ID = CMST.PRODUCT_ID
    ...    INNER JOIN SIT_CPC.[PRICE_MST] PRCMST ON PRCMST.PRODUCT_ID = CMST.PRODUCT_ID
    ...    LEFT JOIN SIT_CPC.[PRODUCT_SPEC] PRDSPC ON PRDSPC.MAT_CODE = CMST.MATERIAL_CODE
    ...    WHERE PRCMST.EFFECTIVE_DATE <= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time'
    ...    AND PRCMST.PRICE_GROUP = 'EUP'
    ...    AND (PRCMST.EXPIRE_DATE IS NULL OR PRCMST.EXPIRE_DATE >= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time')    
    ...    ==>
    ...    *** Condition ***
    ...     - filter by catalogType
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. products ทุกตัวมีค่า catalogProducts[0].catalogType = "Accessories"
    ...    - **sensitive case ค่ะ ตัวเล็กตัวใหญ่จะเห็นเหมือนกัน 
    ...    ==>
    [Tags]   35.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${35_1_body_get_products_by_criteria}
    Send Request API    url=${url_get_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    FOR  ${index}  IN RANGE    ${count_products}
             ${count_catalogProducts}    Get List Key And Count From Json    $.products[${index}].catalogProducts
             FOR  ${index_catalogProducts}  IN RANGE    ${count_catalogProducts}
             ${value_catalogType}           Get Value From Json     ${response.json()}    $.products[${index}].catalogProducts[${index_catalogProducts}].catalogType          
             Should Be Equal As Strings     ${value_catalogType}[0]       Accessories
             ${result}    Catenate
             ...    ${\n}---> loop index products: "${index}"
             ...    ${\n}---> loop index catalogProducts: "${index_catalogProducts}"
             ...    ${\n}---> json_path_catalogType: "$.products[${index}].catalogProducts[${index_catalogProducts}].catalogType"
             ...    ${\n}---> condition: All "catalogType" is "Accessories"
             ...    ${\n}---> "products[*].catalogProducts[*].catalogType" == "${value_catalogType}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_035 Get Products By Criteria (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by catalogType
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. products ทุกตัวมีค่า catalogProducts[0].catalogSubType = "POWER SUPPLIES"
    ...    - **sensitive case ค่ะ ตัวเล็กตัวใหญ่จะเห็นเหมือนกัน 
    ...    ==>
    [Tags]   35.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${35_2_body_get_products_by_criteria}
    Send Request API    url=${url_get_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    FOR  ${index}  IN RANGE    ${count_products}
             ${count_catalogProducts}    Get List Key And Count From Json    $.products[${index}].catalogProducts
             FOR  ${index_catalogProducts}  IN RANGE    ${count_catalogProducts}
             ${value_catalogSubType}           Get Value From Json     ${response.json()}    $.products[${index}].catalogProducts[${index_catalogProducts}].catalogSubType          
             Should Be Equal As Strings     ${value_catalogSubType}[0]       POWER SUPPLIES
             ${result}    Catenate
             ...    ${\n}---> loop index products: "${index}"
             ...    ${\n}---> loop index catalogProducts: "${index_catalogProducts}"
             ...    ${\n}---> json_path_catalogSubType: "$.products[${index}].catalogProducts[${index_catalogProducts}].catalogSubType"
             ...    ${\n}---> condition: All "catalogSubType" is "POWER SUPPLIES"
             ...    ${\n}---> "products[*].catalogProducts[*].catalogSubType" == "${value_catalogSubType}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_035 Get Products By Criteria (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by catalogType and catalogSubType
    ...    ==>
    ...    *** Expect Result ***
    ...    - products.length = 0
    ...    ==>
    [Tags]   35.3.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${35_3_1_body_get_products_by_criteria}
    Send Request API    url=${url_get_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    Should Be True    int(${count}) == int(0)
    Log    ---> Object.keys(products).length(${count}) == 0

CPC_API_1_1_035 Get Products By Criteria (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by catalogType and catalogSubType
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. products ทุกตัวมีค่า catalogProducts[0].catalogType = "Gadget" 
    ...    - 2. catalogProducts[0].catalogSubType = "TABLET" --> **sensitive case ค่ะ ตัวเล็กตัวใหญ่จะเห็นเหมือนกัน 
    ...    ==>
    [Tags]   35.3.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${35_3_2_body_get_products_by_criteria}
    Send Request API    url=${url_get_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    FOR  ${index}  IN RANGE    ${count_products}
             ${count_catalogProducts}    Get List Key And Count From Json    $.products[${index}].catalogProducts
             FOR  ${index_catalogProducts}  IN RANGE    ${count_catalogProducts}
             ${value_catalogType}           Get Value From Json     ${response.json()}    $.products[${index}].catalogProducts[${index_catalogProducts}].catalogType          
             ${value_catalogSubType}        Get Value From Json     ${response.json()}    $.products[${index}].catalogProducts[${index_catalogProducts}].catalogSubType          
             Should Be Equal As Strings     ${value_catalogType}[0]          Gadget
             Should Be Equal As Strings     ${value_catalogSubType}[0]       TABLET
             ${result}    Catenate
             ...    ${\n}---> loop index products: "${index}"
             ...    ${\n}---> loop index catalogProducts: "${index_catalogProducts}"
             ...    ${\n}---> json_path_catalogType: "$.products[${index}].catalogProducts[${index_catalogProducts}].catalogType"
             ...    ${\n}---> json_path_catalogSubTypee: "$.products[${index}].catalogProducts[${index_catalogProducts}].catalogSubType"
             ...    ${\n}---> condition: All "catalogType" is "Gadget"
             ...    ${\n}---> condition: All "catalogSubType" is "TABLET"
             ...    ${\n}---> "products[*].catalogProducts[*].catalogType" == "${value_catalogType}[0]"
             ...    ${\n}---> "products[*].catalogProducts[*].catalogSubType" == "${value_catalogSubType}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_035 Get Products By Criteria (Conditions_Test_Case_4)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by catalogType and catalogSubType
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมีค่า catalogProducts[0].category ที่มีคำว่า WiFi --> **sensitive case ค่ะ ตัวเล็กตัวใหญ่จะเห็นเหมือนกัน 
    ...    ==>
    [Tags]   35.4    Conditions    
    Set API Header Default
    Set Body API        schema_body=${35_4_body_get_products_by_criteria}
    Send Request API    url=${url_get_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    FOR  ${index}  IN RANGE    ${count_products}
             ${count_catalogProducts}    Get List Key And Count From Json    $.products[${index}].catalogProducts
             FOR  ${index_catalogProducts}  IN RANGE    ${count_catalogProducts}
             ${value_category}           Get Value From Json     ${response.json()}    $.products[${index}].catalogProducts[${index_catalogProducts}].category          
             Should Contain              ${value_category}[0]          WiFi        ignore_case=True	
             ${result}    Catenate
             ...    ${\n}---> loop index products: "${index}"
             ...    ${\n}---> loop index catalogProducts: "${index_catalogProducts}"
             ...    ${\n}---> json_path_category: "$.products[${index}].catalogProducts[${index_catalogProducts}].category"
             ...    ${\n}---> condition: All "category" is "WiFi"
             ...    ${\n}---> "products[*].catalogProducts[*].category" == "${value_category}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_035 Get Products By Criteria (Conditions_Test_Case_5)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by catalogType and catalogSubType
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. products ทุกตัวมีค่า catalogProducts[0].catalogType = "IOT"
    ...    - 2. catalogProducts[0].catalogSubType = "Smart Home"
    ...    - 3. catalogProducts[0].category ที่มีคำว่า VR --> **sensitive case ค่ะ ตัวเล็กตัวใหญ่จะเห็นเหมือนกัน 
    ...    ==>
    [Tags]   35.5    Conditions    
    Set API Header Default
    Set Body API        schema_body=${35_5_body_get_products_by_criteria}
    Send Request API    url=${url_get_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    FOR  ${index}  IN RANGE    ${count_products}
             ${count_catalogProducts}    Get List Key And Count From Json    $.products[${index}].catalogProducts
             FOR  ${index_catalogProducts}  IN RANGE    ${count_catalogProducts}
             ${value_catalogType}           Get Value From Json     ${response.json()}    $.products[${index}].catalogProducts[${index_catalogProducts}].catalogType          
             ${value_catalogSubType}        Get Value From Json     ${response.json()}    $.products[${index}].catalogProducts[${index_catalogProducts}].catalogSubType          
             ${value_category}              Get Value From Json     ${response.json()}    $.products[${index}].catalogProducts[${index_catalogProducts}].category          
             Should Be Equal As Strings     ${value_catalogType}[0]          IOT
             Should Be Equal As Strings     ${value_catalogSubType}[0]       Smart Home
             Should Contain                 ${value_category}[0]         VR        ignore_case=True	
             ${result}    Catenate
             ...    ${\n}---> loop index products: "${index}"
             ...    ${\n}---> loop index catalogProducts: "${index_catalogProducts}"
             ...    ${\n}---> json_path_catalogType: "$.products[${index}].catalogProducts[${index_catalogProducts}].catalogType"
             ...    ${\n}---> json_path_catalogSubTypee: "$.products[${index}].catalogProducts[${index_catalogProducts}].catalogSubType"
             ...    ${\n}---> json_path_category: "$.products[${index}].catalogProducts[${index_catalogProducts}].category"
             ...    ${\n}---> condition: All "catalogType" is "IOT"
             ...    ${\n}---> condition: All "catalogSubType" is "Smart Home"
             ...    ${\n}---> condition: All "category" is "VR"
             ...    ${\n}---> "products[*].catalogProducts[*].catalogType" == "${value_catalogType}[0]"
             ...    ${\n}---> "products[*].catalogProducts[*].catalogSubType" == "${value_catalogSubType}[0]"
             ...    ${\n}---> "products[*].catalogProducts[*].category" == "${value_category}[0]"
             Log    ${result}
             END
    END

CPC_API_1_1_035 Get Products By Criteria (Conditions_Test_Case_6_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     - products.length = 5
    ...    ==>
    [Tags]   35.6.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${35_6_1_body_get_products_by_criteria}
    Send Request API    url=${url_get_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    Should Be True    int(${count}) == int(5)
    Log    ---> Object.keys(products).length(${count}) == 5

CPC_API_1_1_035 Get Products By Criteria (Conditions_Test_Case_6_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset-max
    ...    ==>
    ...    *** Expect Result ***
    ...     - products.length  = total - (offset-1)
    ...    ==>
    [Tags]   35.6.2    Conditions         
    Set API Header Default
    Set Body API        schema_body=${35_6_2_body_get_products_by_criteria}
    Send Request API    url=${url_get_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${products_length}    Get List Key And Count From Json          $.products
    ${total}    Get Value From Json     ${response.json()}          $.total
    ${body_offset}    Get Value From Json     ${API_BODY}           $.offset
    ${body_max}       Get Value From Json     ${API_BODY}           $.max
    ${value_status}   Get Value From Json     ${response.json()}    $.status
    ${data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${products_length}) == int(${data_length})
    ${result}    Catenate
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_products_length == "${products_length}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> products_length: int(${total}[0] - (${body_offset}[0] - 1) == "${products_length}"
    ...    ${\n}---> "$products_length(${products_length})" == "$resp_products_length(${products_length})"
    Log    ${result}

CPC_API_1_1_036 Get All Product
    [Documentation]    Owner : Kachain.a
    [Tags]   36    
    Set API Header Default
    Set Body API        schema_body=${36_body_get_all_product}
    Send Request API    url=${url_get_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${36_response_get_all_product}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_036 Get All Product (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - Default by productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...     - products ทุกตัวต้องมีค่า "productType" = "DEVICE"
    ...     - "productSubtype" = HANDSET หรือ HANDSET BUNDLE
    ...    ==>
    [Tags]   36.1    Conditions      
    Set API Header Default
    Set Body API        schema_body=${36_1_body_get_all_product}
    Send Request API    url=${url_get_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    FOR  ${index}  IN RANGE    ${count_products}
        ${value_productType}           Get Value From Json     ${response.json()}    $.products[${index}].productType         
        ${value_productSubtype}        Get Value From Json     ${response.json()}    $.products[${index}].productSubtype
        Log   ---> "productType" : "${value_productType}[0]"${\n}---> "productSubtype" : "${value_productSubtype}[0]"
        Should Be Equal As Strings     ${value_productType}[0]          DEVICE
        Should Be True     '${value_productSubtype}[0]' == 'HANDSET' or '${value_productSubtype}[0]' == 'HANDSET BUNDLE'
        ${result}    Catenate
        ...    ${\n}---> loop index products: "${index}"
        ...    ${\n}---> json_path_productType: "$.products[${index}].productType"
        ...    ${\n}---> json_path_productSubtypee: "$.products[${index}].productSubtype"
        ...    ${\n}---> condition: All "productType" is "DEVICE"
        ...    ${\n}---> condition: All "productSubtype" is "HANDSET" or "HANDSET BUNDLE"
        ...    ${\n}---> "products[*].productType" == "${value_productType}[0]"
        ...    ${\n}---> "products[*].productSubtype" == "${value_productSubtype}[0]"
        Log    ${result}
    END

CPC_API_1_1_036 Get All Product (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT PRODUCT_TYPE , PRODUCT_SUBTYPE FROM SIT_CPC.PRODUCT_MST
    ...    ==>
    ...    *** Condition ***
    ...     - filter by productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...     - products ทุกตัวต้องมีค่า "productType" = "DEVICE"
    ...     - "productSubtype" = SPECIAL PRODUCT
    ...    ==>
    [Tags]   36.2.1    Conditions      
    Set API Header Default
    Set Body API        schema_body=${36_2_1_body_get_all_product}
    Send Request API    url=${url_get_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    FOR  ${index}  IN RANGE    ${count_products}
        ${value_productType}           Get Value From Json     ${response.json()}    $.products[${index}].productType         
        ${value_productSubtype}        Get Value From Json     ${response.json()}    $.products[${index}].productSubtype
        Log   ---> "productType" : "${value_productType}[0]"${\n}---> "productSubtype" : "${value_productSubtype}[0]"
        Should Be Equal As Strings     ${value_productType}[0]          DEVICE
        Should Be Equal As Strings     ${value_productSubtype}[0]       SPECIAL PRODUCT
        ${result}    Catenate
        ...    ${\n}---> loop index products: "${index}"
        ...    ${\n}---> json_path_productType: "$.products[${index}].productType"
        ...    ${\n}---> json_path_productSubtypee: "$.products[${index}].productSubtype"
        ...    ${\n}---> condition: All "productType" is "DEVICE"
        ...    ${\n}---> condition: All "productSubtype" is "SPECIAL PRODUCT"
        ...    ${\n}---> "products[*].productType" == "${value_productType}[0]"
        ...    ${\n}---> "products[*].productSubtype" == "${value_productSubtype}[0]"
        Log    ${result}
    END

CPC_API_1_1_036 Get All Product (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...     - products.length = 0
    ...    ==>
    [Tags]   36.2.2    Conditions      
    Set API Header Default
    Set Body API        schema_body=${36_2_2_body_get_all_product}
    Send Request API    url=${url_get_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}   Get List Key And Count From Json    $.products
    Should Be True      int(${count_products}) == int(0)
    Log    ---> Object.keys(products).length(${count_products}) == 0 

CPC_API_1_1_036 Get All Product (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by brand
    ...    ==>
    ...    *** Expect Result ***
    ...     - products ทุกตัวต้องมีค่า "brand" = APPLE
    ...    ==>
    [Tags]   36.3.1    Conditions      
    Set API Header Default
    Set Body API        schema_body=${36_3_1_body_get_all_product}
    Send Request API    url=${url_get_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    FOR  ${index}  IN RANGE    ${count_products}
        ${value_brand}           Get Value From Json     ${response.json()}    $.products[${index}].brand         
        Log   ---> "brand" : "${value_brand}[0]"
        Should Be Equal As Strings     ${value_brand}[0]          APPLE
        ${result}    Catenate
        ...    ${\n}---> loop index products: "${index}"
        ...    ${\n}---> json_path_brand: "$.products[${index}].brand"
        ...    ${\n}---> condition: All "brand" is "APPLE"
        ...    ${\n}---> "products[*].brand" == "${value_brand}[0]"
        Log    ${result}
    END

CPC_API_1_1_036 Get All Product (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by brand
    ...    ==>
    ...    *** Expect Result ***
    ...     - products ทุกตัวต้องมีค่า "brand" = HUAWEI
    ...    ==>
    [Tags]   36.3.2    Conditions      
    Set API Header Default
    Set Body API        schema_body=${36_3_2_body_get_all_product}
    Send Request API    url=${url_get_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    FOR  ${index}  IN RANGE    ${count_products}
        ${value_brand}           Get Value From Json     ${response.json()}    $.products[${index}].brand         
        Log   ---> "brand" : "${value_brand}[0]"
        Should Be Equal As Strings     ${value_brand}[0]          HUAWEI
        ${result}    Catenate
        ...    ${\n}---> loop index products: "${index}"
        ...    ${\n}---> json_path_brand: "$.products[${index}].brand"
        ...    ${\n}---> condition: All "brand" is "HUAWEI"
        ...    ${\n}---> "products[*].brand" == "${value_brand}[0]"
        Log    ${result}
    END

CPC_API_1_1_036 Get All Product (Conditions_Test_Case_4_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     - products.length = 5
    ...    ==>
    [Tags]   36.4.1    Conditions      
    Set API Header Default
    Set Body API        schema_body=${36_4_1_body_get_all_product}
    Send Request API    url=${url_get_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}   Get List Key And Count From Json    $.products
    Should Be True      int(${count_products}) == int(5)
    Log    ---> Object.keys(products).length("${count_products}) == 5 

CPC_API_1_1_036 Get All Product (Conditions_Test_Case_4_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     - products.length = totalRow - (offset-1)
    ...    ==>
    [Tags]   36.4.2    Conditions      
    Set API Header Default
    Set Body API        schema_body=${36_4_2_body_get_all_product}
    Send Request API    url=${url_get_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    ${totalRow}    Get Value From Json     ${response.json()}    $.totalRow
    ${body_offset}    Get Value From Json     ${API_BODY}     $.offset
    ${products_length}    Evaluate    int(${totalRow}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${count}) == int(${products_length})
    ${result}    Catenate
    ...    ${\n}---> condition: totalRow - (offset-1)
    ...    ${\n}---> resp_products_length == "${count}"
    ...    ${\n}---> resp_totalRow == "${totalRow}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> products_length: int(${totalRow}[0] - (${body_offset}[0] - 1) == "${products_length}"
    ...    ${\n}---> "$products_length(${products_length})" == "$resp_products_length(${count})"
    Log    ${result}

CPC_API_1_1_037 Get Products By Brand and Model
    [Documentation]    Owner : Kachain.a
    [Tags]   37    
    Set API Header Default
    Set Body API        schema_body=${37_body_get_products_by_brand_and_model}
    Send Request API    url=${url_get_products_by_brand_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${37_response_get_products_by_brand_and_model}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    success
    Write Response To Json File

CPC_API_1_1_037 Get Products By Brand and Model (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - verify parameter
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   37.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${37_1_body_get_products_by_brand_and_model}
    Send Request API    url=${url_get_products_by_brand_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${37_1_response_get_products_by_brand_and_model}

CPC_API_1_1_037 Get Products By Brand and Model (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - Default by productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1.products.length > 0
    ...     - 2.products ทุกตัวต้องมีค่า "productType" = "DEVICE"
    ...     - 3."productSubtype" = HANDSET หรือ HANDSET BUNDLE
    ...    ==>
    [Tags]   37.2.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${37_2_1_body_get_products_by_brand_and_model}
    Send Request API    url=${url_get_products_by_brand_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True      int(${count_products}) > int(0)
    FOR  ${index}  IN RANGE    ${count_products}
        ${value_productType}           Get Value From Json     ${response.json()}    $.products[${index}].productType         
        ${value_productSubtype}        Get Value From Json     ${response.json()}    $.products[${index}].productSubtype
        Log   ---> "productType" : "${value_productType}[0]"${\n}---> "productSubtype" : "${value_productSubtype}[0]"
        Should Be Equal As Strings     ${value_productType}[0]          DEVICE
        Should Be True     '${value_productSubtype}[0]' == 'HANDSET' or '${value_productSubtype}[0]' == 'HANDSET BUNDLE'
        ${result}    Catenate
        ...    ${\n}---> loop index products: "${index}"
        ...    ${\n}---> json_path_productType: "$.products[${index}].productType"
        ...    ${\n}---> json_path_productSubtypee: "$.products[${index}].productSubtype"
        ...    ${\n}---> condition: All "productType" is "DEVICE"
        ...    ${\n}---> condition: All "productSubtype" is "HANDSET" or "HANDSET BUNDLE"
        ...    ${\n}---> "products[*].productType" == "${value_productType}[0]"
        ...    ${\n}---> "products[*].productSubtype" == "${value_productSubtype}[0]"
        Log    ${result}
    END

CPC_API_1_1_037 Get Products By Brand and Model (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - Default by productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1.products.length > 0
    ...     - 2.products ทุกตัวต้องมีค่า "productType" = "DEVICE"
    ...     - 3."productSubtype" = HANDSET
    ...    ==>
    [Tags]   37.2.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${37_2_2_body_get_products_by_brand_and_model}
    Send Request API    url=${url_get_products_by_brand_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True      int(${count_products}) > int(0)
    FOR  ${index}  IN RANGE    ${count_products}
        ${value_productType}           Get Value From Json     ${response.json()}    $.products[${index}].productType         
        ${value_productSubtype}        Get Value From Json     ${response.json()}    $.products[${index}].productSubtype
        Log   ---> "productType" : "${value_productType}[0]"${\n}---> "productSubtype" : "${value_productSubtype}[0]"
        Should Be Equal As Strings     ${value_productType}[0]          DEVICE
        Should Be Equal As Strings     ${value_productSubtype}[0]       HANDSET
        ${result}    Catenate
        ...    ${\n}---> loop index products: "${index}"
        ...    ${\n}---> json_path_productType: "$.products[${index}].productType"
        ...    ${\n}---> json_path_productSubtypee: "$.products[${index}].productSubtype"
        ...    ${\n}---> condition: All "productType" is "DEVICE"
        ...    ${\n}---> condition: All "productSubtype" is "HANDSET"
        ...    ${\n}---> "products[*].productType" == "${value_productType}[0]"
        ...    ${\n}---> "products[*].productSubtype" == "${value_productSubtype}[0]"
        Log    ${result}
    END

CPC_API_1_1_037 Get Products By Brand and Model (Conditions_Test_Case_2_3)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...     - products.length = 0
    ...    ==>
    [Tags]   37.2.3    Conditions      
    Set API Header Default
    Set Body API        schema_body=${37_2_3_body_get_products_by_brand_and_model}
    Send Request API    url=${url_get_products_by_brand_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}   Get List Key And Count From Json    $.products
    Should Be True      int(${count_products}) == int(0)
    Log    ---> Object.keys(products).length(${count_products}) == 0

CPC_API_1_1_037 Get Products By Brand and Model (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...     - products.length > 0
    ...    ==>
    [Tags]   37.3.1    Conditions      
    Set API Header Default
    Set Body API        schema_body=${37_3_1_body_get_products_by_brand_and_model}
    Send Request API    url=${url_get_products_by_brand_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}   Get List Key And Count From Json    $.products
    Should Be True      int(${count_products}) > int(0)
    Log    ---> Object.keys(products).length(${count_products}) > 0

CPC_API_1_1_037 Get Products By Brand and Model (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by brand and model
    ...    ==>
    ...    *** Expect Result ***
    ...     - products.length = 0
    ...    ==>
    [Tags]   37.3.2    Conditions      
    Set API Header Default
    Set Body API        schema_body=${37_3_2_body_get_products_by_brand_and_model}
    Send Request API    url=${url_get_products_by_brand_model}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}   Get List Key And Count From Json    $.products
    Should Be True      int(${count_products}) == int(0)
    Log    ---> Object.keys(products).length(${count_products}) == 0

CPC_API_1_1_038 Get Best Seller Products
    [Documentation]    Owner : Patipan.w  Edit : Attapon
    [Tags]   38    
    Set API Header Default
    Set Body API        schema_body=${38_body_get_best_seller_products}
    Send Request API    url=${url_get_best_seller_products}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${38_response_get_best_seller_products}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_038 Get Banks Promotion (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    WITH model as (
    ...            SELECT BS.BRAND, SM.MODEL AS SUB_MODEL, BS.COLOR
    ...            , SM.COMMERCIAL_NAME AS NAME, MIN(BS.PRIORITY) AS PRIORITY
    ...            , BS.TYPE AS ITEM_TYPE
    ...        FROM SIT_CPC.BEST_SELLER BS
    ...            INNER JOIN SIT_CPC.SUB_MODEL SM ON SM.MODEL = BS.SUB_MODEL
    ...            INNER JOIN SIT_CPC.[MODEL_SUB_MODEL] AS MSM ON MSM.SUB_MODEL_ID = SM.ID
    ...            INNER JOIN SIT_CPC.[MODEL] AS MODEL ON MODEL.ID = MSM.MODEL_SUB_MODELS_ID
    ...            INNER JOIN SIT_CPC.BEST_SELLER_GROUP BSG ON BSG.ID = BS.GROUP_ID
    ...            LEFT JOIN SIT_CPC.BEST_SELLER_GROUP_LOCATION_MST BSGL ON BSGL.BEST_SELLER_GROUP_LOCATIONS_ID = BSG.ID
    ...        WHERE  BSGL.LOCATION_MASTER_ID IN (99999999) AND (MODEL.STATUS is null or MODEL.STATUS = 1)
    ...            AND SYSDATETIMEOFFSET() AT TIME ZONE 'SE Asia Standard Time' BETWEEN BS.EFFECTIVE_START_DATE 
    ...                AND CONVERT(datetime,ISNULL(BS.EFFECTIVE_END_DATE, '9999/12/31 23:59:59'))
    ...            GROUP BY BS.BRAND, SM.MODEL, BS.COLOR, SM.COMMERCIAL_NAME, BS.PRIORITY,BS.TYPE
    ...        ) 
    ...        SELECT P.BRAND, P.SUB_MODEL AS SUB_MODEL, P.COLOR
    ...        , P.NAME AS NAME, MIN(P.PRIORITY) AS PRIORITY
    ...        , P.ITEM_TYPE AS ITEM_TYPE 
    ...        FROM 	model P
    ...        GROUP BY P.BRAND, P.SUB_MODEL, P.COLOR, P.NAME, P.ITEM_TYPE
    ...        ORDER BY ITEM_TYPE DESC,PRIORITY, NAME ASC
    ...    ==>
    ...    *** Condition ***
    ...    - default location
    ...    ==>
    ...    *** Expect Result ***
    ...    - products.length = 2
    ...    ==>
    [Tags]   38.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${38_1_body_get_best_seller_products}
    Send Request API    url=${url_get_best_seller_products}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}       Get List Key And Count From Json     $.products
    Should Be True    int(${count}) == int(2)
    Log    ---> Object.keys(data).length(${count} == 2

CPC_API_1_1_038 Get Banks Promotion (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    *** CMD SQL ***
    ...    WITH model as (
    ...            SELECT BS.BRAND, SM.MODEL AS SUB_MODEL, BS.COLOR
    ...            , SM.COMMERCIAL_NAME AS NAME, MIN(BS.PRIORITY) AS PRIORITY
    ...            , BS.TYPE AS ITEM_TYPE
    ...        FROM SIT_CPC.BEST_SELLER BS
    ...            INNER JOIN SIT_CPC.SUB_MODEL SM ON SM.MODEL = BS.SUB_MODEL
    ...            INNER JOIN SIT_CPC.[MODEL_SUB_MODEL] AS MSM ON MSM.SUB_MODEL_ID = SM.ID
    ...            INNER JOIN SIT_CPC.[MODEL] AS MODEL ON MODEL.ID = MSM.MODEL_SUB_MODELS_ID
    ...            INNER JOIN SIT_CPC.BEST_SELLER_GROUP BSG ON BSG.ID = BS.GROUP_ID
    ...            LEFT JOIN SIT_CPC.BEST_SELLER_GROUP_LOCATION_MST BSGL ON BSGL.BEST_SELLER_GROUP_LOCATIONS_ID = BSG.ID
    ...        WHERE  BSGL.LOCATION_MASTER_ID IN (1100) AND (MODEL.STATUS is null or MODEL.STATUS = 1)
    ...            AND SYSDATETIMEOFFSET() AT TIME ZONE 'SE Asia Standard Time' BETWEEN BS.EFFECTIVE_START_DATE 
    ...                AND CONVERT(datetime,ISNULL(BS.EFFECTIVE_END_DATE, '9999/12/31 23:59:59'))
    ...            GROUP BY BS.BRAND, SM.MODEL, BS.COLOR, SM.COMMERCIAL_NAME, BS.PRIORITY,BS.TYPE
    ...        ) 
    ...        SELECT P.BRAND, P.SUB_MODEL AS SUB_MODEL, P.COLOR
    ...        , P.NAME AS NAME, MIN(P.PRIORITY) AS PRIORITY
    ...        , P.ITEM_TYPE AS ITEM_TYPE 
    ...        FROM 	model P
    ...        GROUP BY P.BRAND, P.SUB_MODEL, P.COLOR, P.NAME, P.ITEM_TYPE
    ...        ORDER BY ITEM_TYPE DESC,PRIORITY, NAME ASC
    ...    ==>
    ...    *** Condition ***
    ...    - filter by location
    ...    ==>
    ...    *** Expect Result ***
    ...    - products.length = 5
    ...    ==>
    [Tags]   38.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${38_2_body_get_best_seller_products}
    Send Request API    url=${url_get_best_seller_products}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}          Get List Key And Count From Json     $.products
    Should Be True    int(${count}) == int(5)
    Log    ---> Object.keys(data).length(${count}) == 5

CPC_API_1_1_039 Get Pay Advance Details
    [Documentation]    Owner : Patipan.w  Edit : Kachain.a
    [Tags]   39    
    Set API Header Default
    Set Body API        schema_body=${39_body_get_pay_advance_details}
    Send Request API    url=${url_get_pay_advance_details}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${39_response_get_pay_advance_details}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_039 Get Pay Advance Details (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - verify parameter
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   39.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${39_1_body_get_pay_advance_details}
    Send Request API    url=${url_get_pay_advance_details}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${39_1_response_get_pay_advance_details}

CPC_API_1_1_039 Get Pay Advance Details (Conditions_Test_Case_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - payAdvanceGroupDetail not active
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."statusCode" = "20000"
    ...     - 2.data != null หรือ data != {}
    ...    ==>
    [Tags]   39.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${39_2_body_get_pay_advance_details}
    Send Request API    url=${url_get_pay_advance_details}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key      $..statusCode           20000
    ${response_data}         Get Value From Json    ${response.json()}    $.data
    Log Response Json        ${response_data}[0]
    Should Not Be Empty      ${response_data}[0]    msg=$.data is "null" or "none".

CPC_API_1_1_039 Get Pay Advance Details (Conditions_Test_Case_3)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - payAdvanceGroupDetail not active
    ...     - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...     - "status": "40401"
    ...    ==>
    [Tags]   39.3    Conditions     
    Set API Header Default
    Set Body API        schema_body=${39_3_body_get_pay_advance_details}
    Send Request API    url=${url_get_pay_advance_details}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected        path_expected=${39_3_response_get_pay_advance_details}


CPC_API_1_1_040 Get Payments
    [Documentation]    Owner : Patipan.w  Edit : Attapon
    [Tags]   40 
    Set API Header Default
    Set Body API        schema_body=${40_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${40_response_get_payments}
    # Verify Value Response By Key    $..statusCode    20000
    # Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

# cancel by Sasina.I 2024-08-19 Get Payments send status code 20000 only
# CPC_API_1_1_040 Get Payments (Conditions_Test_Case_1_1)
#     [Documentation]    Owner: Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...    - validate Parameter
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - statusCode = 30000    # ไม่ต้องส่ง Body
#     ...    ==>
#     [Tags]    40.1.1     Conditions     
#     Set API Header Default
#     Send Request API    url=${url_get_payments}
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
#     Should Be Equal As Strings     ${value_statusCode}[0]       30000
#     ${result}    Catenate
#     ...    ${\n}---> condition: statusCode = "30000"
#     ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
#     Log    ${result}
    
# cancel by Sasina.I 2024-08-19 Get Payments send status code 20000 only
# CPC_API_1_1_040 Get Payments (Conditions_Test_Case_1_2)
#     [Documentation]    Owner: Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...    - validate Parameter
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - statusCode = 30000
#     ...    ==>
#     [Tags]    40.1.2    Conditions     
#     Set API Header Default
#     Set Body API        schema_body=${40_1_2_body_get_payments}
#     Send Request API    url=${url_get_payments}
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
#     Should Be Equal As Strings     ${value_statusCode}[0]       30000
#     ${result}    Catenate
#     ...    ${\n}---> condition: statusCode = "30000"
#     ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
#     Log    ${result}

# cancel by Sasina.I 2024-08-19 Get Payments send status code 20000 only
# CPC_API_1_1_040 Get Payments (Conditions_Test_Case_2)
#     [Documentation]    Owner: Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...    - data not found
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - statusCode = 40401
#     ...    ==>
#     [Tags]    40.2   Conditions      
#     Set API Header Default
#     Set Body API        schema_body=${40_2_body_get_payments}
#     Send Request API    url=${url_get_payments}
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
#     Should Be Equal As Strings     ${value_statusCode}[0]       40401
#     ${result}    Catenate
#     ...    ${\n}---> condition: statusCode = "40401"
#     ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
#     Log    ${result}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.TR_PAYMENT tp 
    ...    left join SIT_CPC.TR_PAYMENT tp2 on tp2.TRADE_NO = tp.TRADE_NO and tp2.TRADE_PRODUCT_ID is not null
    ...    where tp.TRADE_PRODUCT_ID is null and tp2.TRADE_NO is null
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo only
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" length = 7
    ...    2. "cardType": "OTHER"
    ...       "method": "CC"
    ...       "banks" length = 5
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks"  length = 7
    ...    ==>
    [Tags]    40.3.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${40_3_1_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}    Create List   
    ${expect_cardType}    Create List      MASTER    OTHER    VISA
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${count_banks}       Get List Key And Count From Json               $.payments[${index_payments - 1}].banks
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(7)
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(5)
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(7)
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_banks: "$.payments[${index_payments - 1}].banks"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 7
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 5
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}--->    "banks"  length = 7
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "banks_length" == "${count_banks}"
                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo only
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" length = 7
    ...    2. "cardType": "OTHER"
    ...       "method": "CC"
    ...       "banks" length = 5
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks"  length = 7
    ...    ==>
    [Tags]    40.3.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${40_3_2_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}    Create List   
    ${expect_cardType}    Create List      MASTER    OTHER    VISA
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${count_banks}       Get List Key And Count From Json               $.payments[${index_payments - 1}].banks
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(7)
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(5)
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(7)
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_banks: "$.payments[${index_payments - 1}].banks"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 7
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 5
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}--->    "banks"  length = 7
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "banks_length" == "${count_banks}"
                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.TR_PAYMENT tp 
    ...    left join SIT_CPC.TR_PAYMENT tp2 on tp2.TRADE_NO = tp.TRADE_NO and tp2.TRADE_PRODUCT_ID is not null
    ...    where tp.TRADE_PRODUCT_ID is not null
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo and  tradeProductId
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" length = 8
    ...    2. "cardType": "OTHER"
    ...       "method": "CC"
    ...       "banks" length = 8
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks"  length = 8
    ...    ==>
    [Tags]    40.4.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${40_4_1_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}    Create List   
    ${expect_cardType}    Create List      MASTER    OTHER    VISA
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${count_banks}       Get List Key And Count From Json               $.payments[${index_payments - 1}].banks
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_banks: "$.payments[${index_payments - 1}].banks"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 8
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 8
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}--->    "banks"  length = 8
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "banks_length" == "${count_banks}"
                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo and  tradeProductId
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" length = 5
    ...    2. "cardType": "OTHER"
    ...       "method": "CC"
    ...       "banks" length = 5
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks"  length = 5
    ...    ==>
    [Tags]    40.4.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${40_4_2_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}    Create List   
    ${expect_cardType}    Create List      MASTER    OTHER    VISA
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${count_banks}       Get List Key And Count From Json               $.payments[${index_payments - 1}].banks
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(5)
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(5)
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(5)
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_banks: "$.payments[${index_payments - 1}].banks"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 5
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 5
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}--->    "banks"  length = 5
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "banks_length" == "${count_banks}"
                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_4_3)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo and  tradeProductId
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" length = 8
    ...    2. "cardType": "OTHER"
    ...       "method": "CC"
    ...       "banks" length = 8
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks"  length = 8
    ...    ==>
    [Tags]    40.4.3    Conditions        
    Set API Header Default
    Set Body API        schema_body=${40_4_3_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}    Create List   
    ${expect_cardType}    Create List      MASTER    OTHER    VISA
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${count_banks}       Get List Key And Count From Json               $.payments[${index_payments - 1}].banks
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_banks: "$.payments[${index_payments - 1}].banks"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 8
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 8
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}--->    "banks"  length = 8
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "banks_length" == "${count_banks}"
                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

# cancel by Sasina.I 2024-08-19 Get Payments send status code 20000 only
# CPC_API_1_1_040 Get Payments (Conditions_Test_Case_5_1)
#     [Documentation]    Owner: Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...    - filter by tradeProductId (config by tradeNo only)
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - statusCode = 40401
#     ...    ==>
#     [Tags]    40.5.1    Conditions        
#     Set API Header Default
#     Set Body API        schema_body=${40_5_1_body_get_payments}
#     Send Request API    url=${url_get_payments}
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
#     Should Be Equal As Strings     ${value_statusCode}[0]       40401
#     ${result}    Catenate
#     ...    ${\n}---> condition: statusCode = "40401"
#     ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
#     Log    ${result}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_5_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradeProductId (config by tradeNo and  tradeProductId)
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" check bankAbbr ต้องพบ SCB, SCBSPEEDY
    ...    2. "cardType": "OTHER"
    ...       "method": "CC"
    ...       "banks" check bankAbbr ต้องพบ SCB, SCBSPEEDY
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks" check bankAbbr ต้องพบ SCB, SCBSPEEDY
    ...    ==>
    [Tags]    40.5.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${40_5_2_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}           Create List   
    ${expect_cardType}           Create List      MASTER    OTHER    VISA
    ${expect_master_bankAbbr}    Create List      SCB       SCBSPEEDY
    ${expect_other_bankAbbr}     Create List      SCB       SCBSPEEDY
    ${expect_visa_bankAbbr}      Create List      SCB       SCBSPEEDY    
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${value_bankAbbr}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].banks[*].bankAbbr
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Lists Should Be Equal            ${expect_master_bankAbbr}     ${value_bankAbbr}    ignore_order=${True}
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Lists Should Be Equal            ${expect_other_bankAbbr}      ${value_bankAbbr}    ignore_order=${True}
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Lists Should Be Equal            ${expect_visa_bankAbbr}       ${value_bankAbbr}    ignore_order=${True}
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_bankAbbr: "$.payments[${index_payments - 1}].banks[*].bankAbbr"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" check bankAbbr ต้องพบ SCB, SCBSPEEDY
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" check bankAbbr ต้องพบ SCB, SCBSPEEDY
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}--->    "banks" check bankAbbr ต้องพบ SCB, SCBSPEEDY
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "bankAbbr" == "${value_bankAbbr}"

                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_6_1)
    [Documentation]    Owner: Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.TR_PAYMENT tp 
    ...    left join SIT_CPC.TR_PAYMENT tp2 on tp2.TRADE_NO = tp.TRADE_NO and tp2.TRADE_PRODUCT_ID is not null
    ...    where tp.TRADE_PRODUCT_ID is null and tp2.TRADE_NO is null
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradeNo (config by tradeNo only)
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" check bankAbbr ต้องพบ BAY, BBL
    ...    2. "cardType": "OTHER"
    ...        "method": "CC"
    ...        "banks" check bankAbbr ต้องพบ BAY, BBL
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks" check bankAbbr ต้องพบ BAY, BBL
    ...    ==>
    [Tags]    40.6.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${40_6_1_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}           Create List   
    ${expect_cardType}           Create List      MASTER    OTHER    VISA
    ${expect_master_bankAbbr}    Create List      BAY       BBL
    ${expect_other_bankAbbr}     Create List      BAY       BBL
    ${expect_visa_bankAbbr}      Create List      BAY       BBL    
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${value_bankAbbr}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].banks[*].bankAbbr
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings          ${value_method}[0]     CC
                                                ${count_expect_bankAbbr}            Get Length          ${expect_master_bankAbbr} 
                                                FOR    ${index_expect_bankAbbr}    IN RANGE    1    ${count_expect_bankAbbr} + 1
                                                    List Should Contain Value        list_=${value_bankAbbr}     value=${expect_master_bankAbbr}[${index_expect_bankAbbr - 1}]    
                                                    ...    msg=bankAbbr is different, value="${value_bankAbbr}" is not contain value "${expect_master_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                    Log     bankAbbr: "${value_bankAbbr}" is contain value "${expect_master_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                END
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                ${count_expect_bankAbbr}            Get Length          ${expect_other_bankAbbr} 
                                                FOR    ${index_expect_bankAbbr}    IN RANGE    1    ${count_expect_bankAbbr} + 1
                                                    List Should Contain Value        list_=${value_bankAbbr}     value=${expect_other_bankAbbr}[${index_expect_bankAbbr - 1}]    
                                                    ...    msg=bankAbbr is different, value="${value_bankAbbr}" is not contain value "${expect_other_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                    Log     bankAbbr: "${value_bankAbbr}" is contain value "${expect_other_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                END
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                ${count_expect_bankAbbr}            Get Length          ${expect_visa_bankAbbr} 
                                                FOR    ${index_expect_bankAbbr}    IN RANGE    1    ${count_expect_bankAbbr} + 1
                                                    List Should Contain Value        list_=${value_bankAbbr}     value=${expect_visa_bankAbbr}[${index_expect_bankAbbr - 1}]    
                                                    ...    msg=bankAbbr is different, value="${value_bankAbbr}" is not contain value "${expect_visa_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                    Log     bankAbbr: "${value_bankAbbr}" is contain value "${expect_visa_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                END
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_bankAbbr: "$.payments[${index_payments - 1}].banks[*].bankAbbr"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "bankAbbr" == "${value_bankAbbr}"
                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_6_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradeNo (config by tradeNo and  tradeProductId)
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" length = 8
    ...    2. "cardType": "OTHER"
    ...       "method": "CC"
    ...       "banks" length = 8
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks"  length = 8
    ...    ==>
    [Tags]    40.6.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${40_6_2_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}    Create List   
    ${expect_cardType}    Create List      MASTER    OTHER    VISA
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${count_banks}       Get List Key And Count From Json               $.payments[${index_payments - 1}].banks
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_banks: "$.payments[${index_payments - 1}].banks"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 8
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 8
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}--->    "banks"  length = 8
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "banks_length" == "${count_banks}"
                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_7_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradeNo and tradeProductId (config by tradeNo only)
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" check bankAbbr ต้องพบ BAY, BBL
    ...    2. "cardType": "OTHER"
    ...       "method": "CC"
    ...       "banks" check bankAbbr ต้องพบ BAY, BBL
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks" check bankAbbr ต้องพบ BAY, BBL
    ...    ==>
    [Tags]    40.7.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${40_7_1_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}           Create List   
    ${expect_cardType}           Create List      MASTER    OTHER    VISA
    ${expect_master_bankAbbr}    Create List      BAY       BBL
    ${expect_other_bankAbbr}     Create List      BAY       BBL
    ${expect_visa_bankAbbr}      Create List      BAY       BBL    
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${value_bankAbbr}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].banks[*].bankAbbr
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                ${count_expect_bankAbbr}            Get Length          ${expect_master_bankAbbr} 
                                                FOR    ${index_expect_bankAbbr}    IN RANGE    1    ${count_expect_bankAbbr} + 1
                                                    List Should Contain Value        list_=${value_bankAbbr}     value=${expect_master_bankAbbr}[${index_expect_bankAbbr - 1}]    
                                                    ...    msg=bankAbbr is different, value="${value_bankAbbr}" is not contain value "${expect_master_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                    Log     bankAbbr: "${value_bankAbbr}" is contain value "${expect_master_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                END
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                ${count_expect_bankAbbr}            Get Length          ${expect_other_bankAbbr} 
                                                FOR    ${index_expect_bankAbbr}    IN RANGE    1    ${count_expect_bankAbbr} + 1
                                                    List Should Contain Value        list_=${value_bankAbbr}     value=${expect_other_bankAbbr}[${index_expect_bankAbbr - 1}]    
                                                    ...    msg=bankAbbr is different, value="${value_bankAbbr}" is not contain value "${expect_other_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                    Log     bankAbbr: "${value_bankAbbr}" is contain value "${expect_other_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                END
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                ${count_expect_bankAbbr}            Get Length          ${expect_visa_bankAbbr} 
                                                FOR    ${index_expect_bankAbbr}    IN RANGE    1    ${count_expect_bankAbbr} + 1
                                                    List Should Contain Value        list_=${value_bankAbbr}     value=${expect_visa_bankAbbr}[${index_expect_bankAbbr - 1}]    
                                                    ...    msg=bankAbbr is different, value="${value_bankAbbr}" is not contain value "${expect_visa_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                   Log     bankAbbr: "${value_bankAbbr}" is contain value "${expect_visa_bankAbbr}[${index_expect_bankAbbr - 1}]".
                                                END
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_bankAbbr: "$.payments[${index_payments - 1}].banks[*].bankAbbr"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "bankAbbr" == "${value_bankAbbr}"

                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

CPC_API_1_1_040 Get Payments (Conditions_Test_Case_7_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradeNo and tradeProductId (config by tradeNo and  tradeProductId)
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน payments ต้องพบข้อมูลต่อไปนี้
    ...    1. "cardType": "MASTER"
    ...       "method": "CC"
    ...       "banks" length = 8
    ...    2. "cardType": "OTHER"
    ...       "method": "CC"
    ...       "banks" length = 8
    ...    3. "cardType": "VISA",
    ...       "method": "CC",
    ...       "banks"  length = 8
    ...    ==>
    [Tags]    40.7.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${40_7_2_body_get_payments}
    Send Request API    url=${url_get_payments}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${actual_cardType}    Create List   
    ${expect_cardType}    Create List      MASTER    OTHER    VISA
    ${count_payments}     Get List Key And Count From Json    $.payments
    Should Be True        int(${count_payments}) > int(0)
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
            ${value_cardType}    Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].cardType
            IF    $value_cardType[0] != $None
                    FOR    ${cardType}    IN    @{expect_cardType}
                            ${status_cardType}    Run Keyword And Return Status    Should Be Equal As Strings       ${value_cardType}[0]     ${cardType}
                            IF    ${status_cardType} == ${True}
                                    Append To List      ${actual_cardType}        ${value_cardType}[0]
                                    ${value_method}      Get Value From Json      ${response.json()}    $.payments[${index_payments - 1}].method
                                    ${count_banks}       Get List Key And Count From Json               $.payments[${index_payments - 1}].banks
                                    IF         "${value_cardType}[0]" == "MASTER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE IF    "${value_cardType}[0]" == "OTHER"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE IF    "${value_cardType}[0]" == "VISA"
                                                Should Be Equal As Strings       ${value_method}[0]     CC
                                                Should Be True                   int(${count_banks}) == int(8)
                                    ELSE
                                        Fail    No support cardtype "${value_cardType}[0]".
                                    END
                                    ${result}    Catenate
                                    ...    ${\n}---> loop payments: "${index_payments}"
                                    ...    ${\n}---> json_path_cardType: "$.payments[${index_payments - 1}].cardType"
                                    ...    ${\n}---> json_path_method: "$.payments[${index_payments - 1}].method"
                                    ...    ${\n}---> json_path_banks: "$.payments[${index_payments - 1}].banks"
                                    ...    ${\n}---> condition: ใน payments ต้องพบข้อมูลต่อไปนี้
                                    ...    ${\n}---> 1. "cardType": "MASTER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 8
                                    ...    ${\n}---> 2. "cardType": "OTHER"
                                    ...    ${\n}--->    "method": "CC"
                                    ...    ${\n}--->    "banks" length = 8
                                    ...    ${\n}---> 3. "cardType": "VISA",
                                    ...    ${\n}--->    "method": "CC",
                                    ...    ${\n}--->    "banks"  length = 8
                                    ...    ${\n}---> "cardType" == "${value_cardType}[0]"
                                    ...    ${\n}---> "method" == "${value_method}[0]"
                                    ...    ${\n}---> "banks_length" == "${count_banks}"
                                    Log    ${result}
                            END
                    END
            END
    END
    Log Many    Actual: ${actual_cardType}
    Log Many    Expect: ${expect_cardType}
    Lists Should Be Equal    ${expect_cardType}    ${actual_cardType}    ignore_order=${True}

CPC_API_1_1_041 Get AIS Points
    [Documentation]    Owner : Patipan.w  Edit : Attapon
    [Tags]   41
    Set API Header Default
    Set Body API        schema_body=${41_body_get_ais_points}
    Send Request API    url=${url_get_ais_points}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${41_response_get_ais_points}
    Verify Value Response By Key    $..status        20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_041 Get AIS Points (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    *** CMD SQL ***
    ...    SELECT * FROM SIT_CPC.AIS_POINT_MASTER 
    ...    ==>
    ...    *** Condition ***
    ...    - AisPoints from DT active
    ...    ==>
    ...    *** Expect Result ***
    ...    1. points.length = 2
    ...    2. points ทุกตัวมีค่า "groupId" = 12
    ...    ==>
    [Tags]    41.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${41_1_body_get_ais_points}
    Send Request API    url=${url_get_ais_points}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_points}    Get List Key And Count From Json    $.points
    Should Be True    int(${count_points}) == int(2)
    FOR    ${index_points}  IN RANGE   1    ${count_points} + 1
            ${value_groupId}    Get Value From Json    ${response.json()}    $.points[${index_points - 1}].groupId
            Should Be Equal As Strings     ${value_groupId}[0]     12
            ${result}    Catenate
            ...    ${\n}---> loop points: "${index_points}"
            ...    ${\n}---> json_path_groupId: "$.points[${index_points - 1}].groupId"
            ...    ${\n}---> condition: "points.length = 2"
            ...    ${\n}---> condition: "points ทุกตัวมีค่า "groupId" = 12"
            ...    ${\n}---> "points.length" == "${count_points}"
            ...    ${\n}---> "groupId" == "${value_groupId}[0]"
            Log    ${result}
    END

CPC_API_1_1_041 Get AIS Points (Conditions_Test_Case_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - AisPoints from DT not active
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    41.2     Conditions        
    Set API Header Default
    Set Body API        schema_body=${41_2_body_get_ais_points}
    Send Request API    url=${url_get_ais_points}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}   Get Value From Json     ${response.json()}    $.status
    Should Be Equal As Strings   ${value_status}[0]    40401
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_042 Search Products by Criteria
    [Documentation]    Owner : Patipan.w  Edit : Attapon
    [Tags]   42
    Set API Header Default
    Set Body API        schema_body=${42_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${42_response_search_products_by_criteria}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_042 Search Products by Criteria (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by catalogType
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมีค่า catalogProducts[0].catalogType = "Accessories"
    ...    ==>
    [Tags]    42.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${42_1_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_catalogProducts}   Get List Key And Count From Json    $.products[${index_products - 1}].catalogProducts
            Should Be True    int(${count_catalogProducts}) == int(1)
            ${value_catalogType}           Get Value From Json         ${response.json()}    $.products[${index_products - 1}].catalogProducts[0].catalogType
            Should Be Equal As Strings     ${value_catalogType}[0]     Accessories
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_catalogType: "$.products[${index_products - 1}].catalogProducts[0].catalogType"
            ...    ${\n}---> condition: "products ทุกตัวมีค่า catalogProducts[0].catalogType = Accessories"
            ...    ${\n}---> "catalogType" == "${value_catalogType}[0]"
            Log    ${result}
    END

CPC_API_1_1_042 Search Products by Criteria (Conditions_Test_Case_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by catalogSubType
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมีค่า catalogProducts[0].catalogSubType = "ACCESSORIES FOR AIRTAG"
    ...    ==>
    [Tags]    42.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${42_2_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_catalogProducts}   Get List Key And Count From Json      $.products[${index_products - 1}].catalogProducts
            Should Be True    int(${count_catalogProducts}) == int(1)
            ${value_catalogSubType}           Get Value From Json           ${response.json()}    $.products[${index_products - 1}].catalogProducts[0].catalogSubType
            Should Be Equal As Strings       ${value_catalogSubType}[0]     ACCESSORIES FOR AIRTAG
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_catalogSubType: "$.products[${index_products - 1}].catalogProducts[0].catalogSubType"
            ...    ${\n}---> condition: "products ทุกตัวมีค่า catalogProducts[0].catalogSubType = ACCESSORIES FOR AIRTAG"
            ...    ${\n}---> "catalogSubType" == "${value_catalogSubType}[0]"
            Log    ${result}
    END

CPC_API_1_1_042 Search Products by Criteria (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by catalogType and catalogSubType
    ...    ==>
    ...    *** Expect Result ***
    ...    - products.length = 0
    ...    ==>
    [Tags]    42.3.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${42_3_1_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    Should Be True    int(${count}) == int(0)
    Log    ---> Object.keys(products).length(${count}) == 0

CPC_API_1_1_042 Search Products by Criteria (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by catalogType and catalogSubType
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมีค่า catalogProducts[0].catalogType = "Gadget" 
    ...    - และ              catalogProducts[0].catalogSubType = "TABLET"
    ...    ==>
    [Tags]    42.3.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${42_3_2_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_catalogProducts}   Get List Key And Count From Json      $.products[${index_products - 1}].catalogProducts
            Should Be True    int(${count_catalogProducts}) == int(1)
            ${value_catalogType}              Get Value From Json           ${response.json()}    $.products[${index_products - 1}].catalogProducts[0].catalogType
            ${value_catalogSubType}           Get Value From Json           ${response.json()}    $.products[${index_products - 1}].catalogProducts[0].catalogSubType
            Should Be Equal As Strings       ${value_catalogType}[0]        Gadget
            Should Be Equal As Strings       ${value_catalogSubType}[0]     TABLET
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_catalogType: "$.products[${index_products - 1}].catalogProducts[0].catalogType"
            ...    ${\n}---> json_path_catalogSubType: "$.products[${index_products - 1}].catalogProducts[0].catalogSubType"
            ...    ${\n}---> condition: "products ทุกตัวมีค่า catalogProducts[0].catalogType = Gadget"
            ...    ${\n}---> condition: "products ทุกตัวมีค่า catalogProducts[0].catalogSubType = TABLET"
            ...    ${\n}---> "catalogType" == "${value_catalogType}[0]"
            ...    ${\n}---> "catalogSubType" == "${value_catalogSubType}[0]"
            Log    ${result}
    END

CPC_API_1_1_042 Search Products by Criteria (Conditions_Test_Case_4)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by category
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมีค่า catalogProducts[0].category ต้องตรงกับค่าที่ request เข้าไป (เป็น insensitive case)
    ...    ==>
    [Tags]    42.4     Conditions    
    Set API Header Default
    Set Body API        schema_body=${42_4_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    ${body_category}    Get Value From Json     ${API_BODY}     $.category
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_catalogProducts}   Get List Key And Count From Json      $.products[${index_products - 1}].catalogProducts
            Should Be True    int(${count_catalogProducts}) == int(1)
            ${value_category}              Get Value From Json           ${response.json()}    $.products[${index_products - 1}].catalogProducts[0].category
            Should Contain    ${value_category}[0]    ${body_category}[0]    ignore_case=${True}
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_category: "$.products[${index_products - 1}].catalogProducts[0].category"
            ...    ${\n}---> condition: "products ทุกตัวมีค่า catalogProducts[0].category ที่มีคำว่า CASE (เป็น sensitive case)"
            ...    ${\n}---> "category" == "${value_category}[0]"
            Log    ${result}
    END

CPC_API_1_1_042 Search Products by Criteria (Conditions_Test_Case_5)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by catalogType and catalogSubType and category
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมีค่า catalogProducts[0].catalogType = ต้องตรงกับค่าที่ request เข้าไป (เป็น insensitive case)
    ...    และ                catalogProducts[0].catalogSubType = ต้องตรงกับค่าที่ request เข้าไป (เป็น insensitive case)
    ...    และ                catalogProducts[0].category ต้องตรงกับค่าที่ request เข้าไป (เป็น insensitive case)
    ...    ==>
    [Tags]    42.5     Conditions    
    Set API Header Default
    Set Body API        schema_body=${42_5_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    ${body_category}    Get Value From Json     ${API_BODY}     $.category
    ${body_catalogSubType}    Get Value From Json     ${API_BODY}     $.catalogSubType
    ${body_catalogType}    Get Value From Json     ${API_BODY}     $.catalogType
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_catalogProducts}   Get List Key And Count From Json      $.products[${index_products - 1}].catalogProducts
            Should Be True    int(${count_catalogProducts}) == int(1)
            ${value_catalogType}              Get Value From Json           ${response.json()}    $.products[${index_products - 1}].catalogProducts[0].catalogType
            ${value_catalogSubType}           Get Value From Json           ${response.json()}    $.products[${index_products - 1}].catalogProducts[0].catalogSubType
            ${value_category}                 Get Value From Json           ${response.json()}    $.products[${index_products - 1}].catalogProducts[0].category
            Should Be Equal As Strings       ${value_catalogType}[0]        ${body_catalogType}[0]
            Should Be Equal As Strings       ${value_catalogSubType}[0]     ${body_catalogSubType}[0]
            Should Contain                   ${value_category}[0]           ${body_category}[0]       ignore_case=${True}
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_catalogType: "$.products[${index_products - 1}].catalogProducts[0].catalogType"
            ...    ${\n}---> json_path_catalogSubType: "$.products[${index_products - 1}].catalogProducts[0].catalogSubType"
            ...    ${\n}---> json_path_category: "$.products[${index_products - 1}].catalogProducts[0].category"
            ...    ${\n}---> "catalogType" == "${value_catalogType}[0]"
            ...    ${\n}---> "catalogSubType" == "${value_catalogSubType}[0]"
            ...    ${\n}---> "category" == "${value_category}[0]"
            Log    ${result}
    END

CPC_API_1_1_042 Search Products by Criteria (Conditions_Test_Case_6_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    - products.length = 5
    ...    ==>
    [Tags]    42.6.1     Conditions        
    Set API Header Default
    Set Body API        schema_body=${42_6_1_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    Should Be True    int(${count}) == int(5)
    Log    ---> Object.keys(products).length(${count}) == 5

CPC_API_1_1_042 Search Products by Criteria (Conditions_Test_Case_6_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    - products.length = total - (offset-1)
    ...    - ** SA แจ้งเปลี่ยน "offset" เป็น "19"  7/5/2567 **
    ...    ==>
    [Tags]    42.6.2     Conditions        
    Set API Header Default
    Set Body API        schema_body=${42_6_2_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${products_length}    Get List Key And Count From Json          $.products
    ${total}    Get Value From Json     ${response.json()}          $.total
    ${body_offset}    Get Value From Json     ${API_BODY}           $.offset
    ${data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${products_length}) == int(${data_length})
    ${result}    Catenate
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_products_length == "${products_length}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> data_length: int(${total}[0] - (${body_offset}[0] - 1) == "${data_length}"
    ...    ${\n}---> "$data_length(${data_length})" == "$resp_products_length(${products_length})"
    Log    ${result}

CPC_API_1_1_042 Search Products by Criteria (Conditions_Test_Case_7)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by commercialName
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมีค่า commercialName ต้องตรงกับค่าที่ request เข้าไป (เป็น insensitive case)
    ...    ==>
    [Tags]    42.7     Conditions    
    Set API Header Default
    Set Body API        schema_body=${42_7_body_search_products_by_criteria}
    Send Request API    url=${url_search_products_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)    
    ${body_commercialName}    Get Value From Json     ${API_BODY}     $.commercialName
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${value_commercialName}    Get Value From Json    ${response.json()}    $.products[${index_products - 1}].commercialName
            Should Contain    ${value_commercialName}[0]    ${body_commercialName}[0]    ignore_case=${True}
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products - 1}"
            ...    ${\n}---> json_path_commercialName: "$.products[${index_products - 1}].commercialName"
            ...    ${\n}---> condition: "products ทุกตัวมีค่า commercialName ที่มีคำว่า SAMSUNG ADAPTOR 25W"
            ...    ${\n}---> "commercialName" == "${value_commercialName}[0]"
            Log    ${result}
    END

CPC_API_1_1_043 Get Product with Promotions by Product
    [Documentation]    Owner : Patipan.w
    [Tags]   43      Conditions
    Set API Header Default
    Set Body API        schema_body=${43_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${43_response_get_product_with_promotions_by_product}
    Verify Value Response By Key    $..status        20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_1_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter required
    ...    - parameter ไม่ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    statusCode = 50000
    ...    ==>
    [Tags]    43.1.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${43_1_1_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=500
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    50000 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "50000"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_1_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter matCode 
    ...    - parameter ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length > 0
    ...    ==>
    [Tags]    43.1.2     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_1_2_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    Should Be True    int(${count}) > int(0)
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    20000 
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length > 0
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> "products" == "${count}"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_1_3)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter brand, model, color 
    ...    - parameter ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length > 0
    ...    ==>
    [Tags]    43.1.3     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_1_3_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    Should Be True    int(${count}) > int(0)
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    20000 
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length > 0
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> "products" == "${count}"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_1_4)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter brand, model, color 
    ...    - parameter ไม่ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    statusCode = 50000
    ...    ==>
    [Tags]    43.1.4     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_1_4_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=500
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    50000 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "50000"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by regularPrice **MOC
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. ใน products ทุกตัวจะต้องมี trades[0].discounts.tradeDiscountId = 145677 เท่านั้น 
    ...    (ที่ sit มี set  ไว้แค่ 4 trade อาจมีเปลี่ยนแปลงได้ ** "endDate": "2024-12-31" )
    ...    ==>
    [Tags]    43.2.1     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_2_1_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json             $.products
    ${value_status}      Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings                  ${value_status}[0]    20000
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${count_discounts}    Get List Key And Count From Json    $.products[${index_products - 1}].trades[0].discounts
            Should Be True    int(${count_discounts}) > int(0)
            FOR  ${index_discounts}  IN RANGE   1    ${count_discounts} + 1
            ${value_tradeDiscountId}      Get Value From Json     ${response.json()}    $.products[${index_products - 1}].trades[0].discounts[${index_discounts - 1}].tradeDiscountId          
            Should Be True    int(${value_tradeDiscountId}[0]) == int(145677)
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_tradeDiscountId: "$.products[${index_products - 1}].trades[0].discounts[${index_discounts - 1}].tradeDiscountId "
            ...    ${\n}---> condition: "status" = "20000"
            ...    ${\n}---> condition: "ใน products จะต้องมี trades[0].discounts.tradeDiscountId = 145677"
            ...    ${\n}---> "tradeDiscountId" == "${value_tradeDiscountId}[0]"
            ...    ${\n}---> "status" == "${value_status}[0]"
            Log    ${result}
            END
    END

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by regularPrice **MOC
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    43.2.2     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_2_2_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_2_3)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by regularPrice ** Non MOC
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน products จะต้องไม่พบ tradeNo (trades[0].tradeNo) ต่อไปนี้ 
    ...    TP22054718
    ...    TP22054719
    ...    TP22054721
    ...    TP22054722
    ...    TP22054724
    ...    TP22054726
    ...    TP22064743
    ...    ==>
    [Tags]    43.2.3     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_2_3_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${expect_not_contain_tradeNo}    Create List    
    ...    TP22054718  TP22054719  TP22054721  TP22054722 TP22054724  TP22054726  TP22064743
    ${count_products}    Get List Key And Count From Json             $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_tradeNo}      Get Value From Json     ${response.json()}    $.products[${index_products - 1}].trades[0].tradeNo
            List Should Not Contain Value    ${expect_not_contain_tradeNo}    ${value_tradeNo}[0]
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_tradeNo: "$.products[${index_products - 1}].trades[0].tradeNo"
            ...    ${\n}---> condition: ใน products จะต้องไม่พบ tradeNo (trades[0].tradeNo) ต่อไปนี้ 
            ...    ${\n}---> ${expect_not_contain_tradeNo}
            ...    ${\n}---> "tradeNo" == "${value_tradeNo}[0]"
            Log    ${result}
    END

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by orderTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>    
    [Tags]    43.3.1     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_3_1_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by orderTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...    - ใน products ทุกตัวจะต้องพบ "Convert Pre to Post" อยู่ใน criterias (trades[0].criterias[index].criteria) 
    ...    ==>
    [Tags]    43.3.2     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_3_2_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_criteria}           Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].criteria
            List Should Contain Value    ${value_criteria}[0]    Convert Pre to Post
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_criteria: "$.products[${index_products - 1}].trades[0].criterias[*].criteria"
            ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ "Convert Pre to Post" อยู่ใน criterias (trades[0].criterias[index].criteria)"
            ...    ${\n}---> "criteria" == "${value_criteria}[0]"
            Log    ${result}
    END

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by chargeTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    43.4.1     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_4_1_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by chargeTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "Existing" อยู่ใน criterias (trades[0].criterias[index].criteria) 
    ...    2. "Pre-paid" อยู่ใน criterias (trades[0].criterias[index].chargeType) 
    ...    ==>
    [Tags]    43.4.2     Conditions        
    Set API Header Default
    Set Body API        schema_body=${43_4_2_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_criteria}            Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].criteria
            ${value_chargeType}          Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].chargeType
            List Should Contain Value    ${value_criteria}[0]      Existing
            List Should Contain Value    ${value_chargeType}[0]    Pre-paid
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_criteria: "$.products[${index_products - 1}].trades[0].criterias[*].criteria"
            ...    ${\n}---> json_path_chargeType: "$.products[${index_products - 1}].trades[0].criterias[*].chargeType"
            ...    ${\n}---> condition: "Existing อยู่ใน criterias (trades[0].criterias[index].criteria)"
            ...    ${\n}---> condition: "Pre-paid อยู่ใน criterias (trades[0].criterias[index].chargeType)"
            ...    ${\n}---> "criteria" == "${value_criteria}[0]"
            ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
            Log    ${result}
    END

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_5_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by saleChannels 
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    43.5.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${43_5_1_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_6_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by blacklistAcrossOper
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    43.6.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${43_6_1_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_6_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by blacklistAcrossOper 
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. products[index].campaign[index].requireCheckBlacklistAcrossOper = 'Y"
    ...    - 2. products[index].trades[index].criterias[index].blacklistAcrossOper = ['1']
    ...    ==>
    [Tags]    43.6.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${43_6_2_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_campaigns}   Get List Key And Count From Json    $.products[${index_products - 1}].campaigns
            Should Be True    int(${count_campaigns}) > int(0)
            FOR    ${index_campaigns}  IN RANGE   1    ${count_campaigns} + 1
                    ${value_requireCheckBlacklistAcrossOper}    Get Value From Json    ${response.json()}    $.products[${index_products - 1}].campaigns[${index_campaigns - 1}].requireCheckBlacklistAcrossOper
                    Should Be Equal As Strings       ${value_requireCheckBlacklistAcrossOper}[0]     Y
                    ${result}    Catenate
                    ...    ${\n}---> loop products: "${index_products}"
                    ...    ${\n}---> json_path_requireCheckBlacklistAcrossOper: "$.products[${index_products - 1}].campaigns[${index_campaigns - 1}].requireCheckBlacklistAcrossOper"
                    ...    ${\n}---> condition: products[index].campaign[index].requireCheckBlacklistAcrossOper = "Y"
                    ...    ${\n}---> "requireCheckBlacklistAcrossOper" == "${value_requireCheckBlacklistAcrossOper}[0]"
                    Log    ${result}
            END
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) > int(0)
            FOR    ${index_trades}  IN RANGE   1    ${count_trades} + 1
                    ${value_blacklistAcrossOper}    Get Value From Json    ${response.json()}    $.products[${index_products - 1}].trades[${index_trades - 1}].criterias[*].blacklistAcrossOper
                    Should Be Equal As Strings      ${value_blacklistAcrossOper[0]}[0]     1
                    ${result}    Catenate
                    ...    ${\n}---> loop products: "${index_products}"
                    ...    ${\n}---> json_path_blacklistAcrossOper: "$.products[${index_products - 1}].trades[${index_trades - 1}].criterias[*].blacklistAcrossOper"
                    ...    ${\n}---> condition: products[index].trades[index].criterias[index].blacklistAcrossOper = ['1']
                    ...    ${\n}---> "blacklistAcrossOper" == "${value_blacklistAcrossOper}[0]"
                    Log    ${result}
            END
    END    

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_7_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by aspFlag 
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    43.7.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${43_7_1_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_7_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by aspFlag 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length > 0 **ข้อมูลอาจจะเปลี่ยนตาม config จาก DT
    ...    ==>
    [Tags]    43.7.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${43_7_2_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings                 ${value_status}[0]    20000
    Should Be True    int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> "status" == "${value_status}[0]"
    ...    ${\n}---> "$data_length(${count})" > "0"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_8_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length == 3 
    ...    ==>
    [Tags]    43.8.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${43_8_1_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings                 ${value_status}[0]    20000
    Should Be True    int(${count}) == int(3)
    ${result}    Catenate
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> "status" == "${value_status}[0]"
    ...    ${\n}---> "$data_length(${count})" == "3"
    Log    ${result}

CPC_API_1_1_043 Get Product with Promotions by Product (Conditions_Test_Case_8_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length == total - (offset-1) 
    ...    ==>
    [Tags]    43.8.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${43_8_2_body_get_product_with_promotions_by_product}
    Send Request API    url=${url_get_product_with_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${products_length}    Get List Key And Count From Json          $.products
    ${total}    Get Value From Json     ${response.json()}          $.total
    ${body_offset}    Get Value From Json     ${API_BODY}           $.offset
    ${value_status}   Get Value From Json     ${response.json()}    $.status
    ${data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${products_length}) == int(${data_length})
    Should Be Equal As Strings   ${value_status}[0]    20000
    ${result}    Catenate
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_products_length == "${products_length}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> data_length: int(${total}[0] - (${body_offset}[0] - 1) == "${data_length}"
    ...    ${\n}---> "$data_length(${data_length})" == "$resp_products_length(${products_length})"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_044 Get Trade Limit Quota by Location
    [Documentation]    Owner : Patipan.w  Edit : Attapon
    [Tags]   44
    Set API Header Default
    Set Body API        schema_body=${44_body_get_trade_limit_quota_by_location}
    Send Request API    url=${url_get_trade_limit_quota_by_location}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${44_response_get_trade_limit_quota_by_location}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_044 Get Trade Limit Quota by Location (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - location not config
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    44.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${44_1_body_get_trade_limit_quota_by_location}
    Send Request API    url=${url_get_trade_limit_quota_by_location}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_044 Get Trade Limit Quota by Location (Conditions_Test_Case_2)
    [Documentation]    Owner: Patipan.w
    ...    select qg.GROUP_CODE ,qg.GROUP_NAME,qg.EFFECTIVE_START_DATE,qg.EFFECTIVE_END_DATE
    ...                    ,ql.LOCATION_CODE,ql.QUOTA_LIMIT,qc.CRITERIA_NAME,qc.CRITERIA_VALUE
    ...    from SIT_CPC.QUOTA_GROUP qg
    ...    left join SIT_CPC.QUOTA_LOCATION ql on ql.QUOTA_GROUP_ID = qg.ID
    ...    left join SIT_CPC.QUOTA_CRITERIA qc on qc.QUOTA_GROUP_ID = qg.ID
    ...    where 
    ...    qg.EFFECTIVE_START_DATE < ( DATEADD(day, 1, CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time') )
    ...    AND (qg.EFFECTIVE_END_DATE IS NULL OR qg.EFFECTIVE_END_DATE >  CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time' ) 
    ...    ==>
    ...    *** Condition ***
    ...    - location  config
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode = 20000
    ...    2. data.length > 0
    ...    ==>
    [Tags]    44.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${44_2_body_get_trade_limit_quota_by_location}
    Send Request API    url=${url_get_trade_limit_quota_by_location}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: data.length > 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "data.length" == "${count}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text
    [Documentation]    Owner : Patipan.w
    [Tags]   45    
    Set API Header Default
    Set Body API        schema_body=${45_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${45_response_search_campaign_with_discount_by_text}
    Verify Value Response By Key    $..status        20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_1_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter required
    ...    - parameter ไม่ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    statusCode = 50000
    ...    ==>
    [Tags]    45.1.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_1_1_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=500
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    50000 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "50000"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_1_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter matCode 
    ...    - parameter ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length > 0
    ...    ==>
    [Tags]    45.1.2     Conditions
    Set API Header Default
    Set Body API        schema_body=${45_1_2_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    20000
    Should Be True                 int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length > 0
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> "products" == "${count}"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_1_3)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter brand, model, color 
    ...    - parameter ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length > 0
    ...    ==>
    [Tags]    45.1.3     Conditions
    Set API Header Default
    Set Body API        schema_body=${45_1_3_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    20000
    Should Be True                 int(${count}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length > 0
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> "products" == "${count}"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_1_4)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter brand, model, color 
    ...    - parameter ไม่ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    statusCode = 50000
    ...    ==>
    [Tags]    45.1.4     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_1_4_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=500
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    50000 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "50000"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by regularPrice **MOC
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. ใน products ทุกตัวจะต้องมี trades[0].discounts.tradeDiscountId = 145677 เท่านั้น (ที่ sit มี set  ไว้แค่ 4 trade อาจมีเปลี่ยนแปลงได้ ** "endDate": "2024-12-31" )
    ...    3. ใน products จะต้องมี trades[0].discounts.tradeDiscountId = 145677
    ...    ==>
    [Tags]    45.2.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_2_1_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json             $.products
    ${value_status}      Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings                  ${value_status}[0]    20000
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${count_discounts}    Get List Key And Count From Json    $.products[${index_products - 1}].trades[0].discounts
            Should Be True    int(${count_discounts}) > int(0)
            FOR  ${index_discounts}  IN RANGE   1    ${count_discounts} + 1
            ${value_tradeDiscountId}      Get Value From Json     ${response.json()}    $.products[${index_products - 1}].trades[0].discounts[${index_discounts - 1}].tradeDiscountId          
            Should Be True    int(${value_tradeDiscountId}[0]) == int(145677)
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_tradeDiscountId: "$.products[${index_products - 1}].trades[0].discounts[${index_discounts - 1}].tradeDiscountId "
            ...    ${\n}---> condition: "status" = "20000"
            ...    ${\n}---> condition: "ใน products จะต้องมี trades[0].discounts.tradeDiscountId = 145677"
            ...    ${\n}---> "tradeDiscountId" == "${value_tradeDiscountId}[0]"
            ...    ${\n}---> "status" == "${value_status}[0]"
            Log    ${result}
            END
    END

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by regularPrice **MOC
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    45.2.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_2_2_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_2_3)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by regularPrice ** Non MOC
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน products จะต้องไม่พบ tradeNo (trades[0].tradeNo) ต่อไปนี้ 
    ...    TP22054718
    ...    TP22054719
    ...    TP22054721
    ...    TP22054722
    ...    TP22054724
    ...    TP22054726
    ...    TP22064743
    ...    ==>
    [Tags]    45.2.3     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_2_3_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${expect_not_contain_tradeNo}    Create List    
    ...    TP22054718  TP22054719  TP22054721  TP22054722 TP22054724  TP22054726  TP22064743
    ${count_products}    Get List Key And Count From Json             $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_tradeNo}      Get Value From Json     ${response.json()}    $.products[${index_products - 1}].trades[0].tradeNo
            List Should Not Contain Value    ${expect_not_contain_tradeNo}    ${value_tradeNo}[0]
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_tradeNo: "$.products[${index_products - 1}].trades[0].tradeNo"
            ...    ${\n}---> condition: ใน products จะต้องไม่พบ tradeNo (trades[0].tradeNo) ต่อไปนี้ 
            ...    ${\n}---> ${expect_not_contain_tradeNo}
            ...    ${\n}---> "tradeNo" == "${value_tradeNo}[0]"
            Log    ${result}
    END

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by orderTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    45.3.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_3_1_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by orderTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...    - ใน products ทุกตัวจะต้องพบ "Convert Pre to Post" อยู่ใน criterias (trades[0].criterias[index].criteria) 
    ...    ==>
    [Tags]    45.3.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_3_2_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_criteria}           Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].criteria
            List Should Contain Value    ${value_criteria}[0]    Convert Pre to Post
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_criteria: "$.products[${index_products - 1}].trades[0].criterias[*].criteria"
            ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ "Convert Pre to Post" อยู่ใน criterias (trades[0].criterias[index].criteria)"
            ...    ${\n}---> "criteria" == "${value_criteria}[0]"
            Log    ${result}
    END

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by chargeTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    45.4.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_4_1_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by chargeTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน products ทุกตัวจะต้องพบ
    ...    1. "Existing" อยู่ใน criterias (trades[0].criterias[index].criteria) 
    ...    2. "Pre-paid" อยู่ใน criterias (trades[0].criterias[index].chargeType) 
    ...    ==>
    [Tags]    45.4.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_4_2_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_criteria}            Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].criteria
            ${value_chargeType}          Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].chargeType
            List Should Contain Value    ${value_criteria}[0]      Existing
            List Should Contain Value    ${value_chargeType}[0]    Pre-paid
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_criteria: "$.products[${index_products - 1}].trades[0].criterias[*].criteria"
            ...    ${\n}---> json_path_chargeType: "$.products[${index_products - 1}].trades[0].criterias[*].chargeType"
            ...    ${\n}---> condition: "Existing อยู่ใน criterias (trades[0].criterias[index].criteria)"
            ...    ${\n}---> condition: "Pre-paid อยู่ใน criterias (trades[0].criterias[index].chargeType)"
            ...    ${\n}---> "criteria" == "${value_criteria}[0]"
            ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
            Log    ${result}
    END

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_5_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by searchText 
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    45.5.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_5_1_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_5_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by searchText 
    ...    ==>
    ...    *** Expect Result ***
    ...    - ใน products ทุกตัวจะต้องพบ campaigns[0].campaignName ที่มีคำว่า COMPENSATION หรือ Compensation หรือ compensation
    ...    ==>
    [Tags]    45.5.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_5_2_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_campaigns}   Get List Key And Count From Json    $.products[${index_products - 1}].campaigns
            Should Be True    int(${count_campaigns}) == int(1)
            ${value_campaignName}    Get Value From Json      ${response.json()}    $.products[${index_products - 1}].campaigns[0].campaignName
            Should Contain    ${value_campaignName}[0]    COMPENSATION    ignore_case=${True}
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_campaignName: "$.products[${index_products - 1}].campaigns[0].campaignName"
            ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ campaigns[0].campaignName ที่มีคำว่า COMPENSATION หรือ Compensation หรือ compensation  (เป็น sensitive case)"
            ...    ${\n}---> "campaignName" == "${value_campaignName}[0]"
            Log    ${result}
    END

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_6_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by blacklistAcrossOper 
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    45.6.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_6_1_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_6_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by blacklistAcrossOper 
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1. products[index].campaign[index].requireCheckBlacklistAcrossOper = 'Y"
    ...    - 2. products[index].trades[index].criterias[index].blacklistAcrossOper = ['1']
    ...    ==>
    [Tags]    45.6.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_6_2_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_campaigns}   Get List Key And Count From Json    $.products[${index_products - 1}].campaigns
            Should Be True    int(${count_campaigns}) > int(0)
            FOR    ${index_campaigns}  IN RANGE   1    ${count_campaigns} + 1
                    ${value_requireCheckBlacklistAcrossOper}    Get Value From Json    ${response.json()}    $.products[${index_products - 1}].campaigns[${index_campaigns - 1}].requireCheckBlacklistAcrossOper
                    Should Be Equal As Strings       ${value_requireCheckBlacklistAcrossOper}[0]     Y
                    ${result}    Catenate
                    ...    ${\n}---> loop products: "${index_products}"
                    ...    ${\n}---> json_path_requireCheckBlacklistAcrossOper: "$.products[${index_products - 1}].campaigns[${index_campaigns - 1}].requireCheckBlacklistAcrossOper"
                    ...    ${\n}---> condition: products[index].campaign[index].requireCheckBlacklistAcrossOper = "Y"
                    ...    ${\n}---> "requireCheckBlacklistAcrossOper" == "${value_requireCheckBlacklistAcrossOper}[0]"
                    Log    ${result}
            END
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) > int(0)
            FOR    ${index_trades}  IN RANGE   1    ${count_trades} + 1
                    ${value_blacklistAcrossOper}    Get Value From Json    ${response.json()}    $.products[${index_products - 1}].trades[${index_trades - 1}].criterias[*].blacklistAcrossOper
                    Should Be Equal As Strings      ${value_blacklistAcrossOper[0]}[0]     1
                    ${result}    Catenate
                    ...    ${\n}---> loop products: "${index_products}"
                    ...    ${\n}---> json_path_blacklistAcrossOper: "$.products[${index_products - 1}].trades[${index_trades - 1}].criterias[*].blacklistAcrossOper"
                    ...    ${\n}---> condition: products[index].trades[index].criterias[index].blacklistAcrossOper = ['1']
                    ...    ${\n}---> "blacklistAcrossOper" == "${value_blacklistAcrossOper}[0]"
                    Log    ${result}
            END
    END   

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_7_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by aspFlag 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length == 6 **ข้อมูลอาจจะเปลี่ยนตาม config จาก DT
    ...    ==>
    [Tags]    45.7.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_7_1_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    20000
    Should Be True                 int(${count}) == int(6)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length == 6
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> "products" == "${count}"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_7_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by aspFlag 
    ...    ==>
    ...    *** Expect Result ***
    ...    - status = 40401
    ...    ==>
    [Tags]    45.7.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_7_2_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_8_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length == maxRow 
    ...    
    ...    ==>
    [Tags]    45.8.1     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_8_1_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}       Get List Key And Count From Json        $.products
    ${body_max}    Get Value From Json     ${API_BODY}     $.max
    Should Be True    int(${count}) == int(${body_max}[0])
    ${result}    Catenate
    ...    ${\n}---> body_max: ${body_max}
    ...    ${\n}---> "$data_length(${count})" == "$body_max(${body_max}[0])"
    Log    ${result}

CPC_API_1_1_045 Search Campaign with Discount by Text (Conditions_Test_Case_8_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length == total - (offset-1) 
    ...    ==>
    [Tags]    45.8.2     Conditions    
    Set API Header Default
    Set Body API        schema_body=${45_8_2_body_search_campaign_with_discount_by_text}
    Send Request API    url=${url_search_campaign_with_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${products_length}    Get List Key And Count From Json          $.products
    ${total}    Get Value From Json     ${response.json()}          $.total
    ${body_offset}    Get Value From Json     ${API_BODY}           $.offset
    ${value_status}   Get Value From Json     ${response.json()}    $.status
    ${data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${products_length}) == int(${data_length})
    Should Be Equal As Strings   ${value_status}[0]    20000
    ${result}    Catenate
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_products_length == "${products_length}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> data_length: int(${total}[0] - (${body_offset}[0] - 1) == "${data_length}"
    ...    ${\n}---> "$data_length(${data_length})" == "$resp_products_length(${products_length})"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_046 Get Campaign By Trade Discount
    [Documentation]    Owner : Patipan.w  Edit : Attapon
    [Tags]   46
    Set API Header Default
    Set Body API        schema_body=${46_body_get_campaign_by_trade_discount}
    Send Request API    url=${url_get_campaign_by_trade_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${46_response_get_campaign_by_trade_discount}
    Verify Value Response By Key    $..status        20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_046 Get Campaign By Trade Discount (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode = 30000
    ...    ==>
    [Tags]    46.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${46_1_body_get_campaign_by_trade_discount}
    Send Request API    url=${url_get_campaign_by_trade_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${46_1_response_get_campaign_by_trade_discount}

CPC_API_1_1_046 Get Campaign By Trade Discount (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    *** CMD SQL ***
    ...    select cn.LOCATION_CODE, cn.SALE_CHANNEL,c.NAME as CAMPAIGN_NAME, c.CODE as CAMPAIGN_CODE, d.*
    ...    ,p.PRODUCT_ID,p.BRAND,p.MODEL,p.COLOR,p.MAT_CODE,p.PRODUCT_TYPE,p.PRODUCT_SUBTYPE
    ...    ,air.TRADE_AIRTIME_ID, air.PRICE_INC_VAT, air.PAY_ADVANCE_GROUP_ID as AIR_PAY_ADVANCE_GROUP_ID
    ...    ,s.COMPANY, s.COMMERCIAL_NAME, PSPC.THUMBNAIL 
    ...    from SIT_CPC.TR_CN cn
    ...    inner join SIT_CPC.TR_PRODUCT trp on cn.TRADE_NO = trp.TRADE_NO
    ...    inner join SIT_CPC.TR_DISCOUNT d on d.TRADE_PRODUCT_ID = trp.TRADE_PRODUCT_ID
    ...    inner join SIT_CPC.PRODUCT_MST p on p.BRAND = trp.BRAND AND p.MODEL = trp.MODEL 
    ...    AND p.COLOR = ISNULL(trp.COLOR, p.COLOR) AND p.MAT_CODE = ISNULL(trp.MAT_CODE, p.MAT_CODE) 
    ...    AND p.PRODUCT_TYPE = ISNULL(trp.PRODUCT_TYPE, p.PRODUCT_TYPE) 
    ...    AND p.PRODUCT_SUBTYPE = ISNULL(trp.PRODUCT_SUBTYPE, p.PRODUCT_SUBTYPE)
    ...    AND P.GRADE is null 
    ...    left join SIT_CPC.CAMPAIGN_TR_MST  ct on ct.TR_MST_TRADE_NO  = cn.TRADE_NO
    ...    left join SIT_CPC.CAMPAIGN c on c.ID = ct.CAMPAIGN_ID 
    ...    left join SIT_CPC.TR_AIRTIME air on air.TRADE_AIRTIME_ID = d.MATAIRTIME_ID
    ...    LEFT JOIN SIT_CPC.PUBLISH_SPEC PSPC ON PSPC.MAT_CODE = p.MAT_CODE
    ...    left join SIT_CPC.SUB_MODEL s on s.BRAND = p.BRAND AND s.MODEL = p.MODEL 
    ...    AND (s.MAT_CODE is null or s.MAT_CODE = p.MAT_CODE)
    ...    AND s.PRODUCT_TYPE =  p.PRODUCT_TYPE
    ...    AND s.PRODUCT_SUBTYPE =  p.PRODUCT_SUBTYPE
    ...    LEFT JOIN SIT_CPC.[MODEL_SUB_MODEL] AS MSM ON MSM.SUB_MODEL_ID = s.ID
    ...    LEFT JOIN SIT_CPC.[MODEL] AS MODEL ON MODEL.ID = MSM.MODEL_SUB_MODELS_ID
    ...    where cn.LOCATION_CODE is null  
    ...    -- cn.SALE_CHANNEL is null
    ...    order by d.END_DATE desc 
    ...    ==>
    ...    *** Condition ***
    ...    -  tradeDiscountId not config location 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.length == 1
    ...    2. data[0].tradeProductId = 143982   ** SA ให้ cancel test data[0].tradeProductId = 143982  (7/5/2567) **
    ...    3. data[0].location = 1100
    ...    4. data[0].saleChannels มีค่าที่เป็น "AISBUDDY" อยู่ 
    ...    ==>
    [Tags]    46.2.1    Conditions       
    Set API Header Default
    Set Body API        schema_body=${46_2_1_body_get_campaign_by_trade_discount}
    Send Request API    url=${url_get_campaign_by_trade_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) == int(1)
    # ${value_tradeProductId}    Get Value From Json    ${response.json()}    $.data[0].tradeProductId
    ${value_location}          Get Value From Json    ${response.json()}    $.data[0].location
    ${value_saleChannels}      Get Value From Json    ${response.json()}    $.data[0].saleChannels
    # Should Be Equal As Strings   ${value_tradeProductId}[0]   143982
    Should Be Equal As Strings   ${value_location}[0]         1100
    List Should Contain Value    ${value_saleChannels}[0]     AISBUDDY
    ${result}    Catenate
    # ...    ${\n}---> json_path_tradeProductId: "$.data[0].tradeProductId"
    ...    ${\n}---> json_path_location: "$.data[0].location"
    ...    ${\n}---> json_path_saleChannels: "$.data[0].saleChannels"
    ...    ${\n}---> condition: "data.length == 1"
    # ...    ${\n}---> condition: "data[0].tradeProductId = 143982"
    ...    ${\n}---> condition: "data[0].location = 1100"
    ...    ${\n}---> condition: "data[0].saleChannels มีค่าที่เป็น "AISBUDDY" อยู่"
    ...    ${\n}---> "data.length" == "${count_data}"
    # ...    ${\n}---> "tradeProductId" == "${value_tradeProductId}[0]"
    ...    ${\n}---> "location" == "${value_location}[0]"
    ...    ${\n}---> "saleChannels" == "${value_saleChannels}[0]"
    Log    ${result}

CPC_API_1_1_046 Get Campaign By Trade Discount (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    *** CMD SQL ***
    ...    select cn.LOCATION_CODE, cn.SALE_CHANNEL,c.NAME as CAMPAIGN_NAME, c.CODE as CAMPAIGN_CODE, d.*
    ...    ,p.PRODUCT_ID,p.BRAND,p.MODEL,p.COLOR,p.MAT_CODE,p.PRODUCT_TYPE,p.PRODUCT_SUBTYPE
    ...    ,air.TRADE_AIRTIME_ID, air.PRICE_INC_VAT, air.PAY_ADVANCE_GROUP_ID as AIR_PAY_ADVANCE_GROUP_ID
    ...    ,s.COMPANY, s.COMMERCIAL_NAME, PSPC.THUMBNAIL 
    ...    from SIT_CPC.TR_CN cn
    ...    inner join SIT_CPC.TR_PRODUCT trp on cn.TRADE_NO = trp.TRADE_NO
    ...    inner join SIT_CPC.TR_DISCOUNT d on d.TRADE_PRODUCT_ID = trp.TRADE_PRODUCT_ID
    ...    inner join SIT_CPC.PRODUCT_MST p on p.BRAND = trp.BRAND AND p.MODEL = trp.MODEL 
    ...    AND p.COLOR = ISNULL(trp.COLOR, p.COLOR) AND p.MAT_CODE = ISNULL(trp.MAT_CODE, p.MAT_CODE) 
    ...    AND p.PRODUCT_TYPE = ISNULL(trp.PRODUCT_TYPE, p.PRODUCT_TYPE) 
    ...    AND p.PRODUCT_SUBTYPE = ISNULL(trp.PRODUCT_SUBTYPE, p.PRODUCT_SUBTYPE)
    ...    AND P.GRADE is null 
    ...    left join SIT_CPC.CAMPAIGN_TR_MST  ct on ct.TR_MST_TRADE_NO  = cn.TRADE_NO
    ...    left join SIT_CPC.CAMPAIGN c on c.ID = ct.CAMPAIGN_ID 
    ...    left join SIT_CPC.TR_AIRTIME air on air.TRADE_AIRTIME_ID = d.MATAIRTIME_ID
    ...    LEFT JOIN SIT_CPC.PUBLISH_SPEC PSPC ON PSPC.MAT_CODE = p.MAT_CODE
    ...    left join SIT_CPC.SUB_MODEL s on s.BRAND = p.BRAND AND s.MODEL = p.MODEL 
    ...    AND (s.MAT_CODE is null or s.MAT_CODE = p.MAT_CODE)
    ...    AND s.PRODUCT_TYPE =  p.PRODUCT_TYPE
    ...    AND s.PRODUCT_SUBTYPE =  p.PRODUCT_SUBTYPE
    ...    LEFT JOIN SIT_CPC.[MODEL_SUB_MODEL] AS MSM ON MSM.SUB_MODEL_ID = s.ID
    ...    LEFT JOIN SIT_CPC.[MODEL] AS MODEL ON MODEL.ID = MSM.MODEL_SUB_MODELS_ID
    ...    where cn.LOCATION_CODE is not null and cn.SALE_CHANNEL is not null
    ...    order by d.END_DATE desc 
    ...    ==>
    ...    *** Condition ***
    ...    -  tradeDiscountId not config location 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.length == 1
    ...    2. data[0].tradeProductId = 143982     ** SA ให้ cancel test data[0].tradeProductId = 143982  (7/5/2567) **
    ...    3. data[0].location = 1122
    ...    4. data[0].saleChannels มีค่าที่เป็น "AISBUDDY" อยู่ 
    ...    ==>
    [Tags]    46.2.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${46_2_2_body_get_campaign_by_trade_discount}
    Send Request API    url=${url_get_campaign_by_trade_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) == int(1)
    # ${value_tradeProductId}    Get Value From Json    ${response.json()}    $.data[0].tradeProductId
    ${value_location}          Get Value From Json    ${response.json()}    $.data[0].location
    ${value_saleChannels}      Get Value From Json    ${response.json()}    $.data[0].saleChannels
    # Should Be Equal As Strings   ${value_tradeProductId}[0]   143982
    Should Be Equal As Strings   ${value_location}[0]         1122
    List Should Contain Value    ${value_saleChannels}[0]     AISBUDDY
    ${result}    Catenate
    # ...    ${\n}---> json_path_tradeProductId: "$.data[0].tradeProductId"
    ...    ${\n}---> json_path_location: "$.data[0].location"
    ...    ${\n}---> json_path_saleChannels: "$.data[0].saleChannels"
    ...    ${\n}---> condition: "data.length == 1"
    # ...    ${\n}---> condition: "data[0].tradeProductId = 143982"
    ...    ${\n}---> condition: "data[0].location = 1122"
    ...    ${\n}---> condition: "data[0].saleChannels มีค่าที่เป็น "AISBUDDY" อยู่"
    ...    ${\n}---> "data.length" == "${count_data}"
    # ...    ${\n}---> "tradeProductId" == "${value_tradeProductId}[0]"
    ...    ${\n}---> "location" == "${value_location}[0]"
    ...    ${\n}---> "saleChannels" == "${value_saleChannels}[0]"
    Log    ${result}

CPC_API_1_1_046 Get Campaign By Trade Discount (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    -  tradeDiscountId config location and saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    1. data.length == 1
    ...    2. data[0].tradeProductId = 148721
    ...    3. data[0].location = 1501
    ...    4. data[0].saleChannels มีค่าที่เป็น "ALL AIS" อยู่ 
    ...    ==>
    [Tags]    46.3.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${46_3_1_body_get_campaign_by_trade_discount}
    Send Request API    url=${url_get_campaign_by_trade_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) == int(1)
    ${value_tradeProductId}    Get Value From Json    ${response.json()}    $.data[0].tradeProductId
    ${value_location}          Get Value From Json    ${response.json()}    $.data[0].location
    ${value_saleChannels}      Get Value From Json    ${response.json()}    $.data[0].saleChannels
    Should Be Equal As Strings   ${value_tradeProductId}[0]   148721
    Should Be Equal As Strings   ${value_location}[0]         1501
    List Should Contain Value    ${value_saleChannels}[0]     ALL AIS
    ${result}    Catenate
    ...    ${\n}---> json_path_tradeProductId: "$.data[0].tradeProductId"
    ...    ${\n}---> json_path_location: "$.data[0].location"
    ...    ${\n}---> json_path_saleChannels: "$.data[0].saleChannels"
    ...    ${\n}---> condition: "data.length == 1"
    ...    ${\n}---> condition: "data[0].tradeProductId = 148721"
    ...    ${\n}---> condition: "data[0].location = 1501"
    ...    ${\n}---> condition: "data[0].saleChannels มีค่าที่เป็น "ALL AIS" อยู่"
    ...    ${\n}---> "data.length" == "${count_data}"
    ...    ${\n}---> "tradeProductId" == "${value_tradeProductId}[0]"
    ...    ${\n}---> "location" == "${value_location}[0]"
    ...    ${\n}---> "saleChannels" == "${value_saleChannels}[0]"
    Log    ${result}

CPC_API_1_1_046 Get Campaign By Trade Discount (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    -  tradeDiscountId config location and saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    - data.length == 0
    ...    ==>
    [Tags]    46.3.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${46_3_2_body_get_campaign_by_trade_discount}
    Send Request API    url=${url_get_campaign_by_trade_discount}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.data
    Should Be True    int(${count}) == int(0)
    Log    ---> Object.keys(data).length(${count}) == 0

CPC_API_1_1_047 Get Campaigns
    [Documentation]    Owner : Kachain.a
    [Tags]   47
    Set API Header Default
    Set Body API        schema_body=${47_body_get_campaigns}
    Send Request API    url=${url_get_campaigns}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${47_response_get_campaigns}
    Verify Value Response By Key    $..statusCode        20000
    Verify Value Response By Key    $..statusDesc        Success
    Write Response To Json File

CPC_API_1_1_048 Get Free Goods 
    [Documentation]    Owner : Kachain.a
    [Tags]   48 
    Set API Header Default
    Set Body API        schema_body=${48_body_get_free_goods}
    Send Request API    url=${url_get_free_goods}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${48_response_get_free_goods}
    Verify Value Response By Key    $..statusCode        20000
    Verify Value Response By Key    $..statusDesc        Success
    Write Response To Json File

CPC_API_1_1_048 Get Free Goods (Conditions_Test_Case_1)
    [Documentation]    Owner: Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT * FROM SIT_CPC.TR_FREE_GOODS
    ...    order by END_DATE desc
    ...    ==>
    ...    *** Condition ***
    ...    - config active
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.freeGoods.length > 0
    ...    ==>
    [Tags]    48.1    Conditions 
    Set API Header Default
    Set Body API        schema_body=${48_1_body_get_free_goods}
    Send Request API    url=${url_get_free_goods}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_freeGoods}    Get List Key And Count From Json    $.freeGoods
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_freeGoods}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: freeGoods มี length > 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "freeGoods" == "${count_freeGoods}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_048 Get Free Goods (Conditions_Test_Case_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - config not active
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.freeGoods.length = 0
    ...    ==>
    [Tags]    48.2    Conditions
    Set API Header Default
    Set Body API        schema_body=${48_2_body_get_free_goods}
    Send Request API    url=${url_get_free_goods}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_freeGoods}    Get List Key And Count From Json    $.freeGoods
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_freeGoods}) == int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: freeGoods มี length == 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "freeGoods" == "${count_freeGoods}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_048 Get Free Goods (Conditions_Test_Case_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - config expriced
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.freeGoods.length = 0
    ...    ==>
    [Tags]    48.3    Conditions 
    Set API Header Default
    Set Body API        schema_body=${48_3_body_get_free_goods}
    Send Request API    url=${url_get_free_goods}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_freeGoods}    Get List Key And Count From Json    $.freeGoods
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_freeGoods}) == int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: freeGoods มี length == 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "freeGoods" == "${count_freeGoods}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_049 Get Location
    [Documentation]    Owner : Kachain.a    Edit : Patipan.w
    [Tags]   49        
    Set API Header Default
    Set Body API        schema_body=${49_body_get_location}
    Send Request API    url=${url_get_location}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${49_response_get_location}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_049 Get Location (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    *** CMD SQL ***
    ...    - SELECT * FROM SIT_CPC.LOCATION_MST
    ...    ==>
    ...    *** Condition ***
    ...    -  location active
    ...    ==>
    ...    *** Expect Result ***
   ...     1. statusCode = 20000
   ...     2. location != null
    ...    ==>
    [Tags]    49.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${49_1_body_get_location}
    Send Request API    url=${url_get_location}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_location}              Get Value From Json          ${response.json()}    $.location
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    Log Response Json              ${value_location}[0]
    Should Not Be Empty            ${value_location}[0]         msg=$.location is "null" or "none".
    Should Be Equal As Strings     ${value_statusCode}[0]       20000
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: location != null
    ...    ${\n}---> "location" == "${value_location}[0]"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_049 Get Location (Conditions_Test_Case_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    -  
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode = 20000
    ...    2. location = null
    ...    ==>
    [Tags]    49.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${49_2_body_get_location}
    Send Request API    url=${url_get_location}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_location}              Get Value From Json          ${response.json()}    $.location
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_location}[0]         ${None}
    Should Be Equal As Strings     ${value_statusCode}[0]       20000
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: location = "null"
    ...    ${\n}---> "location" == "${value_location}[0] or null"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_050 Get Product Price Options by Material Code
    [Documentation]    Owner : Kachain.a    Edit : Patipan.w
    [Tags]   50        
    Set API Header Default
    Set Body API        schema_body=${50_body_get_product_price_options_by_material_code}
    Send Request API    url=${url_get_product_price_options_by_mat_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${50_response_get_product_price_options_by_material_code}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_050 Get Product Price Options by Material Code (Conditions_Test_Case_1_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    ==>
    ...    *** Expect Result ***
    ...    - statusCode = 50000
    ...    ==>
    [Tags]    50.1.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${50_1_1_body_get_product_price_options_by_material_code}
    Send Request API    url=${url_get_product_price_options_by_mat_code}
    ...                 expected_status=500
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       50000
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "50000"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_050 Get Product Price Options by Material Code (Conditions_Test_Case_1_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - verify location
    ...    ==>
    ...    *** Expect Result ***
    ...    - statusCode = 40401
    ...    - statusDesc = "Location not found"
    ...    ==>
    [Tags]    50.1.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${50_1_2_body_get_product_price_options_by_material_code}
    Send Request API    url=${url_get_product_price_options_by_mat_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    ${value_statusDesc}            Get Value From Json          ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]       40401
    Should Be Equal As Strings     ${value_statusDesc}[0]       Location not found
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> condition: statusDesc = "Location not found"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_050 Get Product Price Options by Material Code (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    *** CMD SQL ***
    ...    WITH tradeByChannel as (      
    ...    SELECT DISTINCT CN.TRADE_NO
    ...              FROM [SIT_CPC].TR_CN CN
    ...              WHERE CN.LOCATION_CODE = 1100 
    ...            OR (CN.LOCATION_CODE IS NULL  
    ...                  AND (CN.PROVINCE = 'กรุงเทพ'
    ...                          OR (CN.PROVINCE = 'ALL'
    ...                                AND (CN.REGION = 'CB' OR CN.REGION = 'ALL')
    ...                                AND ( 
    ...                                        ( CN.SHOP_TYPE = 'RETAIL' OR  
    ...                                          ( 
    ...                                            (CN.SHOP_TYPE = 'ALL' OR  CN.SHOP_TYPE is null )
    ...                                            AND 
    ...                                            (  
    ...                                                (CN.SHOP_TYPE_GROUP = 'ALL' OR CN.SHOP_TYPE_GROUP is null)
    ...                                            )  
    ...                                          )  
    ...                                       )                                                
    ...                                        AND (CN.PUBLIC_NAME is null OR CN.PUBLIC_NAME = 'ALL') 
    ...                                       AND CN.SALE_CHANNEL in ('BRN','ALL AIS')   
    ...                                    )
    ...                          ) 
    ...                  ) 
    ...               ) 
    ...         ),
    ...  productOption as (
    ...     SELECT  ROW_NUMBER() OVER( ORDER BY TRPRD.TRADE_PRODUCT_ID, TRDC.OPTIONS, TRDC.TRADE_DISCOUNT_ID, TRPRV.TRADE_PRIVILEGE_ID) as RN,
    ...        TRPRD.TRADE_PRODUCT_ID, ISNULL(TRDC.DURATION_CONTRACT, TRPRD.DURATION_CONTRACT) AS DURATION_CONTRACT,
    ...        TRPRD.TRADE_NO, TRDC.OPTIONS, ISNULL(TRDC.CONTRACT_ID, TRPRD.CONTRACT_ID) AS CONTRACT_ID, TRPRD.MAX_RECEIVE_FREE_GOODS,
    ...         ISNULL(TRPRD.PAY_ADVANCE_GROUP_ID, TRDC.PAY_ADVANCE_GROUP_ID) AS PAY_ADVANCE_GROUP_ID, TRDC.TRADE_DISCOUNT_ID,
    ...         TRDC.TRADE_PRICE_INC_VAT, TRDC.TRADE_PRICE_EXC_VAT, TRDC.TRADE_PRICE_VAT_AMT, TRDC.DISCOUNT_BY,
    ...       TRDC.DISCOUNT_EXC, TRDC.DISCOUNT_INC_BY, TRDC.SPECIAL_DISC_INC, TRPRV.TRADE_PRIVILEGE_ID, TRPRV.PRIVILEGE_ID,
    ...         TRPRV.USSD_CODE, TRDC.LIMIT_CONTRACT,
    ...         CASE WHEN TRDC.PAY_ADVANCE_GROUP_ID IS NULL THEN 0 ELSE 1 END AS CHANGE_PACK
    ...       FROM [SIT_CPC].TR_PRODUCT TRPRD
    ...       INNER JOIN tradeByChannel tr on tr.TRADE_NO = TRPRD.TRADE_NO
    ...       INNER JOIN [SIT_CPC].TR_DISCOUNT TRDC ON TRDC.TRADE_PRODUCT_ID = TRPRD.TRADE_PRODUCT_ID
    ...      INNER JOIN [SIT_CPC].TR_MST TRMST ON TRMST.TRADE_NO = TRPRD.TRADE_NO
    ...      LEFT JOIN [SIT_CPC].TR_PRIVILEGE TRPRV ON TRDC.TRADE_PRIVILEGE_ID = TRPRV.TRADE_PRIVILEGE_ID OR (TRDC.TRADE_PRIVILEGE_ID IS NULL AND TRPRV.TRADE_PRODUCT_ID = TRPRD.TRADE_PRODUCT_ID)
    ...     WHERE ((TRPRD.START_DATE <= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time'  AND TRPRD.END_DATE >= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time')
    ...           AND (TRDC.TRADE_DISCOUNT_ID IS NULL OR (TRDC.START_DATE <= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time' AND TRDC.END_DATE >= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time')))
    ...      AND TRMST.SHOW_MC_CATALOG_FLAG = 'Y'
    ...       AND TRMST.SALE_TYPE = 'SALE'
    ...      AND
    ...       (
    ...          (TRPRD.PRODUCT_TYPE = 'ACCESSORY' AND TRPRD.PRODUCT_SUBTYPE = 'N/A'
    ...            AND TRPRD.BRAND IS NULL AND TRPRD.MODEL IS NULL AND TRPRD.COLOR IS NULL AND MAT_CODE IS NULL)
    ...          OR
    ...          (TRPRD.PRODUCT_TYPE = 'ACCESSORY' AND TRPRD.PRODUCT_SUBTYPE = 'N/A'
    ...            AND TRPRD.BRAND = 'APPLE' AND TRPRD.MODEL IS NULL AND TRPRD.COLOR IS NULL AND MAT_CODE IS NULL)
    ...          OR
    ...          (TRPRD.PRODUCT_TYPE = 'ACCESSORY' AND TRPRD.PRODUCT_SUBTYPE = 'N/A'
    ...            AND TRPRD.BRAND = 'APPLE' AND TRPRD.MODEL = 'CASEIPHONE' AND TRPRD.COLOR IS NULL AND MAT_CODE IS NULL)
    ...         OR
    ...          (TRPRD.PRODUCT_TYPE = 'ACCESSORY' AND TRPRD.PRODUCT_SUBTYPE = 'N/A'
    ...            AND TRPRD.BRAND = 'APPLE' AND TRPRD.MODEL = 'CASEIPHONE' AND TRPRD.COLOR = 'CLOVER' AND MAT_CODE IS NULL)
    ...          OR
    ...          (TRPRD.PRODUCT_TYPE = 'ACCESSORY' AND TRPRD.PRODUCT_SUBTYPE = 'N/A' AND MAT_CODE = '33016454')
    ...        )
    ...      )      
    ...      ,rowtotal as (
    ...       select max(RN) as TOTAL
    ...        from productOption
    ...      )
    ...      select
    ...      pro.* , rowtotal.TOTAL
    ...      from productOption pro
    ...      left join rowtotal on rowtotal.TOTAL > 0
    ...    ==>
    ...    *** Condition ***
    ...    - filter by productMaster
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode = 20000
    ...    2. priceOptions.length = 10
    ...    ==>
    [Tags]    50.2.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${50_2_1_body_get_product_price_options_by_material_code}
    Send Request API    url=${url_get_product_price_options_by_mat_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_priceOptions}     Get List Key And Count From Json              $.priceOptions
    ${value_statusCode}       Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_priceOptions}) == int(10)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: priceOptions.length = "10"
    ...    ${\n}---> "priceOptions" == "${count_priceOptions}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_050 Get Product Price Options by Material Code (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    *** CMD SQL ***
    ...    WITH tradeByChannel as (      
    ...              SELECT DISTINCT CN.TRADE_NO
    ...              FROM [SIT_CPC].TR_CN CN
    ...              WHERE CN.LOCATION_CODE = 1100 
    ...                OR (CN.LOCATION_CODE IS NULL  
    ...                      AND (CN.PROVINCE = 'กรุงเทพ'
    ...                              OR (CN.PROVINCE = 'ALL'
    ...                                    AND (CN.REGION = 'CB' OR CN.REGION = 'ALL')
    ...                                    AND ( 
    ...                                            ( CN.SHOP_TYPE = 'RETAIL' OR  
    ...                                              ( 
    ...                                                (CN.SHOP_TYPE = 'ALL' OR  CN.SHOP_TYPE is null )
    ...                                                AND 
    ...                                                (  
    ...                                                    (CN.SHOP_TYPE_GROUP = 'ALL' OR CN.SHOP_TYPE_GROUP is null)
    ...                                                )  
    ...                                              )  
    ...                                            )                                                
    ...                                             AND (CN.PUBLIC_NAME is null OR CN.PUBLIC_NAME = 'ALL') 
    ...                                             AND CN.SALE_CHANNEL in ('BRN','ALL AIS')   
    ...                                          )
    ...                                ) 
    ...                        ) 
    ...                    ) 
    ...             ),
    ...    productOption as (
    ...        SELECT  ROW_NUMBER() OVER( ORDER BY TRPRD.TRADE_PRODUCT_ID, TRDC.OPTIONS, TRDC.TRADE_DISCOUNT_ID, TRPRV.TRADE_PRIVILEGE_ID) as RN,
    ...          TRPRD.TRADE_PRODUCT_ID, ISNULL(TRDC.DURATION_CONTRACT, TRPRD.DURATION_CONTRACT) AS DURATION_CONTRACT,
    ...          TRPRD.TRADE_NO, TRDC.OPTIONS, ISNULL(TRDC.CONTRACT_ID, TRPRD.CONTRACT_ID) AS CONTRACT_ID, TRPRD.MAX_RECEIVE_FREE_GOODS,
    ...          ISNULL(TRPRD.PAY_ADVANCE_GROUP_ID, TRDC.PAY_ADVANCE_GROUP_ID) AS PAY_ADVANCE_GROUP_ID, TRDC.TRADE_DISCOUNT_ID,
    ...          TRDC.TRADE_PRICE_INC_VAT, TRDC.TRADE_PRICE_EXC_VAT, TRDC.TRADE_PRICE_VAT_AMT, TRDC.DISCOUNT_BY,
    ...          TRDC.DISCOUNT_EXC, TRDC.DISCOUNT_INC_BY, TRDC.SPECIAL_DISC_INC, TRPRV.TRADE_PRIVILEGE_ID, TRPRV.PRIVILEGE_ID,
    ...              TRPRV.USSD_CODE, TRDC.LIMIT_CONTRACT,
    ...             CASE WHEN TRDC.PAY_ADVANCE_GROUP_ID IS NULL THEN 0 ELSE 1 END AS CHANGE_PACK
    ...            FROM [SIT_CPC].TR_PRODUCT TRPRD
    ...            INNER JOIN tradeByChannel tr on tr.TRADE_NO = TRPRD.TRADE_NO
    ...            INNER JOIN [SIT_CPC].TR_DISCOUNT TRDC ON TRDC.TRADE_PRODUCT_ID = TRPRD.TRADE_PRODUCT_ID
    ...            INNER JOIN [SIT_CPC].TR_MST TRMST ON TRMST.TRADE_NO = TRPRD.TRADE_NO
    ...           LEFT JOIN [SIT_CPC].TR_PRIVILEGE TRPRV ON TRDC.TRADE_PRIVILEGE_ID = TRPRV.TRADE_PRIVILEGE_ID OR (TRDC.TRADE_PRIVILEGE_ID IS NULL AND TRPRV.TRADE_PRODUCT_ID = TRPRD.TRADE_PRODUCT_ID)
    ...            WHERE ((TRPRD.START_DATE <= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time'  AND TRPRD.END_DATE >= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time')
    ...                AND (TRDC.TRADE_DISCOUNT_ID IS NULL OR (TRDC.START_DATE <= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time' AND TRDC.END_DATE >= CONVERT(datetimeoffset, SYSDATETIMEOFFSET()) AT TIME ZONE 'SE Asia Standard Time')))
    ...        AND TRMST.SHOW_MC_CATALOG_FLAG = 'Y'
    ...        AND TRMST.SALE_TYPE = 'SALE'
    ...        AND
    ...        (
    ...          (TRPRD.PRODUCT_TYPE = 'DEVICE' AND TRPRD.PRODUCT_SUBTYPE = 'HANDSET'
    ...            AND TRPRD.BRAND IS NULL AND TRPRD.MODEL IS NULL AND TRPRD.COLOR IS NULL AND MAT_CODE IS NULL)
    ...          OR
    ...              (TRPRD.PRODUCT_TYPE = 'DEVICE' AND TRPRD.PRODUCT_SUBTYPE = 'HANDSET'
    ...                AND TRPRD.BRAND = 'APPLE' AND TRPRD.MODEL IS NULL AND TRPRD.COLOR IS NULL AND MAT_CODE IS NULL)
    ...              OR
    ...              (TRPRD.PRODUCT_TYPE = 'DEVICE' AND TRPRD.PRODUCT_SUBTYPE = 'HANDSET'
    ...                AND TRPRD.BRAND = 'APPLE' AND TRPRD.MODEL = 'IPHONEXSM256' AND TRPRD.COLOR IS NULL AND MAT_CODE IS NULL)
    ...              OR
    ...              (TRPRD.PRODUCT_TYPE = 'DEVICE' AND TRPRD.PRODUCT_SUBTYPE = 'HANDSET'
    ...                AND TRPRD.BRAND = 'APPLE' AND TRPRD.MODEL = 'IPHONEXSM256' AND TRPRD.COLOR = 'GOLD' AND MAT_CODE IS NULL)
    ...              OR
    ...              (TRPRD.PRODUCT_TYPE = 'DEVICE' AND TRPRD.PRODUCT_SUBTYPE = 'HANDSET' AND MAT_CODE = 'NEW0APXM256-GD01')
    ...            )
    ...          )      
    ...         ,rowtotal as (
    ...            select max(RN) as TOTAL
    ...            from productOption
    ...          )
    ...          select
    ...          pro.* , rowtotal.TOTAL
    ...          from productOption pro
    ...          left join rowtotal on rowtotal.TOTAL > 0
    ...    ==>
    ...    *** Condition ***
    ...    - filter by productMaster
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode = 20000
    ...    2. total = 172
    ...    ==>
    [Tags]    50.2.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${50_2_2_body_get_product_price_options_by_material_code}
    Send Request API    url=${url_get_product_price_options_by_mat_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_total}            Get Value From Json    ${response.json()}     $.total
    ${value_statusCode}       Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_total}[0]         189
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: total = "189"
    ...    ${\n}---> "total" == "${value_total}[0]"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_050 Get Product Price Options by Material Code (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode = 20000
    ...    2. priceOptions ทุกตัวมี tradeNo อยู่ใน lisit นี้
    ...    TP19021670
    ...    TP19021675
    ...    TP19021678
    ...    TP19031804
    ...    ==>
    [Tags]    50.3.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${50_3_1_body_get_product_price_options_by_material_code}
    Send Request API    url=${url_get_product_price_options_by_mat_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${expect_contain_tradeNo}    Create List    
    ...    TP19021670
    ...    TP19021675
    ...    TP19021678
    ...    TP19031804
    ${count_priceOptions}    Get List Key And Count From Json              $.priceOptions
    ${value_statusCode}      Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True    int(${count_priceOptions}) > int(0)
    FOR    ${index_priceOptions}  IN RANGE   1    ${count_priceOptions} + 1
            ${value_tradeNo}      Get Value From Json     ${response.json()}    $.priceOptions[${index_priceOptions - 1}].tradeNo
            List Should Contain Value    ${expect_contain_tradeNo}    ${value_tradeNo}[0]
            ${result}    Catenate
            ...    ${\n}---> loop priceOptions: "${index_priceOptions}"
            ...    ${\n}---> json_path_tradeNo: "$.priceOptions[${index_priceOptions - 1}].tradeNo"
            ...    ${\n}---> condition: priceOptions ทุกตัวมี tradeNo อยู่ใน lisit นี้ 
            ...    ${\n}---> ${expect_contain_tradeNo}
            ...    ${\n}---> condition: statusCode = "20000"
            ...    ${\n}---> "tradeNo" == "${value_tradeNo}[0]"
            ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
            Log    ${result}
    END

CPC_API_1_1_050 Get Product Price Options by Material Code (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    *** Condition ***
    ...    - filter by saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode = 20000
    ...    2. priceOptions ทุกตัวมี tradeNo อยู่ใน lisit นี้
    ...    TP19021670
    ...    TP19021675
    ...    TP19021678
    ...    TP19031804
    ...    ==>
    [Tags]    50.3.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${50_3_2_body_get_product_price_options_by_material_code}
    Send Request API    url=${url_get_product_price_options_by_mat_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${expect_contain_tradeNo}    Create List    
    ...    TP19021670
    ...    TP19021675
    ...    TP19021678
    ...    TP19031804
    ${count_priceOptions}    Get List Key And Count From Json              $.priceOptions
    ${value_statusCode}      Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True    int(${count_priceOptions}) > int(0)
    FOR    ${index_priceOptions}  IN RANGE   1    ${count_priceOptions} + 1
            ${value_tradeNo}      Get Value From Json     ${response.json()}    $.priceOptions[${index_priceOptions - 1}].tradeNo
            List Should Contain Value    ${expect_contain_tradeNo}    ${value_tradeNo}[0]
            ${result}    Catenate
            ...    ${\n}---> loop priceOptions: "${index_priceOptions}"
            ...    ${\n}---> json_path_tradeNo: "$.priceOptions[${index_priceOptions - 1}].tradeNo"
            ...    ${\n}---> condition: priceOptions ทุกตัวมี tradeNo อยู่ใน lisit นี้ 
            ...    ${\n}---> ${expect_contain_tradeNo}
            ...    ${\n}---> condition: statusCode = "20000"
            ...    ${\n}---> "tradeNo" == "${value_tradeNo}[0]"
            ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
            Log    ${result}
    END

CPC_API_1_1_050 Get Product Price Options by Material Code (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"    ** SA แจ้ง เปลี่ยนเป็น check statusCode (7/5/2567)**
    ...    2. priceOptions มี length == 5 
    ...    ==>
    [Tags]    50.4.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${50_4_1_body_get_product_price_options_by_material_code}
    Send Request API    url=${url_get_product_price_options_by_mat_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_priceOptions}         Get List Key And Count From Json              $.priceOptions
    ${value_statusCode}           Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_priceOptions}) == int(5)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: priceOptions.length = "5"
    ...    ${\n}---> "priceOptions" == "${count_priceOptions}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_050 Get Product Price Options by Material Code (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"    ** SA แจ้ง เปลี่ยนเป็น check statusCode (7/5/2567)**
    ...    2. priceOptions มี length == total - (offset-1)     ** SA แจ้ง เปลี่ยน offset body ให้ส่งค่าเป็น 32 (13/05/2567)**
    ...    ==>
    [Tags]    50.4.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${50_4_2_body_get_product_price_options_by_material_code}
    Send Request API    url=${url_get_product_price_options_by_mat_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}    Get Value From Json     ${response.json()}    $.statusCode
    ${count}               Get List Key And Count From Json              $.priceOptions
    ${total}               Get Value From Json     ${response.json()}    $.total
    ${body_offset}         Get Value From Json     ${API_BODY}           $.offset
    ${data_length}         Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count}) == int(${data_length})
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_data_length == "${count}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> data_length: int(${total}[0] - (${body_offset}[0] - 1) == "${data_length}"
    ...    ${\n}---> "$data_length(${data_length})" == "$resp_data_length(${count})"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_051 Get Product Detail
    [Documentation]    Owner : Kachain.a
    [Tags]    51   
    Set API Header Default
    Set Body API        schema_body=${51_body_get_product_detail}
    Send Request API    url=${url_get_product_detail}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${51_response_get_product_detail}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_051 Get Product Detail (Conditions_Test_Case_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - verify parameter
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 99999
    ...    ==>
    [Tags]   51.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${51_1_body_get_product_detail}
    Send Request API    url=${url_get_product_detail}
    ...                 expected_status=400
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    99999 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "99999"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_051 Get Product Detail (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by brand and model
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.products.length = 2
    ...    - 3.product ทุกตัวต้องมี productInfo length > 0
    ...    ==>
    [Tags]   51.2.1    Conditions     
    Set API Header Default
    Set Body API        schema_body=${51_2_1_body_get_product_detail}
    Send Request API    url=${url_get_product_detail}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}       Get List Key And Count From Json    $.products
    ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
    ${count_productInfo}       Get List Key And Count From Json    $.products[*].productInfo
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(2)
    FOR  ${index}  IN RANGE     ${count_products}
         ${count_productInfo}       Get List Key And Count From Json      $.products[${index}].productInfo
         Should Be True             int(${count_productInfo}) > int(0)    
         ${result}    Catenate
         ...    ${\n}---> loop index: "${index}"
         ...    ${\n}---> json_path_productInfo: "$.products[${index}].productInfo"
         ...    ${\n}---> condition: statusCode = "20000"
         ...    ${\n}---> condition: products.length = 2
         ...    ${\n}---> condition: product ทุกตัวต้องมี productInfo length > 0
         ...    ${\n}---> "productInfo" == "${count_productInfo}"
         Log    ${result}
    END

CPC_API_1_1_051 Get Product Detail (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by brand and model
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.products.length = 0
    ...    ==>
    [Tags]   51.2.2    Conditions     
    Set API Header Default
    Set Body API        schema_body=${51_2_2_body_get_product_detail}
    Send Request API    url=${url_get_product_detail}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}       Get List Key And Count From Json    $.products
    ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(0) 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: products.length = 0
    ...    ${\n}---> "statusCode" == "${value_statusCode}"
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_051 Get Product Detail (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by productType  and productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.products.length = 2
    ...    - 3.product ทุกตัวต้องไม่พบ matCode ต่อไปนี้ใน sku
    ...    - NEW0HWY5LIT-BK01S3
    ...    - NEW0HWY5LIT-BK01X3
    ...    - NEW0HWY5LIT-BK01N3
    ...    - NEW0HWY5LIT-BK01C3
    ...    - NEW0HWY5LIT-BL01X3
    ...    - NEW0HWY5LIT-BL01C3
    ...    - NEW0HWY5LIT-BL01N3
    ...    - NEW0HWY5LIT-BL01S3
    ...    ==>
    [Tags]    51.3.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${51_3_1_body_get_product_detail}
    Send Request API    url=${url_get_product_detail}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${expect_not_contain_matCode}    Create List    
    ...    NEW0HWY5LIT-BK01S3
    ...    NEW0HWY5LIT-BK01X3
    ...    NEW0HWY5LIT-BK01N3
    ...    NEW0HWY5LIT-BK01C3
    ...    NEW0HWY5LIT-BL01X3
    ...    NEW0HWY5LIT-BL01C3
    ...    NEW0HWY5LIT-BL01N3
    ...    NEW0HWY5LIT-BL01S3
    ${count_products}        Get List Key And Count From Json              $.products
    ${value_statusCode}      Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True    int(${count_products}) == int(2)
    FOR    ${index}  IN RANGE     ${count_products}
            ${value_sku}      Get Value From Json     ${response.json()}      $.products[${index}].sku
            Log    ${value_sku}[0]
            FOR    ${sku}    IN    @{value_sku}[0]
                List Should Not Contain Value       ${expect_not_contain_matCode}     ${sku}
                ${result}    Catenate
                ...    ${\n}---> loop products: "${index}"
                ...    ${\n}---> json_path_sku: "$.products[${index}].sku"
                ...    ${\n}---> condition: product ทุกตัวต้องไม่พบ matCode ต่อไปนี้ใน sku : ${expect_not_contain_matCode}
                ...    ${\n}---> condition: statusCode = "20000"
                ...    ${\n}---> "sku" == "${sku}"
                ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
                Log    ${result}
            END
    END

CPC_API_1_1_051 Get Product Detail (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by productType  and productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.products.length = 2
    ...    - 3.product ทุกตัวต้องไม่พบ matCode ต่อไปนี้ใน sku
    ...    - NEW0HWY5LIT-BL01
    ...    - NEW0HWY5LIT-BK01
    ...    ==>
    [Tags]    51.3.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${51_3_2_body_get_product_detail}
    Send Request API    url=${url_get_product_detail}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${expect_not_contain_matCode}    Create List    
    ...    NEW0HWY5LIT-BL01
    ...    NEW0HWY5LIT-BK01
    ${count_products}        Get List Key And Count From Json              $.products
    ${value_statusCode}      Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True    int(${count_products}) == int(2)
    FOR    ${index}  IN RANGE     ${count_products}
            ${value_sku}      Get Value From Json     ${response.json()}      $.products[${index}].sku
            Log    ${value_sku}[0]
            FOR    ${sku}    IN    @{value_sku}[0]
                List Should Not Contain Value       ${expect_not_contain_matCode}     ${sku}
                ${result}    Catenate
                ...    ${\n}---> loop products: "${index}"
                ...    ${\n}---> json_path_sku: "$.products[${index}].sku"
                ...    ${\n}---> condition: product ทุกตัวต้องไม่พบ matCode ต่อไปนี้ใน sku : ${expect_not_contain_matCode}
                ...    ${\n}---> condition: statusCode = "20000"
                ...    ${\n}---> "sku" == "${sku}"
                ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
                Log    ${result}
            END
    END

CPC_API_1_1_051 Get Product Detail (Conditions_Test_Case_3_3)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by productType  and productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.products.length = 0
    ...    ==>
    [Tags]   51.3.3    Conditions     
    Set API Header Default
    Set Body API        schema_body=${51_3_3_body_get_product_detail}
    Send Request API    url=${url_get_product_detail}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}       Get List Key And Count From Json    $.products
    ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(0) 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: products.length = 0
    ...    ${\n}---> "statusCode" == "${value_statusCode}"
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_052 Get Product Detail by Criteria
    [Documentation]    Owner : Kachain.a    Edit : Patipan.w
    [Tags]   52        
    Set API Header Default
    Set Body API        schema_body=${52_body_get_product_detail_by_criteria}
    Send Request API    url=${url_get_product_detail_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${52_response_get_product_detail_by_criteria}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_052 Get Product Detail by Criteria (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    ==>
    ...    *** Expect Result ***
    ...    - statusCode =  50000
    ...    ==>
    [Tags]    52.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${52_1_body_get_product_detail_by_criteria}
    Send Request API    url=${url_get_product_detail_by_criteria}
    ...                 expected_status=500
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       50000
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "50000"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_052 Get Product Detail by Criteria (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by catalogType,category catalogSubType,commercialName
    ...    ==>
    ...    *** Expect Result ***
    ...    - product != null    ** SA เปลี่ยนเป็น Check "product" != "null" (7/5/2567)  **
    ...    ==>
    [Tags]    52.2.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${52_2_1_body_get_product_detail_by_criteria}
    Send Request API    url=${url_get_product_detail_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${response_product}     Get Value From Json    ${response.json()}    $.product
    Log Response Json        ${response_product}[0]
    Should Not Be Empty      ${response_product}[0]    msg=$.product is "null" or "none".

CPC_API_1_1_052 Get Product Detail by Criteria (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by catalogType,category catalogSubType,commercialName
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "statusCode": "40401",
    ...    2. "statusDesc": "Data not found"
    ...    ==>
    [Tags]    52.2.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${52_2_2_body_get_product_detail_by_criteria}
    Send Request API    url=${url_get_product_detail_by_criteria}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    ${value_statusDesc}            Get Value From Json          ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]       40401
    Should Be Equal As Strings     ${value_statusDesc}[0]       Data not found
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> condition: statusDesc = "Data not found"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_053 Get Product Price Options
    [Documentation]    Owner : Kachain.a    Edit : Patipan.w
    [Tags]    53    
    Set API Header Default
    Set Body API        schema_body=${53_body_get_product_price_options}
    Send Request API    url=${url_get_product_price_options}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${53_response_get_product_price_options}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_053 Get Product Price Options (Conditions_Test_Case_1_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - default campaign Handset Only
    ...    ==>
    ...    *** Expect Result ***
    ...    1. priceOptions.length > 0
    ...    2. ต้องมี priceOptions อย่างน้อย 1 ตัวมี campaignId = 1
    ...    ==>
    [Tags]    53.1.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${53_1_1_body_get_product_price_options}
    Send Request API    url=${url_get_product_price_options}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_priceOptions}    Get List Key And Count From Json    $.priceOptions
    Should Be True    int(${count_priceOptions}) > int(0)
    ${value_campaignId}          Get Value From Json      ${response.json()}    $.priceOptions[*].campaignId
    List Should Contain Value    ${value_campaignId}      1
    ${result}    Catenate
    ...    ${\n}---> json_path_campaignId: "$.priceOptions[*].campaignId"
    ...    ${\n}---> condition: "priceOptions.length > 0"
    ...    ${\n}---> condition: "ต้องมี priceOptions อย่างน้อย 1 ตัวมี campaignId = 1"
    ...    ${\n}---> "priceOptions" == "${count_priceOptions}"
    ...    ${\n}---> "campaignId" == "${value_campaignId}"
    Log    ${result}

CPC_API_1_1_053 Get Product Price Options (Conditions_Test_Case_1_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by brand, model, color
    ...    ==>
    ...    *** Expect Result ***
    ...    1. priceOptions.length > 0
    ...    2. ต้องมี priceOptions อย่างน้อย 1 ตัวมี campaignId = 1
    ...    ==>
    [Tags]    53.1.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${53_1_2_body_get_product_price_options}
    Send Request API    url=${url_get_product_price_options}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_priceOptions}    Get List Key And Count From Json    $.priceOptions
    Should Be True    int(${count_priceOptions}) > int(0)
    ${value_campaignId}          Get Value From Json      ${response.json()}    $.priceOptions[*].campaignId
    List Should Contain Value    ${value_campaignId}      1
    ${result}    Catenate
    ...    ${\n}---> json_path_campaignId: "$.priceOptions[*].campaignId"
    ...    ${\n}---> condition: "priceOptions.length > 0"
    ...    ${\n}---> condition: "ต้องมี priceOptions อย่างน้อย 1 ตัวมี campaignId = 1"
    ...    ${\n}---> "priceOptions" == "${count_priceOptions}"
    ...    ${\n}---> "campaignId" == "${value_campaignId}"
    Log    ${result}

CPC_API_1_1_053 Get Product Price Options (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by regularPrice **MOC
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"    ** SA แจ้งเปลี่ยนเป็น check จาก statusCode (5/7/2567) **
    ...    2. priceOptions ทุกตัวจะต้องมีค่า 
    ...       - privileges[index].trades[index].promotionPrice + privileges[index].trades[index].discount.discountIncludeVat = 60000
    ...    ==>
    [Tags]    53.2.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${53_2_1_body_get_product_price_options}
    Send Request API    url=${url_get_product_price_options}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_priceOptions}        Get List Key And Count From Json              $.priceOptions
    ${value_statusCode}          Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       20000 
    Should Be True                 int(${count_priceOptions}) > int(0)
    FOR    ${index_priceOptions}  IN RANGE   1    ${count_priceOptions} + 1
            ${count_privileges}      Get List Key And Count From Json      $.priceOptions[${index_priceOptions - 1}].privileges
            Should Be True    int(${count_privileges}) > int(0)
            FOR    ${index_privileges}  IN RANGE   1    ${count_privileges} + 1
                    ${count_trades}      Get List Key And Count From Json      $.priceOptions[${index_priceOptions - 1}].privileges[${index_privileges - 1}].trades
                    Should Be True    int(${count_trades}) > int(0)
                    FOR    ${index_trades}  IN RANGE   1    ${count_trades} + 1
                            ${value_promotionPrice}    Get Value From Json     
                            ...    ${response.json()}    
                            ...    $.priceOptions[${index_priceOptions - 1}].privileges[${index_privileges - 1}].trades[${index_trades - 1}].promotionPrice
                            ${value_discountIncludeVat}    Get Value From Json     
                            ...    ${response.json()}    
                            ...    $.priceOptions[${index_priceOptions - 1}].privileges[${index_privileges - 1}].trades[${index_trades - 1}].discount.discountIncludeVat
                            ${expect}    Evaluate    int(${value_promotionPrice}[0] + ${value_discountIncludeVat}[0])
                            Should Be True    int(${expect}) == int(60000)
                            ${result}    Catenate
                            ...    ${\n}---> loop priceOptions: "${index_priceOptions}"
                            ...    ${\n}---> json_path_promotionPrice:     "$.priceOptions[${index_priceOptions - 1}].privileges[${index_privileges - 1}].trades[${index_trades - 1}].promotionPrice"
                            ...    ${\n}---> json_path_discountIncludeVat: "$.priceOptions[${index_priceOptions - 1}].privileges[${index_privileges - 1}].trades[${index_trades - 1}].discount.discountIncludeVat"
                            ...    ${\n}---> condition: "statusCode": "20000"
                            ...    ${\n}---> condition: priceOptions ทุกตัวจะต้องมีค่า 
                            ...    ${\n}--->  - privileges[index].trades[index].promotionPrice + privileges[index].trades[index].discount.discountIncludeVat = 60000
                            ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
                            ...    ${\n}---> "promotionPrice" == "${value_promotionPrice}[0]"
                            ...    ${\n}---> "discountIncludeVat" == "${value_discountIncludeVat}[0]"
                            ...    ${\n}---> "expect(${value_promotionPrice}[0] + ${value_discountIncludeVat}[0]) == ${expect}"
                            Log    ${result}
                    END
            END
    END

CPC_API_1_1_053 Get Product Price Options (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by regularPrice **MOC
    ...    ==>
    ...    *** Expect Result ***
    ...    - priceOptions.length = 0
    ...    ==>
    [Tags]    53.2.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${53_2_2_body_get_product_price_options}
    Send Request API    url=${url_get_product_price_options}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.priceOptions
    Should Be True    int(${count}) == int(0)
    Log    ---> Object.keys(priceOptions).length(${count}) == 0

CPC_API_1_1_053 Get Product Price Options (Conditions_Test_Case_2_3)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by regularPrice ** Non MOC
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน priceOptions จะต้องไม่พบ privileges[index].trades[index].tradeNo ต่อไปนี้ 
    ...    TP22054718
    ...    TP22054719
    ...    TP22054721
    ...    TP22054722
    ...    TP22054724
    ...    TP22054726
    ...    TP22064743
    ...    ==>
    [Tags]    53.2.3    Conditions    
    Set API Header Default
    Set Body API        schema_body=${53_2_3_body_get_product_price_options}
    Send Request API    url=${url_get_product_price_options}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${expect_not_contain_tradeNo}    Create List    
    ...    TP22054718
    ...    TP22054719
    ...    TP22054721
    ...    TP22054722
    ...    TP22054724
    ...    TP22054726
    ...    TP22064743
    ${stat_error_trades}     Create List
    ${count_priceOptions}    Get List Key And Count From Json    $.priceOptions
    Should Be True    int(${count_priceOptions}) > int(0)
    FOR    ${index_priceOptions}  IN RANGE   1    ${count_priceOptions} + 1
            ${count_privileges}   Get List Key And Count From Json    $.priceOptions[${index_priceOptions - 1}].privileges
            Should Be True    int(${count_privileges}) > int(0)
            FOR    ${index_privileges}  IN RANGE   1    ${count_privileges} + 1
                    ${count_trades}      Get List Key And Count From Json      $.priceOptions[${index_priceOptions - 1}].privileges[${index_privileges - 1}].trades
                    ${status_trades}     Run Keyword And Return Status         Should Be True    int(${count_trades}) > int(0)
                    IF    ${status_trades} == ${False}
                            Append To List   ${stat_error_trades}   $.priceOptions[${index_priceOptions - 1}].privileges[${index_privileges - 1}].trades
                    END
                    FOR    ${index_trades}  IN RANGE   1    ${count_trades} + 1
                            ${value_tradeNo}    Get Value From Json     
                            ...    ${response.json()}    
                            ...    $.priceOptions[${index_priceOptions - 1}].privileges[${index_privileges - 1}].trades[${index_trades - 1}].tradeNo
                            ${status_verify}    Run Keyword And Return Status    List Should Not Contain Value    ${expect_not_contain_tradeNo}    ${value_tradeNo}[0]
                            IF    ${status_verify} == ${True}
                                    ${result}    Catenate
                                    ...    ${\n}---> loop priceOptions: "${index_priceOptions}"
                                    ...    ${\n}---> json_path_tradeNo: "$.priceOptions[${index_priceOptions - 1}].privileges[${index_privileges - 1}].trades[${index_trades - 1}].tradeNo"
                                    ...    ${\n}---> condition: ใน priceOptions จะต้องไม่พบ privileges[index].trades[index].tradeNo ต่อไปนี้
                                    ...    ${\n}---> ${expect_not_contain_tradeNo}
                                    ...    ${\n}---> "tradeNo" == "${value_tradeNo}[0]"
                                    Log    ${result}
                            END
                    END
            END
    END
    ${status_pass}    Run Keyword And Return Status    Should Be Empty     ${stat_error_trades}
    IF    ${status_pass} == ${False}
            ${result_fail}    Catenate
            ...    ${\n}---> Fail : $.priceOptions[index].privileges[index].trades == "0"
            ...    ${\n}---> json_path = ${stat_error_trades}
            Fail    ${result_fail}
    END

CPC_API_1_1_054 Get Products By Material Code
    [Documentation]    Owner : Kachain.a    Edit : Patipan.w
    [Tags]    54        
    Set API Header Default
    Set Body API        schema_body=${54_body_get_products_by_material_code}
    Send Request API    url=${url_get_products_by_material_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${54_response_get_products_by_material_code}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_054 Get Products By Material Code (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - default priceTypes
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมี prices[index].priceType เป็น EUP หรือ TUP เท่านั้น
    ...    ==>
    [Tags]    54.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${54_1_body_get_products_by_material_code}
    Send Request API    url=${url_get_products_by_material_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR  ${index_products}  IN RANGE    1    ${count_products} + 1
          ${count_prices}    Get List Key And Count From Json    $.products[${index_products - 1}].prices
          FOR    ${index_prices}  IN RANGE    1    ${count_prices} + 1
                  ${value_priceType}    Get Value From Json    ${response.json()}    $.products[${index_products - 1}].prices[${index_prices - 1}].priceType
                  Should Be True        str("${value_priceType}[0]") == str("EUP") or str("${value_priceType}[0]") == str("TUP")
                  ${result}    Catenate
                  ...    ${\n}---> loop: "${index_products}"
                  ...    ${\n}---> json_path_priceType: "$.products[${index_products - 1}].prices[${index_prices - 1}].priceType"
                  ...    ${\n}---> condition: products ทุกตัวมี prices[index].priceType เป็น EUP หรือ TUP เท่านั้น
                  ...    ${\n}---> "priceType" == "${value_priceType}[0]"
                  Log    ${result}
          END
    END

CPC_API_1_1_054 Get Products By Material Code (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by company, materialCode
    ...    ==>
    ...    *** Expect Result ***
    ...    1. products.length = 2
    ...    2. products[0].materialCode = "NEW0APXM256-GD01"
    ...    3. products[1].materialCode = "NEW0AP00122-RD01"
    ...    ==>
    [Tags]    54.2.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${54_2_1_body_get_products_by_material_code}
    Send Request API    url=${url_get_products_by_material_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) == int(2)
    ${value_materialCode_index_0}    Get Value From Json    ${response.json()}    $.products[0].materialCode
    ${value_materialCode_index_1}    Get Value From Json    ${response.json()}    $.products[1].materialCode
    Should Be Equal As Strings       ${value_materialCode_index_0}[0]             NEW0APXM256-GD01
    Should Be Equal As Strings       ${value_materialCode_index_1}[0]             NEW0AP00122-RD01
    ${result}    Catenate
    ...    ${\n}---> condition: products.length = 2
    ...    ${\n}---> condition: products[0].materialCode = "NEW0APXM256-GD01"
    ...    ${\n}---> condition: products[1].materialCode = "NEW0AP00122-RD01"
    ...    ${\n}---> "result_products.length" == "${count_products}"
    ...    ${\n}---> "result_products[0].materialCode" == "${value_materialCode_index_0}[0]"
    ...    ${\n}---> "result_products[1].materialCode" == "${value_materialCode_index_1}[0]"
    Log    ${result}

CPC_API_1_1_054 Get Products By Material Code (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by company, materialCode
    ...    ==>
    ...    *** Expect Result ***
    ...    1. products.length = 1
    ...    2. products[0].materialCode = "NEW0AP00122-RD01"
    ...    ==>
    [Tags]    54.2.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${54_2_2_body_get_products_by_material_code}
    Send Request API    url=${url_get_products_by_material_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) == int(1)
    ${value_materialCode_index_0}    Get Value From Json    ${response.json()}    $.products[0].materialCode
    Should Be Equal As Strings       ${value_materialCode_index_0}[0]             NEW0AP00122-RD01
    ${result}    Catenate
    ...    ${\n}---> condition: products.length = 1
    ...    ${\n}---> condition: products[0].materialCode = "NEW0AP00122-RD01"
    ...    ${\n}---> "result_products.length" == "${count_products}"
    ...    ${\n}---> "result_products[0].materialCode" == "${value_materialCode_index_0}[0]"
    Log    ${result}

CPC_API_1_1_054 Get Products By Material Code (Conditions_Test_Case_2_3)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by company, materialCode
    ...    ==>
    ...    *** Expect Result ***
    ...    - products.length =0
    ...    ==>
    [Tags]    54.2.3    Conditions        
    Set API Header Default
    Set Body API        schema_body=${54_2_3_body_get_products_by_material_code}
    Send Request API    url=${url_get_products_by_material_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count}    Get List Key And Count From Json    $.products
    Should Be True    int(${count}) == int(0)
    Log    ---> Object.keys(products).length(${count}) == 0

CPC_API_1_1_054 Get Products By Material Code (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by priceTypes
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมี prices[index].priceType เป็น EUP 
    ...    ==>
    [Tags]    54.3.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${54_3_1_body_get_products_by_material_code}
    Send Request API    url=${url_get_products_by_material_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR  ${index_products}  IN RANGE    1    ${count_products} + 1
          ${count_prices}    Get List Key And Count From Json    $.products[${index_products - 1}].prices
          FOR    ${index_prices}  IN RANGE    1    ${count_prices} + 1
                  ${value_priceType}               Get Value From Json    ${response.json()}    $.products[${index_products - 1}].prices[${index_prices - 1}].priceType
                  Should Be Equal As Strings       ${value_priceType}[0]    EUP
                  ${result}    Catenate
                  ...    ${\n}---> loop: "${index_products}"
                  ...    ${\n}---> json_path_priceType: "$.products[${index_products - 1}].prices[${index_prices - 1}].priceType"
                  ...    ${\n}---> condition: products ทุกตัวมี prices[index].priceType เป็น EUP 
                  ...    ${\n}---> "priceType" == "${value_priceType}[0]"
                  Log    ${result}
          END
    END

CPC_API_1_1_054 Get Products By Material Code (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by priceTypes
    ...    ==>
    ...    *** Expect Result ***
    ...    - products ทุกตัวมี prices[index].priceType เป็น  TUP เท่านั้น
    ...    ==>
    [Tags]    54.3.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${54_3_2_body_get_products_by_material_code}
    Send Request API    url=${url_get_products_by_material_code}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR  ${index_products}  IN RANGE    1    ${count_products} + 1
          ${count_prices}    Get List Key And Count From Json    $.products[${index_products - 1}].prices
          FOR    ${index_prices}  IN RANGE    1    ${count_prices} + 1
                  ${value_priceType}               Get Value From Json    ${response.json()}    $.products[${index_products - 1}].prices[${index_prices - 1}].priceType
                  Should Be Equal As Strings       ${value_priceType}[0]    TUP
                  ${result}    Catenate
                  ...    ${\n}---> loop: "${index_products}"
                  ...    ${\n}---> json_path_priceType: "$.products[${index_products - 1}].prices[${index_prices - 1}].priceType"
                  ...    ${\n}---> condition: products ทุกตัวมี prices[index].priceType เป็น  TUP เท่านั้น 
                  ...    ${\n}---> "priceType" == "${value_priceType}[0]"
                  Log    ${result}
          END
    END

CPC_API_1_1_055 Get All Product Search
    [Documentation]    Owner : Kachain.a    Edit : Patipan.w
    [Tags]    55        
    Set API Header Default
    Set Body API        schema_body=${55_body_get_all_product_search}
    Send Request API    url=${url_get_all_product_search}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${55_response_get_all_product_search}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_055 Get All Product Search (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - default productType, productSubtype,offset,maxRow
    ...    ==>
    ...    *** Expect Result ***
    ...    1. maxRow = 10000
    ...    2. data.length > 0
    ...    - 
    ...    ==>
    [Tags]    55.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${55_1_body_get_all_product_search}
    Send Request API    url=${url_get_all_product_search}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}      Get List Key And Count From Json    $.data
    Should Be True     int(${count_data}) > int(0)
    ${value_maxRow}    Get Value From Json    ${response.json()}    $.maxRow
    Should Be Equal As Integers               ${value_maxRow}[0]    10000
    ${result}    Catenate
    ...    ${\n}---> condition: maxRow = 10000
    ...    ${\n}---> condition: data.length > 0
    ...    ${\n}---> "maxRow" == "${value_maxRow}[0]"
    ...    ${\n}---> "data" == "${count_data}"
    Log    ${result}

CPC_API_1_1_055 Get All Product Search (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    data ทุกตัวต้องมี 
    ...    - "productType": "GADGET/IOT"
    ...    - "productSubtype": "N/A"
    ...    ==>
    [Tags]    55.2.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${55_2_1_body_get_all_product_search}
    Send Request API    url=${url_get_all_product_search}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) > int(0)
    FOR  ${index_data}  IN RANGE    1    ${count_data} + 1
          ${value_productType}             Get Value From Json    ${response.json()}    $.data[${index_data - 1}].productType
          ${value_productSubtype}          Get Value From Json    ${response.json()}    $.data[${index_data - 1}].productSubtype
          Should Be Equal As Strings       ${value_productType}[0]       GADGET/IOT
          Should Be Equal As Strings       ${value_productSubtype}[0]    N/A
          ${result}    Catenate
          ...    ${\n}---> loop: "${index_data}"
          ...    ${\n}---> json_path_productType: "$.data[${index_data - 1}].productType"
          ...    ${\n}---> json_path_productSubtype: "$.data[${index_data - 1}].productSubtype"
          ...    ${\n}---> condition: data ทุกตัวต้องมี "productType": "GADGET/IOT" 
          ...    ${\n}---> condition: data ทุกตัวต้องมี "productSubtype": "N/A" 
          ...    ${\n}---> "productType" == "${value_productType}[0]"
          ...    ${\n}---> "productSubtype" == "${value_productSubtype}[0]"
          Log    ${result}
    END

CPC_API_1_1_055 Get All Product Search (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    data ทุกตัวต้องมี 
    ...    - "productType": "DEVICE"
    ...    - "productSubtype": "HANDSET BUNDLE"
    ...    ==>
    [Tags]    55.2.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${55_2_2_body_get_all_product_search}
    Send Request API    url=${url_get_all_product_search}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) > int(0)
    FOR  ${index_data}  IN RANGE    1    ${count_data} + 1
          ${value_productType}             Get Value From Json    ${response.json()}    $.data[${index_data - 1}].productType
          ${value_productSubtype}          Get Value From Json    ${response.json()}    $.data[${index_data - 1}].productSubtype
          Should Be Equal As Strings       ${value_productType}[0]       DEVICE
          Should Be Equal As Strings       ${value_productSubtype}[0]    HANDSET BUNDLE
          ${result}    Catenate
          ...    ${\n}---> loop: "${index_data}"
          ...    ${\n}---> json_path_productType: "$.data[${index_data - 1}].productType"
          ...    ${\n}---> json_path_productSubtype: "$.data[${index_data - 1}].productSubtype"
          ...    ${\n}---> condition: data ทุกตัวต้องมี "productType": "DEVICE" 
          ...    ${\n}---> condition: data ทุกตัวต้องมี "productSubtype": "HANDSET BUNDLE" 
          ...    ${\n}---> "productType" == "${value_productType}[0]"
          ...    ${\n}---> "productSubtype" == "${value_productSubtype}[0]"
          Log    ${result}
    END

CPC_API_1_1_055 Get All Product Search (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"    ** SA แจ้ง เปลี่ยนเป็น check จาก "statusCode" (7/5/2567)**
    ...    2. data มี length == 5 
    ...    ==>
    [Tags]    55.3.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${55_3_1_body_get_all_product_search}
    Send Request API    url=${url_get_all_product_search}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}       Get Value From Json    ${response.json()}     $.statusCode
    ${count_data}             Get List Key And Count From Json              $.data
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_data}) == int(5)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: data มี length == "5" 
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "data.length" == "${count_data}"
    Log    ${result}

CPC_API_1_1_055 Get All Product Search (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"    ** SA แจ้ง เปลี่ยนเป็น check จาก "statusCode" (7/5/2567)**
    ...    2. data มี length == total - (offset-1) 
    ...    ==>
    [Tags]    55.3.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${55_3_3_body_get_all_product_search}
    Send Request API    url=${url_get_all_product_search}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${resp_data_length}    Get List Key And Count From Json              $.data
    ${total}               Get Value From Json     ${response.json()}    $.total
    ${body_offset}         Get Value From Json     ${API_BODY}           $.offset
    ${value_statusCode}    Get Value From Json     ${response.json()}    $.statusCode
    ${expect_data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${expect_data_length}) == int(${resp_data_length})
    Should Be Equal As Strings   ${value_statusCode}[0]    20000
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_data_length == "${resp_data_length}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> expect_data_length: int(${total}[0] - (${body_offset}[0] - 1) == "${expect_data_length}"
    ...    ${\n}---> "$expect_data_length(${expect_data_length})" == "$resp_data_length(${resp_data_length})"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_056 Get All Products For Searching
    [Documentation]    Owner : Kachain.a    Edit : Thanchanok, Patipan.w
    [Tags]    56        
    Set API Header Default
    Set Body API        schema_body=${56_body_get_all_products_for_searching}
    Send Request API    url=${url_get_all_products_for_searching}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${56_response_get_all_products_for_searching}
    Verify Value Response By Key    $..statusCode    2000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_056 Get All Products For Searching (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000",
    ...    - "statusDesc": "Parameter is invalid"
    ...    ==>
    [Tags]    56.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${56_1_body_get_all_products_for_searching}
    Send Request API    url=${url_get_all_products_for_searching}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    ${value_statusDesc}            Get Value From Json          ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]       30000
    Should Be Equal As Strings     ${value_statusDesc}[0]       Parameter is invalid
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "30000"
    ...    ${\n}---> condition: statusCode = "Parameter is invalid"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_056 Get All Products For Searching (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    data ทุกตัวต้องมี 
    ...    - "productType": "GADGET/IOT"
    ...    - "productSubtype": "N/A"
    ...    ==>
    [Tags]    56.2.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${56_2_1_body_get_all_products_for_searching}
    Send Request API    url=${url_get_all_products_for_searching}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) > int(0)
    FOR  ${index_data}  IN RANGE    1    ${count_data} + 1
          ${value_productType}             Get Value From Json    ${response.json()}    $.data[${index_data - 1}].productType
          ${value_productSubtype}          Get Value From Json    ${response.json()}    $.data[${index_data - 1}].productSubtype
          Should Be Equal As Strings       ${value_productType}[0]       GADGET/IOT
          Should Be Equal As Strings       ${value_productSubtype}[0]    N/A
          ${result}    Catenate
          ...    ${\n}---> loop: "${index_data}"
          ...    ${\n}---> json_path_productType: "$.data[${index_data - 1}].productType"
          ...    ${\n}---> json_path_productSubtype: "$.data[${index_data - 1}].productSubtype"
          ...    ${\n}---> condition: data ทุกตัวต้องมี "productType": "GADGET/IOT" 
          ...    ${\n}---> condition: data ทุกตัวต้องมี "productSubtype": "N/A" 
          ...    ${\n}---> "productType" == "${value_productType}[0]"
          ...    ${\n}---> "productSubtype" == "${value_productSubtype}[0]"
          Log    ${result}
    END

CPC_API_1_1_056 Get All Products For Searching (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter productType, productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    data ทุกตัวต้องมี 
    ...    - "productType": "DEVICE"
    ...    - "productSubtype": "HANDSET"
    ...    ==>
    [Tags]    56.2.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${56_2_2_body_get_all_products_for_searching}
    Send Request API    url=${url_get_all_products_for_searching}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_data}    Get List Key And Count From Json    $.data
    Should Be True    int(${count_data}) > int(0)
    FOR  ${index_data}  IN RANGE    1    ${count_data} + 1
          ${value_productType}             Get Value From Json    ${response.json()}    $.data[${index_data - 1}].productType
          ${value_productSubtype}          Get Value From Json    ${response.json()}    $.data[${index_data - 1}].productSubtype
          Should Be Equal As Strings       ${value_productType}[0]       DEVICE
          Should Be Equal As Strings       ${value_productSubtype}[0]    HANDSET
          ${result}    Catenate
          ...    ${\n}---> loop: "${index_data}"
          ...    ${\n}---> json_path_productType: "$.data[${index_data - 1}].productType"
          ...    ${\n}---> json_path_productSubtype: "$.data[${index_data - 1}].productSubtype"
          ...    ${\n}---> condition: data ทุกตัวต้องมี "productType": "DEVICE" 
          ...    ${\n}---> condition: data ทุกตัวต้องมี "productSubtype": "HANDSET" 
          ...    ${\n}---> "productType" == "${value_productType}[0]"
          ...    ${\n}---> "productSubtype" == "${value_productSubtype}[0]"
          Log    ${result}
    END

CPC_API_1_1_056 Get All Products For Searching (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"       ** SA แจ้ง ใช้เป็น check "statusCode": "2000" (14/5/2567)**
    ...    2. data มี length == 15     
    ...    ==>
    [Tags]    56.3.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${56_3_1_body_get_all_products_for_searching}
    Send Request API    url=${url_get_all_products_for_searching}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}       Get Value From Json    ${response.json()}     $.statusCode
    ${count_data}             Get List Key And Count From Json              $.data
    Should Be Equal As Strings     ${value_statusCode}[0]    2000
    Should Be True                 int(${count_data}) == int(15)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "2000"
    ...    ${\n}---> condition: data มี length == "15" 
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "data.length" == "${count_data}"
    Log    ${result}

CPC_API_1_1_056 Get All Products For Searching (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"    ** SA แจ้ง ใช้เป็น check "statusCode": "2000" (14/5/2567)**
    ...    2. data มี length == total - (offset-1)     ** SA แจ้ง ให้ส่ง body "offset" = "480" (14/5/2567)**
    ...    ==>
    [Tags]    56.3.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${56_3_2_body_get_all_products_for_searching}
    Send Request API    url=${url_get_all_products_for_searching}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${resp_data_length}    Get List Key And Count From Json              $.data
    ${total}               Get Value From Json     ${response.json()}    $.total
    ${body_offset}         Get Value From Json     ${API_BODY}           $.offset
    ${value_statusCode}    Get Value From Json     ${response.json()}    $.statusCode
    ${expect_data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${expect_data_length}) == int(${resp_data_length})
    Should Be Equal As Strings   ${value_statusCode}[0]    2000
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "2000"
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_data_length == "${resp_data_length}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> expect_data_length: int(${total}[0] - (${body_offset}[0] - 1) == "${expect_data_length}"
    ...    ${\n}---> "$expect_data_length(${expect_data_length})" == "$resp_data_length(${resp_data_length})"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_057 Get All Products By Price
    [Documentation]    Owner : Kachain.a    Edit : Patipan.w
    [Tags]    57        
    Set API Header Default
    Set Body API        schema_body=${57_body_get_all_products_by_price}
    Send Request API    url=${url_get_all_products_by_price}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${57_response_get_all_products_by_price}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_057 Get All Products By Price (Conditions_Test_Case_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "statusCode": "50000",
    ...    2. "statusDesc": "Error: invalid parameters."
    ...    ==>
    [Tags]    57.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${57_1_body_get_all_products_by_price}
    Send Request API    url=${url_get_all_products_by_price}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    ${value_statusDesc}            Get Value From Json          ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]       50000
    Should Be Equal As Strings     ${value_statusDesc}[0]       Error: invalid parameters.
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "50000"
    ...    ${\n}---> condition: statusDesc = "Error: invalid parameters."
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_057 Get All Products By Price (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by price + flagSearchFromNormalPrice (Y)
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode=20000
    ...    2. products ทุกตัวมี normalPrice.min <= 4500 หรือ normalPrice.max <= 4900
    ...    ==>
    [Tags]    57.2.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${57_2_1_body_get_all_products_by_price}
    Send Request API    url=${url_get_all_products_by_price}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       20000 
    ${count}    Get List Key And Count From Json                $.products
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_normalPrice_min}    Get Value From Json    ${response.json()}    $.products[${index - 1}].normalPrice.min
         ${value_normalPrice_max}    Get Value From Json    ${response.json()}    $.products[${index - 1}].normalPrice.max
         Should Be True    float(${value_normalPrice_min}[0]) <= float(4500) or float(${value_normalPrice_max}[0]) <= float(4900)
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_normalPrice_min: "$.products[${index - 1}].normalPrice.min"
         ...    ${\n}---> json_path_normalPrice_max: "$.products[${index - 1}].normalPrice.max"
         ...    ${\n}---> condition = products ทุกตัวมี normalPrice.min <= 4500 หรือ normalPrice.max <= 4900
         ...    ${\n}---> condition("normalPrice_min(${value_normalPrice_min}[0])" <= 4500 or "normalPrice_max(${value_normalPrice_max}[0])" <= 4900)
         ...    ${\n}---> "normalPrice_min" == "${value_normalPrice_min}[0]"
         ...    ${\n}---> "normalPrice_max" == "${value_normalPrice_max}[0]"
         Log    ${result}
    END

CPC_API_1_1_057 Get All Products By Price (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by price + flagSearchFromNormalPrice (N)
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode=20000
    ...    2. products ทุกตัวมี promotionPrice.min <= 4500 หรือ promotionPrice.max <= 4900
    ...    ==>
    [Tags]    57.2.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${57_2_2_body_get_all_products_by_price}
    Send Request API    url=${url_get_all_products_by_price}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       20000 
    ${count}    Get List Key And Count From Json                $.products
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_promotionPrice_min}    Get Value From Json    ${response.json()}    $.products[${index - 1}].promotionPrice.min
         ${value_promotionPrice_max}    Get Value From Json    ${response.json()}    $.products[${index - 1}].promotionPrice.max
         Should Be True    float(${value_promotionPrice_min}[0]) <= float(4500) or float(${value_promotionPrice_max}[0]) <= float(4900)
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_promotionPrice_min: "$.products[${index - 1}].promotionPrice.min"
         ...    ${\n}---> json_path_promotionPrice_max: "$.products[${index - 1}].promotionPrice.max"
         ...    ${\n}---> condition = products ทุกตัวมี promotionPrice.min <= 4500 หรือ promotionPrice.max <= 4900
         ...    ${\n}---> condition("promotionPrice_min(${value_promotionPrice_min}[0])" <= 4500 or "promotionPrice_max(${value_promotionPrice_max}[0])" <= 4900)
         ...    ${\n}---> "promotionPrice_min" == "${value_promotionPrice_min}[0]"
         ...    ${\n}---> "promotionPrice_max" == "${value_promotionPrice_max}[0]"
         Log    ${result}
    END

CPC_API_1_1_057 Get All Products By Price (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"    ** SA แจ้งใช้เป็น statusCode (7/5/2567)**
    ...    2. products มี length == 3 
    ...    ==>
    [Tags]    57.3.1    Conditions        
    Set API Header Default
    Set Body API        schema_body=${57_3_1_body_get_all_products_by_price}
    Send Request API    url=${url_get_all_products_by_price}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}       Get Value From Json    ${response.json()}     $.statusCode
    ${count_products}         Get List Key And Count From Json              $.products
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(3)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: products มี length == "3" 
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "products.length" == "${count_products}"
    Log    ${result}

CPC_API_1_1_057 Get All Products By Price (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"                           ** SA แจ้งใช้เป็น statusCode (7/5/2567)**
    ...    2. products มี length == total - (offset-1)     ** SA แจ้งใช้เป็น totalRow (7/5/2567)**
    ...    ==>
    [Tags]    57.3.2    Conditions        
    Set API Header Default
    Set Body API        schema_body=${57_3_2_body_get_all_products_by_price}
    Send Request API    url=${url_get_all_products_by_price} 
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${resp_products_length}    Get List Key And Count From Json         $.products
    ${totalRow}           Get Value From Json     ${response.json()}    $.totalRow
    ${body_offset}        Get Value From Json     ${API_BODY}           $.offset
    ${value_statusCode}   Get Value From Json     ${response.json()}    $.statusCode
    ${expect_data_length}    Evaluate    int(${totalRow}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${expect_data_length}) == int(${resp_products_length})
    Should Be Equal As Strings   ${value_statusCode}[0]    20000
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: totalRow - (offset-1)
    ...    ${\n}---> resp_products_length == "${resp_products_length}"
    ...    ${\n}---> resp_totalRow == "${totalRow}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> expect_data_length: int(${totalRow}[0] - (${body_offset}[0] - 1) == "${expect_data_length}"
    ...    ${\n}---> "$expect_data_length(${expect_data_length})" == "$resp_products_length(${resp_products_length})"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_058 Get All Products By Campaign
    [Documentation]    Owner : Kachain.a
    [Tags]    58    
    Set API Header Default
    Set Body API        schema_body=${58_body_get_all_products_by_campaign}
    Send Request API    url=${url_get_all_products_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${58_response_get_all_products_by_campaign}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_058 Get All Products By Campaign (Conditions_Test_Case_1_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by code
    ...    ==>
    ...    *** Expect Result ***
    ...    - products.length = 0
    ...    ==>
    [Tags]    58.1.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${58_1_1_body_get_all_products_by_campaign}
    Send Request API    url=${url_get_all_products_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}     Get List Key And Count From Json    $.products
    Should Be True                 int(${count_products}) == int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length == 0
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_058 Get All Products By Campaign (Conditions_Test_Case_1_2)
    [Documentation]    Owner: Kachain.a
    ...    *** CMD SQL ***
    ...    WITH main_products as (
    ...        SELECT  (CASE  WHEN BS.TYPE = 'HOT' THEN 1  WHEN BS.TYPE = 'NEW' THEN 2 ELSE 99999 END) as BEST_SELLER_TYPE_NUM
    ...        , ISNULL(M.COMMERCIAL_NAME, PP.MODEL) as COMMERCIAL_NAME,PP.BRAND, PP.COMPANY, PP.MAT_CODE, PP.MODEL, PP.PRODUCT_TYPE, PP.PRODUCT_SUBTYPE, ISNULL(M.PRIORITY,9999) as PRIORITY, BS.TYPE as  BEST_SELLER_TYPE
    ...        , M.FLAG_5G,PP.PRODUCT_ID,PRCM.INC_VAT AS BASE_PRICE,PRCM.EFFECTIVE_DATE, PRCM.PRICE_ID
    ...        , ISNULL(SM.COMMERCIAL_NAME, PP.MODEL) as SUB_COMMERCIAL_NAME
    ...        FROM [SIT-CPC].[SIT_CPC].PRODUCT_MST PP       
    ...        INNER JOIN [SIT-CPC].[SIT_CPC].PRICE_MST PRCM ON PRCM.PRODUCT_ID = PP.PRODUCT_ID AND PRCM.PRICE_GROUP = 'EUP'
    ...        AND CONVERT(datetime,SYSDATETIMEOFFSET() AT TIME ZONE 'SE Asia Standard Time') BETWEEN PRCM.EFFECTIVE_DATE AND CONVERT(datetime,ISNULL(PRCM.EXPIRE_DATE,'9999/12/31 23:59:59'))
    ...        LEFT JOIN [SIT-CPC].[SIT_CPC].SUB_MODEL SM ON SM.PRODUCT_SUBTYPE = PP.PRODUCT_SUBTYPE 
    ...        AND SM.PRODUCT_TYPE = PP.PRODUCT_TYPE 
    ...        AND ((SM.MAT_CODE IS NULL AND SM.COMPANY = PP.COMPANY AND SM.BRAND = PP.BRAND AND SM.MODEL = PP.MODEL) 
    ...        OR (SM.COMPANY = PP.COMPANY AND SM.MAT_CODE = PP.MAT_CODE))
    ...        LEFT JOIN [SIT-CPC].[SIT_CPC].MODEL_SUB_MODEL MSM ON SM.ID = MSM.SUB_MODEL_ID
    ...        LEFT JOIN [SIT-CPC].[SIT_CPC].MODEL M ON M.ID = MSM.MODEL_SUB_MODELS_ID
    ...        LEFT JOIN [SIT-CPC].[SIT_CPC].BEST_SELLER BS ON SM.MODEL = BS.SUB_MODEL AND CONVERT(datetime,SYSDATETIMEOFFSET() AT TIME ZONE 'SE Asia Standard Time') BETWEEN BS.EFFECTIVE_START_DATE  AND CONVERT(datetime,ISNULL(BS.EFFECTIVE_END_DATE, '9999/12/31 23:59:59'))
    ...        LEFT JOIN [SIT-CPC].[SIT_CPC].BEST_SELLER_GROUP BSG ON BSG.ID = BS.GROUP_ID
    ...        LEFT JOIN [SIT-CPC].[SIT_CPC].BEST_SELLER_GROUP_LOCATION_MST BSGL ON BSGL.BEST_SELLER_GROUP_LOCATIONS_ID = BSG.ID AND BSGL.LOCATION_MASTER_ID IN (1100,99999999)
    ...    WHERE (M.STATUS = 1 OR M.STATUS IS NULL) AND PP.BRAND NOT LIKE 'TRADE%' AND PP.GRADE is null ),
    ...        sub_products as(SELECT DENSE_RANK() OVER (ORDER BY M.COMMERCIAL_NAME,M.PRODUCT_TYPE, M.PRODUCT_SUBTYPE ) as row_rank, c.CODE
    ...        ,M.PRODUCT_ID, M.BEST_SELLER_TYPE_NUM,M.COMMERCIAL_NAME,M.BRAND, M.COMPANY, M.MAT_CODE, M.MODEL, M.PRODUCT_TYPE, M.PRODUCT_SUBTYPE, M.PRIORITY
    ...        ,M.FLAG_5G, M.BASE_PRICE,TRDC.TRADE_PRICE_INC_VAT,TRDC.DISCOUNT_EXC,TRDC.SPECIAL_DISC_INC,TRDC.DISCOUNT_INC_BY, TRDC.DISCOUNT_BY,TRDC.VAT_RATE
    ...        ,CONCAT(TRP.TRADE_NO , '_' , TRDC.OPTIONS , '_' , TRDC.TRADE_PRIVILEGE_ID) AS OPTIONS    
    ...        ,ps.THUMBNAIL, M.EFFECTIVE_DATE, M.PRICE_ID,TRP.TRADE_PRODUCT_ID,TRDC.TRADE_DISCOUNT_ID
    ...        ,M.SUB_COMMERCIAL_NAME
    ...        ,ROUND(ISNULL(TRDC.TRADE_PRICE_INC_VAT, M.BASE_PRICE) - 
    ...          (CASE
    ...    WHEN TRDC.DISCOUNT_EXC IS NULL AND TRDC.SPECIAL_DISC_INC IS NOT NULL THEN
    ...        CASE
    ...    WHEN ISNULL(TRDC.DISCOUNT_INC_BY, TRDC.DISCOUNT_BY) = 'B' THEN
    ...    TRDC.SPECIAL_DISC_INC
    ...        WHEN ISNULL(TRDC.DISCOUNT_INC_BY, TRDC.DISCOUNT_BY) = 'P' THEN
    ...            (ISNULL(TRDC.TRADE_PRICE_INC_VAT, M.BASE_PRICE) * (TRDC.SPECIAL_DISC_INC)) / 100.00
    ...        ELSE
    ...            0
    ...        END
    ...        WHEN TRDC.DISCOUNT_EXC IS NOT NULL AND TRDC.SPECIAL_DISC_INC IS NULL THEN
    ...        CASE
    ...        WHEN ISNULL(TRDC.DISCOUNT_BY, TRDC.DISCOUNT_INC_BY) = 'B' THEN
    ...        (TRDC.DISCOUNT_EXC * (ISNULL(TRDC.VAT_RATE, 7.00) + 100.00)) / 100.00
    ...        WHEN ISNULL(TRDC.DISCOUNT_BY, DISCOUNT_INC_BY) = 'P' THEN
    ...        (ISNULL(TRDC.TRADE_PRICE_INC_VAT, M.BASE_PRICE ) * (TRDC.DISCOUNT_EXC)) / 100.00
    ...        ELSE
    ...            0
    ...        END
    ...        WHEN TRDC.DISCOUNT_EXC IS NOT NULL AND TRDC.SPECIAL_DISC_INC IS NOT NULL THEN
    ...        CASE
    ...        WHEN TRDC.DISCOUNT_BY = 'B' AND TRDC.DISCOUNT_INC_BY = 'B' THEN
    ...        ((TRDC.DISCOUNT_EXC * (ISNULL(TRDC.VAT_RATE, 7.00) + 100.00)) / 100.00)
    ...        WHEN TRDC.DISCOUNT_BY = 'B' AND TRDC.DISCOUNT_INC_BY = 'P' THEN
    ...        ((TRDC.DISCOUNT_EXC * (ISNULL(TRDC.VAT_RATE, 7.00) + 100.00)) / 100 ) +
    ...        (((ISNULL(TRDC.TRADE_PRICE_INC_VAT, M.BASE_PRICE ) -
    ...        ((TRDC.DISCOUNT_EXC * (ISNULL(TRDC.VAT_RATE, 7.00) + 100.00)) / 100.00))))
    ...        WHEN TRDC.DISCOUNT_BY = 'P' AND TRDC.DISCOUNT_INC_BY = 'B' THEN
    ...        ((ISNULL(TRDC.TRADE_PRICE_INC_VAT, M.BASE_PRICE) * (TRDC.DISCOUNT_EXC)) / 100.00)
    ...        WHEN TRDC.DISCOUNT_BY = 'P' AND TRDC.DISCOUNT_INC_BY = 'P' THEN
    ...            ((ISNULL(TRDC.TRADE_PRICE_INC_VAT, M.BASE_PRICE ) * (TRDC.DISCOUNT_EXC)) / 100.00) +
    ...            ((ISNULL(TRDC.TRADE_PRICE_INC_VAT, M.BASE_PRICE )-
    ...            ((ISNULL(TRDC.TRADE_PRICE_INC_VAT, M.BASE_PRICE ) * (TRDC.DISCOUNT_EXC)) / 100.00)))
    ...        ELSE
    ...            0
    ...        END
    ...        ELSE
    ...           0
    ...        END), 2) AS PRICE
    ...    FROM main_products M
    ...    LEFT JOIN [SIT-CPC].[SIT_CPC].PRODUCT_SPEC ps on ps.COMPANY = M.COMPANY AND ps.MAT_CODE = M.MAT_CODE
    ...    LEFT JOIN [SIT-CPC].[SIT_CPC].TR_PRODUCT TRP ON TRP.BRAND = M.BRAND AND TRP.MODEL = M.MODEL AND TRP.PRODUCT_TYPE = M.PRODUCT_TYPE AND TRP.PRODUCT_SUBTYPE = M.PRODUCT_SUBTYPE
    ...    AND CONVERT(datetime,SYSDATETIMEOFFSET() AT TIME ZONE 'SE Asia Standard Time') BETWEEN TRP.START_DATE AND CONVERT(datetime,ISNULL(TRP.END_DATE,'9999/12/31 23:59:59'))
    ...    LEFT JOIN [SIT-CPC].[SIT_CPC].TR_MST TMS ON TRP.TRADE_NO = TMS.TRADE_NO AND CONVERT(datetime,SYSDATETIMEOFFSET() AT TIME ZONE 'SE Asia Standard Time') BETWEEN TMS.TRADE_START_DATE AND CONVERT(datetime,ISNULL(TMS.TRADE_END_DATE,'9999/12/31 23:59:59'))
    ...    LEFT JOIN [SIT-CPC].[SIT_CPC].TR_DISCOUNT TRDC ON TRDC.TRADE_NO = TMS.TRADE_NO AND TRDC.TRADE_PRODUCT_ID = TRP.TRADE_PRODUCT_ID AND CONVERT(datetime, SYSDATETIMEOFFSET() AT TIME ZONE 'SE Asia Standard Time') BETWEEN TRDC.START_DATE AND CONVERT(datetime, ISNULL(TRDC.END_DATE, '9999/12/31 23:59:59'))
    ...    JOIN [SIT-CPC].[SIT_CPC].CAMPAIGN_TR_MST ctm on ctm.TR_MST_TRADE_NO = TMS.TRADE_NO
    ...        JOIN [SIT-CPC].[SIT_CPC].CAMPAIGN c on c.ID = ctm.CAMPAIGN_ID
    ...        Where c.CODE = 'HOT_DEAL_NEW' ),
    ...    all_product as (
    ...    select *, DENSE_RANK() OVER (ORDER BY row_rank ) as row_num
    ...    from sub_products s
    ...    where 1=1),
    ...    total_product as (
    ...    select max(row_num) as total from all_product)
    ...    select *
    ...    from all_product p
    ...    left join total_product t on t.total > 0    
    ...    order by p.BEST_SELLER_TYPE_NUM, p.PRODUCT_ID Desc, p.row_num  
    ...    ==>
    ...    *** Condition ***
    ...    - filter by code
    ...    ==>
    ...    *** Expect Result ***
    ...    - products.length = 8
    ...    ==>
    [Tags]    58.1.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${58_1_2_body_get_all_products_by_campaign}
    Send Request API    url=${url_get_all_products_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}     Get List Key And Count From Json    $.products
    Should Be True                 int(${count_products}) == int(8)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length == 8
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_058 Get All Products By Campaign (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by code
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.products.length == 3
    ...    ==>
    [Tags]    58.2.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${58_2_1_body_get_all_products_by_campaign}
    Send Request API    url=${url_get_all_products_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}       Get List Key And Count From Json             $.products
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(3)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length == 3
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "products" == "${count_products}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_058 Get All Products By Campaign (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."status": "20000"
    ...     - 2.products มี length == totalRow - (offset-1) 
    ...    ==>
    [Tags]   58.2.2    Conditions         
    Set API Header Default
    Set Body API        schema_body=${58_2_2_body_get_all_products_by_campaign}
    Send Request API    url=${url_get_all_products_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    ${total}    Get Value From Json     ${response.json()}    $.totalRow
    ${body_offset}    Get Value From Json     ${API_BODY}     $.offset
    ${products_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${count_products}) == int(${products_length})
    ${result}    Catenate
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_products_length == "${count_products}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> products_length: int(${total}[0] - (${body_offset}[0] - 1) == "${products_length}"
    ...    ${\n}---> "$products_length(${products_length})" == "$resp_products_length(${count_products})"
    Log    ${result}

CPC_API_1_1_059 Custom Search All Product
    [Documentation]    Owner : Kachain.a    Edit : Patipan.w
    [Tags]    59        
    Set API Header Default
    Set Body API        schema_body=${59_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${59_response_custom_search_all_product}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_059 Custom Search All Product (Conditions_Test_Case_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by brands
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode = 20000
    ...    2. products ทุกตัวต้องมี brand เป็น APPLE
    ...    ==>
    [Tags]   59.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${59_1_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       20000 
    ${count}    Get List Key And Count From Json                $.products
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_brand}    Get Value From Json    ${response.json()}    $.products[${index - 1}].brand
         Should Be Equal As Strings               ${value_brand}[0]     APPLE
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_brand: "$.products[${index - 1}].brand"
         ...    ${\n}---> condition = "statusCode = 20000"
         ...    ${\n}---> condition = products ทุกตัวต้องมี brand เป็น APPLE
         ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
         ...    ${\n}---> "brand" == "${value_brand}[0]"
         Log    ${result}
    END

CPC_API_1_1_059 Custom Search All Product (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by price, flagAISPromotion (N)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. statusCode = 20000
    ...     2. products ทุกตัวต้องมี 
    ...        - normalPrice.min <= 30000
    ...        - normalPrice.max >= 30000
    ...    ==>
    [Tags]   59.2.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${59_2_1_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       20000 
    ${count}    Get List Key And Count From Json                $.products
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_normalPrice_min}    Get Value From Json    ${response.json()}    $.products[${index - 1}].normalPrice.min
         ${value_normalPrice_max}    Get Value From Json    ${response.json()}    $.products[${index - 1}].normalPrice.max
         Should Be True    float(${value_normalPrice_min}[0]) <= float(30000)
         Should Be True    float(${value_normalPrice_max}[0]) >= float(30000) 
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_normalPrice_min: "$.products[${index - 1}].normalPrice.min"
         ...    ${\n}---> json_path_normalPrice_max: "$.products[${index - 1}].normalPrice.max"
         ...    ${\n}---> condition = "statusCode = 20000"
         ...    ${\n}---> condition = products ทุกตัวมี normalPrice.min <= 30000
         ...    ${\n}---> condition = products ทุกตัวมี normalPrice.max >= 30000
         ...    ${\n}---> condition("normalPrice_min(${value_normalPrice_min}[0])" <= 30000 and "normalPrice_max(${value_normalPrice_max}[0])" >= 30000)
         ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
         ...    ${\n}---> "normalPrice_min" == "${value_normalPrice_min}[0]"
         ...    ${\n}---> "normalPrice_max" == "${value_normalPrice_max}[0]"
         Log    ${result}
    END

CPC_API_1_1_059 Custom Search All Product (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by price, flagAISPromotion (Y)
    ...    ==>
    ...    *** Expect Result ***
    ...     1. statusCode = 20000
    ...     2. products ทุกตัวต้องมี 
    ...        - promotionPrice.min <= 30000
    ...        - promotionPrice.max >= 30000
    ...    ==>
    [Tags]   59.2.2    Conditions             
    Set API Header Default
    Set Body API        schema_body=${59_2_2_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json    ${response.json()}     $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       20000
    ${count}    Get List Key And Count From Json                $.products
    Should Be True    int(${count}) > int(0)
    FOR  ${index}  IN RANGE    1    ${count} + 1
         ${value_promotionPrice_min}    Get Value From Json    ${response.json()}    $.products[${index - 1}].promotionPrice.min
         ${value_promotionPrice_max}    Get Value From Json    ${response.json()}    $.products[${index - 1}].promotionPrice.max
         Should Be True    float(${value_promotionPrice_min}[0]) <= float(30000)
         Should Be True    float(${value_promotionPrice_max}[0]) >= float(30000) 
         ${result}    Catenate
         ...    ${\n}---> loop: "${index}"
         ...    ${\n}---> json_path_promotionPrice_min: "$.products[${index - 1}].promotionPrice.min"
         ...    ${\n}---> json_path_promotionPrice_max: "$.products[${index - 1}].promotionPrice.max"
         ...    ${\n}---> condition = "statusCode = 20000"
         ...    ${\n}---> condition = products ทุกตัวมี promotionPrice.min <= 30000
         ...    ${\n}---> condition = products ทุกตัวมี promotionPrice.max >= 30000
         ...    ${\n}---> condition("promotionPrice_min(${value_promotionPrice_min}[0])" <= 30000 and "promotionPrice_max(${value_promotionPrice_max}[0])" >= 30000)
         ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
         ...    ${\n}---> "promotionPrice_min" == "${value_promotionPrice_min}[0]"
         ...    ${\n}---> "promotionPrice_max" == "${value_promotionPrice_max}[0]"
         Log    ${result}
    END

CPC_API_1_1_059 Custom Search All Product (Conditions_Test_Case_3)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by display
    ...     SCREEN_SIZE_NUMBER = 4.7
    ...    ==>
    ...    *** Expect Result ***
    ...    1. statusCode = 20000
    ...    2. products.length = 5
    ...    ==>
    [Tags]   59.3    Conditions             
    Set API Header Default
    Set Body API        schema_body=${59_3_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${count_products}       Get List Key And Count From Json             $.products
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(5)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: products.length = "5"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_059 Custom Search All Product (Conditions_Test_Case_4)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by dualSIM
    ...    ==>
    ...    *** Expect Result ***
    ...     1. statusCode = 20000
    ...     2. products.length = 2
    ...    ==>
    [Tags]   59.4    Conditions             
    Set API Header Default
    Set Body API        schema_body=${59_4_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${count_products}       Get List Key And Count From Json             $.products
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(2)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: products.length = "2"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_059 Custom Search All Product (Conditions_Test_Case_5)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by memorySize
    ...    ==>
    ...    *** Expect Result ***
    ...     1. statusCode = 20000
    ...     2. products.length = 1
    ...    ==>
    [Tags]   59.5    Conditions             
    Set API Header Default
    Set Body API        schema_body=${59_5_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${count_products}       Get List Key And Count From Json             $.products
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(1)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: products.length = "1"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_059 Custom Search All Product (Conditions_Test_Case_6)
    [Documentation]    Owner : Patipan.w
    ...    *** CMD SQL ***
    ...    WITH product as (
    ...          SELECT DISTINCT PSPC.MAIN_CAMERA_NUMBER, PPRD.COMMERCIAL_NAME, PPRD.BRAND FROM [SIT_CPC].VIEWPUBLISHPRODUCT() PPRD
    ...          INNER JOIN [SIT_CPC].VIEWPUBLISHSPEC()  AS PSPC  ON PPRD.MODEL = PSPC.MODEL 
    ...          LEFT JOIN [SIT_CPC].VIEWPUBLISH_PAYMENT() AS PPAY ON PPRD.TRADE_PRODUCT_ID = PPAY.TRADE_PRODUCT_ID
    ...    --      AND (PPAY.BANK_ABBR  IN (@14)) 
    ...          WHERE PPRD.PRICE_TYPE = 'NORMAL' AND (PPRD.BRAND IN ('SAMSUNG'))  --AND PPRD.PRICE BETWEEN   @0  AND  @1 
    ...    --      AND PSPC.SCREEN_SIZE_NUMBER BETWEEN @2 AND @3
    ...    --      AND PSPC.MEMORY_NUMBER BETWEEN  @4 AND @5
    ...    --      AND PSPC.MAIN_CAMERA_NUMBER BETWEEN @6 AND @7
    ...    --      AND PSPC.SECONDARY_CAMERA_NUMBER BETWEEN @8 AND @9 
    ...    --      AND PSPC.SIM_SLOT = @10  
    ...          )
    ...          ,total as (
    ...            select count(*) as totalRow
    ...            from product
    ...          )
    ...          ,count_row as (
    ...            SELECT COUNT(*) AS NUM  FROM (
    ...              SELECT ROW_NUMBER() OVER(ORDER BY BRAND) AS RN 
    ...            FROM product P
    ...            )s --WHERE  RN >= @11 AND  RN <= ((@11 + @12)-1)
    ...          )
    ...           select p.*,t.totalRow, c.NUM as countRow
    ...           from product p
    ...           left join total t on t.totalRow > 0
    ...           left join count_row c on c.NUM > 0
    ...           ORDER BY BRAND, COMMERCIAL_NAME OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY 
    ...    ==>
    ...    *** Condition ***
    ...     - filter by mainCamera
    ...    ==>
    ...    *** Expect Result ***
    ...     1. statusCode = 20000
    ...     2. products.length = countRow    ** SA แจ้ง เปลื่ยนเงื่อนไขเป็น products.length = countRow (14/5/2567)**
    ...    ==>
    [Tags]   59.6    Conditions             
    Set API Header Default
    Set Body API        schema_body=${59_6_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${value_countRow}       Get Value From Json    ${response.json()}    $.countRow
    ${count_products}       Get List Key And Count From Json             $.products
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(${value_countRow}[0])
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: products.length = countRow
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "countRow" == "${value_countRow}[0]"
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_059 Custom Search All Product (Conditions_Test_Case_7)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by secondaryCamera
    ...    ==>
    ...    *** Expect Result ***
    ...     1. statusCode = 20000
    ...     2. products.length = 4    
    ...    ==>
    [Tags]   59.7    Conditions        
    Set API Header Default
    Set Body API        schema_body=${59_7_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${count_products}       Get List Key And Count From Json             $.products
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(4)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: products.length = "4"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_059 Custom Search All Product (Conditions_Test_Case_8)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by banks
    ...    ==>
    ...    *** Expect Result ***
    ...     1. statusCode = 20000
    ...     2. products.length = 5
    ...    ==>
    [Tags]   59.8    Conditions             
    Set API Header Default
    Set Body API        schema_body=${59_8_body_custom_search_all_product}
    Send Request API    url=${url_custom_search_all_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}

    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${count_products}       Get List Key And Count From Json             $.products
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(4)
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: products.length = "4"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "products" == "${count_products}"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text
    [Documentation]    Owner : Kachain.a    Edit : Patipan.w
    [Tags]    60        
    Set API Header Default
    Set Body API        schema_body=${60_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${60_response_search_product_with_promotions_by_text}
    Verify Value Response By Key    $..status        20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_1_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter required
    ...    - parameter ไม่ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    - statusCode = 50000
    ...    ==>
    [Tags]   60.1.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_1_1_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=500
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    50000 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "50000"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_1_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...    validate parameter matCode 
    ...    - parameter ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...    1. "status": "20000"
    ...    2. products มี length > 0
    ...    ==>
    [Tags]   60.1.2    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_1_2_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}         Get List Key And Count From Json              $.products
    ${value_status}           Get Value From Json    ${response.json()}     $.status
    Should Be Equal As Strings     ${value_status}[0]    20000
    Should Be True                 int(${count_products}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> condition: products.length > "0"
    ...    ${\n}---> "products" == "${count_products}"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_1_3)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     validate parameter brand, model, color 
    ...     - parameter ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...     1. "status": "20000"
    ...     2. products มี length > 0
    ...    ==>
    [Tags]   60.1.3    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_1_3_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}         Get List Key And Count From Json              $.products
    ${value_status}           Get Value From Json    ${response.json()}     $.status
    Should Be Equal As Strings     ${value_status}[0]    20000
    Should Be True                 int(${count_products}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> condition: products.length > "0"
    ...    ${\n}---> "products" == "${count_products}"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_1_4)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     validate parameter brand, model, color 
    ...     - parameter ไม่ครบ
    ...    ==>
    ...    *** Expect Result ***
    ...     - statusCode = 50000
    ...    ==>
    [Tags]   60.1.4    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_1_4_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=500
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    50000 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "50000"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by regularPrice **MOC
    ...    ==>
    ...    *** Expect Result ***
    ...     1. "status": "20000"
    ...     2. ใน products ทุกตัวจะต้องมี trades[0].discounts.tradeDiscountId = 145677 เท่านั้น (ที่ sit มี set  ไว้แค่ 4 trade อาจมีเปลี่ยนแปลงได้ ** "endDate": "2024-12-31" )
    ...    ==>
    [Tags]   60.2.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_2_1_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json              $.products
    ${value_status}      Get Value From Json    ${response.json()}     $.status
    Should Be Equal As Strings     ${value_status}[0]       20000 
    Should Be True                 int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}      Get List Key And Count From Json      $.products[${index_products - 1}].trades
            Should Be True       int(${count_trades}) == int(1)
            ${count_discounts}   Get List Key And Count From Json      $.products[${index_products - 1}].trades[0].discounts
            FOR    ${index_discounts}  IN RANGE   1    ${count_discounts} + 1
                    ${value_tradeDiscountId}    Get Value From Json     ${response.json()}    $.products[${index_products - 1}].trades[0].discounts[${index_discounts - 1}].tradeDiscountId
                    Should Be True    int(${value_tradeDiscountId}[0]) == int(145677)
                    ${result}    Catenate
                    ...    ${\n}---> loop products: "${index_products}"
                    ...    ${\n}---> json_path_tradeDiscountId: "$.products[${index_products - 1}].trades[0].discounts[${index_discounts - 1}].tradeDiscountId"
                    ...    ${\n}---> condition: "status": "20000"
                    ...    ${\n}---> condition: ใน products ทุกตัวจะต้องมี trades[0].discounts.tradeDiscountId = "145677" เท่านั้น
                    ...    ${\n}---> "status" == "${value_status}[0]"
                    ...    ${\n}---> "tradeDiscountId" == "${value_tradeDiscountId}[0]"
                    Log    ${result}
            END
    END

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by regularPrice **MOC
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   60.2.2    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_2_2_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_2_3)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by regularPrice ** Non MOC
    ...    ==>
    ...    *** Expect Result ***
    ...     - ใน products จะต้องไม่พบ tradeNo (trades[0].tradeNo) ต่อไปนี้ 
    ...    TP22054718
    ...    TP22054719
    ...    TP22054721
    ...    TP22054722
    ...    TP22054724
    ...    TP22054726
    ...    TP22064743
    ...    ==>
    [Tags]   60.2.3    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_2_3_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${expect_not_contain_tradeNo}    Create List    
    ...    TP22054718
    ...    TP22054719
    ...    TP22054721
    ...    TP22054722
    ...    TP22054724
    ...    TP22054726
    ...    TP22064743
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_tradeNo}      Get Value From Json     ${response.json()}    $.products[${index_products - 1}].trades[0].tradeNo
            List Should Not Contain Value    ${expect_not_contain_tradeNo}    ${value_tradeNo}[0]
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_tradeNo: "$.products[${index_products - 1}].trades[0].tradeNo"
            ...    ${\n}---> condition: ใน products จะต้องไม่พบ tradeNo (trades[0].tradeNo) ต่อไปนี้ 
            ...    ${\n}---> ${expect_not_contain_tradeNo}
            ...    ${\n}---> "tradeNo" == "${value_tradeNo}[0]"
            Log    ${result}
    END

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_3_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by orderTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   60.3.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_3_1_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_3_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by orderTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...     - ใน products ทุกตัวจะต้องพบ "Convert Pre to Post" อยู่ใน criterias (trades[0].criterias[index].criteria) 
    ...    ==>
    [Tags]   60.3.2    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_3_2_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE       1    ${count_products} + 1    
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_criteria}           Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].criteria
            List Should Contain Value    ${value_criteria}[0]    Convert Pre to Post
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_criteria: "$.products[${index_products - 1}].trades[0].criterias[*].criteria"
            ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ "Convert Pre to Post" อยู่ใน criterias (trades[0].criterias[*].criteria)"
            ...    ${\n}---> "criteria" == "${value_criteria}[0]"
            Log    ${result}
    END

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_4_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by chargeTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   60.4.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_4_1_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_4_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by chargeTypes 
    ...    ==>
    ...    *** Expect Result ***
    ...    ใน products ทุกตัวจะต้องพบ
    ...    1. "Existing" อยู่ใน criterias (trades[0].criterias[index].criteria) 
    ...    2. "Pre-paid" อยู่ใน criterias (trades[0].criterias[index].chargeType) 
    ...    ==>
    [Tags]   60.4.2    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_4_2_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
            Should Be True    int(${count_trades}) == int(1)
            ${value_criteria}            Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].criteria
            ${value_chargeType}          Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].criterias[*].chargeType
            List Should Contain Value    ${value_criteria}[0]      Existing
            List Should Contain Value    ${value_chargeType}[0]    Pre-paid
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_criteria: "$.products[${index_products - 1}].trades[0].criterias[*].criteria"
            ...    ${\n}---> json_path_chargeType: "$.products[${index_products - 1}].trades[0].criterias[*].chargeType"
            ...    ${\n}---> condition: "Existing อยู่ใน criterias (trades[0].criterias[index].criteria)"
            ...    ${\n}---> condition: "Pre-paid อยู่ใน criterias (trades[0].criterias[index].chargeType)"
            ...    ${\n}---> "criteria" == "${value_criteria}[0]"
            ...    ${\n}---> "chargeType" == "${value_chargeType}[0]"
            Log    ${result}
    END

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_5_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by saleChannels 
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   60.5.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_5_1_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

# CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_5_2)
#     [Documentation]    Owner : Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...     - filter by saleChannels 
#     ...    ==>
#     ...    *** Expect Result ***
#     ...     - ใน products ทุกตัวจะต้องพบ "TELEWIZ" อยู่ใน channels (trades[0].channels[index].saleChannel) 
#     ...     - ** SA แจ้งให้ Cancel Case 14/5/2567 **
#     ...    ==>
#     [Tags]   60.5.2    Conditions        Cancel         
#     Set API Header Default
#     Set Body API        schema_body=${60_5_2_body_search_product_with_promotions_by_text}
#     Send Request API    url=${url_search_product_with_promotions_by_text}
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     ${count_products}    Get List Key And Count From Json    $.products
#     Should Be True    int(${count_products}) > int(0)
#     FOR    ${index_products}  IN RANGE       1    ${count_products} + 1
#             ${count_trades}   Get List Key And Count From Json    $.products[${index_products - 1}].trades
#             Should Be True    int(${count_trades}) == int(1)
#             ${value_saleChannel}           Get Value From Json      ${response.json()}    $.products[${index_products - 1}].trades[0].channels[*].saleChannel
#             List Should Contain Value    ${value_saleChannel}       TELEWIZ
#             ${result}    Catenate
#             ...    ${\n}---> loop products: "${index_products}"
#             ...    ${\n}---> json_path_saleChannel: "$.products[${index_products - 1}].trades[0].channels[*].saleChannel"
#             ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ "TELEWIZ" อยู่ใน channels (trades[0].channels[index].saleChannel)"
#             ...    ${\n}---> "saleChannel" == "${value_saleChannel}"
#             Log    ${result}
#     END

# CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_6_1)
#     [Documentation]    Owner : Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...     - filter by blacklistAcrossOper 
#     ...    ==>
#     ...    *** Expect Result ***
#     ...     - status = 40401
#     ...     - ** SA แจ้งให้ Cancel Case 14/5/2567 **
#     ...    ==>
#     [Tags]   60.6.1    Conditions       Cancel   

# CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_6_2)
#     [Documentation]    Owner : Patipan.w
#     ...    ==>
#     ...    *** Condition ***
#     ...     - filter by blacklistAcrossOper 
#     ...    ==>
#     ...    *** Expect Result ***
#     ...     - ** SA แจ้งให้ Cancel Case 14/5/2567 **
#     ...    ==>
#     [Tags]   60.6.2    Conditions      Cancel       

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_7_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by aspFlag 
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   60.7.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_7_1_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_7_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by aspFlag 
    ...    ==>
    ...    *** Expect Result ***
    ...     1. "status": "20000"
    ...     2. products มี length > 0 **ข้อมูลอาจจะเปลี่ยนตาม config จาก DT
    ...    ==>
    [Tags]   60.7.2    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_7_2_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}       Get List Key And Count From Json             $.products
    ${value_status}         Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]       20000
    Should Be True                 int(${count_products}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length > 0
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> "products" == "${count_products}"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_8_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     1. "status": "20000"
    ...     2. products มี length == 3 
    ...    ==>
    [Tags]   60.8.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_8_1_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}       Get List Key And Count From Json             $.products
    ${value_status}         Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]       20000
    Should Be True                 int(${count_products}) == int(3)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length == 3
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> "products" == "${count_products}"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_8_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by offset -max 
    ...    ==>
    ...    *** Expect Result ***
    ...     1. "status": "20000"
    ...     2. products มี length == total - (offset-1) 
    ...    ==>
    [Tags]   60.8.2    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_8_2_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${products_length}    Get List Key And Count From Json          $.products
    ${total}    Get Value From Json     ${response.json()}          $.total
    ${body_offset}    Get Value From Json     ${API_BODY}           $.offset
    ${value_status}   Get Value From Json     ${response.json()}    $.status
    ${data_length}    Evaluate    int(${total}[0] - (${body_offset}[0] - 1))
    Should Be True    int(${products_length}) == int(${data_length})
    Should Be Equal As Strings   ${value_status}[0]    20000
    ${result}    Catenate
    ...    ${\n}---> condition: status = "20000"
    ...    ${\n}---> condition: total - (offset-1)
    ...    ${\n}---> resp_products_length == "${products_length}"
    ...    ${\n}---> resp_total == "${total}[0]"
    ...    ${\n}---> body_offset == "${body_offset}[0]"
    ...    ${\n}---> data_length: int(${total}[0] - (${body_offset}[0] - 1) == "${data_length}"
    ...    ${\n}---> "$data_length(${data_length})" == "$resp_products_length(${products_length})"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_9_1)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by searchText 
    ...    ==>
    ...    *** Expect Result ***
    ...     - ใน products ทุกตัวจะต้องพบ campaigns[0].campaignName ที่มีคำว่า Point  (เป็น sensitive case)
    ...    ==>
    [Tags]   60.9.1    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_9_1_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}    Get List Key And Count From Json    $.products
    Should Be True    int(${count_products}) > int(0)
    FOR    ${index_products}  IN RANGE   1    ${count_products} + 1
            ${count_campaigns}   Get List Key And Count From Json    $.products[${index_products - 1}].campaigns
            Should Be True    int(${count_campaigns}) == int(1)
            ${value_campaignName}    Get Value From Json    ${response.json()}    $.products[${index_products - 1}].campaigns[0].campaignName
            Should Contain    ${value_campaignName}[0]    Point    ignore_case=${True}
            ${result}    Catenate
            ...    ${\n}---> loop products: "${index_products}"
            ...    ${\n}---> json_path_campaignName: "$.products[${index_products - 1}].campaigns[0].campaignName"
            ...    ${\n}---> condition: "ใน products ทุกตัวจะต้องพบ campaigns[0].campaignName ที่มีคำว่า Point (เป็น sensitive case)"
            ...    ${\n}---> "campaignName" == "${value_campaignName}[0]"
            Log    ${result}
    END

CPC_API_1_1_060 Search Product with Promotions by Text (Conditions_Test_Case_9_2)
    [Documentation]    Owner : Patipan.w
    ...    ==>
    ...    *** Condition ***
    ...     - filter by searchText 
    ...    ==>
    ...    *** Expect Result ***
    ...     - status = 40401
    ...    ==>
    [Tags]   60.9.2    Conditions             
    Set API Header Default
    Set Body API        schema_body=${60_9_2_body_search_product_with_promotions_by_text}
    Send Request API    url=${url_search_product_with_promotions_by_text}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_status}     Get Value From Json    ${response.json()}    $.status
    Should Be Equal As Strings     ${value_status}[0]    40401 
    ${result}    Catenate
    ...    ${\n}---> condition: status = "40401"
    ...    ${\n}---> "status" == "${value_status}[0]"
    Log    ${result}

CPC_API_1_1_061 Get Trade Criteria by Product 
    [Documentation]    Owner : Kachain.a
    [Tags]    61
    Set API Header Default
    Set Body API        schema_body=${61_body_get_trade_criteria_by_product}
    Send Request API    url=${url_get_trade_criteria_by_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${61_response_get_trade_criteria_by_product}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_061 Get Trade Criteria by Product (Conditions_Test_Case_1_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by company,matCode
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.criterias.length > 0
    ...    ==>
    [Tags]   61.1.1    Conditions
    Set API Header Default
    Set Body API        schema_body=${61_1_1_body_get_trade_criteria_by_product}
    Send Request API    url=${url_get_trade_criteria_by_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_criterias}       Get List Key And Count From Json    $.criterias
    ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_criterias}) > int(0) 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: criterias.length > 0
    ...    ${\n}---> "statusCode" == "${value_statusCode}"
    ...    ${\n}---> "criterias" == "${count_criterias}"
    Log    ${result}

CPC_API_1_1_061 Get Trade Criteria by Product (Conditions_Test_Case_1_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by company,matCode
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.criterias.length = 0
    ...    ==>
    [Tags]   61.1.2    Conditions 
    Set API Header Default
    Set Body API        schema_body=${61_1_2_body_get_trade_criteria_by_product}
    Send Request API    url=${url_get_trade_criteria_by_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_criterias}       Get List Key And Count From Json    $.criterias
    ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_criterias}) == int(0) 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: criterias.length = 0
    ...    ${\n}---> "statusCode" == "${value_statusCode}"
    ...    ${\n}---> "criterias" == "${count_criterias}"
    Log    ${result}

CPC_API_1_1_061 Get Trade Criteria by Product (Conditions_Test_Case_2_1)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by company,brand,model,color,productType,productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.criterias.length > 0
    ...    ==>
    [Tags]   61.2.1    Conditions 
    Set API Header Default
    Set Body API        schema_body=${61_2_1_body_get_trade_criteria_by_product}
    Send Request API    url=${url_get_trade_criteria_by_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_criterias}       Get List Key And Count From Json    $.criterias
    ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_criterias}) > int(0) 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: criterias.length > 0
    ...    ${\n}---> "statusCode" == "${value_statusCode}"
    ...    ${\n}---> "criterias" == "${count_criterias}"
    Log    ${result}

CPC_API_1_1_061 Get Trade Criteria by Product (Conditions_Test_Case_2_2)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - filter by company,brand,model,color,productType,productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.criterias.length = 0
    ...    ==>
    [Tags]   61.2.2    Conditions
    Set API Header Default
    Set Body API        schema_body=${61_2_2_body_get_trade_criteria_by_product}
    Send Request API    url=${url_get_trade_criteria_by_product}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_criterias}       Get List Key And Count From Json    $.criterias
    ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_criterias}) == int(0) 
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> condition: criterias.length = 0
    ...    ${\n}---> "statusCode" == "${value_statusCode}"
    ...    ${\n}---> "criterias" == "${count_criterias}"
    Log    ${result}

# CPC_API_1_1_061 Get Trade Criteria by Product (Conditions_Test_Case_3_1)
#     [Documentation]    Owner : Kachain.a
#     ...    ==>
#     ...    *** Condition ***
#     ...     - filter by aspFlag = true
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - 1.statusCode = 20000
#     ...    - 2.criterias.length = 0
#     ...     ** cancel เนื่องจากไม่มีผลกับข้อมูล 7/5/2567 **
#     ...    ==>
#     [Tags]   61.3.1    Conditions 
#     Set API Header Default
#     Set Body API        schema_body=${61_3_1_body_get_trade_criteria_by_product}
#     Send Request API    url=${url_get_trade_criteria_by_product}
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     ${count_criterias}       Get List Key And Count From Json    $.criterias
#     ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
#     Should Be Equal As Strings     ${value_statusCode}[0]    20000
#     Should Be True                 int(${count_criterias}) == int(0) 
#     ${result}    Catenate
#     ...    ${\n}---> condition: statusCode = "20000"
#     ...    ${\n}---> condition: criterias.length = 0
#     ...    ${\n}---> "statusCode" == "${value_statusCode}"
#     ...    ${\n}---> "criterias" == "${count_criterias}"
#     Log    ${result}

# CPC_API_1_1_061 Get Trade Criteria by Product (Conditions_Test_Case_3_2)
#     [Documentation]    Owner : Kachain.a
#     ...    ==>
#     ...    *** Condition ***
#     ...     - filter by aspFlag = true
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - 1.statusCode = 20000
#     ...    - 2.criterias.length = 0
#     ...     ** cancel เนื่องจากไม่มีผลกับข้อมูล 7/5/2567 **
#     ...    ==>
#     [Tags]   61.3.2    Conditions     
#     skip
#     Set API Header Default
#     Set Body API        schema_body=${61_3_2_body_get_trade_criteria_by_product}
#     Send Request API    url=${url_get_trade_criteria_by_product}
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     ${count_criterias}       Get List Key And Count From Json    $.criterias
#     ${value_statusCode}     Get Value From Json     ${response.json()}    $.statusCode
#     Should Be Equal As Strings     ${value_statusCode}[0]    20000
#     Should Be True                 int(${count_criterias}) == int(0) 
#     ${result}    Catenate
#     ...    ${\n}---> condition: statusCode = "20000"
#     ...    ${\n}---> condition: criterias.length = 0
#     ...    ${\n}---> "statusCode" == "${value_statusCode}"
#     ...    ${\n}---> "criterias" == "${count_criterias}"
#     Log    ${result}

CPC_API_1_1_062 Get Trade Sale Channel
    [Documentation]    Owner : Kachain.a
    [Tags]    62    
    Set API Header Default
    Set Body API        schema_body=${62_body_get_trade_sale_channel}
    Send Request API    url=${url_get_trade_sale_channel}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${62_response_get_trade_sale_channel}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_062 Get Trade Sale Channel (Conditions_Test_Case_1)
    [Documentation]    Owner: Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT * FROM SIT_CPC.TR_SALE_CHANNEL 
    ...    ==>
    ...    *** Condition ***
    ...    - TR_SALE_CHANNEL active
    ...    ==>
    ...    *** Expect Result ***
    ...    - tradeSaleChannels.length = 1
    ...    ==>
    [Tags]    62.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${62_1_body_get_trade_sale_channel}
    Send Request API    url=${url_get_trade_sale_channel}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_tradeSaleChannels}     Get List Key And Count From Json    $.tradeSaleChannels
    Should Be True                 int(${count_tradeSaleChannels}) == int(1)
    ${result}    Catenate
    ...    ${\n}---> condition: tradeSaleChannels มี length == 1
    ...    ${\n}---> "tradeSaleChannels" == "${count_tradeSaleChannels}"
    Log    ${result}

CPC_API_1_1_062 Get Trade Sale Channel (Conditions_Test_Case_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - TR_SALE_CHANNEL not active
    ...    ==>
    ...    *** Expect Result ***
    ...    - tradeSaleChannels.length = 0
    ...    ==>
    [Tags]    62.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${62_2_body_get_trade_sale_channel}
    Send Request API    url=${url_get_trade_sale_channel}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_tradeSaleChannels}     Get List Key And Count From Json    $.tradeSaleChannels
    Should Be True                 int(${count_tradeSaleChannels}) == int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: tradeSaleChannels มี length == 0
    ...    ${\n}---> "tradeSaleChannels" == "${count_tradeSaleChannels}"
    Log    ${result}

CPC_API_1_1_063 Get All Product Search
    [Documentation]    Owner : Kachain.a
    [Tags]    63
    Set API Header Default
    Send Request API    url=${url_get_all_product_search}
    ...                 method=GET
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${63_response_get_all_product_search}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_064 Get Product Specification
    [Documentation]    Owner : Kachain.a
    [Tags]    64   
    Set API Header Default
    Set Body API        schema_body=${64_body_get_product_specification}
    Send Request API    url=${url_get_product_specification}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${64_response_get_product_specification}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_064 Get Product Specification (Conditions_Test_Case_1)
    [Documentation]    Owner: Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT PSPC.MODEL,BRAND,PSPC.SCREEN_SIZE, PSPC.MEMORY, PSPC.MAIN_CAMERA
    ...    , PSPC.SECONDARY_CAMERA, PSPC.CPU_TYPE, PSPC.CPU_CORE, PSPC.CPU_SPEED, PSPC.OPERATING_SYSTEM
    ...    , PSPC.OPERATING_SYSTEM_VERSION, PSPC.SIM_SLOT, PSPC.SCREEN_RESOLUTION, PSPC.VIDEO_UHD
    ...    , PSPC.INTERNAL_MEMORY, PSPC.CAMERA_SPECIFICATION, PSPC.CPU_SYSTEM, PSPC.VIDEO
    ...    FROM SIT_CPC.VIEWPUBLISHPRODUCT() PRODUCT
    ...    INNER JOIN  SIT_CPC.VIEWPUBLISHSPEC() AS PSPC  ON PRODUCT.MODEL = PSPC.MODEL 
    ...    ==>
    ...    *** Condition ***
    ...    - filter by brand, model
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.products.length > 0
    ...    ==>
    [Tags]    64.1    Conditions    
    Set API Header Default
    Set Body API        schema_body=${64_1_body_get_product_specification}
    Send Request API    url=${url_get_product_specification}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}       Get List Key And Count From Json    $.products
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length > 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "products" == "${count_products}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_064 Get Product Specification (Conditions_Test_Case_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by brand, model
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode = 20000
    ...    - 2.products.length = 0
    ...    ==>
    [Tags]    64.2    Conditions    
    Set API Header Default
    Set Body API        schema_body=${64_2_body_get_product_specification}
    Send Request API    url=${url_get_product_specification}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_products}       Get List Key And Count From Json    $.products
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_products}) == int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: products มี length == 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "products" == "${count_products}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

# CPC_API_1_1_065 Get Related Products
#     [Documentation]    Owner : Kachain.a
#     ...   *** Remark : skip ข้ามเทสข้อนี้ไปได้เลย ไม่มี data test #พี่มด(24/04/2567) ***
#     [Tags]    65        skip
#     Set API Header Default
#     Set Body API        schema_body=${65_body_get_related_products}
#     Send Request API    url=${url_get_related_products}
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     Verify Json Schema Success      ${65_response_get_related_products}
#     Verify Value Response By Key    $..statusCode    20000
#     Verify Value Response By Key    $..statusDesc    Success
#     Write Response To Json File

CPC_API_1_1_066 Get Trade Prebooking
    [Documentation]    Owner : Kachain.a
    [Tags]    66
    Set API Header Default
    Set Body API        schema_body=${66_body_get_trade_prebooking}
    Send Request API    url=${url_get_trade_prebooking}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${66_response_get_trade_prebooking}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_066 Get Trade Prebooking (Conditions_Test_Case_1_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by brand,model,color,productType,productSubtype
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.trades.length = 8
    ...    ==>
    [Tags]    66.1.1    Conditions
    Set API Header Default
    Set Body API        schema_body=${66_1_1_body_get_trade_prebooking}
    Send Request API    url=${url_get_trade_prebooking}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_trades}       Get List Key And Count From Json    $.trades
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_trades}) == int(8)
    ${result}    Catenate
    ...    ${\n}---> condition: trades มี length == 8
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "trades" == "${count_trades}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_066 Get Trade Prebooking (Conditions_Test_Case_1_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by brand,model,color,productType,productSubtype
    ...      **not found config
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 40401
    ...    ==>
    [Tags]    66.1.2    Conditions 
    Set API Header Default
    Set Body API        schema_body=${66_1_2_body_get_trade_prebooking}
    Send Request API    url=${url_get_trade_prebooking}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    40401
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_066 Get Trade Prebooking (Conditions_Test_Case_2_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by location ** config for 1011
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.trades.length = 1
    ...    - 3. trades[0].tradeNo = TP17070354
    ...    ==>
    [Tags]    66.2.1    Conditions
    Set API Header Default
    Set Body API        schema_body=${66_2_1_body_get_trade_prebooking}
    Send Request API    url=${url_get_trade_prebooking}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${count_trades}         Get List Key And Count From Json    $.trades
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True         int(${count_trades}) == int(1)
    ${value_tradeNo}       Get Value From Json     ${response.json()}    $.trades[0].tradeNo
    Should Be Equal As Strings     ${value_tradeNo}[0]      TP17070354
    ${result}    Catenate
    ...    ${\n}---> condition: trades มี length == 1
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "trades" == "${count_trades}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> loop index trades: fix "0"
    ...    ${\n}---> json_path_title: "$.trades[0].tradeNo"
    ...    ${\n}---> condition: All "tradeNo" is "TP17070354"
    ...    ${\n}---> "trades[0].tradeNo" == "${value_tradeNo}[0]"
    Log    ${result}

CPC_API_1_1_066 Get Trade Prebooking (Conditions_Test_Case_2_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by location ** config for 1011
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.trades.length = 1
    ...    - 3. trades[0].tradeNo = TP17070354
    ...    ==>
    [Tags]    66.2.2    Conditions  
    Set API Header Default
    Set Body API        schema_body=${66_2_2_body_get_trade_prebooking}
    Send Request API    url=${url_get_trade_prebooking}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${count_trades}         Get List Key And Count From Json    $.trades
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True         int(${count_trades}) == int(1)
    ${value_tradeNo}       Get Value From Json     ${response.json()}    $.trades[0].tradeNo
    Should Be Equal As Strings     ${value_tradeNo}[0]      TP17070354
    ${result}    Catenate
    ...    ${\n}---> condition: trades มี length == 1
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "trades" == "${count_trades}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> loop index trades: fix "0"
    ...    ${\n}---> json_path_title: "$.trades[0].tradeNo"
    ...    ${\n}---> condition: All "tradeNo" is "TP17070354"
    ...    ${\n}---> "trades[0].tradeNo" == "${value_tradeNo}[0]"
    Log    ${result}

CPC_API_1_1_067 Get Campaign Promotions
    [Documentation]    Owner : Kachain.a
    [Tags]    67
    Set Header Validate Token
    Set Body API        schema_body=${67_body_get_campaign_promotions}
    Send Request API    url=${url_get_campaign_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Verify Json Schema Success      ${67_response_get_campaign_promotions}
    Write Response To Json File

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token does not exist
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]    67.1    Conditions
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJMMlJDYUdJcmFtcGxUWFpVYTNaVFpFeFdkRWhNVVQwOUxuTmhjMmx1WVMxbWIzSXRjSEp2WkE9PSIsImNsaWVudEtleSI6InNhc2luYS1mb3ItcHJvZCIsImlhdCI6MTcxMjA3NDMxMiwiZXhwIjoxNzEyMTE3NTEyfQ.hJ_p9urGVYiz3C0bslcPpeNUCVCmJm2saLvgq7rPpjE
    Set Body API        schema_body=${67_1_body_get_campaign_promotions}
    Send Request API          url=${url_get_payments_by_campaign}
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${67_1_response_get_campaign_promotions}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token expire
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    67.2    Conditions
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJZVGMwYWpsaVVFazFWMjFGYTJsVE1qTkJaSGgyZHowOUxuUnllU0IwYnlCelpXVWdiV1U9IiwiY2xpZW50S2V5IjoidHJ5IHRvIHNlZSBtZSIsImlhdCI6MTcxMjA4OTEzOCwiZXhwIjoxNzEyMjYxOTM4fQ.9K6gaZ3-CM_t52J_12-GrMQIWF9mi6SDSoUIROvp0ho
    Set Body API        schema_body=${67_2_body_get_campaign_promotions}
    Send Request API          url=${url_get_payments_by_campaign}
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${67_2_response_get_campaign_promotions}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000"
    ...    ==>
    [Tags]    67.3    Conditions
    Set Header Validate Token
    Set Body API              schema_body=${67_3_body_get_campaign_promotions}
    Send Request API          url=${url_get_payments_by_campaign}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${67_3_response_get_campaign_promotions}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT pm.BRAND,pm.MODEL, pm.PRODUCT_TYPE, pm.PRODUCT_SUBTYPE, ctm.CAMPAIGN_ID, tc.CRITERIA_VALUE
    ...    FROM SIT_CPC.CAMPAIGN c 
    ...    join SIT_CPC.CAMPAIGN_TR_MST ctm on ctm.CAMPAIGN_ID = c.ID 
    ...    JOIN SIT_CPC.TR_MST tm on tm.TRADE_NO = ctm.TR_MST_TRADE_NO 
    ...    JOIN SIT_CPC.TR_PRODUCT tp on tp.TRADE_NO = tm.TRADE_NO 
    ...    JOIN SIT_CPC.PRODUCT_MST pm on pm.BRAND = ISNULL(tp.BRAND, pm.BRAND) and pm.MODEL = ISNULL(tp.MODEL, pm.MODEL)
    ...    JOIN SIT_CPC.TR_CRITERIA tc on tc.TRADE_NO = tm.TRADE_NO 
    ...    and pm.PRODUCT_TYPE  = ISNULL(tp.PRODUCT_TYPE, pm.PRODUCT_TYPE) and pm.PRODUCT_SUBTYPE  = ISNULL(tp.PRODUCT_SUBTYPE, pm.PRODUCT_SUBTYPE)
    ...    WHERE c.PUBLISH = 1
    ...    and pm.MODEL = 'IP12_128GB'
    ...    and tc.CRITERIA_VALUE = 'Existing'
    ...    and tm.TRADE_NO in (
    ...    SELECT DISTINCT CN.TRADE_NO
    ...            FROM [SIT_CPC].TR_CN CN
    ...            WHERE CN.LOCATION_CODE = 1100 
    ...                OR (CN.LOCATION_CODE IS NULL  
    ...                    AND (CN.PROVINCE = 'กรุงเทพ'
    ...                            OR (CN.PROVINCE = 'ALL'
    ...                                    AND (CN.REGION = 'CB' OR CN.REGION = 'ALL')
    ...                                    AND ( 
    ...                                            ( CN.SHOP_TYPE = 'RETAIL' OR  
    ...                                            ( 
    ...                                                (CN.SHOP_TYPE = 'ALL' OR  CN.SHOP_TYPE is null )
    ...                                                AND 
    ...                                                (  
    ...                                                    (CN.SHOP_TYPE_GROUP = 'ALL' OR CN.SHOP_TYPE_GROUP is null)
    ...                                                )  
    ...                                            )  
    ...                                            )                                                
    ...                                            AND (CN.PUBLIC_NAME is null OR CN.PUBLIC_NAME = 'ALL') 
    ...                                            AND CN.SALE_CHANNEL in ('ALL AIS','BRN','ACC')   
    ...                                        )
    ...                                ) 
    ...                        ) 
    ...                    ) 
    ...    )
    ...    ==>
    ...    *** Condition ***
    ...    - filter by brand,model,color,productType,productSubtype, locationCode, saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.campaigns.length = 2
    ...    ==>
    [Tags]    67.4.1    Conditions
    Set Header Validate Token
    Set Body API        schema_body=${67_4_1_body_get_campaign_promotions}
    Send Request API    url=${url_get_campaign_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_campaigns}       Get List Key And Count From Json    $.campaigns
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_campaigns}) == int(2)
    ${result}    Catenate
    ...    ${\n}---> condition: campaigns มี length == 2
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "campaigns" == "${count_campaigns}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT pm.BRAND,pm.MODEL, pm.PRODUCT_TYPE, pm.PRODUCT_SUBTYPE, ctm.CAMPAIGN_ID, tc.CRITERIA_VALUE
    ...    FROM SIT_CPC.CAMPAIGN c 
    ...    join SIT_CPC.CAMPAIGN_TR_MST ctm on ctm.CAMPAIGN_ID = c.ID 
    ...    JOIN SIT_CPC.TR_MST tm on tm.TRADE_NO = ctm.TR_MST_TRADE_NO 
    ...    JOIN SIT_CPC.TR_PRODUCT tp on tp.TRADE_NO = tm.TRADE_NO 
    ...    JOIN SIT_CPC.PRODUCT_MST pm on pm.BRAND = ISNULL(tp.BRAND, pm.BRAND) and pm.MODEL = ISNULL(tp.MODEL, pm.MODEL)
    ...    JOIN SIT_CPC.TR_CRITERIA tc on tc.TRADE_NO = tm.TRADE_NO 
    ...    and pm.PRODUCT_TYPE  = ISNULL(tp.PRODUCT_TYPE, pm.PRODUCT_TYPE) and pm.PRODUCT_SUBTYPE  = ISNULL(tp.PRODUCT_SUBTYPE, pm.PRODUCT_SUBTYPE)
    ...    WHERE c.PUBLISH = 1
    ...    and pm.MODEL = 'V5' and pm.BRAND = 'VIVO'
    ...    and tc.CRITERIA_VALUE = 'Existing'
    ...    and tm.TRADE_NO in (
    ...    SELECT DISTINCT CN.TRADE_NO
    ...            FROM [SIT_CPC].TR_CN CN
    ...            WHERE CN.LOCATION_CODE = 1100 
    ...                OR (CN.LOCATION_CODE IS NULL  
    ...                    AND (CN.PROVINCE = 'กรุงเทพ'
    ...                            OR (CN.PROVINCE = 'ALL'
    ...                                    AND (CN.REGION = 'CB' OR CN.REGION = 'ALL')
    ...                                    AND ( 
    ...                                            ( CN.SHOP_TYPE = 'RETAIL' OR  
    ...                                            ( 
    ...                                                (CN.SHOP_TYPE = 'ALL' OR  CN.SHOP_TYPE is null )
    ...                                                AND 
    ...                                                (  
    ...                                                    (CN.SHOP_TYPE_GROUP = 'ALL' OR CN.SHOP_TYPE_GROUP is null)
    ...                                                )  
    ...                                            )  
    ...                                            )                                                
    ...                                            AND (CN.PUBLIC_NAME is null OR CN.PUBLIC_NAME = 'ALL') 
    ...                                            AND CN.SALE_CHANNEL in ('ASP')   
    ...                                        )
    ...                                ) 
    ...                        ) 
    ...                    ) 
    ...    )
    ...    ==>
    ...    *** Condition ***
    ...    - filter by brand,model,color,productType,productSubtype, locationCode, saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.campaigns.length = 6
    ...    ==>
    [Tags]    67.4.2    Conditions 
    Set Header Validate Token
    Set Body API        schema_body=${67_4_2_body_get_campaign_promotions}
    Send Request API    url=${url_get_campaign_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_campaigns}       Get List Key And Count From Json    $.campaigns
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_campaigns}) == int(6)
    ${result}    Catenate
    ...    ${\n}---> condition: campaigns มี length == 6
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "campaigns" == "${count_campaigns}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_4_3)
    [Documentation]    Owner: Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT pm.BRAND,pm.MODEL, pm.PRODUCT_TYPE, pm.PRODUCT_SUBTYPE, ctm.CAMPAIGN_ID, tc.CRITERIA_VALUE
    ...    FROM SIT_CPC.CAMPAIGN c 
    ...    join SIT_CPC.CAMPAIGN_TR_MST ctm on ctm.CAMPAIGN_ID = c.ID 
    ...    JOIN SIT_CPC.TR_MST tm on tm.TRADE_NO = ctm.TR_MST_TRADE_NO 
    ...    JOIN SIT_CPC.TR_PRODUCT tp on tp.TRADE_NO = tm.TRADE_NO 
    ...    JOIN SIT_CPC.PRODUCT_MST pm on pm.BRAND = ISNULL(tp.BRAND, pm.BRAND) and pm.MODEL = ISNULL(tp.MODEL, pm.MODEL)
    ...    JOIN SIT_CPC.TR_CRITERIA tc on tc.TRADE_NO = tm.TRADE_NO 
    ...    and pm.PRODUCT_TYPE  = ISNULL(tp.PRODUCT_TYPE, pm.PRODUCT_TYPE) and pm.PRODUCT_SUBTYPE  = ISNULL(tp.PRODUCT_SUBTYPE, pm.PRODUCT_SUBTYPE)
    ...    WHERE c.PUBLISH = 1
    ...    and pm.MODEL = 'IPHONEXSM256' and pm.BRAND = 'VIVO'
    ...    and tc.CRITERIA_VALUE = 'Existing'
    ...    and tm.TRADE_NO in (
    ...    SELECT DISTINCT CN.TRADE_NO
    ...            FROM [SIT_CPC].TR_CN CN
    ...            WHERE CN.LOCATION_CODE = 1100 
    ...                OR (CN.LOCATION_CODE IS NULL  
    ...                    AND (CN.PROVINCE = 'กรุงเทพ'
    ...                            OR (CN.PROVINCE = 'ALL'
    ...                                    AND (CN.REGION = 'CB' OR CN.REGION = 'ALL')
    ...                                    AND ( 
    ...                                            ( CN.SHOP_TYPE = 'RETAIL' OR  
    ...                                            ( 
    ...                                                (CN.SHOP_TYPE = 'ALL' OR  CN.SHOP_TYPE is null )
    ...                                                AND 
    ...                                                (  
    ...                                                    (CN.SHOP_TYPE_GROUP = 'ALL' OR CN.SHOP_TYPE_GROUP is null)
    ...                                                )  
    ...                                            )  
    ...                                            )                                                
    ...                                            AND (CN.PUBLIC_NAME is null OR CN.PUBLIC_NAME = 'ALL') 
    ...                                            AND CN.SALE_CHANNEL in ('ASP')   
    ...                                        )
    ...                                ) 
    ...                        ) 
    ...                    ) 
    ...    )    
    ...    ==>
    ...    *** Condition ***
    ...    - filter by brand,model,color,productType,productSubtype, locationCode, saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 40401
    ...    - 2.campaigns.length = 0
    ...    ==>
    [Tags]    67.4.3    Conditions
    Set Header Validate Token
    Set Body API        schema_body=${67_4_3_body_get_campaign_promotions}
    Send Request API    url=${url_get_campaign_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_campaigns}       Get List Key And Count From Json    $.campaigns
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    40401
    Should Be True                 int(${count_campaigns}) == int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: campaigns มี length == 0
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> "campaigns" == "${count_campaigns}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_5_1)
    [Documentation]    Owner: Kachain.a
    ...    *** CMD SQL ***
    ...    SELECT DISTINCT pm.BRAND,pm.MODEL,pm.COLOR , pm.PRODUCT_TYPE, pm.PRODUCT_SUBTYPE, ctm.CAMPAIGN_ID, tc.CRITERIA_VALUE
    ...    FROM SIT_CPC.CAMPAIGN c 
    ...    join SIT_CPC.CAMPAIGN_TR_MST ctm on ctm.CAMPAIGN_ID = c.ID 
    ...    JOIN SIT_CPC.TR_MST tm on tm.TRADE_NO = ctm.TR_MST_TRADE_NO 
    ...    JOIN SIT_CPC.TR_PRODUCT tp on tp.TRADE_NO = tm.TRADE_NO 
    ...    JOIN SIT_CPC.PRODUCT_MST pm on pm.BRAND = ISNULL(tp.BRAND, pm.BRAND) and pm.MODEL = ISNULL(tp.MODEL, pm.MODEL)
    ...    JOIN SIT_CPC.TR_CRITERIA tc on tc.TRADE_NO = tm.TRADE_NO 
    ...    and pm.PRODUCT_TYPE  = ISNULL(tp.PRODUCT_TYPE, pm.PRODUCT_TYPE) and pm.PRODUCT_SUBTYPE  = ISNULL(tp.PRODUCT_SUBTYPE, pm.PRODUCT_SUBTYPE)
    ...    WHERE c.PUBLISH = 1
    ...    and pm.MODEL = 'IP12_128GB' and pm.BRAND = 'APPLE' and pm.COLOR = 'BLACK'
    ...    and tc.CRITERIA_VALUE = 'MNP'
    ...    and tm.TRADE_NO in (
    ...    SELECT DISTINCT CN.TRADE_NO
    ...            FROM [SIT_CPC].TR_CN CN
    ...            WHERE CN.LOCATION_CODE = 1100 
    ...                OR (CN.LOCATION_CODE IS NULL  
    ...                    AND (CN.PROVINCE = 'กรุงเทพ'
    ...                            OR (CN.PROVINCE = 'ALL'
    ...                                    AND (CN.REGION = 'CB' OR CN.REGION = 'ALL')
    ...                                    AND ( 
    ...                                            ( CN.SHOP_TYPE = 'RETAIL' OR  
    ...                                            ( 
    ...                                                (CN.SHOP_TYPE = 'ALL' OR  CN.SHOP_TYPE is null )
    ...                                                AND 
    ...                                                (  
    ...                                                    (CN.SHOP_TYPE_GROUP = 'ALL' OR CN.SHOP_TYPE_GROUP is null)
    ...                                                )  
    ...                                            )  
    ...                                            )                                                
    ...                                            AND (CN.PUBLIC_NAME is null OR CN.PUBLIC_NAME = 'ALL') 
    ...                                            AND CN.SALE_CHANNEL in ('ALL AIS','BRN','ACC')  
    ...                                        )
    ...                                ) 
    ...                        ) 
    ...                    ) 
    ...    )
    ...    ==>
    ...    *** Condition ***
    ...    - filter by customerGroup
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.campaigns.length = 2
    ...    ==>
    [Tags]    67.5.1    Conditions 
    Set Header Validate Token
    Set Body API        schema_body=${67_5_1_body_get_campaign_promotions}
    Send Request API    url=${url_get_campaign_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_campaigns}       Get List Key And Count From Json    $.campaigns
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_campaigns}) == int(2)
    ${result}    Catenate
    ...    ${\n}---> condition: campaigns มี length == 2
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "campaigns" == "${count_campaigns}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_5_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by customerGroup
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 40401
    ...    - 2.campaigns.length = 0
    ...    ==>
    [Tags]    67.5.2    Conditions
    Set Header Validate Token
    Set Body API        schema_body=${67_5_2_body_get_campaign_promotions}
    Send Request API    url=${url_get_campaign_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_campaigns}       Get List Key And Count From Json    $.campaigns
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    40401
    Should Be True                 int(${count_campaigns}) == int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: campaigns มี length == 0
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> "campaigns" == "${count_campaigns}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_5_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by customerGroup
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.campaigns.length = 3
    ...    ==>
    [Tags]    67.5.3    Conditions 
    Set Header Validate Token
    Set Body API        schema_body=${67_5_3_body_get_campaign_promotions}
    Send Request API    url=${url_get_campaign_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_campaigns}       Get List Key And Count From Json    $.campaigns
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_campaigns}) == int(3)
    ${result}    Catenate
    ...    ${\n}---> condition: campaigns มี length == 3
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "campaigns" == "${count_campaigns}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_6_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradePattern.includes
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.campaigns.length = 4
    ...    ==>
    [Tags]    67.6.1    Conditions 
    Set Header Validate Token
    Set Body API        schema_body=${67_6_1_body_get_campaign_promotions}
    Send Request API    url=${url_get_campaign_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_campaigns}       Get List Key And Count From Json    $.campaigns
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_campaigns}) == int(4)
    ${result}    Catenate
    ...    ${\n}---> condition: campaigns มี length == 4
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "campaigns" == "${count_campaigns}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_067 Get Campaign Promotions (Conditions_Test_Case_6_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradePattern.excludes
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.campaigns.length = 1
    ...    ==>
    [Tags]    67.6.2    Conditions 
    Set Header Validate Token
    Set Body API        schema_body=${67_6_2_body_get_campaign_promotions}
    Send Request API    url=${url_get_campaign_promotions}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_campaigns}       Get List Key And Count From Json    $.campaigns
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_campaigns}) == int(1)
    ${result}    Catenate
    ...    ${\n}---> condition: campaigns มี length == 1
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "campaigns" == "${count_campaigns}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_068 Get Trade Promotions by Campaign
    [Documentation]    Owner : Kachain.a
    [Tags]    68
    Set Header Validate Token
    Set Body API        schema_body=${68_body_get_trade_promotions_by_campaign}
    Send Request API    url=${url_get_trade_promotions_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Verify Json Schema Success      ${68_response_get_trade_promotions_by_campaign}
    Write Response To Json File

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token does not exist
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]    68.1    Conditions
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJMMlJDYUdJcmFtcGxUWFpVYTNaVFpFeFdkRWhNVVQwOUxuTmhjMmx1WVMxbWIzSXRjSEp2WkE9PSIsImNsaWVudEtleSI6InNhc2luYS1mb3ItcHJvZCIsImlhdCI6MTcxMjA3NDMxMiwiZXhwIjoxNzEyMTE3NTEyfQ.hJ_p9urGVYiz3C0bslcPpeNUCVCmJm2saLvgq7rPpjE
    Set Body API        schema_body=${68_1_body_get_trade_promotions_by_campaign}
    Send Request API          url=${url_get_trade_promotions_by_campaign}
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${68_1_response_get_trade_promotions_by_campaign}

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token expire
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    68.2    Conditions  
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJZVGMwYWpsaVVFazFWMjFGYTJsVE1qTkJaSGgyZHowOUxuUnllU0IwYnlCelpXVWdiV1U9IiwiY2xpZW50S2V5IjoidHJ5IHRvIHNlZSBtZSIsImlhdCI6MTcxMjA4OTEzOCwiZXhwIjoxNzEyMjYxOTM4fQ.9K6gaZ3-CM_t52J_12-GrMQIWF9mi6SDSoUIROvp0ho
    Set Body API        schema_body=${68_2_body_get_trade_promotions_by_campaign}
    Send Request API          url=${url_get_trade_promotions_by_campaign}
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${68_2_response_get_trade_promotions_by_campaign}

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000"
    ...    ==>
    [Tags]    68.3    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${68_3_body_get_trade_promotions_by_campaign}
    Send Request API          url=${url_get_trade_promotions_by_campaign}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${68_3_response_get_trade_promotions_by_campaign}

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by campaignId
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "40401",
    ...    - 2."statusDesc": "Trade not found"
    ...    ==>
    [Tags]    68.4.1    Conditions  
    Set Header Validate Token
    Set Body API        schema_body=${68_4_1_body_get_trade_promotions_by_campaign}
    Send Request API    url=${url_get_trade_promotions_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${value_statusDesc}     Get Value From Json    ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]    40401
    Should Be Equal As Strings     ${value_statusDesc}[0]    Trade not found
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> condition: statusDesc = "Trade not found"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by campaignId brand,model,color,productType,productSubtype, locationCode, saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.data.prices.length > 0
    ...    ==>
    [Tags]    68.4.2    Conditions  
    Set Header Validate Token
    Set Body API        schema_body=${68_4_2_body_get_trade_promotions_by_campaign}
    Send Request API    url=${url_get_trade_promotions_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_prices}       Get List Key And Count From Json    $.data.prices
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_prices}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: prices มี length > 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "prices" == "${count_prices}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_4_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by campaignId brand,model,color,productType,productSubtype, locationCode, saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "40401",
    ...    - 2."statusDesc": "Trade not found"
    ...    ==>
    [Tags]    68.4.3    Conditions   
    Set Header Validate Token
    Set Body API        schema_body=${68_4_3_body_get_trade_promotions_by_campaign}
    Send Request API    url=${url_get_trade_promotions_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${value_statusDesc}     Get Value From Json    ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]    40401
    Should Be Equal As Strings     ${value_statusDesc}[0]    Trade not found
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> condition: statusDesc = "Trade not found"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_5_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by customerGroup
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.data.prices.length > 0
    ...    - 3.data.trades ทุกตัวจะต้องมีค่า criterias[index].criteria เป็น MNP
    ...    ==>
    [Tags]    68.5.1    Conditions  
    Set Header Validate Token
    Set Body API        schema_body=${68_5_1_body_get_trade_promotions_by_campaign}
    Send Request API    url=${url_get_trade_promotions_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_prices}       Get List Key And Count From Json    $.data.prices
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_prices}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: prices มี length > 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "prices" == "${count_prices}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}
    ${count_trades}       Get List Key And Count From Json    $.data.trades
    FOR    ${index}  IN RANGE      ${count_trades}
            ${count_trades}   Get List Key And Count From Json    $.data.trades
            Should Be True    int(${count_trades}) >= int(1)
            ${value_criteria}            Get Value From Json      ${response.json()}    $.data.trades[${index}].criterias[*].criteria
            List Should Contain Value    ${value_criteria}[0]     MNP
            ${result}    Catenate
            ...    ${\n}---> loop trades: "${index}"
            ...    ${\n}---> json_path_criteria: "$.data.trades[${index}].criterias[*].criteria"
            ...    ${\n}---> condition: "data.trades ทุกตัวจะต้องมีค่า $.data.trades[*].criterias[*].criteria เป็น MNP"
            ...    ${\n}---> "criteria" == "${value_criteria}[0]"
            Log    ${result}
    END

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_5_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by campaignId
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "40401",
    ...    - 2."statusDesc": "Trade not found"
    ...    ==>
    [Tags]    68.5.2    Conditions 
    Set Header Validate Token
    Set Body API        schema_body=${68_5_2_body_get_trade_promotions_by_campaign}
    Send Request API    url=${url_get_trade_promotions_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${value_statusDesc}     Get Value From Json    ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]    40401
    Should Be Equal As Strings     ${value_statusDesc}[0]    Trade not found
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> condition: statusDesc = "Trade not found"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_5_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by customerGroup
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1.statusCode= 20000
    ...    - 2.data.prices.length > 0
    ...    - 3.data.trades ทุกตัวจะต้องไม่มีค่า criterias[index].criteria 
    ...    ==>
    [Tags]    68.5.3    Conditions 
    Set Header Validate Token
    Set Body API        schema_body=${68_5_3_body_get_trade_promotions_by_campaign}
    Send Request API    url=${url_get_trade_promotions_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_prices}       Get List Key And Count From Json    $.data.prices
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_prices}) > int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: prices มี length > 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "prices" == "${count_prices}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}
    ${count_trades}       Get List Key And Count From Json    $.data.trades
    FOR    ${index}  IN RANGE      ${count_trades}
            ${count_trades}   Get List Key And Count From Json    $.data.trades
            ${value_criteria}            Get Value From Json      ${response.json()}    $.data.trades[${index}].criterias[*].criteria
            Should Be Empty        ${value_criteria}    msg=$.data.trades ทุกตัวจะต้องไม่มีค่า criterias[*].criteria 
            ${result}    Catenate
            ...    ${\n}---> loop trades: "${index}"
            ...    ${\n}---> json_path_criteria: "$.data.trades[${index}].criterias[*].criteria"
            ...    ${\n}---> condition: "data.trades ทุกตัวจะต้องไม่มีค่า criterias[index].criteria "
            ...    ${\n}---> "criteria" == "${value_criteria}"
            Log    ${result}
    END

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_6_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradePattern.includes
    ...    ==>
    ...    *** Expect Result ***
    ...    - รอ data test 
    ...    ==>
    [Tags]    68.6.1    Conditions 
    Set Header Validate Token
    Set Body API        schema_body=${68_6_1_body_get_trade_promotions_by_campaign}
    Send Request API    url=${url_get_trade_promotions_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}

CPC_API_1_1_068 Get Trade Promotions by Campaign (Conditions_Test_Case_6_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradePattern.includes
    ...    ==>
    ...    *** Expect Result ***
    ...    - รอ data test 
    ...    ==>
    [Tags]    68.6.2    Conditions 
    Set Header Validate Token
    Set Body API        schema_body=${68_6_2_body_get_trade_promotions_by_campaign}
    Send Request API    url=${url_get_trade_promotions_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}

CPC_API_1_1_069 Get Payments by Campaign
    [Documentation]    Owner : Kachain.a
    [Tags]    69   
    Set Header Validate Token
    Set Body API        schema_body=${69_body_get_payments_by_campaign}
    Send Request API    url=${url_get_payments_by_campaign}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Verify Json Schema Success      ${69_response_get_payments_by_campaign}
    Write Response To Json File

CPC_API_1_1_069 Get Payments by Campaign (Conditions_Test_Case_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token does not exist
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]    69.1    Conditions 
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJMMlJDYUdJcmFtcGxUWFpVYTNaVFpFeFdkRWhNVVQwOUxuTmhjMmx1WVMxbWIzSXRjSEp2WkE9PSIsImNsaWVudEtleSI6InNhc2luYS1mb3ItcHJvZCIsImlhdCI6MTcxMjA3NDMxMiwiZXhwIjoxNzEyMTE3NTEyfQ.hJ_p9urGVYiz3C0bslcPpeNUCVCmJm2saLvgq7rPpjE
    Set Body API        schema_body=${69_1_body_get_payments_by_campaign}
    Send Request API          url=${url_get_payments_by_campaign}
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${69_1_response_get_payments_by_campaign}

CPC_API_1_1_069 Get Payments by Campaign (Conditions_Test_Case_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token expire
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    69.2    Conditions 
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJZVGMwYWpsaVVFazFWMjFGYTJsVE1qTkJaSGgyZHowOUxuUnllU0IwYnlCelpXVWdiV1U9IiwiY2xpZW50S2V5IjoidHJ5IHRvIHNlZSBtZSIsImlhdCI6MTcxMjA4OTEzOCwiZXhwIjoxNzEyMjYxOTM4fQ.9K6gaZ3-CM_t52J_12-GrMQIWF9mi6SDSoUIROvp0ho
    Set Body API        schema_body=${69_2_body_get_payments_by_campaign}
    Send Request API          url=${url_get_payments_by_campaign}
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${69_2_response_get_payments_by_campaign}

CPC_API_1_1_069 Get Payments by Campaign (Conditions_Test_Case_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000"
    ...    ==>
    [Tags]    69.3    Conditions 
    Set Header Validate Token
    Set Body API              schema_body=${69_3_body_get_payments_by_campaign}
    Send Request API          url=${url_get_payments_by_campaign}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${69_3_response_get_payments_by_campaign}

CPC_API_1_1_069 Get Payments by Campaign (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by campaignId
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "40401",
    ...    - 2."statusDesc": "Data not found"
    ...    ==>
    [Tags]    69.4.1    Conditions 
    Set Header Validate Token
    Set Body API              schema_body=${69_4_1_body_get_payments_by_campaign}
    Send Request API          url=${url_get_payments_by_campaign}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${value_statusDesc}     Get Value From Json    ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]    40401
    Should Be Equal As Strings     ${value_statusDesc}[0]    Data not found
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> condition: statusDesc = "Data not found"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_069 Get Payments by Campaign (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by campaignId, locationCode, saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "20000"
    ...    - 2.payments.length = 10
    ...    ==>
    [Tags]    69.4.2    Conditions  
    Set Header Validate Token
    Set Body API              schema_body=${69_4_2_body_get_payments_by_campaign}
    Send Request API          url=${url_get_payments_by_campaign}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    ${count_payments}       Get List Key And Count From Json    $.payments
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_payments}) == int(9)
    ${result}    Catenate
    ...    ${\n}---> condition: payments มี length == 10
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "payments" == "${count_payments}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_069 Get Payments by Campaign (Conditions_Test_Case_4_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - filter by campaignId, locationCode, saleChannels
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "20000"
    ...    - 2.payments.length = 0
    ...    ==>
    [Tags]    69.4.3    Conditions  
    Set Header Validate Token
    Set Body API              schema_body=${69_4_3_body_get_payments_by_campaign}
    Send Request API          url=${url_get_payments_by_campaign}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    ${count_payments}       Get List Key And Count From Json    $.payments
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]    20000
    Should Be True                 int(${count_payments}) == int(0)
    ${result}    Catenate
    ...    ${\n}---> condition: payments มี length == 0
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "payments" == "${count_payments}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_070 Get FBB Matchings
    [Documentation]    Owner : Kachain.a
    [Tags]    70    
    Set Header Validate Token
    Set Body API        schema_body=${70_body_get_fbb_matchings}
    Send Request API    url=${url_get_fbb_matchings}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Verify Json Schema Success      ${70_response_get_fbb_matchings}
    Write Response To Json File

CPC_API_1_1_070 Get FBB Matchings (Conditions_Test_Case_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token does not exist
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]    70.1    Conditions    
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJMMlJDYUdJcmFtcGxUWFpVYTNaVFpFeFdkRWhNVVQwOUxuTmhjMmx1WVMxbWIzSXRjSEp2WkE9PSIsImNsaWVudEtleSI6InNhc2luYS1mb3ItcHJvZCIsImlhdCI6MTcxMjA3NDMxMiwiZXhwIjoxNzEyMTE3NTEyfQ.hJ_p9urGVYiz3C0bslcPpeNUCVCmJm2saLvgq7rPpjE
    Set Body API        schema_body=${70_1_body_get_fbb_matchings}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${70_1_response_get_fbb_matchings}

CPC_API_1_1_070 Get FBB Matchings (Conditions_Test_Case_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token expire
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    70.2    Conditions    
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJZVGMwYWpsaVVFazFWMjFGYTJsVE1qTkJaSGgyZHowOUxuUnllU0IwYnlCelpXVWdiV1U9IiwiY2xpZW50S2V5IjoidHJ5IHRvIHNlZSBtZSIsImlhdCI6MTcxMjA4OTEzOCwiZXhwIjoxNzEyMjYxOTM4fQ.9K6gaZ3-CM_t52J_12-GrMQIWF9mi6SDSoUIROvp0ho
    Set Body API        schema_body=${70_2_body_get_fbb_matchings}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${70_2_response_get_fbb_matchings}

CPC_API_1_1_070 Get FBB Matchings (Conditions_Test_Case_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000"
    ...    ==>
    [Tags]    70.3    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${70_3_body_get_fbb_matchings}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${70_3_response_get_fbb_matchings}

CPC_API_1_1_070 Get FBB Matchings (Conditions_Test_Case_4)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - have config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."statusCode" = "20000"
    ...     - 2.data != null
    ...    ==>
    [Tags]    70.4    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${70_4_body_get_fbb_matchings}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Value Response By Key      $..statusCode           20000
    ${response_data}         Get Value From Json    ${response.json()}    $.data
    Log Response Json        ${response_data}[0]
    Should Not Be Empty      ${response_data}[0]    msg=$.data valid is "null" or "none".

CPC_API_1_1_070 Get FBB Matchings (Conditions_Test_Case_5)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - not have config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."statusCode" = "20000"
    ...     - 2.data = {}
    ...    ==>
    [Tags]    70.5    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${70_5_body_get_fbb_matchings}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Value Response By Key      $..statusCode           20000
    ${response_data}         Get Value From Json    ${response.json()}    $.data
    Log Response Json        ${response_data}[0]
    Should Be Empty          ${response_data}[0]    msg=$.data valid is "{}".

CPC_API_1_1_071 Get AIS Fibre
    [Documentation]    Owner : Thanchanok    Edit : Kachain.a
    [Tags]    71
    Set Header Validate Token
    Set Body API        schema_body=${71_body_get_ais_fibre}
    Send Request API    url=${url_get_ais_fibre}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Verify Json Schema Success      ${71_response_get_ais_fibre}
    Write Response To Json File

CPC_API_1_1_071 Get AIS Fibre (Conditions_Test_Case_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token does not exist
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]    71.1    Conditions    
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJMMlJDYUdJcmFtcGxUWFpVYTNaVFpFeFdkRWhNVVQwOUxuTmhjMmx1WVMxbWIzSXRjSEp2WkE9PSIsImNsaWVudEtleSI6InNhc2luYS1mb3ItcHJvZCIsImlhdCI6MTcxMjA3NDMxMiwiZXhwIjoxNzEyMTE3NTEyfQ.hJ_p9urGVYiz3C0bslcPpeNUCVCmJm2saLvgq7rPpjE
    Set Body API              schema_body=${71_1_body_get_ais_fibre}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${71_1_response_get_ais_fibre}

CPC_API_1_1_071 Get AIS Fibre (Conditions_Test_Case_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token expire
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    71.2    Conditions    
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJZVGMwYWpsaVVFazFWMjFGYTJsVE1qTkJaSGgyZHowOUxuUnllU0IwYnlCelpXVWdiV1U9IiwiY2xpZW50S2V5IjoidHJ5IHRvIHNlZSBtZSIsImlhdCI6MTcxMjA4OTEzOCwiZXhwIjoxNzEyMjYxOTM4fQ.9K6gaZ3-CM_t52J_12-GrMQIWF9mi6SDSoUIROvp0ho
    Set Body API        schema_body=${71_2_body_get_ais_fibre}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${71_2_response_get_ais_fibre}

CPC_API_1_1_071 Get AIS Fibre (Conditions_Test_Case_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000"
    ...    ==>
    [Tags]    71.3    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${71_3_body_get_ais_fibre}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${71_3_response_get_ais_fibre}

CPC_API_1_1_071 Get AIS Fibre (Conditions_Test_Case_4)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - have config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."statusCode" = "20000"
    ...     - 2.data != null
    ...    ==>
    [Tags]    71.4    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${71_4_body_get_ais_fibre}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Value Response By Key      $..statusCode           20000
    ${response_data}         Get Value From Json    ${response.json()}    $.data
    Log Response Json        ${response_data}[0]
    Should Not Be Empty      ${response_data}[0]    msg=$.data valid is "null" or "none".

CPC_API_1_1_071 Get AIS Fibre (Conditions_Test_Case_5)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - not have config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."statusCode" = "20000"
    ...     - 2.data = {}
    ...    ==>
    [Tags]    71.5    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${71_5_body_get_ais_fibre}
    Send Request API          url=${url_get_fbb_matchings}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Value Response By Key      $..statusCode           20000
    ${response_data}         Get Value From Json    ${response.json()}    $.data
    Log Response Json        ${response_data}[0]
    Should Be Empty          ${response_data}[0]    msg=$.data valid is "{}".

CPC_API_1_1_072 Get FBB Change Detail
    [Documentation]    Owner : Thanchanok
    [Tags]    72
    Set Header Validate Token
    Set Body API        schema_body=${72_body_get_fbb_change_detail}
    Send Request API    url=${url_get_fbb_change_detail}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Verify Json Schema Success      ${72_response_get_fbb_change_detail}
    Write Response To Json File

CPC_API_1_1_072 Get FBB Change Detail (Conditions_Test_Case_1)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token does not exist
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]    72.1    Conditions    
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJMMlJDYUdJcmFtcGxUWFpVYTNaVFpFeFdkRWhNVVQwOUxuTmhjMmx1WVMxbWIzSXRjSEp2WkE9PSIsImNsaWVudEtleSI6InNhc2luYS1mb3ItcHJvZCIsImlhdCI6MTcxMjA3NDMxMiwiZXhwIjoxNzEyMTE3NTEyfQ.hJ_p9urGVYiz3C0bslcPpeNUCVCmJm2saLvgq7rPpjE
    Set Body API              schema_body=${72_1_body_get_fbb_change_detail}
    Send Request API          url=${url_get_fbb_change_detail}
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${72_1_response_get_fbb_change_detail}

CPC_API_1_1_072 Get FBB Change Detail (Conditions_Test_Case_2)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - token expire
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    72.2    Conditions    
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJZVGMwYWpsaVVFazFWMjFGYTJsVE1qTkJaSGgyZHowOUxuUnllU0IwYnlCelpXVWdiV1U9IiwiY2xpZW50S2V5IjoidHJ5IHRvIHNlZSBtZSIsImlhdCI6MTcxMjA4OTEzOCwiZXhwIjoxNzEyMjYxOTM4fQ.9K6gaZ3-CM_t52J_12-GrMQIWF9mi6SDSoUIROvp0ho
    Set Body API        schema_body=${72_2_body_get_fbb_change_detail}
    Send Request API          url=${url_get_fbb_change_detail}
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${72_2_response_get_fbb_change_detail}

CPC_API_1_1_072 Get FBB Change Detail (Conditions_Test_Case_3)
    [Documentation]    Owner: Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000"
    ...    ==>
    [Tags]    72.3    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${72_3_body_get_fbb_change_detail}
    Send Request API          url=${url_get_fbb_change_detail}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${72_3_response_get_fbb_change_detail}

CPC_API_1_1_072 Get FBB Change Detail (Conditions_Test_Case_4)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - have config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."statusCode" = "20000"
    ...     - 2.data != null
    ...    ==>
    [Tags]    72.4    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${72_4_body_get_fbb_change_detail}
    Send Request API          url=${url_get_fbb_change_detail}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Value Response By Key      $..statusCode           20000
    ${response_data}         Get Value From Json    ${response.json()}    $.data
    Log Response Json        ${response_data}[0]
    Should Not Be Empty      ${response_data}[0]    msg=$.data valid is "null" or "none".

CPC_API_1_1_072 Get FBB Change Detail (Conditions_Test_Case_5)
    [Documentation]    Owner : Kachain.a
    ...    ==>
    ...    *** Condition ***
    ...     - not have config from PLM
    ...    ==>
    ...    *** Expect Result ***
    ...     - 1."statusCode" = "20000"
    ...     - 2.data = {}
    ...    ==>
    [Tags]    72.5    Conditions    
    Set Header Validate Token
    Set Body API              schema_body=${72_5_body_get_fbb_change_detail}
    Send Request API          url=${url_get_fbb_change_detail}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Value Response By Key      $..statusCode           20000
    ${response_data}         Get Value From Json    ${response.json()}    $.data
    Log Response Json        ${response_data}[0]
    Should Be Empty          ${response_data}[0]    msg=$.data valid is "{}".

CPC_API_1_1_073 Get Payments V2
    [Documentation]    Owner : Tatphong Ratthanawichai
    [Tags]   73 
    Set Header Validate Token
    Set Body API        schema_body=${73_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${73_response_get_payments_v2}
    # Verify Value Response By Key    $..statusCode    20000
    # Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_1)
    [Documentation]    Owner: Sasina.I
    ...    ==>
    ...    *** Condition ***
    ...    - validate Parameter
    ...    ==>
    ...    *** Expect Result ***
    ...    - statusCode = 30000
    ...    ==>
    [Tags]    73.1    Conditions     
    Set Header Validate Token
    Set Body API        schema_body=${73_1_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       30000
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "30000"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_2)
    [Documentation]    Owner: Sasina.I
    ...    ==>
    ...    *** Condition ***
    ...    - data not found
    ...    ==>
    ...    *** Expect Result ***
    ...    - statusCode = 40401
    ...    ==>
    [Tags]    73.2   Conditions      
    Set Header Validate Token
    Set Body API        schema_body=${73_2_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       40401
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_3_1)
    [Documentation]    Owner: Sasina.I
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.TR_PAYMENT tp 
    ...    left join SIT_CPC.TR_PAYMENT tp2 on tp2.TRADE_NO = tp.TRADE_NO and tp2.TRADE_PRODUCT_ID is not null
    ...    where tp.TRADE_PRODUCT_ID is null and tp2.TRADE_NO is null
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo only
    ...    ==>
    ...    *** Expect Result ***
    ...    1. tradePayments มี length == 1
    ...    2. tradeProductId == null 
    ...    ==>
    [Tags]    73.3.1    Conditions    
    Set Header Validate Token
    Set Body API        schema_body=${73_3_1_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_payments}     Get List Key And Count From Json    $.tradePayments
    Should Be True        int(${count_payments}) == int(1)
    ${value_tradeProductId}    Get Value From Json      ${response.json()}    $.tradePayments[0].tradeProductId
    Should Be Equal As Strings        ${value_tradeProductId}[0]     None

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_3_2)
    [Documentation]    Owner: Sasina.I
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo only
    ...    ==>
    ...    *** Expect Result ***
    ...    1. tradePayments มี length == 1
    ...    2. tradeProductId == null 
    ...    ==>
    [Tags]    73.3.2    Conditions        
    Set Header Validate Token
    Set Body API        schema_body=${73_3_2_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_payments}     Get List Key And Count From Json    $.tradePayments
    Should Be True        int(${count_payments}) == int(1)
    ${value_tradeProductId}    Get Value From Json      ${response.json()}    $.tradePayments[0].tradeProductId
    Should Be Equal As Strings        ${value_tradeProductId}[0]     None

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Sasina.I
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.TR_PAYMENT tp 
    ...    left join SIT_CPC.TR_PAYMENT tp2 on tp2.TRADE_NO = tp.TRADE_NO and tp2.TRADE_PRODUCT_ID is not null
    ...    where tp.TRADE_PRODUCT_ID is not null
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo and  tradeProductId
    ...    ==>
    ...    *** Expect Result ***
    ...    1. tradePayments มี length == 2
    ...    2. พบ tradeProductId == null  และ tradeProductId != null
    ...    ==>
    [Tags]    73.4.1    Conditions        
    Set Header Validate Token
    Set Body API        schema_body=${73_4_1_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_payments}     Get List Key And Count From Json    $.tradePayments
    Should Be True        int(${count_payments}) == int(2)
    FOR    ${index_payments}  IN RANGE       1    2
            ${value_tradeProductId}    Get Value From Json      ${response.json()}    $.tradePayments[${index_payments - 1}].tradeProductId
            IF    $value_tradeProductId[0] != $None
                    ${result}    Catenate
                    ...    ${\n}---> loop tradePayments: "${index_payments}"
                    ...    ${\n}---> json_path_tradeProductId: "$.tradePayments[${index_payments - 1}].tradeProductId"
                    ...    ${\n}---> condition: พบ tradeProductId == null  และ tradeProductId != null
                    ...    ${\n}---> "tradeProductId" == "${value_tradeProductId}[0]"
                    Log    ${result}
            ELSE IF    $value_tradeProductId[0] == $None
                    ${result}    Catenate
                    ...    ${\n}---> loop tradePayments: "${index_payments}"
                    ...    ${\n}---> json_path_tradeProductId: "$.tradePayments[${index_payments - 1}].tradeProductId"
                    ...    ${\n}---> condition: พบ tradeProductId == null  และ tradeProductId != null
                    ...    ${\n}---> "tradeProductId" == "${value_tradeProductId}[0]"
                    Log    ${result}
            ELSE
                Fail    No support tradeProductId "${value_tradeProductId}[0]".
            END
    END

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Sasina.I
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo and  tradeProductId
    ...    ==>
    ...    *** Expect Result ***
    ...    1. tradePayments มี length == 1
    ...    2. tradeProductId != null 
    ...    ==>
    [Tags]    73.4.2    Conditions        
    Set Header Validate Token
    Set Body API        schema_body=${73_4_2_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_payments}     Get List Key And Count From Json    $.tradePayments
    Should Be True        int(${count_payments}) == int(1)
    ${value_tradeProductId}    Get Value From Json      ${response.json()}    $.tradePayments[0].tradeProductId
    Should Not Be Equal As Strings        ${value_tradeProductId}[0]     None

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_4_3)
    [Documentation]    Owner: Sasina.I
    ...    ==>
    ...    *** Condition ***
    ...    - config by tradeNo and  tradeProductId
    ...    ==>
    ...    *** Expect Result ***
    ...    1. tradePayments มี length == 3
    ...    2. พบ tradeProductId == null 1 ตัว
    ...    ==>
    [Tags]    73.4.3    Conditions        
    Set Header Validate Token
    Set Body API        schema_body=${73_4_3_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_payments}     Get List Key And Count From Json    $.tradePayments
    Should Be True        int(${count_payments}) == int(3)
    ${count_tradeProductId}   Set Variable    0
    FOR    ${index_payments}  IN RANGE       1    2
            ${value_tradeProductId}    Get Value From Json      ${response.json()}    $.tradePayments[${index_payments - 1}].tradeProductId
            IF    $value_tradeProductId[0] == $None
                    ${result}    Catenate
                    ...    ${\n}---> loop tradePayments: "${index_payments}"
                    ...    ${\n}---> json_path_tradeProductId: "$.tradePayments[${index_payments - 1}].tradeProductId"
                    ...    ${\n}---> condition: พบ tradeProductId == null 1 ตัว
                    ...    ${\n}---> "tradeProductId" == "${value_tradeProductId}[0]"
                    Log    ${result}        
                    ${count_tradeProductId}    Set Variable    ${count_tradeProductId}+1
            END
    END
    Should Be True        int(${count_tradeProductId}) >= int(1)

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_5_1)
    [Documentation]    Owner: Sasina.I
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradeProductId (config by tradeNo only)
    ...    ==>
    ...    *** Expect Result ***
    ...    - statusCode = 40401
    ...    ==>
    [Tags]    73.5.1    Conditions        
    Set Header Validate Token
    Set Body API        schema_body=${73_5_1_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${value_statusCode}            Get Value From Json          ${response.json()}    $.statusCode
    Should Be Equal As Strings     ${value_statusCode}[0]       40401
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    Log    ${result}

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_5_2)
    [Documentation]    Owner: Sasina.I
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradeProductId (config by tradeNo and  tradeProductId)
    ...    ==>
    ...    *** Expect Result ***
    ...    1. tradePayments มี length == 1
    ...    2. tradeProductId != null 
    ...    ==>
    [Tags]    73.5.2    Conditions        
    Set Header Validate Token
    Set Body API        schema_body=${73_5_2_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_payments}     Get List Key And Count From Json    $.tradePayments
    Should Be True        int(${count_payments}) == int(1)
    ${value_tradeProductId}    Get Value From Json      ${response.json()}    $.tradePayments[0].tradeProductId
    Should Not Be Equal As Strings        ${value_tradeProductId}[0]     None

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_6_1)
    [Documentation]    Owner: Sasina.I
    ...    *** CMD SQL ***
    ...    SELECT *
    ...    FROM SIT_CPC.TR_PAYMENT tp 
    ...    left join SIT_CPC.TR_PAYMENT tp2 on tp2.TRADE_NO = tp.TRADE_NO and tp2.TRADE_PRODUCT_ID is not null
    ...    where tp.TRADE_PRODUCT_ID is null and tp2.TRADE_NO is null
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradeNo (config by tradeNo only)
    ...    ==>
    ...    *** Expect Result ***
    ...    1. tradePayments มี length == 1
    ...    2. tradeProductId == null 
    ...    ==>
    [Tags]    73.6.1    Conditions        
    Set Header Validate Token
    Set Body API        schema_body=${73_6_1_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_payments}     Get List Key And Count From Json    $.tradePayments
    Should Be True        int(${count_payments}) == int(1)
    ${value_tradeProductId}    Get Value From Json      ${response.json()}    $.tradePayments[0].tradeProductId
    Should Be Equal As Strings        ${value_tradeProductId}[0]     None

CPC_API_1_1_073 Get Payments V2 (Conditions_Test_Case_6_2)
    [Documentation]    Owner: Sasina.I
    ...    ==>
    ...    *** Condition ***
    ...    - filter by tradeNo (config by tradeNo and  tradeProductId)
    ...    ==>
    ...    *** Expect Result ***
    ...    1. tradePayments มี length == 2
    ...    2. tradeProductId == null ทั้งหมด
    ...    ==>
    [Tags]    73.6.2    Conditions        
    Set Header Validate Token
    Set Body API        schema_body=${73_6_2_body_get_payments_v2}
    Send Request API    url=${url_get_payments_v2}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    ${count_payments}     Get List Key And Count From Json    $.tradePayments
    Should Be True        int(${count_payments}) == int(2)
    ${count_tradeProductId}   Set Variable    0
    FOR    ${index_payments}  IN RANGE       1    ${count_payments} + 1
        ${value_tradeProductId}    Get Value From Json      ${response.json()}    $.tradePayments[${index_payments - 1}].tradeProductId
        IF    '${value_tradeProductId}[0]' == 'None'
            ${count_tradeProductId}    Set Variable    ${count_tradeProductId}+1
        END
    END
    Should Be True        ${count_tradeProductId} == int(${count_payments})

CPC_API_1_1_074 Get Policy
    [Documentation]    Owner : Tatphong.R
    [Tags]   74         
    Set Header Validate Token
    Set Body API        schema_body=${74_body_get_policies}
    Send Request API    url=${url_get_Policies}
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${74_response_get_policies}
    Verify Value Response By Key    $..statusCode    20000
    Verify Value Response By Key    $..statusDesc    Success
    Write Response To Json File

CPC_API_1_1_074 Get Policy (Conditions_Test_Case_1)
    [Documentation]    Owner : Tatphong.R
    ...    ==>
    ...    *** Condition ***
    ...    - token does not exist
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]    74.1    Conditions 
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJMMlJDYUdJcmFtcGxUWFpVYTNaVFpFeFdkRWhNVVQwOUxuTmhjMmx1WVMxbWIzSXRjSEp2WkE9PSIsImNsaWVudEtleSI6InNhc2luYS1mb3ItcHJvZCIsImlhdCI6MTcxMjA3NDMxMiwiZXhwIjoxNzEyMTE3NTEyfQ.hJ_p9urGVYiz3C0bslcPpeNUCVCmJm2saLvgq7rPpjE
    Set Body API        schema_body=${74_1_body_get_policies}
    Send Request API          url=${url_get_Policies}
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${74_1_response_get_policies}

CPC_API_1_1_074 Get Policy (Conditions_Test_Case_2)
    [Documentation]    Owner: Tatphong R.
    ...    ==>
    ...    *** Condition ***
    ...    - token expire
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    74.2    Conditions    
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJZVGMwYWpsaVVFazFWMjFGYTJsVE1qTkJaSGgyZHowOUxuUnllU0IwYnlCelpXVWdiV1U9IiwiY2xpZW50S2V5IjoidHJ5IHRvIHNlZSBtZSIsImlhdCI6MTcxMjA4OTEzOCwiZXhwIjoxNzEyMjYxOTM4fQ.9K6gaZ3-CM_t52J_12-GrMQIWF9mi6SDSoUIROvp0ho
    Set Body API        schema_body=${74_2_body_get_policies}
    Send Request API          url=${url_get_policies}
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${74_2_response_get_policies}

CPC_API_1_1_074 Get Policy (Conditions_Test_Case_3)
    [Documentation]    Owner: Tatphong.R
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000"
    ...    ==>
    [Tags]    74.3    Conditions   
    Set Header Validate Token
    Set Body API              schema_body=${74_3_body_get_policies}
    Send Request API          url=${url_get_policies}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${74_3_response_get_policies}

CPC_API_1_1_074 Get Policy (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Tatphong.R
    ...    ==>
    ...    *** Condition ***
    ...    - filter by poRowId
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "40401",
    ...    - 2."statusDesc": "Data not found"
    ...    ==>
    [Tags]    74.4.1    Conditions
    Set Header Validate Token
    Set Body API              schema_body=${74_4_1_body_get_policies}
    Send Request API          url=${url_get_policies}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${value_statusDesc}     Get Value From Json    ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]    40401
    Should Be Equal As Strings     ${value_statusDesc}[0]    Data not found
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> condition: statusDesc = "Data not found"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_074 Get Policy (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Tatphong.R
    ...    ==>
    ...    *** Condition ***
    ...    - filter by poRowId
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "20000"
    ...    ==>
    [Tags]    74.4.2    Conditions
    Set Header Validate Token
    Set Body API              schema_body=${74_4_2_body_get_policies}
    Send Request API          url=${url_get_policies}
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}

    ${value_statusCode}    Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings    ${value_statusCode}[0]    20000
    ${data}    Get Value From Json    ${response.json()}    $.data
    Should Not Be Empty    ${data}
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "data" == "${data}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}"
    Log    ${result}

CPC_API_1_1_075 Get All Package Codes By Product Offering ID
    [Documentation]    Owner : Tatphong Ratthanawichai
    [Tags]   75 
    Set Header Validate Token
    Run Keyword And Ignore Error    Send Request API    url=${url_get_package_codes}
    ...                 method=GET
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    # สร้างไฟล์ api_parameter.yml เพื่อเกบ query string ในไฟล์ url_cpc_api.resource ก็กำหนดเปนตัวแปรครับ
    Verify Json Schema Success      ${75_response_get_package_codes}
    Write Response To Json File
    # Log     ${URL_REQUEST}    console=yes
    # Log     Product Offering Price ID: ${getPackageCodes.query_string.productOfferingId}    console=yes

CPC_API_1_1_075 Get All Package Codes By Product Offering ID (Conditions_Test_Case_1)
    [Documentation]    Owner : Tatphong Ratthanawichai
    ...    ==>
    ...    *** Condition ***
    ...    - token does not exist
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]   75.1    Conditions
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJMMlJDYUdJcmFtcGxUWFpVYTNaVFpFeFdkRWhNVVQwOUxuTmhjMmx1WVMxbWIzSXRjSEp2WkE9PSIsImNsaWVudEtleSI6InNhc2luYS1mb3ItcHJvZCIsImlhdCI6MTcxMjA3NDMxMiwiZXhwIjoxNzEyMTE3NTEyfQ.hJ_p9urGVYiz3C0bslcPpeNUCVCmJm2saLvgq7rPpjE
    Send Request API    url=${url_get_package_codes_c1}
    ...                       method=GET
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${75_1_response_get_package_codes}

CPC_API_1_1_075 Get All Package Codes By Product Offering ID (Conditions_Test_Case_2)
    [Documentation]    Owner: Tatphong R.
    ...    ==>
    ...    *** Condition ***
    ...    - token expire
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    75.2    Conditions
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJZVGMwYWpsaVVFazFWMjFGYTJsVE1qTkJaSGgyZHowOUxuUnllU0IwYnlCelpXVWdiV1U9IiwiY2xpZW50S2V5IjoidHJ5IHRvIHNlZSBtZSIsImlhdCI6MTcxMjA4OTEzOCwiZXhwIjoxNzEyMjYxOTM4fQ.9K6gaZ3-CM_t52J_12-GrMQIWF9mi6SDSoUIROvp0ho
    Send Request API          url=${url_get_package_codes_c2}
    ...                       method=GET
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${75_2_response_get_package_codes}

CPC_API_1_1_075 Get All Package Codes By Product Offering ID (Conditions_Test_Case_3)
    [Documentation]    Owner: Tatphong.R
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000"
    ...    ==>
    [Tags]    75.3    Conditions   
    Set Header Validate Token
    Send Request API          url=${url_get_package_codes_c3}
    ...                       method=GET
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${75_3_response_get_package_codes}

# cancel by Sasina.I ในอนาตคอาจจะมีการรองรับมากกว่า POFF
# CPC_API_1_1_075 Get All Package Codes By Product Offering ID (Conditions_Test_Case_4_1)
#     [Documentation]    Owner: Tatphong.R
#     ...    ==>
#     ...    *** Condition ***
#     ...    - filter by productOfferingId that does not start with 'POFF'
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - 1."statusCode": "40401",
#     ...    - 2."statusDesc": "Data not found"
#     ...    ==>
#     [Tags]    75.4.1    Conditions
#     Set Header Validate Token
#     Send Request API          url=${url_get_package_codes_c4}
#     ...                       method=GET
#     ...                       expected_status=200
#     ...                       skip_verify_new_feature=${True}
#     ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
#     ${value_statusDesc}     Get Value From Json    ${response.json()}    $.statusDesc
#     Should Be Equal As Strings     ${value_statusCode}[0]    40401
#     Should Be Equal As Strings     ${value_statusDesc}[0]    Data not found
#     ${result}    Catenate
#     ...    ${\n}---> condition: statusCode = "40401"
#     ...    ${\n}---> condition: statusDesc = "Data not found"
#     ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
#     ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
#     Log    ${result}

# cancel by Sasina.I ในอนาตคอาจจะมีการรองรับมากกว่า POFF
# CPC_API_1_1_075 Get All Package Codes By Product Offering ID (Conditions_Test_Case_4_2)
#     [Documentation]    Owner: Tatphong.R
#     ...    ==>
#     ...    *** Condition ***
#     ...    - filter by productOfferingId starting with 'POFF'
#     ...    ==>
#     ...    *** Expect Result ***
#     ...    - 1."statusCode": "20000"
#     ...    - 2."statusDesc": "Success"
#     ...    ==>
#     [Tags]    75.4.2    Conditions
#     Set Header Validate Token
#     Send Request API          url=${url_get_package_codes_c4}
#     ...                       method=GET
#     ...                       expected_status=200
#     ...                       skip_verify_new_feature=${True}

#     ${value_statusCode}    Get Value From Json    ${response.json()}    $.statusCode
#     Should Be Equal As Strings    ${value_statusCode}[0]    20000
#     ${data}    Get Value From Json    ${response.json()}    $.data
#     Should Not Be Empty    ${data}
#     ${result}    Catenate
#     ...    ${\n}---> condition: statusCode = "20000"
#     ...    ${\n}---> "data" == "${data}"
#     ...    ${\n}---> "statusCode" == "${value_statusCode}"
#     Log    ${result}

CPC_API_1_1_075 Get All Package Codes By Product Offering ID (Conditions_Test_Case_5)
    [Documentation]    Owner: Tatphong.R
    ...    ==>
    ...    *** Condition ***
    ...    - Check for duplicate values in downstreamSystem
    ...    - If duplicate, check downstreamSystemDynField for duplicates
    ...    - If both are duplicated, the test should fail
    ...    ==>
    ...    *** Expect Result ***
    ...    - Test passes if no duplicates or only one field is duplicated
    ...    - Test fails if both fields are duplicated
    ...    ==>
    [Tags]    75.5    Conditions
    Set Header Validate Token
    Send Request API          url=${url_get_package_codes_c5}
    ...                       method=GET
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}

    ${data}    Get Value From Json    ${response.json()}    $.data
    Should Not Be Empty    ${data}

    # ตรวจสอบว่า downstreamSystem และ downstreamSystemDynField มีค่าซ้ำหรือไม่
    ${downstreamSystem_list}    Create List
    ${duplicate_found}    Set Variable    False
    FOR    ${item}    IN    @{data}
        ${downstreamSystem}    Get Value From Json    ${item}    $.downstreamSystem
        ${downstreamSystemDynField}    Get Value From Json    ${item}    $.downstreamSystemDynField
        Run Keyword If    '${downstreamSystem}' in ${downstreamSystem_list}
        ...    ${duplicate_found}    Set Variable    True
        ...    Run Keyword If    '${downstreamSystemDynField}' != 'None' and '${downstreamSystemDynField}' != 'null'
        ...    ...    Fail    Duplicate found in both downstreamSystem and downstreamSystemDynField: ${downstreamSystem}, ${downstreamSystemDynField}
       Append To List    ${downstreamSystem_list}    ${downstreamSystem}
    END
    # ถ้าไม่เจอซ้ำในทั้ง 2 fields จะผ่าน
    # Run Keyword Unless    ${duplicate_found}    Pass    No duplicates found in downstreamSystem and downstreamSystemDynField.
    ${result}    Catenate
    ...    ${\n}---> condition: data => 1
    ...    ${\n}---> "data" == "${data}"
    Log    ${result}

CPC_API_1_1_076 Get Termination Condition
    [Documentation]    Owner : Tatphong.R
    [Tags]   76 
    Set Header Validate Token
    Run Keyword And Ignore Error    Send Request API    url=${url_get_termination_condition}
    ...                 method=GET
    ...                 expected_status=200
    ...                 skip_verify_new_feature=${True}
    Verify Json Schema Success      ${76_response_get_termination_condition}
    Write Response To Json File
    # สร้างไฟล์ api_parameter.yml เพื่อเกบ query string ในไฟล์ url_cpc_api.resource ก็กำหนดเปนตัวแปรครับ
    # Log     ${URL_REQUEST}    console=yes
    # Log     Product Offering Price ID: ${getTerminationCondition.query_string.productOfferingPriceId}    console=yes

CPC_API_1_1_076 Get Termination Condition (Conditions_Test_Case_1)
    [Documentation]    Owner : Tatphong Ratthanawichai
    ...    ==>
    ...    *** Condition ***
    ...    - token does not exist
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "50000"
    ...    ==>
    [Tags]   76.1    Conditions    
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJMMlJDYUdJcmFtcGxUWFpVYTNaVFpFeFdkRWhNVVQwOUxuTmhjMmx1WVMxbWIzSXRjSEp2WkE9PSIsImNsaWVudEtleSI6InNhc2luYS1mb3ItcHJvZCIsImlhdCI6MTcxMjA3NDMxMiwiZXhwIjoxNzEyMTE3NTEyfQ.hJ_p9urGVYiz3C0bslcPpeNUCVCmJm2saLvgq7rPpjE
    Send Request API    url=${url_get_termination_condition_c1}
    ...                       method=GET
    ...                       expected_status=401
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${76_1_response_get_termination_condition}

CPC_API_1_1_076 Get Termination Condition (Conditions_Test_Case_2)
    [Documentation]    Owner: Tatphong R.
    ...    ==>
    ...    *** Condition ***
    ...    - token expire
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "40403"
    ...    ==>
    [Tags]    76.2    Conditions   
    Set API Header Default
    Set Content API Header    $..authorization    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiJZVGMwYWpsaVVFazFWMjFGYTJsVE1qTkJaSGgyZHowOUxuUnllU0IwYnlCelpXVWdiV1U9IiwiY2xpZW50S2V5IjoidHJ5IHRvIHNlZSBtZSIsImlhdCI6MTcxMjA4OTEzOCwiZXhwIjoxNzEyMjYxOTM4fQ.9K6gaZ3-CM_t52J_12-GrMQIWF9mi6SDSoUIROvp0ho
    Send Request API          url=${url_get_termination_condition_c2}
    ...                       method=GET
    ...                       expected_status=403
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${76_2_response_get_termination_condition}

CPC_API_1_1_076 Get Termination Condition (Conditions_Test_Case_3)
    [Documentation]    Owner: Tatphong.R
    ...    ==>
    ...    *** Condition ***
    ...    - verify parameter
    ...    - fixed for automate test
    ...    ==>
    ...    *** Expect Result ***
    ...    - "statusCode": "30000"
    ...    ==>
    [Tags]    76.3    Conditions
    Set Header Validate Token
    Send Request API          url=${url_get_termination_condition_c3}
    ...                       method=GET
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    Verify Response Should Be Equal Expected      path_expected=${76_3_response_get_termination_condition}

CPC_API_1_1_076 Get Termination Condition (Conditions_Test_Case_4_1)
    [Documentation]    Owner: Tatphong.R
    ...    ==>
    ...    *** Condition ***
    ...    - filter by productOfferingId
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "40401",
    ...    - 2."statusDesc": "Data not found"
    ...    ==>
    [Tags]    76.4.    Conditions
    Set Header Validate Token
    Send Request API          url=${url_get_termination_condition_c4_1}
    ...                       method=GET
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}
    ${value_statusCode}     Get Value From Json    ${response.json()}    $.statusCode
    ${value_statusDesc}     Get Value From Json    ${response.json()}    $.statusDesc
    Should Be Equal As Strings     ${value_statusCode}[0]    40401
    Should Be Equal As Strings     ${value_statusDesc}[0]    Data not found
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "40401"
    ...    ${\n}---> condition: statusDesc = "Data not found"
    ...    ${\n}---> "statusCode" == "${value_statusCode}[0]"
    ...    ${\n}---> "statusDesc" == "${value_statusDesc}[0]"
    Log    ${result}

CPC_API_1_1_076 Get Termination Condition (Conditions_Test_Case_4_2)
    [Documentation]    Owner: Tatphong.R
    ...    ==>
    ...    *** Condition ***
    ...    - filter by productOfferingId 
    ...    ==>
    ...    *** Expect Result ***
    ...    - 1."statusCode": "20000"
    ...    - 2."statusDesc": "Success"
    ...    ==>
    [Tags]    76.4.2    Conditions
    Set Header Validate Token
    Send Request API          url=${url_get_termination_condition_c4_2}
    ...                       method=GET
    ...                       expected_status=200
    ...                       skip_verify_new_feature=${True}

    ${value_statusCode}    Get Value From Json    ${response.json()}    $.statusCode
    Should Be Equal As Strings    ${value_statusCode}[0]    20000
    ${data}    Get Value From Json    ${response.json()}    $.data
    Should Not Be Empty    ${data}
    ${result}    Catenate
    ...    ${\n}---> condition: statusCode = "20000"
    ...    ${\n}---> "data" == "${data}"
    ...    ${\n}---> "statusCode" == "${value_statusCode}"
    Log    ${result}








# CPC_API_1_1_099 Example_Get Value From Query String 1
#     [Documentation]    Owner : Kachain
#     [Tags]   99 
#     Set Header Validate Token
#     Run Keyword And Ignore Error    Send Request API    url=${url_example_1}
#     ...                 method=GET
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     # ตัวอย่างที่ 1 กรณี filter แค่ตัวเดียว
#     Log   ${URL_REQUEST}    console=yes
#     ${value_productOfferingPriceId1}    Fetch From Right    ${URL_REQUEST}       productOfferingPriceId=
#     Log   ${value_productOfferingPriceId1}    console=yes
#     ${value_productOfferingPriceId2}    Fetch From Right    ${URL_REQUEST}       ?
#     Log   ${value_productOfferingPriceId2}    console=yes
#     @{key_value}     split string    ${value_productOfferingPriceId2}      =
#     Log   ${key_value}[0]    console=yes
#     Log   ${key_value}[1]    console=yes

# CPC_API_1_1_099 Example_Get Value From Query String 2
#     [Documentation]    Owner : Kachain
#     [Tags]   99 
#     Set Header Validate Token
#     Run Keyword And Ignore Error    Send Request API    url=${url_example_2}
#     ...                 method=GET
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     # ตัวอย่างที่ 2 กรณี filter มากกว่า 1 ตัว (Dic)
#     # แยกส่วนของ URL ก่อน '?'
#     Log     ${URL_REQUEST}    console=yes
#     ${base_url}    ${params_string}     Split String    ${URL_REQUEST}    ?
#     Log     ${base_url}      console=yes 
#     Log     ${params_string}     console=yes
    
#     # แยกพารามิเตอร์ออกเป็นคู่ ๆ
#     ${params_list}    Split String    ${params_string}    &
#     Log    ${params_list}     console=yes

#     # สร้าง dictionary เพื่อเก็บ key-value
#     &{params_dict}    Create Dictionary
    
#     # แยกพารามิเตอร์แต่ละคู่เป็น key-value และเก็บใน dictionary
#     FOR    ${param}    IN    @{params_list}
#         ${key}    ${value}=    Split String    ${param}    =
#         Set To Dictionary    ${params_dict}    ${key}    ${value}
#     END
    
#     # ใช้งาน key-value จาก dictionary
#     Log    Product Offering Price ID: ${params_dict.productOfferingPriceId}    console=yes
#     Log    Phone Number: ${params_dict.phone}     console=yes    


# CPC_API_1_1_099 Example_Get Value From Query String 3
#     [Documentation]    Owner : Kachain
#     [Tags]   99 
#     Set Header Validate Token
#     Run Keyword And Ignore Error    Send Request API    url=${url_example_3}
#     ...                 method=GET
#     ...                 expected_status=200
#     ...                 skip_verify_new_feature=${True}
#     # สร้างไฟล์ api_parameter.yml เพื่อเกบ query string ในไฟล์ url_cpc_api.resource ก็กำหนดเปนตัวแปรครับ
#     Log     ${URL_REQUEST}    console=yes
#     Log     Product Offering Price ID: ${api_99.query_string.productOfferingPriceId}    console=yes
