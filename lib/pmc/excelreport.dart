// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'dart:io';
import 'package:tankerpcmc/pmc/pmcservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';

class ExcelReports extends StatefulWidget {
  const ExcelReports({Key? key}) : super(key: key);

  @override
  State<ExcelReports> createState() => _ExcelReportsState();
}

class _ExcelReportsState extends State<ExcelReports> {
  List<dynamic> dataList = [];

  List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

  Future<List<ExcelDataRow>> _buildCustomersDataRowsIH1(
      List<Map<String, dynamic>> data) async {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

    excelDataRows = data.map<ExcelDataRow>((dataRow) {
      return ExcelDataRow(cells: <ExcelDataCell>[
        ExcelDataCell(
            columnHeader: 'Builder Name', value: dataRow['ni_first_name']),
        ExcelDataCell(
            columnHeader: 'Project Name', value: dataRow['ni_project_name']),
        ExcelDataCell(
            columnHeader: 'Order Count', value: dataRow['order_count']),
        ExcelDataCell(
            columnHeader: 'Total Litres Ordered',
            value: dataRow['total_liters_ordered'])
      ]);
    }).toList();

    return excelDataRows;
  }

  Future<List<ExcelDataRow>> _buildCustomersDataRowsIH2(
      List<Map<String, dynamic>> data) async {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

    excelDataRows = data.map<ExcelDataRow>((dataRow) {
      return ExcelDataRow(cells: <ExcelDataCell>[
        ExcelDataCell(
            columnHeader: 'STP Name', value: dataRow['ni_nearest_stp']),
        ExcelDataCell(
            columnHeader: 'Registered Tanker Count',
            value: dataRow['registered_tanker_count']),
      ]);
    }).toList();

    return excelDataRows;
  }

  Future<List<ExcelDataRow>> _buildCustomersDataRowsIH3(
      List<Map<String, dynamic>> data) async {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

    excelDataRows = data.map<ExcelDataRow>((dataRow) {
      return ExcelDataRow(cells: <ExcelDataCell>[
        ExcelDataCell(
            columnHeader: 'STP Name', value: dataRow['ni_nearest_stp']),
        ExcelDataCell(
            columnHeader: 'Registered Tanker Count',
            value: dataRow['registered_tanker_count']),
      ]);
    }).toList();

    return excelDataRows;
  }

  Future<List<ExcelDataRow>> _buildCustomersDataRowsIH4(
      List<Map<String, dynamic>> data) async {
    List<ExcelDataRow> excelDataRows = [];

    int liter1000Total = 0;
    int liter5000Total = 0;
    int liter7000Total = 0;
    int liter10000Total = 0;
    int liter20000Total = 0;
    int orderCountTotal = 0;
    int totalWaterCapacityTotal = 0;

    for (var row in data) {
      liter1000Total = row['count_1000_liters'];
      liter5000Total = row['count_5000_liters'];
      liter7000Total = row['count_7000_liters'];
      liter10000Total = row['count_10000_liters'];
      liter20000Total = row['count_20000_liters'];
      orderCountTotal = data[0]['todayOrdersCount'] ?? 0;
      totalWaterCapacityTotal = data[0]['today_all_total_liter'] ?? 0;

      excelDataRows.add(ExcelDataRow(cells: <ExcelDataCell>[
        ExcelDataCell(columnHeader: 'STP Name', value: row['ni_stp_name']),
        ExcelDataCell(
            columnHeader: '1000 Liter', value: row['count_1000_liters']),
        ExcelDataCell(
            columnHeader: '5000 Liter', value: row['count_5000_liters']),
        ExcelDataCell(
            columnHeader: '7000 Liter', value: row['count_7000_liters']),
        ExcelDataCell(
            columnHeader: '10000 Liter', value: row['count_10000_liters']),
        ExcelDataCell(
            columnHeader: '20000 Liter', value: row['count_20000_liters']),
        ExcelDataCell(columnHeader: 'Order Count', value: row['order_count']),
        ExcelDataCell(
            columnHeader: 'Total Water Capacity',
            value: row['total_water_capacity']),
      ]));
    }

    // Add the total row
    excelDataRows.add(ExcelDataRow(cells: <ExcelDataCell>[
      const ExcelDataCell(columnHeader: 'Total', value: ''),
      ExcelDataCell(columnHeader: liter1000Total.toString(), value: ''),
      ExcelDataCell(columnHeader: liter5000Total.toString(), value: ''),
      ExcelDataCell(columnHeader: liter7000Total.toString(), value: ''),
      ExcelDataCell(columnHeader: liter10000Total.toString(), value: ''),
      ExcelDataCell(columnHeader: liter20000Total.toString(), value: ''),
      ExcelDataCell(columnHeader: orderCountTotal.toString(), value: ''),
      ExcelDataCell(
          columnHeader: totalWaterCapacityTotal.toString(), value: ''),
    ]));

    return excelDataRows;
  }

  Future<void> importData1(List<Map<String, dynamic>> data) async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    final Future<List<ExcelDataRow>> dataRows =
        _buildCustomersDataRowsIH1(data);

    List<ExcelDataRow> dataRows_1 = await Future.value(dataRows);
    sheet.importData(dataRows_1, 1, 1);

    sheet.getRangeByName('A1:E1').autoFitColumns();

    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

    final String directory;

    if (Platform.isIOS) {
      directory = (await getApplicationSupportDirectory()).path;
      Directory directoryPath = Directory(directory);
      if (!await directoryPath.exists()) {
        await directoryPath.create(recursive: true);
      }
    } else {
      directory = '/storage/emulated/0/Download';
    }
    final File file = File(
        '$directory/Todays Orders-${DateTime.now().day.toString()}_${DateTime.now().month.toString()}_${DateTime.now().year.toString()}.xlsx');
    await file.writeAsBytes(bytes, flush: true);

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Excel File Saved'),
            content: Text(
                'The Excel file has been saved successfully at: ${file.path}'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> importData2(List<Map<String, dynamic>> data) async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    final Future<List<ExcelDataRow>> dataRows =
        _buildCustomersDataRowsIH2(data);

    List<ExcelDataRow> dataRows_1 = await Future.value(dataRows);
    sheet.importData(dataRows_1, 1, 1);

    sheet.getRangeByName('A1:E1').autoFitColumns();

    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

    final String directory;

    if (Platform.isIOS) {
      directory = (await getApplicationSupportDirectory()).path;
      Directory directoryPath = Directory(directory);
      if (!await directoryPath.exists()) {
        await directoryPath.create(recursive: true);
      }
    } else {
      directory = '/storage/emulated/0/Download';
    }
    final File file = File(
        '$directory/STP Wise All Tanker Register-${DateTime.now().day.toString()}_${DateTime.now().month.toString()}_${DateTime.now().year.toString()}.xlsx');
    await file.writeAsBytes(bytes, flush: true);

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Excel File Saved'),
            content: Text(
                'The Excel file has been saved successfully at: ${file.path}'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> importData3(List<Map<String, dynamic>> data) async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];

    final Future<List<ExcelDataRow>> dataRows =
        _buildCustomersDataRowsIH3(data);
    List<ExcelDataRow> dataRows_1 = await Future.value(dataRows);
    sheet.importData(dataRows_1, 1, 1);

    sheet.getRangeByName('A1:E1').autoFitColumns();

    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

    final String directory;

    if (Platform.isIOS) {
      directory = (await getApplicationSupportDirectory()).path;
      Directory directoryPath = Directory(directory);
      if (!await directoryPath.exists()) {
        await directoryPath.create(recursive: true);
      }
    } else {
      directory = '/storage/emulated/0/Download';
    }
    // final String path = directory.path;
    final File file = File(
        '$directory/data_${DateTime.now().day.toString()}_${DateTime.now().month.toString()}_${DateTime.now().year.toString()}.xlsx');
    await file.writeAsBytes(bytes, flush: true);

    try {
      // await csvFile.writeAsString(csvString);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Excel File Saved'),
            content: Text(
                'The Excel file has been saved successfully at: ${file.path}'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> importData4(List<Map<String, dynamic>> data) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    final Future<List<ExcelDataRow>> dataRows =
        _buildCustomersDataRowsIH4(data);
    List<ExcelDataRow> dataRowsList = await Future.value(dataRows);

    // Import the data rows
    int rowIndex = 1;
    for (var rowData in dataRowsList) {
      int columnIndex = 1;
      for (var cellData in rowData.cells) {
        sheet
            .getRangeByIndex(rowIndex, columnIndex)
            .setText(cellData.value.toString());
        columnIndex++;
      }
      rowIndex++;
    }

    // Calculate and add the totals row
    int lastRowIndex = rowIndex;
    int columnCount = 8; // Assuming 8 columns
    sheet.getRangeByIndex(lastRowIndex, 1).setText('Total');
    for (int columnIndex = 2; columnIndex <= columnCount; columnIndex++) {
      if (columnIndex == 1) {
        continue; // Skip the first column in the sum calculation
      }
      String columnName = String.fromCharCode(64 + columnIndex);
      String formula = 'SUM(${columnName}2:$columnName${lastRowIndex - 1})';
      sheet.getRangeByIndex(lastRowIndex, columnIndex).setFormula(formula);
    }

    // Auto-fit columns
    sheet.getRangeByName('A1:H$lastRowIndex').autoFitColumns();

    // Save the workbook
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Save the file and show a dialog
    final String directory = Platform.isIOS
        ? (await getApplicationSupportDirectory()).path
        : '/storage/emulated/0/Download';
    final File file = File(
        '$directory/STP wise Todays Orders-${DateTime.now().day.toString()}_${DateTime.now().month.toString()}_${DateTime.now().year.toString()}.xlsx');
    await file.writeAsBytes(bytes, flush: true);

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Excel File Saved'),
            content: Text(
                'The Excel file has been saved successfully at: ${file.path}'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    // ignore: empty_catches
    } catch (e) {}
  }

  void getApiData(String title) {
    switch (title) {
      case 'Todays Orders':
        PCMCservices.excelreport1().then((data) {
          dataList = data['data'];
          if (dataList.isNotEmpty) {
            List<Map<String, dynamic>> formattedDataList = dataList.map((item) {
              return item as Map<String, dynamic>;
            }).toList();
            importData1(formattedDataList);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('No data available.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
        break;

      case 'STP Wise All Tanker Register':
        PCMCservices.excelreport2().then((data) {
          dataList = data['results'];
          if (dataList.isNotEmpty) {
            List<Map<String, dynamic>> formattedDataList = dataList.map((item) {
              return item as Map<String, dynamic>;
            }).toList();
            importData2(formattedDataList);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('No data available.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
        break;

      case 'STP Wise Todays Tanker Register':
        PCMCservices.excelreport3().then((data) {
          dataList = data['results'];
          if (dataList.isNotEmpty) {
            List<Map<String, dynamic>> formattedDataList = dataList.map((item) {
              return item as Map<String, dynamic>;
            }).toList();
            importData3(formattedDataList);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('No data available.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
        break;

      case 'STP wise Todays Orders':
        PCMCservices.excelreport4().then((data) {
          dataList = data['reportData'];
          if (dataList.isNotEmpty) {
            List<Map<String, dynamic>> formattedDataList = dataList.map((item) {
              return item as Map<String, dynamic>;
            }).toList();
            importData4(formattedDataList);
            // int todayOrdersCount = data['todayOrdersCount'];
            // int totalWaterCapacity = data['totalWaterCapacity'];
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('No data available.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
        break;
      default:
        break;
    }
  }

  Widget buildListTile(String leadingText, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: Text(' $leadingText '),
          title: Text(title),
          trailing: TextButton(
            onPressed: () {
              Future.delayed(Duration.zero, () {
                getApiData(title);
              });
            },
            child: const Text('Generate Excel File'),
          ),
          onTap: () {
            Future.delayed(Duration.zero, () {
              getApiData(title);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          buildListTile('1', 'Todays Orders'),
          buildListTile('2', 'STP Wise All Tanker Register'),
          buildListTile('3', 'STP Wise Todays Tanker Register'),
          buildListTile('4', 'STP wise Todays Orders'),
        ],
      ),
    );
  }
}
