# Custom Rule

## Testcase

1. 9901 special-sign-in-testcase
    - There is spcial sign in testcase name
      - เช็คสัญลักษณ์พิเศษ ไม่อนุญาตให้ใช้ตัวอักษรพิเศษดังนี้
        `` ~ ! @ # $ % ^ & * ( ) + : ; [ { } ] \ | , . < > / ? ' "`

2. 9902 syntax-testcase-number
     - Testcase number is invalid format in testcase name
       - format testcase number ต้อง match regex กับ format นี้
        `.+_\d+_[F,S]_\d{3}`

3. 9903 sleep-keyword
    - Keyword name should not use 'Sleep' keyword
      - ไม่อนุญาตให้ใช้ keyword Sleep *ยกเว้นกรณีที่จะเป็นที่ต้องใช้จริง ๆ

4. 9904 empty-lines-between-test-cases-ignore-comment
    - Custom rule - `empty-lines-between-test-cases`
      - เพิ่มการเช็ค case กรณีใส่ comment บน testcase name

5. 9905 empty-lines-between-keywords-ignore-comment
    - Custom rule - `empty-lines-between-keywords`
      - เพิ่มการเช็ค case กรณีใส่ comment บน keyword name

6. 9906 consecutive-without-empty-lines
    - Custom rule - consecutive-empty-lines
      - custom เพราะเป็น rule พ่วงจาก rule `empty-lines-between-test-cases-ignore-comment`, `empty-lines-between-keywords-ignore-comment`

## Variable

1. 9801 section-variable-not-lowercase
    - Section variable name should be lowercase
      - variable ต้องประกาศเป็นตัวเล็ก คั่นด้วย _

2. 9802 incorrect-prefix-variable
    - Prefix variable name is not in prefix name list
      - prefix name ที่สามารถใช้ได้มีดังนี้

      | Element          | Name Prefix Define |
      | ---------------- | ------------------ |
      | Label            | lbl                | -> เกี่ยวกับ text ต่างๆ ที่แสดง
      | TextBox          | txt                | -> เป็นช่องที่สามารถกรอกค่าลงไปได้ใน mode ปกติ (่enable edit), จะรวมทั้งช่องที่เป็น disable (ช่องที่ไม่สามารถกรอกค่าได้)
      | ________________ | __________________ |
      | Button           | btn                | -> เป็นปุ่มต่างๆ ที่แสดง
      | RadioButton      | rdo                | -> เป็นปุ่ม type radio
      | Toggle           | tgg                | -> เป็นปุ่ม type toggle
      | CheckBox         | cbx                | -> เป็น checkbox (ปุ่มที่สามารถกดเพื่อ check หรือกด uncheck ได้)
      | ________________ | __________________ |
      | DropDownList     | ddl                | -> เป็น dropdownlist
      | Table            | tbl                | -> เป็น table
      | DateTimePicker   | dtp                | -> เป็น datetime picker รวมทั้งหน้าที่เป็น element calendar ให้เลือกวันที่
      | List             | lst                | -> เป็นรายการเรียงกันมา หรือ element ที่มีค่าหลายตัว
      | ________________ | __________________ |
      | Image            | img                | -> เป็นรูปต่างๆ ที่แสดง
      | Icon             | icn                | -> เป็น icon หรือสัญลักษณ์ต่างๆ ที่แสดง
      | ________________ | __________________ |
      | MenuList         | mnu                | -> เป็นรายการเมนูเรียงกันมา หรือเป็น element list ที่กดแล้วจะทำการ redirect ไปหน้าใหม่
      | TabPage          | tab                | -> เป็น tab ที่กดแล้วจะ เปลี่ยน mode หรือ เปลี่ยน sub page
      | Panel            | pnl                | -> เป็นสัดส่วน, card list, top bar, footer, แถบต่างๆ, element ที่เป็นแผ่น
      | ProgressBar      | prg                | -> เป็น progress bar ที่แสดง

3. prefix-inappropriate
    - Prefix variable name should not startwith in prefix name list
      - ไม่ให้ใช้ prefix เดียวกับที่ตั้ง prefix list ไว้ใน rule 9802

---

## How to use (การใช้งาน)

### Script

`robocop-test_format_robot.bat` - ใช้รันเพื่อ check format robot **TestSuite** และ **Variable** `ยกเว้น Repository`
(อ่าน argument จากไฟล์ robocop_args.txt)

`robocop-test_format_repository_robot.bat` - ใช้รันเพื่อ check format **Repository**
(อ่าน argument จากไฟล์ robocop_args_repository.txt)

### Change path directory for run script

1. robocop_args_repository.txt
    - แก้ path run script folder repository
2. robocop_args.txt
    - แก้ path ignore folder repository
    - แก้ path run script folder ที่ต้องการรัน check format
3. robocop-test_format_repository_robot.bat
    - แก้ path ของ argument text file
4. robocop-test_format_robot.bat
    - แก้ path ของ argument text file
