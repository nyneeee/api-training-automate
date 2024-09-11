from robot.libraries.BuiltIn import BuiltIn, _RunKeyword
from robot.api.deco import keyword
import time
import requests
import urllib3


urllib3.disable_warnings()
robotBuiltin = BuiltIn()




class send_notification_result:
    '''Require Config key'''
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '1.0.0'
      
    def __init__(self) -> None:
        self.robotSuite = _RunKeyword()
        self.notificationSchema = notification_schema()
    
    
    @keyword('Send Notification Result')
    def send_notification(self) -> None:
        '''Only using in *Suite Teardown*'''
        self.robotSuite._get_suite_in_teardown('Send Notification Result')
        config = robotBuiltin.get_variable_value('$notification_config', default=None)
        if config != None and config['alert']:
            schema: dict = self.notificationSchema.get_schema(config)
            sslCertificate: bool = robotBuiltin.get_variable_value('$verify_ssl_certificate', default=True)
            if schema['url'] != None:
                requests.post(url=schema['url'], headers=schema['header'], 
                            json=schema['body'], proxies=schema['proxy'],
                            verify=sslCertificate)
            else:
                robotBuiltin.log(message="Cannot get platform name in config.yaml file", level='ERROR')
        elif config != None and config['alert'] == False:
            robotBuiltin.log(message="Notification OFF", level='INFO', console=True)
        else:
            robotBuiltin.log(message="Cannot find notification_config in config.yaml file", level='WARN')

    
    @keyword('Check Test Execution Result')
    def check_execution_result(self) -> None:
        '''Only using in *Test Teardown*'''
        self.robotSuite._get_test_in_teardown('Check Test Execution Result')
        testPass: int = robotBuiltin.get_variable_value('$TEST_PASS', default=int(0))
        testFail: int = robotBuiltin.get_variable_value('$TEST_FAIL', default=int(0))
        testSkip: int = robotBuiltin.get_variable_value('$TEST_SKIP', default=int(0))
        testStatus: str = robotBuiltin.get_variable_value('$TEST_STATUS')
        if str(testStatus) == 'PASS':
            testPass += 1
        elif str(testStatus) == 'FAIL':
            testFail += 1
        elif str(testStatus) == 'SKIP':
            testSkip += 1
        robotBuiltin.set_suite_variable('$TEST_PASS', testPass)
        robotBuiltin.set_suite_variable('$TEST_FAIL', testFail)
        robotBuiltin.set_suite_variable('$TEST_SKIP', testSkip)

class notification_schema:
    def __init__(self) -> None:
        pass
    
    
    def get_schema(self, config_schema: dict) -> dict:
        testSite: str = robotBuiltin.get_variable_value('$TEST_SITE')
        setProxy: bool = robotBuiltin.get_variable_value('$FLAG_SET_PROXY_UI')
        if setProxy:
            proxy: str = robotBuiltin.get_variable_value('$proxy_api')
        else:
            proxy = None
        header: dict = {
            'Content-type': 'application/json'
        }
        testPass: int = robotBuiltin.get_variable_value('$TEST_PASS', default=0)
        testFail: int = robotBuiltin.get_variable_value('$TEST_FAIL', default=0)
        testSkip: int = robotBuiltin.get_variable_value('$TEST_SKIP', default=0)
        testSuiteName: str = self.set_test_suite_name()
        platform: str = str(config_schema['platform']).lower()
        if str(platform) == 'slack':
            if str(config_schema['user']).lower() == 'jenkinstest':
                localTime: time = time.localtime()
                hour: int = int(time.strftime('%H%M', localTime))
                if 800 < hour < 1830:
                    url: str = config_schema['webhook']['slack']['jenkins'][1]
                else:
                    url: str = config_schema['webhook']['slack']['jenkins'][0]
            else:
                url: str = config_schema['webhook']['slack']['others'][0]
            body: dict = {
                'text': str('===================================' + '\n' +
                            'Project: ' + config_schema['project'] + '\n'
                            'Test by: ' + config_schema['user'] + '\n'
                            'Suite name: ' + str(testSuiteName) + '\n' + 
                            'Test Site: ' + str(testSite) + '\n' +
                            'PASS: ' + str(testPass) + '\n' +
                            'FAIL: ' + str(testFail) + '\n' +
                            'SKIP: ' + str(testSkip) + '\n' +
                            '===================================')
            }
        elif str(platform) != 'none' and str(platform) != 'slack':
            url: str = config_schema['webhook'][platform]
            body: dict = {
                'Suite_name': testSuiteName,
                'Test_by': config_schema['user'],
                'Pass': testPass,
                'Fail': testFail,
                'Skip': testSkip
            }
        else:
            url = None
            body = None
        schema: dict = {
            'url': url,
            'header': header,
            'body': body,
            'proxy': proxy
        }
        return schema
    
    
    def set_test_suite_name(self) -> str:
        suiteName: str = robotBuiltin.get_variable_value('$SUITE_NAME')
        suiteName: list = suiteName.split('.')
        return suiteName[-1]
    
    