# Arcadia robotframework UI buffet

## Commit version

### Version 1.4
- Add **Open New Browser** keyword for using with new structure.
#### *Example:*
``` Robotframework
*** Keywords ***
Open Google Website
    [Documentation]    Owner: Lorem Ipsum
    Open New Browser    https://google.co.th
```
- Adjust all keyword for support with all Config.yaml file with new automated structure.
- Adjust WARN and ERROR log when Config.yaml file don't have Required key value
- Support with responsive website
- Support with specific Geo location
---
### Version 1.3.2

- edit error message of keyword Verify Text Exist On Selector

---

### Version 1.3

- modify log error message for verify keyword
- add keyword set default timeout
- add keyword "Browser Take Screenshot"
- add keyword "Check Element Visible"
- tags keyword_command will add robot:private for prevent call keyword from another file.

---

### Version 1.2.1

- add keyword close browser context
- modify keyword set up browser fullscreen to support multiple context

---

### Version 1.1.2

- modify keyword Verify Number On Selector to support number with sign , (both actual number and expect number)

---

### Version 1.1.1

- Support with web UI testing
- Add retry assertion for verify wording in webpage

---

## **Requirements**

- nodejs
- Python3 or later
- robotframework 5.0 or later

### Python Library

- robotframework
- robotframework-browser
  ```
  pip install robotframework robotframework-browser
  ```
  - run this command after install browser library
    ``` bash
    rfbrowser init
    ```

### Using Variable in config files
#### *buffet_config.yaml*
``` yaml
Browser:
  BrowserTimeout: 30s   # Required
  WaitStateTimeout: 20s # Required
  AssertionTimeout: 10s # Required
  ScreenshotTimeout: 5s # Required
  Headless: False       # Required
  DownloadPath: Downloads
  Permissions:
    - udid
    - midi
    - notifications
    - push
    - camera
  Location:
    latitude: 13.745021
    longitude: 100.538428
  Viewport:
    width: 1920
    height: 1080
```
#### *default_config.yaml*
``` yaml
# Required all
Lang: EN
TestSite: Qa
```
#### *testsite.yaml*
``` yaml
Qa:
  Url: https://qa.plttravelsolutions.com/ # Required
  ApiUnlockAccount: https://qa.plttravelsolutions.com/tmpauthentication-qa/api/Users/UnlockUserForTester
  IgnoreSslCertificate: False # Required
  AdminUser: Admin@mail.com
  Topup: 1222222
  SetProxy: False # Optional
  Proxy: # Required when contain SetProxy
    server: http://proxy.tmp.com:3128
    username: null
    password: null
Dev:
  Url: https://dev.plttravelsolutions.com/ # Required
  ApiUnlockAccount: https://dev.plttravelsolutions.com/tmpauthentication-qa/api/Users/UnlockUserForTester
  IgnoreSslCertificate: False # Required
  AdminUser: Admin@mail.com
  Topup: 5555555
  SetProxy: False # Optional
  Proxy: # Required when contain SetProxy
    server: http://proxy.tmp.com:3128
    username: null
    password: null
```