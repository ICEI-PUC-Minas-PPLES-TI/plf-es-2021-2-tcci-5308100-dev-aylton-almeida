from base64 import b64encode
from io import BytesIO

import xlsxwriter


def build_xlsx(headers: list[str], columns: dict[str, list[str]]) -> str:
    """Builds xlsx out of given header and columns

        Returns
          str: xlsx encoded in base64
    """

    # Create an in memory workbook and 1 worksheet
    output = BytesIO()
    workbook = xlsxwriter.Workbook(output, {'in_memory': True})
    worksheet = workbook.add_worksheet()

    # Iterate over the data and write it out row by row.
    for index, header in enumerate(headers):
        worksheet.write(0, index, header)
        worksheet.write_column(1, index, [item[header] for item in columns])

    # Close the workbook and output the Excel file.
    workbook.close()

    b64_output = b64encode(output.getvalue()).decode('utf-8')

    encoded_xlsx = f'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;base64,{b64_output}'

    return encoded_xlsx
