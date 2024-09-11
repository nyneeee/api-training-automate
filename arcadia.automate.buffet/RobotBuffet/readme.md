# Arcadia Robot Framework Buffet

## Commit version

### Version 1.4.0

- Group keyword follow type (keyword action, command and deprecated)
- Add warning message for deprecated keyword
- Add new keyword for check none type 'Variable Should Be Null'

### Version 1.3.0

- 'Verify Item Should Contain' was deprecated
- Modify keyword 'Verify Value Should Contain' for support both value and list. (except dictionary type)

---

### Version 1.2.2

- Modify keyword Send Notification Result for fully support with other platform
- Deprecated old "Send Notification Result" keywords

---

### Version 1.2.1

- Modify keyword Verify Number Should Be Equal (for support string/
number with sign ,)

---

### Version 1.2.0

- Add keyword Verify Lists Should Be Equal (for compare 2 lists)
- Add import Library Collections

---

### Version 1.1.1

- Verify variable(str) that should be equal or not equal with expected
- Send result of robot test to slack or telegram via webhook

---

## **Requirements**

### Python Library

- Python3.8 or later *
- robotframework 5.0 or later *
- PyYaml *
- robotframework-requests, *(for api testing)*
- robotframework-browser, *(with nodejs, for UI browser testing)*
- icu, *(for sorting list of Thai language)*
- jwt, *(for encode or decode jwt)*
- requests, *(for sending notification or etc.)*

\* *required*

---

## **How to use config files?**

### **Browser UI Config format**

``` yaml
test_site: QA
localized: EN
browser_config:
  browser: chromium
  headless: false
  ssl_certificate: true
  retry_assertion: 10s
  timeout: 20s
```

### **Notification Config format**

``` yaml
notification_config:
  user: str      # can be use own name
  platform: str  # slack or other platform name
  alert: boolean # true, false
  project: str   # project name
  webhook:       # generate url from slack bot
   slack:        # can contain more than 1 webhook
    jenkins:
     - https://hooks.slack.com/services/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 # TMP Regression
     - https://hooks.slack.com/services/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 # TMP CI/CD
    other:
     - https://hooks.slack.com/services/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 # TMP_QA Unit_01
   other_platform:
    - webhook # str
```

1. If you want to use the notification you must added these config into your project ***config.yaml*** file
2. Then import the ***send_notification_result.py*** as robot library
3. You must always Run Keyword ***Check Test Execution Result*** in test teardown
4. Then use the keyword ***Send Notification Result*** on suite teardown as lasted keyword

## **Example.**

```robot framework
*** Settings ***
Library           ../../arcadia.automate.buffet/Library/send_notification_result.py
Variable          Config.yaml
Test Teardown     Keyword Test Teardown
Suite Teardown    Keyword Suite Teardown


*** Keywords ***
Keyword Suite Teardown
    [Documentation]    Owner: owner_name
    Log    Pass
    Do Something
    ${config_path}    Join Path    ${CURDIR}    ../Config.yaml
    Send Notification Result    ${notification_config}

Keyword Test Teardown
    [Documentation]    Owner: owner_name
    Pass And Capture Screen
    Fail And Capture Screen
    Check Test Execution Result


*** Test Cases ***
Test_1_1_001_Login_As_Some_User
    [Documentation]    Owner: owner_name
    Open Website
    Login As    ${user}    ${password}
    Press Login Button
    Verify Login Success
```

---
