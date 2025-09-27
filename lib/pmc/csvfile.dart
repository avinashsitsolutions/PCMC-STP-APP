import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:tankerpcmc/pmc/pmcservices.dart';
import 'package:csv/csv.dart';

class ExcelReports extends StatefulWidget {
  const ExcelReports({Key? key}) : super(key: key);

  @override
  State<ExcelReports> createState() => _ExcelReportsState();
}

class _ExcelReportsState extends State<ExcelReports> {
  List<dynamic> dataList = [];
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void exportToCsv(List<Map<String, dynamic>> data) async {
    List<String> headers = [
      // Header list
      'User id',
      'First name',
      'Last name',
      'Project name',
      'Order count',
      'Total liters ordered',
    ];

    List<List<dynamic>> rows = [];

    for (var item in data) {
      List<dynamic> row = [
        item['user_id'],
        item['ni_first_name'],
        item['ni_last_name'],
        item['ni_project_name'],
        item['order_count'],
        item['total_liters_ordered'],
      ];
      rows.add(row);
    }
    List<List<dynamic>> csvData = [headers, ...rows];
    String csvString = const ListToCsvConverter().convert(csvData);

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

    final File csvFile = File(
        '$directory/Todays_orders_${DateTime.now().day.toString()}_${DateTime.now().month.toString()}_${DateTime.now().year.toString()}_${DateTime.now().hour.toString()}_${DateTime.now().minute.toString()}_${DateTime.now().second.toString()}.csv');
    await csvFile.writeAsString(csvString, mode: FileMode.append);

    try {
      await csvFile.writeAsString(csvString);
      showSnackbar('CSV file saved successfully');
    } catch (e) {
      showSnackbar('Failed to save the CSV file');
    }
  }

  void exportToCsv1(List<Map<String, dynamic>> data, int todayOrdersCount,
      int totalWaterCapacity) async {
    List<String> headers = [
      // Header list
      'STP Name',
      'Order Count',
      'Total Water Capacity',
    ];

    List<List<dynamic>> rows = [];

    for (var item in data) {
      List<dynamic> row = [
        item['ni_stp_name'],
        item['order_count'],
        item['total_water_capacity'],
      ];
      rows.add(row);
    }

    // Add the totalWaterCapacity and todayOrdersCount to the last row
    List<dynamic> totalRow = [
      'Total:',
      todayOrdersCount,
      totalWaterCapacity,
    ];
    rows.add(totalRow);

    List<List<dynamic>> csvData = [headers, ...rows];
    String csvString = const ListToCsvConverter().convert(csvData);

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

    final File csvFile = File(
        '$directory/STP-wise-todays-order_${DateTime.now().day.toString()}_${DateTime.now().month.toString()}_${DateTime.now().year.toString()}_${DateTime.now().hour.toString()}_${DateTime.now().minute.toString()}_${DateTime.now().second.toString()}.csv');
    await csvFile.writeAsString(csvString, mode: FileMode.append);

    try {
      await csvFile.writeAsString(csvString);
      showSnackbar('CSV file saved successfully');
    } catch (e) {
      showSnackbar('Failed to save the CSV file');
    }
  }

  void exportToCsv2(List<Map<String, dynamic>> data) async {
    List<String> headers = [
      // Header list
      'STP Name',
      'Registered Tanker Count',
    ];

    List<List<dynamic>> rows = [];

    for (var item in data) {
      List<dynamic> row = [
        item['ni_nearest_stp'],
        item['registered_tanker_count'],
      ];
      rows.add(row);
    }
    List<List<dynamic>> csvData = [headers, ...rows];
    String csvString = const ListToCsvConverter().convert(csvData);

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

    final File csvFile = File(
        '$directory/STP-Wise-all-tan-reg_${DateTime.now().day.toString()}_${DateTime.now().month.toString()}_${DateTime.now().year.toString()}_${DateTime.now().hour.toString()}_${DateTime.now().minute.toString()}_${DateTime.now().second.toString()}.csv');
    await csvFile.writeAsString(csvString, mode: FileMode.append);

    try {
      await csvFile.writeAsString(csvString);
      showSnackbar('CSV file saved successfully');
    } catch (e) {
      showSnackbar('Failed to save the CSV file');
    }
  }

  void exportToCsv3(List<Map<String, dynamic>> data) async {
    List<String> headers = [
      // Header list
      'STP Name',
      'Registered Tanker Count',
    ];

    List<List<dynamic>> rows = [];

    for (var item in data) {
      List<dynamic> row = [
        item['ni_nearest_stp'],
        item['registered_tanker_count'],
      ];
      rows.add(row);
    }
    List<List<dynamic>> csvData = [headers, ...rows];
    String csvString = const ListToCsvConverter().convert(csvData);

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

    final File csvFile = File(
        '$directory/STP-Wise-todays-tan-reg_${DateTime.now().day.toString()}_${DateTime.now().month.toString()}_${DateTime.now().year.toString()}_${DateTime.now().hour.toString()}_${DateTime.now().minute.toString()}_${DateTime.now().second.toString()}.csv');
    await csvFile.writeAsString(csvString, mode: FileMode.append);

    try {
      await csvFile.writeAsString(csvString);
      showSnackbar('CSV file saved successfully');
    } catch (e) {
      showSnackbar('Failed to save the CSV file');
    }
  }

  void getApiData(String title) {
    switch (title) {
      case 'Todays Orders':
        PCMCservices.excelreport1().then((data) {
          dataList = data['data'];
          List<Map<String, dynamic>> formattedDataList = dataList.map((item) {
            return item as Map<String, dynamic>;
          }).toList();
          exportToCsv(formattedDataList);
        });
        break;
      case 'STP Wise All Tanker Register':
        PCMCservices.excelreport2().then((data) {
          dataList = data['results'];
          List<Map<String, dynamic>> formattedDataList = dataList.map((item) {
            return item as Map<String, dynamic>;
          }).toList();
          exportToCsv2(formattedDataList);
        });
        break;
      case 'STP Wise Todays Tanker Register':
        PCMCservices.excelreport3().then((data) {
          dataList = data['results'];
          List<Map<String, dynamic>> formattedDataList = dataList.map((item) {
            return item as Map<String, dynamic>;
          }).toList();
          exportToCsv3(formattedDataList);
        });
        break;
      case 'STP wise Todays Orders':
        PCMCservices.excelreport4().then((data) {
          dataList = data['reportData'];
          List<Map<String, dynamic>> formattedDataList = dataList.map((item) {
            return item as Map<String, dynamic>;
          }).toList();
          int todayOrdersCount = data['todayOrdersCount'];
          int totalWaterCapacity = data['totalWaterCapacity'];
          exportToCsv1(formattedDataList, todayOrdersCount, totalWaterCapacity);
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
      appBar: AppBar(
        title: const Text('Excel Reports'),
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
