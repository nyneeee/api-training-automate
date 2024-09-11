# python -m unittest tests\test_robotframework_readoutputxml.py

import unittest
from robotframework_readoutputxml import new_ReaderRobotFramework as ReaderXml

xml_file_test: str = 'C:\\Users\\\mc\\Script\\test\\output.xml'

class TestNumber(unittest.TestCase):
    def test_setup(self):
        reader = ReaderXml.ReaderRobotFramework(xml_file_test)
        self.assertEqual(reader.xml_file, xml_file_test)
        self.assertEqual(reader.keyword_ignore, [])
        self.assertEqual(reader.main_suite_xpath, './suite')

    def test_setup_another_suite_level(self):
        reader = ReaderXml.ReaderRobotFramework(xml_file_test, './suite/suite')
        self.assertEqual(reader.xml_file, xml_file_test)
        self.assertEqual(reader.keyword_ignore, [])
        self.assertEqual(reader.main_suite_xpath, './suite/suite')

    def test_setup_keyword_ignore(self):
        reader = ReaderXml.ReaderRobotFramework(xml_file_test, keyword_regex_ignore=['Teardown', 'Run Keyword And Ignore Error'])
        self.assertEqual(reader.xml_file, xml_file_test)
        self.assertEqual(reader.keyword_ignore, ['Teardown', 'Run Keyword And Ignore Error'])
        self.assertEqual(reader.main_suite_xpath, './suite')

    def test_get_robot_output_result(self):
        reader = ReaderXml.ReaderRobotFramework(xml_file_test, keyword_regex_ignore=['Teardown', 'Run Keyword And Ignore Error'])
        result: dict = reader.get_robot_output_result()
        print(result)

if __name__ == '__main__':
    unittest.main()
