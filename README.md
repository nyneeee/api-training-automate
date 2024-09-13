##### กด Ctrl+Shift+v (เพื่ออ่านง่ายขึ้น)

## การเปิด Terminal เพื่อ Run Automate
* คลิ๊กขวาที่ Folder **Testsuites** หรือ **File** ที่แสดงอยู่ใน Folder Testsuites
* ไปที่ **Open in Integrated Terminal**

## คำสั่ง Run Robot ผ่าน Terminal
__ให้เข้าไปที่ path ที่เก็บไฟล์ Testsuite__
* เปิด Terminal ใน VS Code
* รันคำสั่ง `robot -d log test_automate.robot(ชื่อไฟล์ที่เขียน Test)` 

```python
Run     robot -d log test_automate.robot(ชื่อไฟล์ที่เขียน Test)
```

|คำอธิบาย Argument Flags |Argument Flags ที่ใช้|ตัวอย่าง Run CMD|
| :----: | :---- | :---- |
|Run ทุก Case และสร้าง documents ที่ชื่อว่า "log" ไว้เก็บไฟล์ log ของ robot|-d|robot -d log test_api_basic.robot หรือ robot -d log test_api_advanced.robot|
|Run เฉพาะ Case ที่เป็น Tag "sendAPI"|-i|robot -d log -i sendAPI test_api_basic.robot|
|Run ทุก Case แต่ยกเว้น Case ที่เป็น Tag "var"|-e หรือ --exclude|robot -d log -e var test_api_basic.robot|
|Run ทุก Case แต่มีการส่งค่า var เข้าไปเปลื่ยนแปลง value ของ var ที่ชื่อว่า "run_Site" ให้มีค่าเท่ากับ SIT |-v|robot -d log -v run_Site:SIT test_api_basic.robot|

* -d    คือการสร้าง Folder แล้วตั้งชื่อเพื่อเก็บ Log

* run ทุกข้อ Site Test
```python
Run     robot -d "Result" -v "testsite:Test" test_automate.robot

* run ทุกข้อ Site Production
```python
Run     robot -d "Result" -v "testsite:Production" test_automate.robot
```

* -t    รันเฉพาะข้อ Case
```python
Run     robot -d "Result" -t "Case" -v "testsite:Test" test_automate.robot
```

* -e    รันทุกข้อ ยกเว้น Tag On-Hold

```python
Run     robot -d "Result" -e "On-Hold" -v "testsite:Test" test_automate.robot
```
* -i    รันทุกข้อ ที่มี Tag On-Hold
```python
Run     robot -d "Result" -i "On-Hold" -v "testsite:Test" test_automate.robot
```

## การแก้ไข Data ที่ใช้ในการเทส API

#### Site Test 
* สามารถเข้าไปที่ Folder 
```command
\api\Resources\TestSite\Test\body
```
เลือกไฟล์ body ที่จะแก้ไข


#### Site Production 
* สามารถเข้าไปที่ Folder 
```command
\api\Resources\TestSite\Production\body
```
เลือกไฟล์ body ที่จะแก้ไข

#### ตัวอย่างการแก้ไขไฟล์

ขอยกตัวอย่างข้อ 3 

```json
{
    "userId": "943aedfc9b5666fc7b2a59ba019a2b27",
    "language": "EN",
    "parameters":""
}
```
สามารถแก้ไขค่าและทำการบันทึก
