# Arcadia Robotframework

โครงสร้างและข้อตกลง สำหรับการเขียน Robotframework

## ⌗ Agreement / Naming Convention

### ‣ Config

1. buffet_config.yaml
   - ค่า default ของ timeout และ config ต่างๆ สำหรับ library (UI, API, Mobile **สามารถอ่านเพิ่มเติมได้ในไฟล์ ./readme.md ของแต่ละ library**)
2. default_config.yaml
   - ใช้ใส่ค่า variable ที่ง่ายในการแก้ไข
   - สามารถให้ user หรือคนที่ดูแลเรื่องการ run regression เข้ามาแก้ไขได้เอง
3. testsite.yaml
   - ค่าของ variable ที่ต่างกันแต่ละ site จะสร้าง variable ไว้ในไฟล์นี้ ตามแต่ละ site (Dev, Qa, Uat, Prod)

**ชื่อ variable ใน file config จะต้องเป็น `PascalCase`**

### ‣ Resources

1. Keywords
   - ชื่อ keyword จะต้องเป็น `Title Case`
   - keyword "Set Test Variable" variable จะต้องเป็น `UPPER_CASE` คั่นด้วย _
   - ห้ามใช้ keyword sleep (*ในกรณีที่จำเป็นต้องใช้ จะต้อง discuss กับทีม)
   - ให้ใส่ tag ระดับชั้นของ keyword (`keyword_command`, `keyword_action`, `keyword_communicate`) ในทุก keyword
   - ในส่วน settings จะเรียกเฉพาะ localized, repositories, testdata และ common keyword สำหรับ keyword ของตัวเองที่ต้องใช้เท่านั้น (ไม่เรียกไฟล์ keyword อื่น)
   - แต่ละ keyword จะเว้น 1 บรรทัด
   1. Common
      - ใน folder Keywords จะมี folder `Common` สำหรับใส่ keyword common ต่างๆ
      - ในไฟล์นี้จะเป็นไฟล์หลักในการ import library ต่างๆ (รวมถึง buffet ด้วย)
      - ในส่วน settings จะเรียกไฟล์ config yaml ต่างๆ และไฟล์ variable อื่นๆ ที่เกี่ยวข้อง
   2. E2E
      - ใน folder Keywords สามารถมี folder `E2E` ได้สำหรับ group ชุด keyword เฉพาะ testsuite ได้
      - ชื่อไฟล์ใน folder E2E จะต้องขึ้นต้นด้วย `E2E_`
      - ใน file E2E ส่วน settings จะเรียกเฉพาะ `keyword` อื่นๆ เท่าที่ใช้เท่านั้น และจะไม่เรียกไฟล์อื่นๆ นอกจาก `keyword`
2. Localized
   - ชื่อ variable ใน localized แต่ละตัวจะต้องขึ้นต้นด้วย `msg_`
   - จะใส่ค่า variable ที่มีค่าเกี่ยวกับข้อความ, ภาษา
3. Repositories
   - ชื่อ variable ใน repositories จะต้องขึ้นต้นด้วย 3 ตัวย่อ (prefix name) ตามแต่ละ element (**Detail สามารถอ่านเพิ่มเติมได้ใน ./Script/robocop/readme.md**)
   - จะใส่ค่า variable เกี่ยวกับ xpath
   - สำหรับ mobile สามารถใส่ position x, y สำหรับพิกัด element
4. Testdata
   - จะใส่ค่า variable ที่เป็นค่าสำหรับใช้ในการ test สำหรับแต่ละ testcase
   - เป็นค่า variable ที่ต้องมีการแก้ไขที่ database หรือมีขั้นตอนการ setting (มีการ mock ขึ้นมา)

### ‣ Testsuites

1. Testsuites
   - ชื่อ testcase จะไม่ใส่ตัวอักษรพิเศษ (**Detail สามารถอ่านเพิ่มเติมได้ใน ./Script/robocop/readme.md**)
   - แต่ละ testcase จะเว้น 1 บรรทัด
   - ในส่วน settings จะเรียกเฉพาะ keyword เท่าที่ใช้เท่านั้น และจะไม่เรียกไฟล์อื่นๆ นอกจาก keyword
   - tag สำหรับใช้ run regression ต้องใส่ชื่อ feature ทุก testcase
   - tag ทุกตัวจะต้องเป็น `PascalCase`

### ‣ ทุกไฟล์

1. บรรทัดที่คั่นระหว่างแต่ละ section จะเว้น 2 บรรทัด
2. บรรทัดสุดท้ายของไฟล์ จะต้องเว้นไว้ 1 บรรทัด
3. ชื่อ variable ทุกตัวจะต้องเป็น `snake_case` คั่นด้วย _
4. ให้ใส่ชื่อ `Owner: name` ทุก testcase, keyword (ถ้ามีการแก้ไขต่อ Owner คนอื่นให้ใส่ `Edit: name`)

---

## ⌗ Robotframework Structure

แบ่งออกเป็น 3 folders (Config, Resources, Testsuites)

- ให้ตั้งชื่อทุก folder ตามตัวอย่าง (พิมพ์เล็กพิมพ์ใหญ่ต้องถูกต้อง)
- นามสกุลไฟล์ (สำหรับทุกไฟล์ที่ไม่ใช่ testsuite) เปลี่ยนเป็น .resource
- ให้สร้าง folder เฉพาะที่ใช้เท่านั้น
- [link โครงสร้างพื้นฐานตั้งต้น Automate Structure Version 1.1](https://bitbucket.org/arcadiasoftware/arcadia.automate.buffet/downloads/automated_structure-1.1.zip)

### ◆ Config

> buffet_config.yaml
> default_config.yaml
> testsite.yaml

### ◆ Resources

> #### Keywords
>
  >> Common
    >>> ui_common.resource
    >>> api_common.resource
    >>> mobile_common.resource
    >>> ssh_common.resource
    >>> database_common.resource
  >>
  >> E2E
    >>> E2E_keyword_test1.resource
    >>> E2E_keyword_test2.resource
  >>
  >> keyword1.resource
  >> keyword2.resource
>
> #### Localized
>
  >> TH
    >>> test1.resource
    >>> test2.resource
  >>
  >> EN
    >>> test1.resource
    >>> test2.resource
  >>
>
> #### Repositories
>
  >> repo1.resource
  >> repo2.resource
>
> #### Testdata
>
  >> testdata1.resource
  >> testdata2.resource

### ◆ Testsuites

> suite1.robot
> suite2.robot

---

## ⌗ Merging Branches

1. จะต้องมีการแยก branch ในแต่ละ project ตาม feature ที่ implement
2. branch master (main) จะเป็น branch หลักที่จะใช้สำหรับส่งมอบงาน หรือ run regression เท่านั้น
3. ไม่อนุญาตให้ merge script เข้า branch master (main) ตรงๆ
4. เมื่อจบ sprint (หลัง review script และแก้ไขเรียบร้อยแล้ว) จะสามารถ merge เข้า branch master (main) ได้โดยการสร้าง pull request และให้ทีม approve การ merge

---

## Convention เพิ่มเติม (**New**)

### ⭐︎ Keywords

1. ชื่อ Keyword ที่ขึ้นต้นด้วย `Verify` จะไม่อนุญาตให้ใช้ จะสามารถใช้ใน keyword ที่เป็น verify ที่จุด verify จริงๆ เท่านั้น

### ⭐︎ Testsuites

1. เพิ่มการใส่ prefix ของ keyword ในหน้า testsuite เป็นรูปแบบของ BDD (Given, When, Then)
   - [link detail Behavior-driven style](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#behavior-driven-style)
   - เพื่อแบ่ง step testcase เป็นส่วนๆ อย่างชัดเจน
