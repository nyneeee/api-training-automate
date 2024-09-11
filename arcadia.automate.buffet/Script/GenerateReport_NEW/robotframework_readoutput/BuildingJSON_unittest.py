import unittest
import os
from BuildingJSON import exportJson

class unitTesting(unittest.TestCase):
    def setUp(self):
        self.exportJson = exportJson()
    
    def tearDown(self) -> None:
        try:
            os.remove(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'JsonData.json'))
        except Exception:
            pass
        try:
            os.remove(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'DataJson.json'))
        except Exception:
            pass
        
    def test_exportJson_dict(self):
        self.assertNoLogs(self.exportJson.exportJson(dict()))
    
    def test_exportJson_list(self):
        self.assertNoLogs(self.exportJson.exportJson(list()))
    
    def test_exportJson_missing_argument(self):
        with self.assertRaises(TypeError):
            self.exportJson.exportJson()
        
    def test_exportJson_different_json_name(self):
        self.exportJson.exportJson(dict(), 'DataJson')
        self.assertTrue(os.path.exists('DataJson.json'))
    
if __name__ == '__main__':
    unittest.main()