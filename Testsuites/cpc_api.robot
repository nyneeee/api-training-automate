*** Settings ***
Resource    ../resource_init.resource



*** Test Cases ***
Ex01_Variables (ตัวอย่าง)
    [Documentation]    Owner : Patipan.w
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
    # Scalar
    Log         Scalar == ${my_variable}

    # List
    Log Many    List == @{animal}       # ถ้าต้องการ Log ทั้งหมด จะต้องใช้ Log Many และใช้ @ เพื่อระบุ Type 
    Log         List == ${animal}[3]    # ระบุ index จะต้องใส่ $
    Log         List == ${animal[3]}    # ระบุ index จะต้องใส่ $
    
    # Dic
    Log Many    Dic == &{profile}              # ถ้าต้องการ Log ทั้งหมด จะต้องใช้ Log Many และใช้ & เพื่อระบุ Type 
    Log         Dic == ${profile}[nickname]    # ระบุ key จะต้องใส่ $
    Log         Dic == ${profile['nickname']}  # ระบุ key จะต้องใส่ $
    Log         Dic == ${profile.nickname}     # ระบุ key จะต้องใส่ $
    
Ex02_Keywords - Arguments & Embed (ตัวอย่าง)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ตัวอย่างทดสอบ Arguments
    [Tags]    arg    embed
    # Arguments
    ${result}    Convert Value To Upper Case    value=Nick Name

    # Embed
    ${result}    Convert Value Nick Name To Lower Case

Ex03_Condition - IF/ELSE (ตัวอย่าง)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ตัวอย่างทดสอบ IF/ELSE
    [Tags]    condition    IF/ELSE
    ${result}    Convert Value To Upper Case    value=Nick Name      

Ex04_Condition - Inline IF (ตัวอย่าง)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ตัวอย่างทดสอบ IF/ELSE
    [Tags]    condition    inlineIF
    Convert Value Nick Name To Lower Case 

Ex05_Condition - Multiple and / or (ตัวอย่าง 1 Validate แล้ว Success ตรงตามเงื่อนไขที่ดัก)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API - GET LIST USERS)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - "json path" == "$.data" จะต้องมี length >= "1"
    [Tags]    condition    multiple
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    Verify GET List User

Ex06_Condition - Multiple and / or (ตัวอย่าง 2 Validate แล้ว Success ตรงตามเงื่อนไขที่ดัก)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 002 เพื่อยิง API - GET SINGLE USER)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - "json path" == "$.data" จะต้องมี length == "1" 
    [Tags]    condition    multiple
    Send Request API      
    ...    method=${TestData_002.Method}    
    ...    verify_ecode=${TestData_002.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_002.Path}
    Verify GET Single User

Ex07_Condition - Multiple and / or (ตัวอย่าง 3 Validate แล้ว Fail ไม่ตรงตามเงื่อนไขที่ดัก)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API - GET SINGLE USER)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - "json path" == "$.data" จะต้องมี length == "1" (ใน Case นี้จะถูก Mock ให้ Fail)
    [Tags]    condition    multiple
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    Verify GET Single User

Ex08_Loop - Loop List (ตัวอย่างที่ 1)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - jsonpath = "$.data[*].id" จะต้องมี value "id" ตามนี้ 7,8,9,10,11,12 
    [Tags]    loop    
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    Get List Key And Count From Json    $.data
    Log Response Json    ${KEY_VALUE}
    FOR    ${item}    IN    @{KEY_VALUE}
            ${json}    Evaluate    json.dumps(${item}, indent=4, ensure_ascii=False)    json
            ${log_item}     Catenate
            ...    ${\n}---> "json" == ${\n}${json}${\n}
            ...    ${\n}---> get ค่า "id" == ${item['id']}
            ...    ${\n}---> get ค่า "email" == ${item['email']}
            ...    ${\n}---> get ค่า "first_name" == ${item['first_name']}
            ...    ${\n}---> get ค่า "last_name" == ${item['last_name']}
            ...    ${\n}---> get ค่า "avatar" == ${item['avatar']}
            Log     ${log_item}  
            @{expected_id}    Create List    7    8    9    10    11    12
            ${item_id}    Convert To String    ${item['id']}
            List Should Contain Value    ${expected_id}    ${item_id}
    END

Ex09_Loop - Loop Dic (ตัวอย่างที่ 2)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 002 เพื่อยิง API)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - jsonpath = "$.data[*].id" จะต้องมี value "id" ตามนี้ 7,8,9,10,11,12 
    [Tags]    loop    
    Send Request API      
    ...    method=${TestData_002.Method}    
    ...    verify_ecode=${TestData_002.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_002.Path}
    # Get List Key And Count From Json    $.data
    @{values}	Get Value From Json    ${response.json()}	$.data
    &{values}    Convert To Dictionary    @{values}
    # Log Response Json    ${value_type}
    FOR    ${item}    IN    &{values}
            ${json}    Evaluate    json.dumps(${item}, indent=4, ensure_ascii=False)    json
            ${log_item}     Catenate
            ...    ${\n}---> "json" == ${\n}${json}${\n}
            # ...    ${\n}---> get ค่า "id" == ${item['id']}
            # ...    ${\n}---> get ค่า "email" == ${item['email']}
            # ...    ${\n}---> get ค่า "first_name" == ${item['first_name']}
            # ...    ${\n}---> get ค่า "last_name" == ${item['last_name']}
            # ...    ${\n}---> get ค่า "avatar" == ${item['avatar']}
            Log     ${log_item}  
            # @{expected_id}    Create List    7    8    9    10    11    12
            # ${item_id}    Convert To String    ${item['id']}
            # List Should Contain Value    ${expected_id}    ${item_id}
    END




# API_001 GET - List User Page
#     [Documentation]    Owner : Patipan.w
#     ...    ${\n} ==>
#     ...    ** Test Step Description **
#     ...    - ยิงทดสอบ API
#     ...    ${\n} ==>
#     ...    ** Expected Result **
#     ...    - ต้องได้รับ Ecode = 200
#     ...    - jsonpath = "$.data" จะต้องมี length == 6
#     ...    - jsonpath = "$.data.page" จะต้องมี value == 2
#     ...    - jsonpath = "$.data[*].id" จะต้องมี value "id" ตามนี้ 7,8,9,10,11,12 
#     ...    - jsonpath = "$.data[*].email" จะต้องมี value "@reqres.in" อยู่ใน value ทุกๆ index ที่ get ได้ปัจจุบัน
#     ...    - jsonpath = "$.data[*].avatar" จะต้องเป็นนามสกุล ".jpg" ทุกๆ index ที่ get ได้ปัจจุบัน
#     [Tags]    1
#     Send Request API      
#     ...    method=${TestCase_001.Method}    
#     ...    verify_ecode=${TestCase_001.Ecode}    
#     ...    url=${Domain.${run_Site}.${run_Domain}}${TestCase_001.Path}?page=${TestCase_001.QueryString.page}