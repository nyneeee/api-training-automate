# python -m unittest -v tests/test_BuildingJSON.py

import unittest
from robotframework_readoutput import BuildingJSON as builder_json


class TestBuildingJSON(unittest.TestCase):
    def setUp(self) -> None:
        self.exporter = builder_json.exportJson()

    def test_export_json(self):
        self.exporter.exportJson()


if __name__=='__main__':
    unittest.main()
