import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tankerpcmc/pmc/excelreport.dart';
import 'package:tankerpcmc/pmc/report1.dart';
import 'package:tankerpcmc/pmc/report2.dart';
import 'package:tankerpcmc/pmc/report3.dart';
import 'package:tankerpcmc/pmc/report4.dart';
import 'package:tankerpcmc/pmc/report5.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class ReportPCMC extends StatefulWidget {
  const ReportPCMC({super.key});

  @override
  State<ReportPCMC> createState() => _ReportPCMCState();
}

class _ReportPCMCState extends State<ReportPCMC> {
  // ignore: prefer_typing_uninitialized_variables
  var dropdownValue;
  bool isLoading = false;
  bool onchange = false;
  String check = "True";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();
  Future<bool> _onWillPop() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit the app?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    _dateController2.text = formattedDate;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  // ignore: deprecated_member_use
                  onTap: () => launch('https://pcmcindia.gov.in/index.php'),
                  child: const Image(
                    image: AssetImage('assets/pcmc_logo.jpg'),
                    height: 50,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Pimpri-Chinchwad Municipal Corporation",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Treated Water Recycle and Reuse System",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.menu,
                      size: 25,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                },
              ),
            ],
          ),
          endDrawer: const DrawerWid(),
          body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 60),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      TextButton(
                          // ExcelReports
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ExcelReports()));
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Excel Reports"),
                              Icon(Icons.arrow_circle_right_outlined)
                            ],
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Reports",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        width: 320,
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "From Date:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: Text(
                              "To Date:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _dateController1,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelText: 'Date',
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter date';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      DatePicker.showDatePicker(
                                        context,
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 1, 1),
                                        maxTime: DateTime(2025, 12, 31),
                                        onConfirm: (date) {
                                          _dateController1.text =
                                              '${date.day}-${date.month}-${date.year}';
                                        },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _dateController2,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      labelText: 'Date',
                                      suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter date';
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      DatePicker.showDatePicker(
                                        context,
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 1, 1),
                                        maxTime: DateTime(2025, 12, 31),
                                        onConfirm: (date) {
                                          _dateController2.text =
                                              '${date.day}-${date.month}-${date.year}';
                                        },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.green,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  width: 150,
                                  child: DropdownButtonFormField<String>(
                                    value: dropdownValue,

                                    menuMaxHeight: 200,
                                    decoration: const InputDecoration(
                                      suffixIconColor: Colors.green,
                                      hintText: 'Select an option',
                                      border: InputBorder.none,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select an option';
                                      }
                                      return null;
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors
                                          .green, // Set the desired color of the icon
                                    ),
                                    // dropdownColor: Colors.green,
                                    onChanged: (newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                      onchange = true;
                                    },
                                    items: <String>[
                                      'All Order',
                                      'Builder',
                                      'Tanker',
                                      'STP',
                                      'Society',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      onchange = false;
                                      if (dropdownValue == "All Order") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Report1(
                                                    date1:
                                                        _dateController1.text,
                                                    date2:
                                                        _dateController2.text,
                                                    dropdownValue:
                                                        dropdownValue)));
                                      } else if (dropdownValue == "Builder") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Report2(
                                                    date1:
                                                        _dateController1.text,
                                                    date2:
                                                        _dateController2.text,
                                                    dropdownValue:
                                                        dropdownValue)));
                                      } else if (dropdownValue == "Tanker") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Report3(
                                                    date1:
                                                        _dateController1.text,
                                                    date2:
                                                        _dateController2.text,
                                                    dropdownValue:
                                                        dropdownValue)));
                                      } else if (dropdownValue == "STP") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Report4(
                                                    date1:
                                                        _dateController1.text,
                                                    date2:
                                                        _dateController2.text,
                                                    dropdownValue:
                                                        dropdownValue)));
                                      } else if (dropdownValue == "Society") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Report5(
                                                    date1:
                                                        _dateController1.text,
                                                    date2:
                                                        _dateController2.text,
                                                    dropdownValue:
                                                        dropdownValue)));
                                      }
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                  )))),
    );
  }
}
