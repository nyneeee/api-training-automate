import unittest
import json
import sys, os
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../'))
from CSVLibrary import CSVLibrary

class unitTesting(unittest.TestCase):
    def setUp(self) -> None:
        self.CSVLibrary = CSVLibrary()

    def tearDown(self):
        result_file_name: list = list(['export1.csv', 'export2.csv', 'export3.csv'])
        for file in result_file_name:
            file_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/'+str(file))
            if os.path.exists(file_path):
                os.remove(file_path)
                break
            else:
                pass
    
    def test_readCSV(self):
        path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/readCSV_data1.csv')
        expect_result: list = [{'CarModelCode': 'ALFA01AA', 'CarModelName': 'VIGO', 'SubModelCode': '147 2.0 01AA', 'SubModelName': 'Hatch 2dr SA 5sp FWD 2.0i (CBU)'}, {'CarModelCode': 'ALFA01AB', 'CarModelName': 'ALTIS', 'SubModelCode': '156 2.0 01AB', 'SubModelName': 'Sedan 4dr Mac 5sp FWD 2.0i (CBU)'}, {'CarModelCode': 'ALFA01AC', 'CarModelName': '156', 'SubModelCode': '156 2.0 01AC', 'SubModelName': 'Wagon 4dr Sport Mac 5sp FWD 2.0i (CBU)'}, {'CarModelCode': 'ALFA01AD', 'CarModelName': '166', 'SubModelCode': '166 3.0 01AD', 'SubModelName': 'Sedan 4dr SA 4sp FWD 3.0i (CBU)'}, {'CarModelCode': 'HOND00BD', 'CarModelName': 'CIVIC', 'SubModelCode': 'CIVIC 1.6 00BD', 'SubModelName': 'EK Sedan 4dr VTi Man 5sp FWD 1.6i'}, {'CarModelCode': 'HOND00BG', 'CarModelName': 'CR-V', 'SubModelCode': 'CR-V 2.0 00BG', 'SubModelName': 'RD Wagon 4dr EXi Auto 4sp 4WD 2.0i'}, {'CarModelCode': 'HOND00BM', 'CarModelName': 'S2000', 'SubModelCode': 'S2000 2.0 00BM', 'SubModelName': 'Convert. 2dr Man 6sp RWD 2.0i (CBU)'}, {'CarModelCode': 'HOND96AU', 'CarModelName': 'TOURMA', 'SubModelCode': 'TOURMA 2.5 96AU', 'SubModelName': 'Pickup 2dr Ext. Cab LX Man 5sp RWD 2.5D'}]
        self.assertEqual(self.CSVLibrary.readCSV(path), expect_result)
    
    def test_readCSV_with_semicolon(self):
        path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/readCSV_data2.csv')
        expect_result: list = [{'CarModelCode': 'ALFA01AA', 'CarModelName': 'VIGO', 'SubModelCode': '147 2.0 01AA', 'SubModelName': 'Hatch 2dr SA 5sp FWD 2.0i (CBU)'}, {'CarModelCode': 'ALFA01AB', 'CarModelName': 'ALTIS', 'SubModelCode': '156 2.0 01AB', 'SubModelName': 'Sedan 4dr Mac 5sp FWD 2.0i (CBU)'}, {'CarModelCode': 'ALFA01AC', 'CarModelName': '156', 'SubModelCode': '156 2.0 01AC', 'SubModelName': 'Wagon 4dr Sport Mac 5sp FWD 2.0i (CBU)'}, {'CarModelCode': 'ALFA01AD', 'CarModelName': '166', 'SubModelCode': '166 3.0 01AD', 'SubModelName': 'Sedan 4dr SA 4sp FWD 3.0i (CBU)'}, {'CarModelCode': 'HOND00BD', 'CarModelName': 'CIVIC', 'SubModelCode': 'CIVIC 1.6 00BD', 'SubModelName': 'EK Sedan 4dr VTi Man 5sp FWD 1.6i'}, {'CarModelCode': 'HOND00BG', 'CarModelName': 'CR-V', 'SubModelCode': 'CR-V 2.0 00BG', 'SubModelName': 'RD Wagon 4dr EXi Auto 4sp 4WD 2.0i'}, {'CarModelCode': 'HOND00BM', 'CarModelName': 'S2000', 'SubModelCode': 'S2000 2.0 00BM', 'SubModelName': 'Convert. 2dr Man 6sp RWD 2.0i (CBU)'}, {'CarModelCode': 'HOND96AU', 'CarModelName': 'TOURMA', 'SubModelCode': 'TOURMA 2.5 96AU', 'SubModelName': 'Pickup 2dr Ext. Cab LX Man 5sp RWD 2.5D'}]
        self.assertEqual(self.CSVLibrary.readCSV(path, ';'), expect_result)
    
    def test_readCSV_with_wrong_delimiter(self):
        path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/readCSV_data2.csv')
        expect_result: list = [{'CarModelCode': 'ALFA01AA', 'CarModelName': 'VIGO', 'SubModelCode': '147 2.0 01AA', 'SubModelName': 'Hatch 2dr SA 5sp FWD 2.0i (CBU)'}, {'CarModelCode': 'ALFA01AB', 'CarModelName': 'ALTIS', 'SubModelCode': '156 2.0 01AB', 'SubModelName': 'Sedan 4dr Mac 5sp FWD 2.0i (CBU)'}, {'CarModelCode': 'ALFA01AC', 'CarModelName': '156', 'SubModelCode': '156 2.0 01AC', 'SubModelName': 'Wagon 4dr Sport Mac 5sp FWD 2.0i (CBU)'}, {'CarModelCode': 'ALFA01AD', 'CarModelName': '166', 'SubModelCode': '166 3.0 01AD', 'SubModelName': 'Sedan 4dr SA 4sp FWD 3.0i (CBU)'}, {'CarModelCode': 'HOND00BD', 'CarModelName': 'CIVIC', 'SubModelCode': 'CIVIC 1.6 00BD', 'SubModelName': 'EK Sedan 4dr VTi Man 5sp FWD 1.6i'}, {'CarModelCode': 'HOND00BG', 'CarModelName': 'CR-V', 'SubModelCode': 'CR-V 2.0 00BG', 'SubModelName': 'RD Wagon 4dr EXi Auto 4sp 4WD 2.0i'}, {'CarModelCode': 'HOND00BM', 'CarModelName': 'S2000', 'SubModelCode': 'S2000 2.0 00BM', 'SubModelName': 'Convert. 2dr Man 6sp RWD 2.0i (CBU)'}, {'CarModelCode': 'HOND96AU', 'CarModelName': 'TOURMA', 'SubModelCode': 'TOURMA 2.5 96AU', 'SubModelName': 'Pickup 2dr Ext. Cab LX Man 5sp RWD 2.5D'}]
        self.assertNotEqual(self.CSVLibrary.readCSV(path), expect_result)
    
    def test_writeCSV(self):
        json_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/writeCSV_data1.json')
        csv_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/export1.csv')
        with open(json_path, 'r') as json_file:
            dict_data: dict = json.load(json_file)
        self.assertNoLogs(self.CSVLibrary.writeCSV(data=dict_data, full_path=csv_path))
    
    def test_writeCSV_with_semicolon_delimiter(self):
        json_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/writeCSV_data1.json')
        csv_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/export1.csv')
        with open(json_path, 'r') as json_file:
            dict_data: dict = json.load(json_file)
        self.assertNoLogs(self.CSVLibrary.writeCSV(data=dict_data, full_path=csv_path, delimiter=';'))
    
    def test_writeCSV_with_missing_some_column(self):
        json_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/writeCSV_data2.json')
        csv_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/export2.csv')
        with open(json_path, 'r') as json_file:
            dict_data: dict = json.load(json_file)
        self.assertNoLogs(self.CSVLibrary.writeCSV(data=dict_data, full_path=csv_path))
    
    def test_writeCSV_with_missing_table_header(self):
        json_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/writeCSV_data3.json')
        csv_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/export3.csv')
        with open(json_path, 'r') as json_file:
            dict_data: dict = json.load(json_file)
        with self.assertRaises(ValueError):
            self.assertNoLogs(self.CSVLibrary.writeCSV(data=dict_data, full_path=csv_path))
    
    def test_writeCSV_with_missing_table_header(self):
        json_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/writeCSV_data3.json')
        csv_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'Data/export3.csv')
        with open(json_path, 'r') as json_file:
            dict_data: dict = json.load(json_file)
        with self.assertRaises(ValueError):
            self.assertNoLogs(self.CSVLibrary.writeCSV(data=dict_data, full_path=csv_path))
    