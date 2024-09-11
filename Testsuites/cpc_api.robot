*** Settings ***
Resource    ../resource_init.resource



*** Test Cases ***
Ex01_Variables
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ทดสอบ Variables
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    Log เพื่อดู Result
    ...        -  $my_variable 
    ...        -  @animal    
    ...        -  &profile
    [Tags]    var
    # Scalar
    Log    Scalar == ${my_variable}

    # List
    Log Many    List == @{animal}       # ถ้าต้องการ Log ทั้งหมด จะต้องใช้ Log Many และใช้ @ เพื่อระบุ Type 
    Log         List == ${animal}[3]    # ระบุ index จะต้องใส่ $
    Log         List == ${animal[3]}    # ระบุ index จะต้องใส่ $
    
    # Dic
    Log Many    Dic == &{profile}              # ถ้าต้องการ Log ทั้งหมด จะต้องใช้ Log Many และใช้ & เพื่อระบุ Type 
    Log         Dic == ${profile}[nickname]    # ระบุ key จะต้องใส่ $
    Log         Dic == ${profile.nickname}     # ระบุ key จะต้องใส่ $
    
Ex02_Keywords - Arguments & Embed
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ทดสอบ Arguments
    [Tags]    arg    embed
    # Arguments
    ${result}    Convert Value To Upper Case    value=Nick Name

    # Embed
    ${result}    Convert Value Nick Name To Lower Case

Ex03_Condition - IF/ELSE
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ทดสอบ IF/ELSE
    [Tags]    condition    IF/ELSE
    # ตัวอย่างการเขียน IF/ELSE    (Success)
    ${result}    Convert Value To Upper Case    value=Nick Name      

Ex04_Condition - Inline IF
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ทดสอบ IF/ELSE
    [Tags]    condition    inlineIF
    # ตัวอย่างการเขียน IF ในบรรทัดเดียว    (Success)
    Convert Value Nick Name To Lower Case 

Ex05_Condition - Multiple and / or (List Success)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ทดสอบ IF/ELSE
    [Tags]    condition    multiple
    # ตัวอย่างการเขียน IF multiple conditions: and / or (List Success)
    Send Request API      
    ...    method=${TestCase_001.Method}    
    ...    verify_ecode=${TestCase_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestCase_001.Path}?page=${TestCase_001.QueryString.page}
    Check Type User      type=List    json_path=$.data

Ex06_Condition - Multiple and / or (Single Success)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ทดสอบ IF/ELSE
    [Tags]    condition    multiple
    # ตัวอย่างการเขียน IF multiple conditions: and / or (Single Success)
    Send Request API      
    ...    method=${TestCase_002.Method}    
    ...    verify_ecode=${TestCase_002.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestCase_002.Path}
    Check Type User    type=Single    json_path=$.data

Ex07_Condition - Multiple and / or (Single Fail)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ทดสอบ IF/ELSE
    [Tags]    condition    multiple
    # ตัวอย่างการเขียน IF multiple conditions: and / or (Single Fail)
    Send Request API      
    ...    method=${TestCase_001.Method}    
    ...    verify_ecode=${TestCase_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestCase_001.Path}?page=${TestCase_001.QueryString.page}
    Check Type User    type=Single    json_path=$.data

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