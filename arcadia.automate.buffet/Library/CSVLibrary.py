from robot.api.deco import keyword
import csv
import json

class CSVLibrary:
    
    ROBOT_LIBRARY_SCOPE = 'TEST'
    ROBOT_LIBRARY_VERSION = '1.0.0'
    
    def __init__(self) -> None:
        pass
    
    @keyword("Read CSV File")
    def readCSV(self, full_path: str, delimiter: str=',', encoding: str='utf-8') -> list:
        """
        Import the CSV file to list variable the header of table will be the key of dictionary
        and the value index will be the index of list data
        === CSV example data ===
        | *CarModelCode* | *CarModelName* | *SubModelCode* | *SubModelName* |
        | ALFA01AA | VIGO | 147 2.0 01AA | Hatch 2dr SA 5sp FWD 2.0i (CBU) |
        | ALFA01AB | ALTIS | 156 2.0 01AB | Sedan 4dr Mac 5sp FWD 2.0i (CBU) |
        === Usage is: ===
        | ${csv_file_full_path} | Join Path | ${CURDIR} | ./test_data.csv |
        | @{csv_data} | Read CSV File | ${csv_file_full_path} |
        | ${variable_1} | Set Variable | ${csv_data}[0][CarModelName] |
        | ${variable_2} | Set Variable | ${csv_data}[1][SubModelCode] |
        === Output result: ===
        ${variable_1}: VIGO \n
        ${variable_2}: 156 2.0 01AB
        """
        data_list = list()
        with open(full_path, 'r', encoding=encoding) as csv_file:
            csv_reader = csv.DictReader(csv_file, delimiter=delimiter)
            for row in csv_reader:
                data_list.append(row)
        return data_list
    
    @keyword("Write CSV File")
    def writeCSV(self, data: list, full_path: str, delimiter: str=',', encoding: str='utf-8') -> csv:
        """
        Export the CSV file from list variable the header of table must be the key of first dictionary
        and the index of list will be the row of data in CSV file
        === Example of List data ===
        | [
        |     {
        |         "CarModelCode": "ALFA01AA",
        |         "CarModelName": "VIGO",
        |         "SubModelCode": "147 2.0 01AA",
        |         "SubModelName": "Hatch 2dr SA 5sp FWD 2.0i (CBU)"
        |     },
        |     {
        |         "CarModelCode": "ALFA01AB",
        |         "CarModelName": "ALTIS",
        |         "SubModelCode": "156 2.0 01AB",
        |         "SubModelName": "Sedan 4dr Mac 5sp FWD 2.0i (CBU)"
        |     }
        | ]
        === Usage is: ===
        | ${csv_file_full_path} | *Join Path* | ${CURDIR} | ./test_data.csv |
        | *Write CSV File* | ${list_data} | ${csv_file_full_path} |
        === Output result: test_data.csv file ===
        | *CarModelCode* | *CarModelName* | *SubModelCode* | *SubModelName* |
        | ALFA01AA | VIGO | 147 2.0 01AA | Hatch 2dr SA 5sp FWD 2.0i (CBU) |
        | ALFA01AB | ALTIS | 156 2.0 01AB | Sedan 4dr Mac 5sp FWD 2.0i (CBU) |
        """
        with open(full_path, 'w', newline='', encoding=encoding) as csv_file:
            fieldnames = data[0].keys()
            writer = csv.DictWriter(csv_file, fieldnames=fieldnames, delimiter=delimiter)
            writer.writeheader()
            for dict in data:
                writer.writerow(dict)
    