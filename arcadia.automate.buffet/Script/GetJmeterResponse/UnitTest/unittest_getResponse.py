import unittest, os, html
import sys, os
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../'))
from getResponse import readingXmlOutput

class unitTesting(unittest.TestCase):
    def setUp(self):
        self.readingXmlOutput = readingXmlOutput()
        self.error_xml_path: str = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data', 'Error_Data.xml')
        
    def tearDown(self):
        result_file_name: list = list(['JsonData-Dict.json', 'JsonData.json', 'JsonData-list.json', 'Response-1.csv'])
        for file in result_file_name:
            file_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), file)
            if os.path.exists(file_path):
                os.remove(file_path)
                break
            else:
                pass

    def test_getResponseData(self):
        self.assertEqual(type(self.readingXmlOutput.getResponseData()), list)
        
    def test_getResponseData_false_xml(self):
        false_xml_path:  str = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data', 'False_Data.xml')
        data_false = readingXmlOutput(false_xml_path)
        with self.assertRaises(AttributeError):
            data_false.getResponseData()
        
    def test_getResponseData_empty_xml(self):
        empty_xml_path: str = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data', 'Empty_Data.xml')
        data_empty = readingXmlOutput(empty_xml_path)
        with self.assertRaisesRegex(ValueError, "XML file cannot be empty"):
            data_empty.getResponseData()
        
    def test_getResponseData_error_xml(self):
        data_error = readingXmlOutput(self.error_xml_path)
        self.assertEqual(type(data_error.getResponseData()), list)
        
    def test_exportJson_dict(self):
        lst: list = self.readingXmlOutput.getResponseData()
        dic: dict = {'data':lst}
        self.readingXmlOutput.exportJson(dic, 'JsonData-Dict')
        os.path.exists('JsonData-Dict.json')
        self.assertTrue(os.path.exists('JsonData-Dict.json'))
        
    def test_exportJson_list(self):
        lst: list = self.readingXmlOutput.getResponseData()
        self.readingXmlOutput.exportJson(lst, 'JsonData-list')
        os.path.exists('JsonData-list.json')
        self.assertTrue(os.path.exists('JsonData-list.json'))
        
    def test_exportJson(self):
        lst: list = self.readingXmlOutput.getResponseData()
        self.readingXmlOutput.exportJson(lst)
        os.path.exists('JsonData.json')
        self.assertTrue(os.path.exists('JsonData.json'))
    
    def test_exportJson_miss_argument(self):
        self.readingXmlOutput.exportJson()
        self.assertTrue(os.path.exists('JsonData.json'))
        
    def test_exportCsv(self):
        self.readingXmlOutput.getResponseData()
        self.assertNoLogs(self.readingXmlOutput.exportCSV())
    
    def test_exportCsv_with_error(self):
        data_error = readingXmlOutput(self.error_xml_path)
        data_error.getResponseData()
        self.assertNoLogs(data_error.exportCSV())
    
    def test_exportCsv_with_HTTP_error(self):
        xml_http_error: str = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data', 'HTTP_Error_Data.xml')
        http_data_error = readingXmlOutput(xml_http_error)
        http_data_error.getResponseData()
        self.assertNoLogs(http_data_error.exportCSV())
    
    def test_removeNewLineFromString(self):
        html_error_str: str = html.unescape("&lt;html&gt;&#xd;&lt;head&gt;&lt;title&gt;504 Gateway Time-out&lt;/title&gt;&lt;/head&gt;&#xd;&lt;body&gt;&#xd;&lt;center&gt;&lt;h1&gt;504 Gateway Time-out&lt;/h1&gt;&lt;/center&gt;&#xd;&lt;hr&gt;&lt;center&gt;nginx&lt;/center&gt;&#xd;&lt;/body&gt;&#xd;ar&lt;/html&gt;&#xd;")
        expect_str: str = "<html><head><title>504 Gateway Time-out</title></head><body><center><h1>504 Gateway Time-out</h1></center><hr><center>nginx</center></body>ar</html>"
        self.assertEqual(self.readingXmlOutput.removeNewLineFromString(data_str=html_error_str), str(expect_str))
        
if __name__ == '__main__':
    unittest.main()
    