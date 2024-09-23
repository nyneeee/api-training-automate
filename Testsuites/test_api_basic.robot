*** Settings ***
Library     RequestsLibrary
Library     JSONLibrary 
Library     String
Library     Collections   
Library     OperatingSystem
Library     ../Resources/Keywords/CustomLibraryAPI/lib_api.py
Variables   ../Config/configs_header.yml
Variables   ../Config/configs_domain.yml
Variables   ../Config/configs_testdata.yml
Variables   ../Config/configs_timeout.yml
Resource    ../Resources/Keywords/commomKeyword.resource

*** Variables ***
${my_variable}    Hello there
@{animal}         Ant    
...               Bird    
...               Cat    
...               Dog    
...               Elephant
&{profile}        firstname=Patipan
...               nickname=Nine
...               phone=0903921321
${url_api_get}     https://reqres.in/api/users?page=2 
${url_api_post}    https://reqres.in/api/login

*** Keywords ***
# Keyword แบบรับค่า Embed
Get Value Json With JsonPath ${path} And Verify Should Be Equal ${expected_value}
    [Documentation]    Owner : Patipan.w
    Should Have Value In Json    ${response.json()}    json_path=${path}
    ${value}    Get Value From Json    ${response.json()}	json_path=${path}
    ${expected_value}    Convert To String    ${expected_value}
    ${actual_value}      Convert To String    ${value}[0]
    Should Be Equal    ${actual_value}    ${expected_value}
    Log Many    ${response.json()}

# Keyword แบบรับค่า Arguments
Get Value Json And Verify Should Be Equal
    [Documentation]    Owner : Patipan.w
    [Arguments]    ${path}    ${expected_value}
    Should Have Value In Json    ${response.json()}    json_path=${path}
    ${value}    Get Value From Json    ${response.json()}	json_path=${path}
    ${expected_value}    Convert To String    ${expected_value}
    ${actual_value}      Convert To String    ${value}[0]
    Should Be Equal    ${actual_value}   ${expected_value}
    Log Many    ${response.json()}

*** Test Cases *** 
Ex01_Variables (ตัวอย่าง)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** CMD Run Robot **
    ...    - robot -i var -d log test_api_basic.robot  # หากต้องการ Run เฉพาะ Case นี้
    ...    - robot -d log test_api_basic.robot         # หากต้องการ Run Case ทั้งหมด
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ตัวอย่างทดสอบ Variables
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    Log เพื่อดู Result
    ...        -  $my_variable 
    ...        -  @animal    
    ...        -  &profile
    [Tags]    var
    # Variable Scalar
    Log         Scalar == ${my_variable}
    # Variable List
    Log Many    List == @{animal}       # ถ้าต้องการ Log ทั้งหมด จะต้องใช้ Log Many และใช้ @ เพื่อระบุ Type 
    Log         List == ${animal}[3]    # ระบุ index จะต้องใส่ $
    Log         List == ${animal[3]}    # ระบุ index จะต้องใส่ $
    # Variable Dic
    Log Many    Dic == &{profile}              # ถ้าต้องการ Log ทั้งหมด จะต้องใช้ Log Many และใช้ & เพื่อระบุ Type 
    Log         Dic == ${profile}[nickname]    # ระบุ key จะต้องใส่ $
    Log         Dic == ${profile['nickname']}  # ระบุ key จะต้องใส่ $
    Log         Dic == ${profile.nickname}     # ระบุ key จะต้องใส่ $

Ex02_Send Request API : GET - LIST USERS (ตัวอย่างที่ 1 เขียนตาม Doc RequestsLibrary)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** CMD Run Robot **
    ...    - robot -i GET -d log test_api_basic.robot        # หากต้องการ Run เฉพาะ Case นี้
    ...    - robot -i sendAPI -d log test_api_basic.robot    # หากต้องการ Run Case sendAPI ทั้งหมด
    ...    - robot -d log test_api_basic.robot               # หากต้องการ Run Case ทั้งหมด
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ  GET LIST USERS
    ...        - url = https://reqres.in/api/users?page=2 
    ...        - method = GET
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - Ecode ต้องเท่ากับ 200
    ...    - "json path" == "$.total" จะต้องมี value == "12"
    [Tags]    sendAPI    GET
    # ตัวอย่าง กรณีถ้าเขียนตาม Doc  ---> Link: https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#GET
    &{json_header}    Create Dictionary    Content-Type=application/json    User-Agent=PostmanRuntime
    ${response}       GET    url=${url_api_get}          headers=${json_header}    
    ...    expected_status=200     timeout=60    
    ${result_total}    Get Value From Json    ${response.json()}	json_path=$.total
    Should Be Equal As Integers    ${result_total}[0]    12
    Log Many    ${response.json()}
    
Ex03_Send Request API : POST - LOGIN SUCCESSFUL (ตัวอย่างที่ 2 เขียนตาม Doc RequestsLibrary)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** CMD Run Robot **
    ...    - robot -i POST -d log test_api_basic.robot       # หากต้องการ Run เฉพาะ Case นี้
    ...    - robot -i sendAPI -d log test_api_basic.robot    # หากต้องการ Run Case sendAPI ทั้งหมด
    ...    - robot -d log test_api_basic.robot               # หากต้องการ Run Case ทั้งหมด
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ  POST - LOGIN SUCCESSFUL
    ...        - url = https://reqres.in/api/login 
    ...        - method = POST
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - Ecode ต้องเท่ากับ 200
    ...    - จะต้องมี parameter == "token"
    [Tags]    sendAPI    POST
    # ตัวอย่าง กรณีถ้าเขียนตาม Doc  ---> Link: https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST
    &{json_header}    Create Dictionary    Content-Type=application/json    User-Agent=PostmanRuntime
    &{json_body}      Create Dictionary    email=eve.holt@reqres.in         password=cityslicka
    ${response}       POST    url=${url_api_post}    headers=${json_header}
    ...    json=${json_body}    
    ...    expected_status=200     timeout=60    
    ...    verify=${True}
    Should Have Value In Json    ${response.json()}    json_path=$.token
    Log Many    ${response.json()}

Ex04_Keywords - Embed (ตัวอย่างที่ 1)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** CMD Run Robot **
    ...    - robot -i keyword&embed -d log test_api_basic.robot        # หากต้องการ Run เฉพาะ Case นี้
    ...    - robot -d log test_api_basic.robot                         # หากต้องการ Run Case ทั้งหมด
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ  GET LIST USERS
    ...        - url = https://reqres.in/api/users?page=2 
    ...        - method = GET
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - Ecode ต้องเท่ากับ 200
    ...    - "json path" == "$.total" จะต้องมี value == "12"
    [Tags]    keyword&embed    
    &{json_header}    Create Dictionary    Content-Type=application/json    User-Agent=PostmanRuntime
    ${response}       GET    url=${url_api_get}    headers=${json_header}    
    ...    expected_status=200     timeout=60 
    Set Test Variable    ${response}    ${response}
    Get Value Json With JsonPath $.total And Verify Should Be Equal 12

Ex05_Keywords - Arguments (ตัวอย่างที่ 2)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** CMD Run Robot **
    ...    - robot -i keyword&arg -d log test_api_basic.robot        # หากต้องการ Run เฉพาะ Case นี้
    ...    - robot -d log test_api_basic.robot                       # หากต้องการ Run Case ทั้งหมด
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ  GET LIST USERS
    ...        - url = https://reqres.in/api/users?page=2 
    ...        - method = GET
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - Ecode ต้องเท่ากับ 200
    ...    - "json path" == "$.total" จะต้องมี value == "12"
    [Tags]    keyword&arg  
    &{json_header}    Create Dictionary    Content-Type=application/json    User-Agent=PostmanRuntime
    ${response}       GET    url=${url_api_get}    headers=${json_header}    
    ...    expected_status=200     timeout=60
    Set Test Variable    ${response}    ${response}     
    Get Value Json And Verify Should Be Equal    path=$.total    expected_value=12

Ex06_Validate Json By Schema (ตัวอย่างที่ 1 ใช้ Keyword จาก JSONLibrary)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** CMD Run Robot **
    ...    - robot -i validateJsonSchema -d log test_api_basic.robot    # หากต้องการ Run Case ValidateJsonSchema ทั้งหมด
    ...    - robot -d log test_api_basic.robot                          # หากต้องการ Run Case ทั้งหมด
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - Mockup Response
    ...    - ใช้ Validate Json By Schema จาก JSONLibrary ในการ Validate
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - Validate Parameter Required (M/O) และ Type Parameter (String / Integer / Boolean / Number / Null )
    ...    ${\n} ==>
    ...    ** ข้อเสีย **
    ...    - ถ้าหากเกิด Fail จะไม่สามารถแสดง Error ได้ว่า Fail ที่ตัวไหน
    [Tags]    validateJsonSchema 
    # กรณีนี้ขอจำลอง Response โดยการสร้าง Mockup Response ขึ้นเพื่อใช้ เป็นตัวอย่างการเช็ค JsonSchema
    ${response_mockup}    Mock Up Response For Test
    # เช็คการ Validate 
    ${json_schema}    Load Json From File    ${CURDIR}/../Resources/TestSite/Schema/001_schema.json
    Validate Json By Schema    json_object=${response_mockup}    schema=${json_schema}

Ex07_Validate Json By Schema (ตัวอย่างที่ 2 ใช้ Keyword จาก CustomLibraryAPI ที่ทางทีม Automate เขียนไว้)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** CMD Run Robot **
    ...    - robot -i validateJsonSchema -d log test_api_basic.robot    # หากต้องการ Run Case ValidateJsonSchema ทั้งหมด
    ...    - robot -d log test_api_basic.robot                          # หากต้องการ Run Case ทั้งหมด
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - Mockup Response
    ...    - ใช้ Validate Json Schema And Return Error จาก CustomLibraryAPI ที่ทางทีม Automate เขียนไว้ในการ Validate
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - Validate Parameter Required (M/O) และ Type Parameter (String / Integer / Boolean / Number / Null )
    ...    ${\n} ==>
    ...    ** ข้อดี **
    ...    - สามารถแสดง Error ได้ว่า Fail ที่ Parameter ตัวไหน
    [Tags]    validateJsonSchema 
    # กรณีนี้ขอจำลอง Response โดยการสร้าง Mockup Response ขึ้นเพื่อใช้ เป็นตัวอย่างการเช็ค JsonSchema
    ${response_mockup}    Mock Up Response For Test
    # เช็คการ Validate
    ${json_schema}    Load Json From File      ${CURDIR}/../Resources/TestSite/Schema/001_schema.json
    Validate Json Schema And Return Error      json_object=${response_mockup}    schema=${json_schema}