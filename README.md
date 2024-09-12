##### กด Ctrl+Shift+v (เพื่ออ่านง่ายขึ้น)

###  **Install Robot Framework**

__โปรแกรมที่ต้องใช้มีดังนี้__

|ชื่อโปรแกรม|ลิงก์ดาวโหลด|หมายเหตุ|
| :----: | :----: | :---- |
|Python|https://www.python.org/downloads/|คลิ๊กเลือก Install launcher for all users (recommended) <br> คลิ๊กเลือก Add Python (versin) to PATH |
|NodeJS|https://nodejs.org/en/|
|VSCode|https://code.visualstudio.com/download|ใช้สำหรับแก้ไข body|

### การสร้างโปรเจค **Environment**

__ให้สร้างไว้ชั้นนอกสุดของโปรเจค__
* เปิด Terminal ใน VS Code
* รันคำสั่ง `python -m venv (ชื่อ Environment)` 

```python
Run     python -m venv ชื่อ Environment
```

#### Activate Environment 
##### Windows 
  
  ให้เปิด Terminal ใน VS Code ชั้นนอกสุดของโปรเจค  และ Run คำสั่งตามนี้

```python
Run     <ชื่อ Environment>\Scripts\activate
```
* เมื่อ Run คำสั่งข้างต้นแล้ว สังเกตใน Terminal จะแสดง ชื่อ (Environment) ที่เราตั้ง ตามด้วย Devices ที่เก็บโปรเจค
```python
(Environment) C:\Users\....>
```
##### Mac หรือ Linux
  
  ให้เปิด Terminal ใน VS Code ชั้นนอกสุดของโปรเจค  และ Run คำสั่งตามนี้

```python
Run     Source <ชื่อ Environment>/bin/activate
```
* เมื่อ Run คำสั่งข้างต้นแล้ว สังเกตใน Terminal จะแสดง ชื่อ (Environment) ที่เราตั้ง ตามด้วย Devices ที่เก็บโปรเจค
```python
(Environment) folder/..
```

*note* :  ถ้าต้องการออกจาก Environment ที่สร้าง
```python
Run     deactivate
```

### การ Install Library **requirements.txt**  
* ใช้คำสั่ง
```python
Run     pip install -r requirements.txt
```

## การเปิด Terminal เพื่อ Run Automate
* คลิ๊กขวาที่ Folder **Testsuites** หรือ **File** ที่แสดงอยู่ใน Folder Testsuites
* ไปที่ **Open in Integrated Terminal**
## คำสั่ง Run Robot ผ่าน Terminal

* -d    คือการสร้าง Folder แล้วตั้งชื่อเพื่อเก็บ Log

* run ทุกข้อ Site Test
```python
Run     robot -d "Result" -v "testsite:Test" Test.robot

* run ทุกข้อ Site Production
```python
Run     robot -d "Result" -v "testsite:Production" Test.robot
```

* -t    รันเฉพาะข้อ Testcase
```python
Run     robot -d "Result" -t "Testcase" -v "testsite:Test" Test.robot
```

* -e    รันทุกข้อ ยกเว้น Tag On-Hold

```python
Run     robot -d "Result" -e "On-Hold" -v "testsite:Test" Test.robot
```
* -i    รันทุกข้อ ที่มี Tag On-Hold
```python
Run     robot -d "Result" -i "On-Hold" -v "testsite:Test" Test.robot
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
