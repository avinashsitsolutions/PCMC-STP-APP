import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tankerpcmc/garage/garage_services.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class ReportGarage extends StatefulWidget {
  const ReportGarage({super.key});

  @override
  State<ReportGarage> createState() => _ReportGarageState();
}

class _ReportGarageState extends State<ReportGarage> {
  // ignore: prefer_typing_uninitialized_variables
  var dropdownValue;
  List<dynamic> _dataList = [];
  bool isLoading = false;
  bool onchange = false;
  List<dynamic> options = [];
  String check = "True";
  List<Map<String, dynamic>> bcpList = []; // List to store the API response

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    _dateController2.text = formattedDate;
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                // ignore: deprecated_member_use
                onTap: () => launch('https://www.pmc.gov.in/mr?main=marathi'),
                child: const Image(
                  image: AssetImage('assets/pcmc_logo.jpg'),
                  height: 50,
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "PCMC",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Treated Water Recycle and Reuse System",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
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
                    color: Colors.white,
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
        body: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Reports",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // if (_selectedOption.isNotEmpty) {
                            Garageservices.reportgarage(_dateController1.text,
                                    _dateController2.text)
                                .then((data) {
                              if (data['error'] == true) {
                                setState(() {
                                  _dataList = data['data'];
                                });
                                isLoading = false;
                              } else if (data['error'] == false) {
                                setState(() {
                                  _dataList = data['data'];
                                });
                                isLoading = false;
                              }
                            });
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _dataList.isEmpty
                        // check == "false"
                        ? const Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "No Reports Available ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: _dataList.length,
                                itemBuilder: (context, index) {
                                  final data = _dataList[index];
                                  String dateString = data['updated_at'];
                                  final status = data['status'];
                                  DateTime date = DateTime.parse(dateString);
                                  String formattedDate =
                                      DateFormat('dd-MM-yyyy').format(date);
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      buildDataRow(
                                          "Serial No:", (index + 1).toString()),
                                      buildDataRow("Garage  Name:",
                                          data['ni_garage_name']),
                                      buildDataRow(
                                          "Order Completed On:", formattedDate),
                                      buildDataRow("Water Quantity:",
                                          "${data['ni_tanker_capacity'].toString()} Liter"),
                                      buildDataRow("Tankor No:",
                                          data['ni_tanker_no'].toString()),
                                      buildDataRow("Society Address:",
                                          data['address'].toString()),
                                      buildDataRow("STP Name:",
                                          data['ni_nearest_stp'].toString()),
                                      buildDataRow("Distance:",
                                          "${data['ni_distance'].toString()} Km"),
                                      buildDataRow("Amount:",
                                          "₹ ${data['ni_estimated_amount'].toString()}"),
                                      if (status.toString() == "false")
                                        buildDataRow("Status:", "Pending"),
                                      if (status.toString() == "null")
                                        buildDataRow("Status:", "Cancelled"),
                                      if (status.toString() == "true")
                                        buildDataRow("Status:", "Complete"),
                                      const Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  );
                                }),
                          )
              ]),
            )));
  }
}

Widget buildDataRow(String label, String? value) {
  return Row(
    children: [
      SizedBox(
        width: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 10, bottom: 10, right: 10),
              child: Text(
                label.toString(),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 17),
            ),
          ],
        ),
      )
    ],
  );
}
