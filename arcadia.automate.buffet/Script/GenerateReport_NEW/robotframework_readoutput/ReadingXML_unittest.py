from ReadingXML import readingXmlOutput
import xml.etree.ElementTree as ET
import os
import unittest


xml_file = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'UnitTestData', 'output.xml')


class unitTesting(unittest.TestCase):
    def setUp(self) -> None:
        self.readingXmlOutput = readingXmlOutput(xml_file)
        self.xml_data:ET.XML = ET.parse(str(xml_file))
        self.suite:ET.XML = self.xml_data.findall('./suite')
        self.test_amount:ET.XML = self.suite[0].findall('./test')
        self.test_document_xml:ET.XML = self.test_amount[0].find('./doc')
        self.test_document:list = str(self.test_document_xml.text).splitlines()
    
    def test_readingXmlOutput_cannot_file_not_found(self):
        with self.assertRaisesRegex(SystemExit, 'Cannot find "output.xml" file'):
            readingXmlOutput(str())
    
    def test_getTestName(self):
        self.assertEqual(self.readingXmlOutput.getTestName(self.test_amount[0]), 'Test_1_001')
    
    def test_getTestName_wrong_data(self):
        with self.assertRaises(AttributeError):
            self.readingXmlOutput.getTestName(str())
    
    def test_getTestTags(self):
        self.assertListEqual(self.readingXmlOutput.getTestTags(self.test_amount[0]), list(['ManualTest','On-Hold','tags']))
    
    def test_getTestTags_wrong_data(self):
        with self.assertRaises(AttributeError):
            self.readingXmlOutput.getTestTags(str())

    def test_getTestStatus(self):
        self.assertEqual(self.readingXmlOutput.getTestStatus(self.test_amount[0]), 'PASS')
    
    def test_getTestStatus_wrong_data(self):
        with self.assertRaises(AttributeError):
            self.readingXmlOutput.getTestStatus(str())
    
    def test_getTestMessage(self):
        self.assertEqual(self.readingXmlOutput.getTestMessage(self.test_amount[0]), 'Do a manual testing')
    
    def test_getTestMessage_wrong_data(self):
        with self.assertRaises(AttributeError):
            self.readingXmlOutput.getTestMessage(str())
    
    def test_getTestData(self):
        self.assertEqual(self.readingXmlOutput.getTestData(self.test_document, 1), list(['1. Objective', '2. Objective', '3. Objective']))
    
    def test_getTestData_no_index(self):
        self.assertEqual(self.readingXmlOutput.getTestData(self.test_document), None)
    
    def test_getTopicIndex(self):
        self.assertDictEqual(self.readingXmlOutput.getTopicIndex(self.test_document), 
            dict({
                'expect': 21,
                'test_data': 6,
                'test_steps': 16,
                'objective': 1,
                'prerequisite_steps': 11
            })
        )
    
    def test_getTopicIndex_empty_list(self):
        self.assertDictEqual(self.readingXmlOutput.getTopicIndex(list()), 
            dict({
                'expect': None,
                'test_data': None,
                'test_steps': None,
                'objective': None,
                'prerequisite_steps': None
            })
        )
    
    def test_getTopicIndex_wrong_data(self):
        with self.assertRaisesRegex(ValueError, 'Argument should be list'):
            self.readingXmlOutput.getTopicIndex(str())

    def test_getTestResult(self):
        self.assertEqual(type(self.readingXmlOutput.getTestResult()), dict)


if __name__ == '__main__':
    unittest.main()