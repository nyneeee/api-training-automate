import xml.etree.ElementTree as ET


class ReaderRobotFramework:
    def __init__(self) -> None:
        self.robot_xml_file = ''

        
    def set_robot_xml(self, robot_xml_file: str) -> None:
        self.robot_xml_file = robot_xml_file

    
    def convert_xml_file_to_dict(self) -> dict:
        data_dict: dict = {}
        root = ET.parse(self.robot_xml_file).getroot()
        for customer in root:
            print(customer)
        return data_dict


if __name__ == "__main__":
    reader = ReaderRobotFramework()
    reader.set_robot_xml('.output.xml')
    result_dict = reader.convert_xml_file_to_dict()
    print(result_dict)
