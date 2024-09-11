import pandas as pd
from styleframe import StyleFrame, Styler, utils
from dotmap import DotMap
from ReadingXML import readingXmlOutput


class exportedExcel:
    def __init__(self, xmlFileName:str, reportName:str) -> None:
        self.xmlFileName = str(xmlFileName)
        self.PATH_OUTPUT_REPORT = str(reportName)
        self.REPORT_COLUMN = [
            'Test Case Name',
            'Objective',
            'Test Data',
            'Prerequisite Steps',
            'Test Steps',
            'Expectation',
            'Status',
            'Error Message',
        ]
    
    

    def setDefaultExcelStyle(self) -> Styler:
        default_style = Styler(
            horizontal_alignment='left',
            vertical_alignment='top',
            # bg_color=light_cyan_color,
            font=utils.fonts.calibri,
            font_size=13,
            wrap_text=True
            )
        return default_style



    def splitListToString(self, value:list or str) -> str or None:
        if type(value) != type(list()) or value is None:
            return value
        else:
            txt = str('\n'.join(value))
            return txt



    def generateExcelReport(self):
        jsonData:DotMap = DotMap(readingXmlOutput(self.xmlFileName).getTestResult())
        # jsonData:DotMap = DotMap(json.load(open('JsonData.json', encoding='UTF-8')))
        suiteName:list = jsonData.keys()
        # data_index:list = list()
        # print(self.PATH_OUTPUT_REPORT)
        excel_writer = StyleFrame.ExcelWriter(self.PATH_OUTPUT_REPORT)
        for suite_name in suiteName:
            data:list = list()
            for index in range(len(jsonData[suite_name])):
                test_data = list()
                test_data.append(self.splitListToString(jsonData[suite_name][index].name))
                test_data.append(self.splitListToString(jsonData[suite_name][index].objective))
                test_data.append(self.splitListToString(jsonData[suite_name][index].test_data))
                test_data.append(self.splitListToString(jsonData[suite_name][index].prerequisite_steps))
                test_data.append(self.splitListToString(jsonData[suite_name][index].test_steps))
                test_data.append(self.splitListToString(jsonData[suite_name][index].test_expected))
                test_data.append(self.splitListToString(jsonData[suite_name][index].status))
                test_data.append(self.splitListToString(jsonData[suite_name][index].error_message))
                # data_index.append(index)
                data.append(test_data)
            data_frame = pd.DataFrame(
                list(data),
                columns=self.REPORT_COLUMN
            )
            style_frame = StyleFrame(data_frame, styler_obj=self.setDefaultExcelStyle())
            style_frame.apply_column_style(styler_obj=self.setDefaultExcelStyle(), cols_to_style='Test Case Name', width=30)
            style_frame.apply_column_style(styler_obj=self.setDefaultExcelStyle(), cols_to_style='Objective', width=30)
            style_frame.apply_column_style(styler_obj=self.setDefaultExcelStyle(), cols_to_style='Test Data', width=30)
            style_frame.apply_column_style(styler_obj=self.setDefaultExcelStyle(), cols_to_style='Prerequisite Steps', width=50)
            style_frame.apply_column_style(styler_obj=self.setDefaultExcelStyle(), cols_to_style='Test Steps', width=50)
            style_frame.apply_column_style(styler_obj=self.setDefaultExcelStyle(), cols_to_style='Expectation', width=50)
            style_frame.apply_column_style(styler_obj=Styler(horizontal_alignment='center'), cols_to_style='Status', width=10)
            style_frame.apply_column_style(styler_obj=self.setDefaultExcelStyle(), cols_to_style='Error Message', width=40)
            style_frame.to_excel(excel_writer, sheet_name=suite_name, columns_and_rows_to_freeze='A2')
            excel_writer.save()



if __name__ == '__main__':
    exportedExcel('output.xml', 'Report.xlsx').generateExcelReport()
