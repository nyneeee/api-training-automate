*** Settings ***
Library    ../MongodbLibrary.py
Library    DateTime
Library    ../MongodbLibrary.py
Test Setup       Connect To Mongodb    ${connection_string}
Test Teardown    Disconnect From Mongodb


*** Variables ***
# Test on NTL database
${connection_string}    mongodb://mongouser:Test1234@101.32.224.18:27017/?directConnection=true
${database_name}        underwriting
${collection_name}      Order
${new_database}         zNewDb
${new_collection}       zNewCol
${insert_json_path}     test_insert.json
${update_json_path}     test_update.json


*** Tasks ***
001 Test Get Mongodb Database
    ${database_list}    Get Mongodb Database
    ${length}    Get Length    ${database_list}
    IF    ${length} == 0    Fail    msg=No exist database.

002 Test Get Mongodb Collections
    ${database_list}    Get Mongodb Collections    ${database_name}
    ${length}    Get Mongodb Collection Count    ${database_name}    ${collection_name}
    IF    ${length} == 0    Fail    msg=No exist database.

# Not regression test
# 003 Test Create Mongodb Database Collection
#     [Tags]    not_regression
#     Create Mongodb Database Collection    ${new_database}    ${new_collection}
#     ${all_database}    Get MongoDB Database
#     Should Contain    ${all_database}    ${new_database}
#     @{all_collections}    Get MongoDB Collections    ${new_database}
#     Should Contain    ${all_collections}    ${new_collection}

# 004 Test Drop Mongodb Collection
#     [Tags]    not_regression
#     Drop Mongodb Collection    ${new_database}    ${new_collection}
#     @{all_collections}    Get MongoDB Collections    ${new_database}
#     Should Not Contain    ${all_collections}    ${new_collection}

# 005 Test Drop Mongodb Database
#     [Tags]    not_regression
#     Drop Mongodb Database    ${new_database}
#     ${all_database}    Get MongoDB Database
#     Should Not Contain    ${all_database}    ${new_database}

006 Test Insert New Mongodb Record By Json String
    [Tags]    not_regression
    ${json}    Set Variable    {"OrderId": "001"}
    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${json}

007 Test Insert New MongoDB Record By Dictionary
    [Tags]    not_regression
    ${data_dict}    Create Dictionary    OrderId=002
    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${data_dict}

008 Test Insert New Mongodb Record By Json File Cannot Insert
    ${status}    Run Keyword And Return Status    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${insert_json_path}
    IF    ${status} == ${True}    Fail    msg=It's invalid type. It can insert json file.

009 Test Insert New Mongodb Record By Json String With _id
    [Tags]    not_regression
    ${datetime}    Get Current Date
    ${json}    Set Variable    {"_id": "641bd1111e0331332b2e9b70", "OrderId": "004", "CreateTime": "datetime(${datetime})"}
    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${json}

010 Test Insert New Mongodb Record By Json String With Datetime
    [Tags]    not_regression
    ${datetime}    Get Current Date
    ${json}    Set Variable    {"OrderId": "005", "CreateTime": "datetime(${datetime})"}
    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${json}

011 Test Insert New Mongodb Record By Json String With Dict 2 Level
    [Tags]    not_regression
    ${datetime}    Get Current Date
    ${json}    Set Variable    {"OrderId": "006", "UserDetails": {"Name": "Firstname", "Address": "222"}}
    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${json}

012 Test Insert New Mongodb Record By Json String With List 2 Level
    [Tags]    not_regression
    ${datetime}    Get Current Date
    ${json}    Set Variable    {"OrderId": "007", "Pet": ["dog", "cat"]}
    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${json}

013 Test Insert New Mongodb Record By Json String With Dict 2 Level Datetime
    [Tags]    not_regression
    ${datetime}    Get Current Date
    ${json}    Set Variable    {"OrderId": "008", "UserDetails": {"Name": "Firstname", "Address": "222", "CreateTime": "datetime(${datetime})"}}
    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${json}

014 Test Insert New Mongodb Record By Json String With List 2 Level Datetime
    [Tags]    not_regression
    ${datetime}    Get Current Date
    ${json}    Set Variable    {"OrderId": "009", "CreateTime": ["datetime(${datetime})", "datetime(${datetime})", "datetime(${datetime})"]}
    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${json}

015 Test Insert New Mongodb Record By Json String With Dict And List 3 Level
    [Tags]    not_regression
    ${datetime}    Get Current Date
    ${json}    Set Variable    {"OrderId": "010", "OrderDetails": {"OrderName": "name", "Price": {"Best": 1000, "Medium": 500, "Low": 100}, "Pet": ["dog", "cat"]}, "CreateTime": ["datetime(${datetime})", "datetime(${datetime})"]}
    Insert Mongodb One Record    ${new_database}    ${new_collection}    ${json}

016 Test Update Mongodb Records By Multiple Records
    [Tags]    not_regression
    ${json}           Set Variable    {"OrderId": "006"}
    ${json_update}    Set Variable    {"Price": 999}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

017 Test Update Mongodb Records By Single Record query JSON As Dictionary
    [Tags]    not_regression
    ${data_dict}      Create Dictionary    OrderId=006
    ${json_update}    Create Dictionary    Price=888
    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${data_dict}    ${json_update}

018 Test Update Mongodb Records By Single Record query JSON As Json File Cannot Update
    ${data_dict}      Create Dictionary    OrderId=006
    ${json_update}    Create Dictionary    Price=888
    ${status}    Run Keyword And Return Status    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${insert_json_path}    ${update_json_path}
    IF    ${status} == ${True}    Fail    msg=It's invalid type. It can insert json file.

019 Test Update Mongodb Records By Single Record With _id
    [Tags]    not_regression
    ${json}           Set Variable    {"_id": "641bd1111e0331332b2e9b70"}
    ${json_update}    Set Variable    {"Price": 999}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

020 Test Update Mongodb Records By Single Record With Dict 2 Level
    [Tags]    not_regression
    ${json}           Set Variable    {"OrderId": "006", "UserDetails": {"Name": "Firstname", "Address": "222"}}
    ${json_update}    Set Variable    {"Price": 9999}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

021 Test Update Mongodb Records By Single Record With List 2 Level
    [Tags]    not_regression
    ${json}           Set Variable    {"OrderId": "007", "Pet": ["dog", "cat"]}
    ${json_update}    Set Variable    {"Price": 999}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

022 Test Update Mongodb Records By Single Record With Dict And List 3 Level
    [Tags]    not_regression
    ${datetime}       Get Current Date
    ${json}           Set Variable    {"OrderId": "010", "OrderDetails": {"OrderName": "name", "Price": {"Best": 1000, "Medium": 500, "Low": 100}, "Pet": ["dog", "cat"]}}
    ${json_update}    Set Variable    {"NewDate": "datetime(${datetime})"}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

023 Test Update Mongodb Records By Update Fields As Json String
    [Tags]    not_regression
    ${json}           Set Variable    {"OrderId": "006"}
    ${json_update}    Set Variable    {"Price": 1000}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

024 Test Update Mongodb Records By Update Fields As Dictionary
    [Tags]    not_regression
    ${data_dict}      Create Dictionary    OrderId=006
    ${json_update}    Create Dictionary    Price=1500
    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${data_dict}    ${json_update}

025 Test Update Mongodb Records By Update Fields As Json File Cannot Update
    ${data_dict}      Create Dictionary    OrderId=006
    ${json_update}    Create Dictionary    Price=1500
    ${status}    Run Keyword And Return Status    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${insert_json_path}    ${update_json_path}
    IF    ${status} == ${True}    Fail    msg=It's invalid type. It can insert json file.

026 Test Update Mongodb Records By Update Fields Datetime
    [Tags]    not_regression
    ${datetime}       Get Current Date
    ${json}           Set Variable    {"OrderId": "005"}
    ${json_update}    Set Variable    {"NewTime": "datetime(${datetime})"}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

028 Test Update Mongodb Records By Update Fields Dict 2 Level
    [Tags]    not_regression
    ${datetime}       Get Current Date
    ${json}           Set Variable    {"OrderId": "006"}
    ${json_update}    Set Variable    {"UserDetails": {"Name": "NewFirstname", "Address": "NewAdd222."}}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

029 Test Update Mongodb Records By Update Fields List 2 Level
    [Tags]    not_regression
    ${datetime}       Get Current Date
    ${json}           Set Variable    {"OrderId": "007"}
    ${json_update}    Set Variable    {"Pet": ["bird", "pig", "chicken", "hen"]}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

030 Test Update Mongodb Records By Update Fields Dict 2 Level Datetime
    [Tags]    not_regression
    ${datetime}       Get Current Date
    ${json}           Set Variable    {"OrderId": "008"}
    ${json_update}    Set Variable    {"UserDetails": {"Name": "NewName", "NewTime": "datetime(${datetime})"}}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

031 Test Update Mongodb Records By Update Fields List 2 Level Datetime
    [Tags]    not_regression
    ${datetime}       Get Current Date
    ${json}           Set Variable    {"OrderId": "009"}
    ${json_update}    Set Variable    {"NewDate": ["datetime(${datetime})", "datetime(${datetime})"]}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

032 Test Update Mongodb Records By Update Fields Dict And List 3 Level
    [Tags]    not_regression
    ${json}           Set Variable    {"OrderId": "010"}
    ${json_update}    Set Variable    {"OrderDetails": {"OrderName": "NewName", "Price": {"Best": 9000}, "Pet": ["dog", "cat"]}}
    ${record}    Update Many Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${json_update}
    IF    ${record} == 0    Fail    msg=No record exist.

033 Test Retrieve Mongodb Records By All Records All Fields
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}
    ${count}    Get Length    ${result}
    IF    ${count} == 0    Fail    msg=No record exist.

034 Test Retrieve Mongodb Records By Single Record
    ${json}           Set Variable    {"OrderId": "007"}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} == 0    Fail    msg=No record exist.

035 Test Retrieve Mongodb Records By Single Record query JSON As Dictionary
    ${data_dict}    Create Dictionary    OrderId=007
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${data_dict}
    ${length}    Get Length    ${result}
    IF    ${length} == 0    Fail    msg=No record exist.

036 Test Retrieve Mongodb Records By Single Record query JSON As Json File Cannot Retrieve
    ${status}    Run Keyword And Return Status    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${insert_json_path}
    IF    ${status} == ${True}    Fail    msg=It's invalid type. It can insert json file.

037 Test Retrieve Mongodb Records By Single Record _id
    ${json}      Set Variable    {"_id": "641bd1111e0331332b2e9b70"}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} == 0    Fail    msg=No record exist.

038 Test Retrieve Mongodb Records By Single Record With Dict 2 Level
    ${json}      Set Variable    {"OrderId": "006", "UserDetails": {"Name": "NewFirstname", "Address": "NewAdd222."}}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} == 0    Fail    msg=No record exist.

039 Test Retrieve Mongodb Records By Single Record With List 2 Level
    ${json}      Set Variable    {"OrderId": "007", "Pet": ["bird", "pig", "chicken", "hen"]}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} == 0    Fail    msg=No record exist.

040 Test Retrieve Mongodb Records By Single Record With Dict And List 3 Level
    ${json}      Set Variable    {"OrderId": "010", "OrderDetails": {"OrderName": "NewName", "Price": {"Best": 9000}, "Pet": ["dog", "cat"]}}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} == 0    Fail    msg=No record exist.

041 Test Retrieve Mongodb Records Get Only 1 Field
    ${json}      Set Variable    {"OrderId": "007"}
    ${fields}    Create List    Pet
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${fields}
    ${length}    Get Length    ${result}
    IF    ${length} == 0    Fail    msg=No record exist.

042 Test Retrieve Mongodb Records Get Only 1 Field _id
    ${json}      Set Variable    {"OrderId": "007"}
    ${fields}    Create List    _id
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${fields}
    ${length}    Get Length    ${result}
    IF    ${length} == 0    Fail    msg=No record exist.

043 Test Retrieve Mongodb Records Get Many Fields
    ${json}      Set Variable    {"OrderId": "010"}
    ${fields}    Create List    OrderId    Price    Pet
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}    ${fields}
    ${length}    Get Length    ${result}
    IF    ${length} == 0    Fail    msg=No record exist.

044 Test Remove Mongodb Records By Single Record
    [Tags]    not_regression
    ${json}      Set Variable    {"OrderId": "005"}
    Remove Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} > 0    Fail    msg=Record is not remove.

045 Test Remove Mongodb Records By Single Record query JSON As Dictionary
    [Tags]    not_regression
    ${data_dict}    Create Dictionary    OrderId=001
    Remove Mongodb Records    ${new_database}    ${new_collection}    ${data_dict}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${data_dict}
    ${length}    Get Length    ${result}
    IF    ${length} > 0    Fail    msg=Record is not remove.

046 Test Remove Mongodb Records By Single Record query JSON As Json File Cannot Remove
    ${status}    Run Keyword And Return Status    Remove Mongodb Records    ${new_database}    ${new_collection}    ${insert_json_path}
    IF    ${status} == ${True}    Fail    msg=It's invalid type. It can insert json file.

047 Test Remove Mongodb Records By Single Record _id
    [Tags]    not_regression
    ${json}    Set Variable    {"_id": "641bd1111e0331332b2e9b70"}
    Remove Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} > 0    Fail    msg=Record is not remove.

048 Test Remove Mongodb Records By Single Record With Dict 2 Level
    [Tags]    not_regression
    ${json}    Set Variable    {"OrderId": "006", "UserDetails": {"Name": "Firstname", "Address": "222"}}
    Remove Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} > 0    Fail    msg=Record is not remove.

049 Test Remove Mongodb Records By Single Record With List 2 Level
    [Tags]    not_regression
    ${json}      Set Variable    {"OrderId": "007", "Pet": ["dog", "cat"]}
    Remove Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} > 0    Fail    msg=Record is not remove.

050 Test Remove Mongodb Records By Single Record With Dict And List 3 Level
    [Tags]    not_regression
    ${json}      Set Variable    {"OrderId": "010", "Price": {"Best": 1000, "Medium": 500, "Low": 100}, "Pet": ["dog", "cat"]}
    Remove Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${length}    Get Length    ${result}
    IF    ${length} > 0    Fail    msg=Record is not remove.

051 Test Remove Mongodb Records By All Records
    [Tags]    not_regression
    ${json}    Set Variable    {}
    Remove Mongodb Records    ${new_database}    ${new_collection}    ${json}
    ${result}    Retrieve Mongodb Records    ${new_database}    ${new_collection}
    ${length}    Get Length    ${result}
    IF    ${length} > 0    Fail    msg=Record is not remove.
