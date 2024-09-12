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
    
Ex02_Keywords - Arguments & Embed (ตัวอย่าง)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ตัวอย่างทดสอบ Arguments
    [Tags]    arg    embed
    # ตัวอย่างการส่ง Arguments
    ${result}    Convert Value To Upper Case    value=Nick Name
    # ตัวอย่างการส่ง Embed
    ${result}    Convert Value Nick Name To Lower Case

Ex03_Condition - IF/ELSE (ตัวอย่าง)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ตัวอย่างทดสอบ IF/ELSE
    [Tags]    condition    IF/ELSE
    # ตัวอย่างการใช้ IF/ELSE
    ${result}    Convert Value To Upper Case    value=Nick Name      

Ex04_Condition - Inline IF (ตัวอย่าง)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ตัวอย่างทดสอบ IF/ELSE
    [Tags]    condition    inlineIF
    # ตัวอย่างการใช้ inlineIF
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
    # ยิงทดสอบ API for testing free service
    # ...    - ดึง method จากไฟล์ "config_url" = TestData_001.Method
    # ...    - ดึง verify_ecode จากไฟล์ "config_url" = TestData_001.Ecode
    # ...    - ดึง url จากไฟล์ "config_url" = ดึงจาก "run_Site" == "SIT" และ "run_Domain" == "Mockup"
    # ...      เพราะฉนั้นถ้าแปลงค่ามาจะ == "${Domain.SIT.Mockup}${TestData_001.Path}?page=${TestData_001.QueryString.page}"
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    # ตัวอย่างการใช้ Condition - Multiple (ตัวอย่าง 1 ตรงตามเงื่อนไขที่ดัก Success)
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
    # ยิงทดสอบ API for testing free service
    Send Request API      
    ...    method=${TestData_002.Method}    
    ...    verify_ecode=${TestData_002.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_002.Path}
    # ตัวอย่างการใช้ Condition - Multiple  (ตัวอย่าง 2 ตรงตามเงื่อนไขที่ดัก Success)
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
    # ยิงทดสอบ API for testing free service
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    # ตัวอย่างการใช้ Condition - Multiple (ตัวอย่าง 2 ไม่ตรงตามเงื่อนไขที่ดัก Fail)
    Verify GET Single User

Ex08_Loop - Loop List (ตัวอย่างที่ 1)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    loop ตาม list ที่ get ได้
    ...    - jsonpath = "$.data[*].id" จะต้องมี value == (7,8,9,10,11,12) 
    ...    - jsonpath = "$.data[*].email" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].first_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].last_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].avatar" ให้ Log แสดงค่า
    [Tags]    loop    loop_list
    # ยิงทดสอบ API for testing free service"
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    # Count Value และ Get Value ตามที่ส่ง Json Path ไป 
    # ...  - ${KEY_VALUE} จะถูก Set Variable ขึ้นให้เรียกใช้
    # ...  - ${count} จะถูก RETURN ให้เรียกใช้
    Get List Key And Count From Json    json_path=$.data
    Log Response Json    ${KEY_VALUE}
    # ตัวอย่างการใช้ Loop List
    FOR    ${item}    IN    @{KEY_VALUE}
            ${json_formatter}    Convert To Json Format Document    ${item}
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู Key, Value
            ${log_item}     Catenate
            ...    ${\n}---> "json" == ${\n}${json_formatter}${\n}
            ...    ${\n}---> get ค่า "id" == ${item['id']}
            ...    ${\n}---> get ค่า "email" == ${item['email']}
            ...    ${\n}---> get ค่า "first_name" == ${item['first_name']}
            ...    ${\n}---> get ค่า "last_name" == ${item['last_name']}
            ...    ${\n}---> get ค่า "avatar" == ${item['avatar']}
            Log     ${log_item}  
            # สร้าง expected list ของ id เพื่อเป็นค่าต้นแบบในการ Verify กับผลลัพธ์จริงที่ได้ จะต้องเป็นไปตามนี้ นอกเหนือจากเลข id นี้จะ Fail
            @{expected_id}    Create List    7    8    9    10    11    12
            # ดึงค่า id จากกับผลลัพธ์จริงที่ได้ มาแปลงเป็น String
            ${actual_id}    Convert To String    ${item['id']}
            # Verify ค่า "$.data[*].id" จะต้องมี value "id" ตามนี้ (7,8,9,10,11,12) 
            List Should Contain Value    ${expected_id}    ${actual_id}
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู expected_id และ actual_id ที่เช็คใน Loop นั้นๆ
            ${log_verify}     Catenate
            ...    ${\n}---> Success
            ...    ${\n}---> "expected_id" == ${expected_id} 
            ...    ${\n}---> "actual_id" == ${actual_id}
            Log    ${log_verify}
    END

Ex09_Loop - Loop Dic (ตัวอย่างที่ 2)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 002 เพื่อยิง API)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    loop ตาม dic ที่แปลงได้
    ...    - jsonpath = "$.data" จะต้องมี length == "1"
    ...    - jsonpath = "$.data[0].id" จะต้องมี value == "2"
    ...    - jsonpath = "$.data[0].email" จะต้องมี value == "janet.weaver@reqres.in"
    ...    - jsonpath = "$.data[0].first_name" จะต้องมี value == "Janet"
    ...    - jsonpath = "$.data[0].last_name" จะต้องมี value == "Weaver"
    ...    - jsonpath = "$.data[0].avatar" จะต้องมี value == "https://reqres.in/img/faces/2-image.jpg"
    [Tags]    loop    loop_dic    
    # ยิงทดสอบ API for testing free service
    Send Request API      
    ...    method=${TestData_002.Method}    
    ...    verify_ecode=${TestData_002.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_002.Path}
    # Count Value และ Get Value ตามที่ส่ง Json Path ไป 
    # ...  - ${KEY_VALUE} จะถูก Set Variable ขึ้นให้เรียกใช้
    # ...  - ${count} จะถูก RETURN ให้เรียกใช้
    ${count}    Get List Key And Count From Json   json_path=$.data
    # Verify "$.data" จะต้องมี length == "1"
    Should Be True       int(${count}) == int(1)
    &{dic_key_value}     Convert To Dictionary     @{KEY_VALUE}
    ${type_key_value}    Check Type                ${dic_key_value}
    Log Response Json    ${dic_key_value}
    # ตัวอย่างการใช้ Loop Dic
    FOR    ${item_tuple}    IN    &{dic_key_value}
            ${check_type}        Check Type      ${item_tuple}
            ${key}               Set Variable    ${item_tuple}[0]
            ${value}             Set Variable    ${item_tuple}[1]
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู Key, Value
            ${log_key_value}     Catenate
            ...    ${\n}---> "value tuple" == ${item_tuple}
            ...    ${\n}---> get ค่า "key" == ${key}
            ...    ${\n}---> get ค่า "value" == ${value}
            Log    ${log_key_value}    
            # ใช้ inlineIF Verify
            # ...    - jsonpath = "$.data[0].id" จะต้องมี value == "2"
            # ...    - jsonpath = "$.data[0].email" จะต้องมี value == "janet.weaver@reqres.in"
            # ...    - jsonpath = "$.data[0].first_name" จะต้องมี value == "Janet"
            # ...    - jsonpath = "$.data[0].last_name" จะต้องมี value == "Weaver"
            # ...    - jsonpath = "$.data[0].avatar" จะต้องมี value == "https://reqres.in/img/faces/2-image.jpg
            IF                "${key}" == "id"            Should Be Equal As Integers    ${value}    2
            ...    ELSE IF    "${key}" == "email"         Should Be Equal As Strings     ${value}    janet.weaver@reqres.in
            ...    ELSE IF    "${key}" == "first_name"    Should Be Equal As Strings     ${value}    Janet
            ...    ELSE IF    "${key}" == "last_name"     Should Be Equal As Strings     ${value}    Weaver
            ...    ELSE IF    "${key}" == "avatar"        Should Be Equal As Strings     ${value}    https://reqres.in/img/faces/2-image.jpg
            ...    ELSE       Fail     msg=${\n}Fail Unknown Key == "${key}" and value tuple == "${item_tuple}", Please check again.
    END

Ex10_Loop - Loop IN RANGE (ตัวอย่างที่ 3)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    loop ตาม object ที่ get length ได้
    ...    - jsonpath = "$.data[*].id" จะต้องมี value == (7,8,9,10,11,12) 
    ...    - jsonpath = "$.data[*].email" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].first_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].last_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].avatar" ให้ Log แสดงค่า
    [Tags]    loop    loop_range  
    # ยิงทดสอบ API for testing free service"
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    ...    path_body_request=${CURDIR}/../../Body/9_service_reliability/${run_Site}/9_body_check_death_status.json
    # Count Value และ Get Value ตามที่ส่ง Json Path ไป 
    # ...  - ${KEY_VALUE} จะถูก Set Variable ขึ้นให้เรียกใช้
    # ...  - ${count} จะถูก RETURN ให้เรียกใช้
    ${count}    Get List Key And Count From Json    json_path=$.data
    Log Response Json    ${KEY_VALUE}
    # ตัวอย่างการใช้ Loop IN RANGE
    FOR    ${index}    IN RANGE     0     ${count}
            ${object}	            Get Value From Json    ${response.json()}	$.data[${index}]
            ${json_formatter}       Convert To Json Format Document             ${object}
            ${values_id}	        Get Value From Json    ${response.json()}	$.data[${index}].id
            ${values_email}	        Get Value From Json    ${response.json()}	$.data[${index}].email
            ${values_first_name}	Get Value From Json    ${response.json()}	$.data[${index}].first_name
            ${values_last_name}	    Get Value From Json    ${response.json()}	$.data[${index}].last_name
            ${values_avatar}	    Get Value From Json    ${response.json()}	$.data[${index}].avatar
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู Key, Value
            ${log_item}     Catenate
            ...    ${\n}---> "json" == ${\n}${json_formatter}${\n}
            ...    ${\n}---> get ค่า "id" == "${values_id}[0]"
            ...    ${\n}---> get ค่า "email" == "${values_email}[0]"
            ...    ${\n}---> get ค่า "first_name" == "${values_first_name}[0]"
            ...    ${\n}---> get ค่า "last_name" == "${values_last_name}[0]"
            ...    ${\n}---> get ค่า "avatar" == "${values_avatar}[0]"
            Log     ${log_item}  
            # สร้าง expected list ของ id เพื่อเป็นค่าต้นแบบในการ Verify กับผลลัพธ์จริงที่ได้ จะต้องเป็นไปตามนี้ นอกเหนือจากเลข id นี้จะ Fail
            @{expected_id}    Create List    7    8    9    10    11    12
            # ดึงค่า id จากกับผลลัพธ์จริงที่ได้ มาแปลงเป็น String
            ${actual_id}    Convert To String    ${values_id}[0]
            # Verify ค่า "$.data[*].id" จะต้องมี value "id" ตามนี้ (7,8,9,10,11,12) 
            List Should Contain Value    ${expected_id}    ${actual_id}
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู expected_id และ actual_id ที่เช็คใน Loop นั้นๆ
            ${log_verify}     Catenate
            ...    ${\n}---> Success
            ...    ${\n}---> "expected_id" == ${expected_id} 
            ...    ${\n}---> "actual_id" == ${actual_id}
            Log    ${log_verify}
    END

Ex11_Loop - Loop IN ENUMERATE (ตัวอย่างที่ 4)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    loop ตาม list ที่ get ได้
    ...    - jsonpath = "$.data[*].id" จะต้องมี value == (7,8,9,10,11,12) 
    ...    - jsonpath = "$.data[*].email" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].first_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].last_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].avatar" ให้ Log แสดงค่า
    [Tags]    loop    loop_enum 
    # ยิงทดสอบ API for testing free service"
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    # Count Value และ Get Value ตามที่ส่ง Json Path ไป 
    # ...  - ${KEY_VALUE} จะถูก Set Variable ขึ้นให้เรียกใช้
    # ...  - ${count} จะถูก RETURN ให้เรียกใช้
    ${count}    Get List Key And Count From Json    json_path=$.data
    Log Response Json    ${KEY_VALUE}
    # ตัวอย่างการใช้ Loop IN ENUMERATE
    FOR    ${index}    ${item}    IN ENUMERATE    @{KEY_VALUE}
            ${json_formatter}    Convert To Json Format Document    ${item}
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู Key, Value
            ${log_item}     Catenate
            ...    ${\n}---> Loop Index == "${index}"
            ...    ${\n}---> Json Item ${\n} == ${json_formatter}${\n}
            ...    ${\n}---> get ค่า "id" == ${item['id']}
            ...    ${\n}---> get ค่า "email" == ${item['email']}
            ...    ${\n}---> get ค่า "first_name" == ${item['first_name']}
            ...    ${\n}---> get ค่า "last_name" == ${item['last_name']}
            ...    ${\n}---> get ค่า "avatar" == ${item['avatar']}
            Log     ${log_item}  
            # สร้าง expected list ของ id เพื่อเป็นค่าต้นแบบในการ Verify กับผลลัพธ์จริงที่ได้ จะต้องเป็นไปตามนี้ นอกเหนือจากเลข id นี้จะ Fail
            @{expected_id}    Create List    7    8    9    10    11    12
            # ดึงค่า id จากกับผลลัพธ์จริงที่ได้ มาแปลงเป็น String
            ${actual_id}    Convert To String    ${item['id']}
            # Verify ค่า "$.data[*].id" จะต้องมี value "id" ตามนี้ (7,8,9,10,11,12) 
            List Should Contain Value    ${expected_id}    ${actual_id}
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู expected_id และ actual_id ที่เช็คใน Loop นั้นๆ
            ${log_verify}     Catenate
            ...    ${\n}---> Success
            ...    ${\n}---> "expected_id" == ${expected_id} 
            ...    ${\n}---> "actual_id" == ${actual_id}
            Log    ${log_verify}
    END

Ex12_Loop - Loop Exit And Continue (ตัวอย่างที่ 5)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    loop ตาม list ที่ get ได้
    ...    - ถ้าหากค่า "$.data[*].id" มีค่า == "9" ให้ "ข้ามการ Log แสดงค่า ('id','email','first_name','last_name','avatar')"
    ...    - ถ้าหากค่า "$.data[*].id" มีค่า != "9" ให้ "Log แสดงค่า ('id','email','first_name','last_name','avatar')"
    ...    - ถ้าหากค่า "$.data[*].id" มีค่า == "11" ให้ "ออกจาก Loop" ทันที
    [Tags]    loop    loop_exit&continue 
    # ยิงทดสอบ API for testing free service"
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    # Count Value และ Get Value ตามที่ส่ง Json Path ไป 
    # ...  - ${KEY_VALUE} จะถูก Set Variable ขึ้นให้เรียกใช้
    # ...  - ${count} จะถูก RETURN ให้เรียกใช้
    ${count}    Get List Key And Count From Json    json_path=$.data
    Log Response Json    ${KEY_VALUE}
    # ตัวอย่างการใช้  Loop Exit And Continue
    FOR    ${index}    ${item}    IN ENUMERATE    @{KEY_VALUE}
            # ถ้าหากค่า "$.data[*].id" มีค่า == "9" ให้ "ข้ามการ Log แสดงค่า ('id','email','first_name','last_name','avatar')"
            # ถ้าหากค่า "$.data[*].id" มีค่า == "11" ให้ "ออกจาก Loop" ทันที
            IF    "${item['id']}" == "9"    CONTINUE
            ...    ELSE IF    "${item['id']}" == "11"    BREAK
            # ถ้าหากค่า "$.data[*].id" มีค่า != "9" ให้ "Log แสดงค่า ('id','email','first_name','last_name','avatar')"
            ${json_formatter}    Convert To Json Format Document    ${item}
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู Key, Value
            ${log_item}     Catenate
            ...    ${\n}---> Json Item ${\n} == ${json_formatter}${\n}
            ...    ${\n}---> get ค่า "id" == ${item['id']}
            ...    ${\n}---> get ค่า "email" == ${item['email']}
            ...    ${\n}---> get ค่า "first_name" == ${item['first_name']}
            ...    ${\n}---> get ค่า "last_name" == ${item['last_name']}
            ...    ${\n}---> get ค่า "avatar" == ${item['avatar']}
            ...    ${\n}------------------------------------------------
            Log     ${log_item}    console=yes
    END

Ex13_WHILE Loop (ตัวอย่างที่ 1)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    WHILE Loop ตาม list ที่ get ได้
    ...    - jsonpath = "$.data[*].id" จะต้องมี value == (7,8,9,10,11,12) 
    ...    - jsonpath = "$.data[*].email" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].first_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].last_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].avatar" ให้ Log แสดงค่า
    [Tags]    loop    while_loop
    # ยิงทดสอบ API for testing free service"
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    # Count Value และ Get Value ตามที่ส่ง Json Path ไป 
    # ...  - ${KEY_VALUE} จะถูก Set Variable ขึ้นให้เรียกใช้
    # ...  - ${count} จะถูก RETURN ให้เรียกใช้
    ${count}    Get List Key And Count From Json    json_path=$.data
    Log Response Json    ${KEY_VALUE}
    # Set ต่าเริ่มของ index ให้เริ่มต้นที่ 0 เสมอ
    ${start_while_loop}    Set Variable    0
    # ตัวอย่างการใช้  WHILE Loop แบบเขียน Condtion
    WHILE  ${start_while_loop} < ${count}
            ${object}	            Get Value From Json    ${response.json()}	$.data[${start_while_loop}]
            ${json_formatter}       Convert To Json Format Document             ${object}
            ${values_id}	        Get Value From Json    ${response.json()}	$.data[${start_while_loop}].id
            ${values_email}	        Get Value From Json    ${response.json()}	$.data[${start_while_loop}].email
            ${values_first_name}	Get Value From Json    ${response.json()}	$.data[${start_while_loop}].first_name
            ${values_last_name}	    Get Value From Json    ${response.json()}	$.data[${start_while_loop}].last_name
            ${values_avatar}	    Get Value From Json    ${response.json()}	$.data[${start_while_loop}].avatar
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู Key, Value
            ${log_item}     Catenate
            ...    ${\n}---> "json" == ${\n}${json_formatter}${\n}
            ...    ${\n}---> get ค่า "id" == "${values_id}[0]"
            ...    ${\n}---> get ค่า "email" == "${values_email}[0]"
            ...    ${\n}---> get ค่า "first_name" == "${values_first_name}[0]"
            ...    ${\n}---> get ค่า "last_name" == "${values_last_name}[0]"
            ...    ${\n}---> get ค่า "avatar" == "${values_avatar}[0]"
            Log     ${log_item}  
            # สร้าง expected list ของ id เพื่อเป็นค่าต้นแบบในการ Verify กับผลลัพธ์จริงที่ได้ จะต้องเป็นไปตามนี้ นอกเหนือจากเลข id นี้จะ Fail
            @{expected_id}    Create List    7    8    9    10    11    12
            # ดึงค่า id จากกับผลลัพธ์จริงที่ได้ มาแปลงเป็น String
            ${actual_id}    Convert To String    ${values_id}[0]
            # Verify ค่า "$.data[*].id" จะต้องมี value "id" ตามนี้ (7,8,9,10,11,12) 
            List Should Contain Value    ${expected_id}    ${actual_id}
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู expected_id และ actual_id ที่เช็คใน Loop นั้นๆ
            ${log_verify}     Catenate
            ...    ${\n}---> Success
            ...    ${\n}---> "expected_id" == ${expected_id} 
            ...    ${\n}---> "actual_id" == ${actual_id}
            Log    ${log_verify}
            ${start_while_loop}    Evaluate    ${start_while_loop} + 1
    END

Ex14_WHILE Loop (ตัวอย่างที่ 2)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    WHILE Loop ตาม list ที่ get ได้
    ...    - jsonpath = "$.data[*].id" จะต้องมี value == (7,8,9,10,11,12) 
    ...    - jsonpath = "$.data[*].email" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].first_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].last_name" ให้ Log แสดงค่า
    ...    - jsonpath = "$.data[*].avatar" ให้ Log แสดงค่า
    [Tags]    loop    while_loop
    # ยิงทดสอบ API for testing free service"
    Send Request API      
    ...    method=${TestData_001.Method}    
    ...    verify_ecode=${TestData_001.Ecode}    
    ...    url=${Domain.${run_Site}.${run_Domain}}${TestData_001.Path}?page=${TestData_001.QueryString.page}
    # Count Value และ Get Value ตามที่ส่ง Json Path ไป 
    # ...  - ${KEY_VALUE} จะถูก Set Variable ขึ้นให้เรียกใช้
    # ...  - ${count} จะถูก RETURN ให้เรียกใช้
    ${count}    Get List Key And Count From Json    json_path=$.data
    Log Response Json    ${KEY_VALUE}
    # Set ต่าเริ่มของ index ให้เริ่มต้นที่ 0 เสมอ
    ${start_index}      Set Variable    0
    # ตัวอย่างการใช้  WHILE Loop แบบใช้ Limit
    WHILE  ${True}     limit=${count}
            ${object}	            Get Value From Json    ${response.json()}	$.data[${start_index}]
            ${json_formatter}       Convert To Json Format Document             ${object}
            ${values_id}	        Get Value From Json    ${response.json()}	$.data[${start_index}].id
            ${values_email}	        Get Value From Json    ${response.json()}	$.data[${start_index}].email
            ${values_first_name}	Get Value From Json    ${response.json()}	$.data[${start_index}].first_name
            ${values_last_name}	    Get Value From Json    ${response.json()}	$.data[${start_index}].last_name
            ${values_avatar}	    Get Value From Json    ${response.json()}	$.data[${start_index}].avatar
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู Key, Value
            ${log_item}     Catenate
            ...    ${\n}---> "json" == ${\n}${json_formatter}${\n}
            ...    ${\n}---> get ค่า "id" == "${values_id}[0]"
            ...    ${\n}---> get ค่า "email" == "${values_email}[0]"
            ...    ${\n}---> get ค่า "first_name" == "${values_first_name}[0]"
            ...    ${\n}---> get ค่า "last_name" == "${values_last_name}[0]"
            ...    ${\n}---> get ค่า "avatar" == "${values_avatar}[0]"
            Log     ${log_item}  
            # สร้าง expected list ของ id เพื่อเป็นค่าต้นแบบในการ Verify กับผลลัพธ์จริงที่ได้ จะต้องเป็นไปตามนี้ นอกเหนือจากเลข id นี้จะ Fail
            @{expected_id}    Create List    7    8    9    10    11    12
            # ดึงค่า id จากกับผลลัพธ์จริงที่ได้ มาแปลงเป็น String
            ${actual_id}    Convert To String    ${values_id}[0]
            # Verify ค่า "$.data[*].id" จะต้องมี value "id" ตามนี้ (7,8,9,10,11,12) 
            List Should Contain Value    ${expected_id}    ${actual_id}
            # ทำ Log ไว้ในไฟล์ Robot Log เพื่อดู expected_id และ actual_id ที่เช็คใน Loop นั้นๆ
            ${log_verify}     Catenate
            ...    ${\n}---> Success
            ...    ${\n}---> "expected_id" == ${expected_id} 
            ...    ${\n}---> "actual_id" == ${actual_id}
            Log    ${log_verify}
            # ตัว + index เพื่อที่ Loop รอบต่อไปจะไปดึง index ตัวถัดไป
            ${start_index}    Evaluate    ${start_index} + 1
            # ตัว BREAK ออก Loop ถ้า Loop ครบจำนวนแล้วไม่มีการ BEARK ออก Robot จะมองเป็น Fail ทันที เพราะเป็นการวนที่ครบจำนวนแล้ว และไม่มี Action ให้ทำอะไรต่อ 
            # "กรณีที่ใช้ Limit จะต้องเขียน BREAK เสมอ"
            IF    "${start_index}" == "${count}"    BREAK           
    END

Ex15_Send Request API : GET - LIST USERS (ตัวอย่างที่ 1 เขียนตาม Doc)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 001 เพื่อยิง API - GET LIST USERS)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - "json path" == "$.data" จะต้องมี length >= "1"
    [Tags]    sendAPI    GET
    # ตัวอย่าง กรณีถ้าเขียนตาม Doc  ---> Link: https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#GET
    &{json_header}    Create Dictionary    Content-Type=application/json    User-Agent=PostmanRuntime
    ${response}       GET    url=https://reqres.in/api/users?page=2         headers=${json_header}    
    ...    expected_status=200     timeout=60    
    ...    verify=${True}
    Log Many    ${response.json()}
    
Ex16_Send Request API : POST - LOGIN SUCCESSFUL (ตัวอย่างที่ 2 เขียนตาม Doc)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 004 เพื่อยิง API - POST Login - successful)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - "json path" == "$.data" จะต้องมี length >= "1"
    [Tags]    sendAPI    POST
    # ตัวอย่าง กรณีถ้าเขียนตาม Doc  ---> Link: https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html#POST
    &{json_header}    Create Dictionary    Content-Type=application/json    User-Agent=PostmanRuntime
    &{json_body}      Create Dictionary    email=eve.holt@reqres.in         password=cityslicka
    ${response}       POST    url=https://reqres.in/api/login    headers=${json_header}
    ...    json=${json_body}    
    ...    expected_status=200     timeout=60    
    ...    verify=${True}
    Log Many    ${response.json()}

Ex17_Validate Json By Schema (ตัวอย่างการเช็ค O/M และประเภท Type ของ Parameter)
    [Documentation]    Owner : Patipan.w
    ...    ${\n} ==>
    ...    ** Test Step Description **
    ...    - ยิง API เพื่อทดสอบ Condition Multiple
    ...    (โดยใช้ TestData ที่ 004 เพื่อยิง API - POST Login - successful)
    ...    ${\n} ==>
    ...    ** Expected Result **
    ...    - "json path" == "$.data" จะต้องมี length >= "1"
    [Tags]    sendAPI    POST