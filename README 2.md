[STATUS CI/CD]

[![SIT-dispatch-workflow-multi-region](https://github.com/corp-ais/cpc-api-query-package/actions/workflows/SIT-dispatch-workflow-multi-region.yml/badge.svg?branch=sit)](https://github.com/corp-ais/cpc-api-query-package/actions/workflows/SIT-dispatch-workflow-multi-region.yml)

# API Testing(69 API)
* 1.Security Authentication
* 2.Security Validate Token
* 3.Get Promotion Shelves
* 4.Get All Catalog Configurations by Code
* 5.Get All Packages by Criterias
* 6.Get All Promotions by Shelf
* 7.Get Term & Condition for My Channel
* 8.Get Package Service Content VDO
* 9.Get Package Service Internet
* 10.Get Package Service MMS
* 11.Get Package Service SMS
* 12.Get Package Service Vertical Apps
* 13.Get Package Service Voice
* 14.Get Package Service Voice Free Number
* 15.Get Package Service WIFI
* 16.Get All Promotions by Shelf for Pre-paid
* 17.Get Promotion Product Rules
* 18.Get Promotions
* 19.Get Promotions by Promotion Codes
* 20.Get Zones Of Package
* 21.Update table Price Master
* 22.Sync Trades Daily for My Channel
* 23.Get All VAS Items by Shelf
* 24.Get All Accessories by Category
* 25.Get All Accessories by Product
* 26.Get Accessory Categories
* 27.Get Asp Banks
* 28.Get Banks Promotion
* 29.Get Installments For Partner
* 30.Get Brands Of Product
* 31.Get Campaign By Trade Model
* 32.Get Catalog SubTypes By CatalogType
* 33.Get CatalogTypes
* 34.Get Category by Catalog
* 35.Get Products by Criteria
* 36.Get All Product
* 37.Get Products By Brand and Model
* 38.Get Best Seller Products
* 39.Get Pay Advance Details
* 40.Get Payments
* 41.Get AIS Points
* 42.Search Products by Criteria
* 43.Get Product with Promotions by Product
* 44.Get Trade Limit Quota by Location
* 45.Search Campaign with Discount by Text
* 46.Get Campaign By Trade Discount
* 47.Get Campaigns
* 48.Get Free Goods
* 49.Get Location
* 50.Get Product Price Options by Material Code
* 51.Get Product Detail
* 52.Get Product Detail by Criteria
* 53.Get Product Price Options
* 54.Get Products By Material Code
* 55.Get All Product Search
* 56.Get All Products For Searching
* 57.Get All Products By Price
* 58.Get All Products By Campaign
* 59.Custom Search All Product
* 60.Search Product with Promotions by Text
* 61.Get Trade Criteria by Product
* 62.Get Trade Sale Channel
* 63.Get All Product Search
* 64.Get Product Specification
* 65.Get Related Products
* 66.Get Trade Pre-booking
* 67.Get Campaign Promotions
* 68.Get Trade Promotions by Campaign
* 69.Get Payments by Campaign
* 70.Get Payments by Campaign
* 71.Get Payments by Campaign
* 72.Get Payments by Campaign

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
