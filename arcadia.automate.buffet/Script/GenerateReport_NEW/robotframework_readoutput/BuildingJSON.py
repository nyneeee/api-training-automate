import json
from ReadingXML import readingXmlOutput



class exportJson:
    def __init__(self) -> None:
        pass
    

    
    def exportJson(self, testData:dict, fileName:str='JsonData'):
        jsonObject = json.dumps(testData, indent=4)
        with open(fileName + '.json', 'w') as outfile:
            outfile.write(jsonObject)
     
        
        
if __name__ == "__main__":
    testData:dict = readingXmlOutput('output.xml').getTestResult()
    exportJson().exportJson(testData, 'JsonData')        