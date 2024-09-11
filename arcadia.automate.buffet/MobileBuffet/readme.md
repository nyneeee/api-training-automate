# Arcadia Robot Framework Buffet

## Commit version
### Version 1.2.1
- Required Robotframework version 6.1 or newer
- Remove required timeout in `testsite.yaml` file for setting Appium capability
- Deprecate all of these keywords, It will show deprecated warning message when still using it
  - Verify Mobile Locator Is Visible
  - Verify Mobile Locator Is Not Visible
  - Verify Mobile Locator Is Contain Page
  - Verify Mobile Locator Is Not Contain Page
  - Verify Mobile Locator Is Placed On Screen
  - Verify Text Should Be Equal On Mobile Locator
  - Verify Text Should Not Be Equal On Mobile Locator
  - Verify Text Should Match On Mobile Locator
  - Verify Attribute Should Be Equal On Mobile Locator
---
### Version 1.2.0
- Update for support with robotframework version 6.1 or later
- Completely support to run automated test more than 1 device
---
### Version 1.1.0
- Update for using with new Arcadia's Robotframework structure with yaml file
- Changing keywords Open Android Application and Open IOS Application argument
#### Android Example:
``` robot
*** Keywords ***
Open AisPlay Application On Android
    [Documentation]    Owner: Lorem Ipsum
    Open Android Application    AisPlay
```
#### iOS Example:
``` robot
*** Keywords ***
Open AisPlay Application On IOS
    [Documentation]    Owner: Lorem Ipsum
    Open IOS Application    AisPlay
```
- Adjust mobile config key value in default_config.yaml file
#### testsite config file Example:
``` yaml
# These config are required on Arcadia's Appium Buffet
MobileDevice:
  iOS:
    AisPlay:
      RemoteUrl: http://localhost:4723/wd/hub
      Alias: iPhoneBlack
      Config:
        platformName: iOS
        platformVersion: '15.4'
        deviceName: iPhoneBlack
        udid: 7a7a858ad5480baf616f2cece9dd8bbc34c81696
        app: com.ais.mimo.AISPlaybox
        automationName: XCUITest
  Android:
    AisPlay:
      RemoteUrl: http://localhost:4723/wd/hub
      Alias: AisPlay
      Config:
        deviceName: Samsung J7
        platformVersion: '9'
        platformName: Android
        appPackage: com.ais.mimo.AISPlay
        appActivity: net.vimmi.lib.ui.main.MainActivity
        automationName: uiautomator2
    Gallery:
      RemoteUrl: http://localhost:4724/wd/hub
      Alias: Gallery
      Config:
        deviceName: Samsung A10
        platformVersion: '11'
        platformName: Android
        appPackage: com.gallery
        appActivity: com.gallery.main.MainActivity
        automationName: uiautomator2
```
---
### Version 1.0.0

- Add New Keyword (action keyword)
  - Swipe On Element
  - Swipe 2 Section Horizontal On Screen
  - Swipe 2 Section Vertical On Screen
  - Swipe On Specific Point Page
  - Verify Mobile Locator Is Placed On Screen
- Add New Keyword (command keyword)
  - Check Ratio Point Swipe
  - Check Specific Point X Y
  - Check Element Place On Screen
- Modify Command Keyword (Check Mobile Element Visible / Contain)
  - Add keyword `Wait Until Keyword Succeeds` for loop check visible / contain
- Add argument of capacibility for adjust timeout driver uiautomator when first start appium (`$timeout_driver_uiautomator`)

---

## **Requirements**

### Python Library

- Python3.8 or later *
- robotframework 6.1 or later *

``` bash
  pip install robotframework
```
- robotframework-appiumlibrary 2.0 or later *(for connect to mobile module)*

``` bash
  pip install robotframework-appiumlibrary
```
- PIL library version 9.4.0 or later for capture screen on element (optional)

``` bash
  pip install pillow
```

### Using Variable in config files
#### *buffet_config.yaml*
``` yaml
WaitAppiumStateTimeout: 20000 # Required
```
#### *default_config.yaml*
``` yaml
Lang: EN  # Required
AisPlay:
  Username: '8091234567'
  Password: '1234567890'
WeTv:
  Username: test@test.com
  Password: '123456789'
```
#### *testsite.yaml*
``` yaml
MobileDevice:
  iOS:  # Required when testing iOS devices
    Safari: # Required all of these iOS application config except optional comment
      RemoteUrl: http://localhost:4723/wd/hub
      Alias: iPhone
      Config:
        platformName: iOS
        automationName: XCUITest
        deviceName: Lorem iPhone
        platformVersion: '14.8'
        udid: <device_id>
        app: com.apple.mobilesafari
        launchTimeout: 20000  # Optional
  Android:  # Required when testing Android devices
    Chrome: # Required all of these Android application config except optional comment
      RemoteUrl: http://localhost:4724/wd/hub
      Alias: Android
      Config:
        automationName: UIAutomator2
        platformName: Android
        platformVersion: '11.0'
        deviceName: Lorem phone
        appPackage: com.android.chrome
        appActivity: com.google.android.apps.chrome.Main
        appWaitDuration: 20000                  # Optional
        uiautomator2ServerInstallTimeout: 20000 # Optional
        uiautomator2ServerLaunchTimeout: 20000  # Optional

```