import xml.etree.ElementTree as ET
import re



class readingXmlOutput_Legacy:
    def __init__(self, xml_file:str) -> None:
        try:
            xml_data:ET.XML = ET.parse(str(xml_file))
            self.suite:ET.XML = xml_data.findall('./suite')
        except FileNotFoundError:
            print('Cannot find "output.xml" file')
            exit()
        
    
    
    def getTestName(self, data:ET.XML) -> str:
        # print(data.get('name'))
        return data.get('name')



    def getTestMessage(self, data:ET.XML) -> str:
        # print(data.find('./status').text)
        return data.find('./status').text
    
    
    
    def getTestStatus(self, data:ET.XML) -> str:
        '''Getting Test Status result'''
        # print(data.find('./status').get('status'))
        return data.find('./status').get('status')



    def getTestTags(self, data:ET.XML) -> list:
        tags:ET.XML = data.findall('./tag')
        test_tags:list = list()
        for tag in tags:
            test_tags.append(tag.text)
        
        return test_tags
    
    
    
    # def getTestObjective(self, data:ET.XML) -> list:
    #     test_document_data:ET.XML = data.find('./doc')
    #     if test_document_data != None and re.search('[*]{3} Objective [*]{3}', str(test_document_data.text)):
    #         test_document:list = str(test_document_data.text).splitlines()
    #         objective:list = list()
    #         for index in range(len(test_document)):
    #             if re.match('[*]{3} Objective [*]{3}', str(test_document[index])):
    #                 for objective_index in range(index + 1, len(test_document)):
    #                     if '==>' in test_document[objective_index] or re.match('[*]{3} .* [*]{3}', str(test_document[objective_index])):
    #                         break
    #                     else:
    #                         objective.append(test_document[objective_index])
    #             else:
    #                 continue
    #     else:
    #         objective = None
       
    #     return objective



    # def getTestSteps(self, data:ET.XML) -> list:
    #     test_document_data:ET.XML = data.find('./doc')
    #     if (test_document_data != None) and (re.search('[*]{3} Test Steps [*]{3}', str(test_document_data.text))):
    #         test_document:list = str(test_document_data.text).splitlines()
    #         test_step:list = list()
    #         for index in range(len(test_document)):
    #             if re.match('[*]{3} Test Steps [*]{3}', str(test_document[index])):
    #                 for test_step_index in range(index + 1, len(test_document)):
    #                     if '==>' in test_document[test_step_index] or re.search('[*]{3} .* [*]{3}', str(test_document[test_step_index])):
    #                         break
    #                     else:
    #                         test_step.append(test_document[test_step_index])
    #             else:
    #                 continue
    #     else:
    #         test_step = None
        
    #     return test_step
        


    # def getTestData(self, data:ET.XML) -> list:
    #     test_document_data:ET.XML = data.find('./doc')
    #     if (test_document_data != None) and (re.search('[*]{3} Test Data [*]{3}', str(test_document_data.text))):
    #         test_document:list = str(test_document_data.text).splitlines()
    #         test_data:list = list()
    #         for index in range(len(test_document)):
    #             if re.search('[*]{3} Test Data [*]{3}', str(test_document[index])):
    #                 for test_data_index in range(int(index) + 1, len(test_document)):
    #                     if '==>' in test_document[test_data_index] or re.match('[*]{3} .* [*]{3}', str(test_document[test_data_index])):
    #                         break
    #                     else:
    #                         test_data.append(test_document[test_data_index])
    #             else:
    #                 continue
    #     else:
    #         test_data = None
        
    #     return test_data
        
        
        
    # def getTestExpected(self, data:ET.XML) -> list:
    #     test_document_data:ET.XML = data.find('./doc')
    #     if (test_document_data != None) and (re.search('[*]{3} Expect Result [*]{3}', str(test_document_data.text))):
    #         test_document:list = str(test_document_data.text).splitlines()
    #         test_expected:list = list()
    #         for index in range(len(test_document)):
    #             if re.search('[*]{3} Expect Result [*]{3}', str(test_document[index])):
    #                 for test_expected_index in range(int(index) + 1, len(test_document)):
    #                     if '==>' in test_document[test_expected_index] or re.search('[*]{3} .+ [*]{3}', str(test_document[test_expected_index])):
    #                         break
    #                     else:
    #                         test_expected.append(test_document[test_expected_index])
    #             else:
    #                 continue
    #     else:
    #         test_expected = None
        
    #     return test_expected
    
    
    
    # def getPrerequisiteSteps(self, data:ET.XML) -> list:
    #     test_document_data:ET.XML = data.find('./doc')
    #     if (test_document_data != None) and (re.search('[*]{3} Test Steps [*]{3}', str(test_document_data.text))):
    #         test_document:list = str(test_document_data.text).splitlines()
    #         prerequisite_steps:list = list()
    #         for index in range(len(test_document)):
    #             if re.match('[*]{3} Test Steps [*]{3}', str(test_document[index])):
    #                 for test_step_index in range(index + 1, len(test_document)):
    #                     if '==>' in test_document[test_step_index] or re.search('[*]{3} .* [*]{3}', str(test_document[test_step_index])):
    #                         break
    #                     else:
    #                         prerequisite_steps.append(test_document[test_step_index])
    #             else:
    #                 continue
    #     else:
    #         prerequisite_steps = None
        
    #     return prerequisite_steps
    
    
    
    def getTestResult(self, suite_data=None, data:dict=dict()) -> dict:
        '''Getting All test result as dictionary'''
        if suite_data is None:
            suite_data = self.suite
        for suite_name in suite_data:
            if len(suite_name.findall('./suite')) > 0:
                data:dict = self.getTestResult(suite_name.findall('./suite'), data)
            
            else:
                test_amount:ET.XML = suite_name.findall('./test')
                test_result:list = list()
                for data_index in test_amount:
                    test_document_xml:ET.XML = data_index.find('./doc')
                    dict_test_result:dict = {
                        'name' : self.getTestName(data_index),
                        'tag' : self.getTestTags(data_index),
                        'status' : self.getTestStatus(data_index),
                        'error_message' : self.getTestMessage(data_index),
                        'objective' : None,
                        'test_data' : None,
                        'test_steps' : None,
                        'test_expected' : None,
                        'prerequisite_steps' : None,
                    }
                
                # Check test document contain *** .+ *** format
                    if (test_document_xml != None) and (re.search('[*]{3} .+ [*]{3}', str(test_document_xml.text))):
                        test_document:list = str(test_document_xml.text).splitlines()
                        document_range = len(test_document)
                    
                    # Get Manual test document
                        for index in range(document_range):
                        
                        # Check Contain *** Expected Result *** 
                            if re.search('[*]{3} Expect Result [*]{3}', str(test_document[index])):
                                test_expected:list = list()
                                for test_expected_index in range(int(index) + 1, int(document_range)):
                                    if '==>' in test_document[test_expected_index] or re.search('[*]{3} .+ [*]{3}', str(test_document[test_expected_index])):
                                        break
                                    else:
                                        test_expected.append(test_document[test_expected_index])
                                dict_test_result.update({'test_expected': test_expected})
                        
                        # Check Contain *** Test Data ***
                            elif re.search('[*]{3} Test Data [*]{3}', str(test_document[index])):
                                test_data:list = list()
                                for test_data_index in range(int(index) + 1, int(document_range)):
                                    if '==>' in test_document[test_data_index] or re.match('[*]{3} .* [*]{3}', str(test_document[test_data_index])):
                                        break
                                    else:
                                        test_data.append(test_document[test_data_index])
                                dict_test_result.update({'test_data': test_data})
                        
                        # Check Contain *** Test Steps ***
                            elif re.search('[*]{3} Test Steps [*]{3}', str(test_document[index])):
                                test_steps:list = list()
                                for test_step_index in range(int(index) + 1, int(document_range)):
                                    if '==>' in test_document[test_step_index] or re.match('[*]{3} .* [*]{3}', str(test_document[test_step_index])):
                                        break
                                    else:
                                        test_steps.append(test_document[test_step_index])
                                dict_test_result.update({'test_steps': test_steps})
                        
                        # Check Contain *** Objective ***
                            elif re.search('[*]{3} Objective [*]{3}', str(test_document[index])):
                                test_objective:list = list()
                                for test_objective_index in range(int(index) + 1, int(document_range)):
                                    if '==>' in test_document[test_objective_index] or re.match('[*]{3} .* [*]{3}', str(test_document[test_objective_index])):
                                        break
                                    else:
                                        test_objective.append(test_document[test_objective_index])
                                    dict_test_result.update({'objective': test_objective})
                        
                        # Check Contain *** Prerequisite Steps ***
                            elif re.search('[*]{3} Prerequisite Steps [*]{3}', str(test_document[index])):
                                test_prerequisite_steps:list = list()
                                for test_prerequisite_index in range(int(index) + 1, int(document_range)):
                                    if '==>' in test_document[test_prerequisite_index] or re.match('[*]{3} .* [*]{3}', str(test_document[test_objective_index])):
                                        break
                                    else:
                                        test_prerequisite_steps.append(test_document[test_prerequisite_index])
                                    dict_test_result.update({'prerequisite_steps': test_prerequisite_steps})
                                    
                        test_result.append(dict_test_result)
                    else:
                        test_result.append(dict_test_result)
                        continue
                data.update({str(suite_name.get('name')) : test_result})
                    # dict_test_result:dict = {
                    #     'name' : self.getTestName(data_index),
                    #     'tag' : self.getTestTags(data_index),
                    #     'status' : self.getTestStatus(data_index),
                    #     'error_message' : self.getTestMessage(data_index),
                    #     'objective' : self.getTestObjective(data_index),
                    #     'test_data' : self.getTestData(data_index),
                    #     'test_steps' : self.getTestSteps(data_index),
                    #     'test_expected' : self.getTestExpected(data_index)
                    # }
        
        return data




class readingXmlOutput:
    def __init__(self, xml_file:str) -> None:
        try:
            xml_data:ET.XML = ET.parse(str(xml_file))
            self.suite:ET.XML = xml_data.findall('./suite')
        except FileNotFoundError:
            exit('Cannot find "output.xml" file')



    def getTestName(self, data:ET.XML) -> str:
        return data.get('name')



    def getTestMessage(self, data:ET.XML) -> str:
        return data.find('./status').text



    def getTestStatus(self, data:ET.XML) -> str:
        '''Getting Test Status result'''
        return data.find('./status').get('status')



    def getTestTags(self, data:ET.XML) -> list:
        tags:ET.XML = data.findall('./tag')
        test_tags:list = list()
        for tag in tags:
            test_tags.append(tag.text)
        return test_tags



    def getTestData(self, data:list, index:int=None) -> list:
        if index == None:
            return None
        else:
            index += 1
            test_expected:list = list()
            while True:
                if '==>' in data[index] or re.search('[*]{3} .+ [*]{3}', str(data[index])):
                    break
                else:
                    test_expected.append(data[index])
                    index += 1
            return test_expected



    def getTopicIndex(self, test_document:list) -> dict:
        if type(test_document) != list:
            raise ValueError('Argument should be list')
        else:
            topic_index = {
                'expect': None,
                'test_data': None,
                'test_steps': None,
                'objective': None,
                'prerequisite_steps': None
            }
            for index, doc in enumerate(test_document):
                if re.search('[*]{3} Expect Result [*]{3}', doc):
                    topic_index.update({'expect': index})
                elif re.search('[*]{3} Test Data [*]{3}', doc):
                    topic_index.update({'test_data': index})
                elif re.search('[*]{3} Test Steps [*]{3}', doc):
                    topic_index.update({'test_steps': index})
                elif re.search('[*]{3} Objective [*]{3}', doc):
                    topic_index.update({'objective': index})
                elif re.search('[*]{3} Prerequisite Steps [*]{3}', doc):
                    topic_index.update({'prerequisite_steps': index})
                else:
                    continue
            return topic_index



    def getTestResult(self, suite_data=None, data:dict=dict()) -> dict:
        '''Getting All test result as dictionary'''
        if suite_data is None:
            suite_data = self.suite
        for suite_name in suite_data:
            if len(suite_name.findall('./suite')) > 0:
                data:dict = self.getTestResult(suite_name.findall('./suite'), data)
            else:
                test_amount:ET.XML = suite_name.findall('./test')
                test_result:list = list()
                for data_index in test_amount:
                    test_document_xml:ET.XML = data_index.find('./doc')
                    test_document:list = str(test_document_xml.text).splitlines()
                    topic_index = self.getTopicIndex(test_document)
                    dict_test_result:dict = {
                        'name' : self.getTestName(data_index),
                        'tag' : self.getTestTags(data_index),
                        'status' : self.getTestStatus(data_index),
                        'error_message' : self.getTestMessage(data_index),
                        'objective' : self.getTestData(test_document, topic_index['objective']),
                        'test_data' : self.getTestData(test_document, topic_index['test_data']),
                        'test_steps' : self.getTestData(test_document, topic_index['test_steps']),
                        'test_expected' : self.getTestData(test_document, topic_index['expect']),
                        'prerequisite_steps' : self.getTestData(test_document, topic_index['prerequisite_steps']),
                    }
                    test_result.append(dict_test_result)
                data.update({str(suite_name.get('name')) : test_result})
        return data
    
    
    
    
if __name__ == "__main__":
    from BuildingJSON import *
    testData:dict = readingXmlOutput('output.xml').getTestResult()
    exportJson().exportJson(testData, 'JsonData')
    # print(testData)
