import xml.etree.ElementTree as ET
import html
import json, csv
import sys, os


xml_file_name = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'UnitTest', 'Data', 'True_Data.xml')
csv_file_name = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'UnitTest', 'Response-1.csv')


class readingXmlOutput:
    def __init__(self, unit_test_data=None) -> None:
        if unit_test_data != None:
            xml_data:ET.XML = ET.parse(str(unit_test_data))
        else:
            xml_data:ET.XML = ET.parse(str(xml_file_name))
        self.xml_http_request:ET.XML = xml_data.findall('./httpSample')
        self.response_data: list = list()

    def getResponseData(self) -> list:
        for element in list(self.xml_http_request):
            data_xml: str = html.unescape(element.find('./responseData').text)
            try:
                data: json = json.loads(data_xml)
            except json.decoder.JSONDecodeError:
                data_xml: str = self.removeNewLineFromString(data_xml)
                data: dict = {'respCode': data_xml}
            self.response_data.append(data)
        if not self.response_data:
            raise ValueError('XML file cannot be empty')
        else:
            return self.response_data
        
    def removeNewLineFromString(self, data_str: str) -> str:
        return data_str.replace('\n\t', '').replace('\n', '').replace('\r', '')

    def exportCSV(self) -> csv:
        if not self.response_data:
            raise ValueError('XML file cannot be empty')

        with open(csv_file_name, 'w', newline='') as file:
            writer = csv.writer(file)
            for row in self.response_data:
                if isinstance(row, dict):
                    writer.writerow(row.values())
                else:
                    writer.writerow([row])

    def exportJson(self, testData=None, fileName:str='JsonData') -> json:
        import json
        if not testData:
            testData: dict = dict({'data': self.response_data})
        jsonObject: json = json.dumps(testData, indent=4)
        with open(fileName + '.json', 'w') as outfile:
            outfile.write(jsonObject)


if __name__ == '__main__':
    try:
        xml_file_name = sys.argv[1]
        csv_file_name = sys.argv[2]
    except IndexError:
        print('Please input required value "<input_name.xml>" and "<output_name.csv>"' + '\n' +
            'Example command: python3 getResponse.py <input.xml> <output.csv>')
        exit()
    response = readingXmlOutput()
    response.getResponseData()
    # response.exportJson()
    response.exportCSV()
    