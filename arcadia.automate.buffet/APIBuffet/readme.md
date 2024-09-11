# Arcadia robotframework API buffet

## Commit version

### Version 1.0.1

- Setting headers and body for sending API requests
- Sending API requests and verify response code
- Verify API response data

---

## **Requirements**

- Python3 or later
- robotframework 5.0 or later

### Python Library

- robotframework
- robotframework-requests
- robotframework-jsonlibrary

### Using Variable in file buffet_config.yaml

#### buffet_config.yaml

```yaml
Api:
  RequestTimeout: 20
```

### ***Variable in file TestSite***

- ${FLAG_SET_PROXY_API}
- ${PROXY_API}
