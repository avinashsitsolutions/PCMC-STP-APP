import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tankerpcmc/stp/stpservices.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class ReportWardOfficer extends StatefulWidget {
  const ReportWardOfficer({super.key});

  @override
  State<ReportWardOfficer> createState() => _ReportWardOfficerState();
}

class _ReportWardOfficerState extends State<ReportWardOfficer> {
  // ignore: prefer_typing_uninitialized_variables
  var dropdownValue;
  List<String> stpNames = [];
  bool isLoading = false;

  String check = "True";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();
  Map<String, dynamic> stpData = {};
  bool onchange = false;
  String selectedStpId = "";
  String dropdownValueId = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Stpsservices.stplist().then((data) {
      if (data['error'] == true) {
        setState(() {
          Map<String, dynamic> response = data;
          stpData = response['data']['ni_stp_assign'];

          stpData.forEach((key, value) {
            List<String> parts = value.split(',');
            String name = parts[1].trim();

            stpNames.add(name);
          });

          dropdownValue = stpNames[0]; // Set default dropdown value
          dropdownValueId = stpData.keys.first; // Set default dropdown value ID
        });
      } else if (data['error'] == false) {
        setState(() {
          Map<String, dynamic> response = data;
          stpData = response['data']['ni_stp_assign'];

          stpData.forEach((key, value) {
            List<String> parts = value.split(',');
            String name = parts[1].trim();

            stpNames.add(name);
          });

          dropdownValue = stpNames[0];
          dropdownValueId = stpData.keys.first;
        });
      }
    });
  }

  List<dynamic> _dataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const SizedBox(
                      height: 20,
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
                                    hintText: 'Select an STP',
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
                                    color: Colors.green,
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      dropdownValue = newValue;
                                      dropdownValueId = stpData.entries
                                          .firstWhere((entry) {
                                        List<String> parts =
                                            entry.value.split(',');
                                        String name = parts[1].trim();
                                        return name == newValue;
                                      },
                                              orElse: () =>
                                                  const MapEntry('', '')).key;
                                    });
                                    onchange = true;
                                    // Print the selected STP name and ID
                                  },
                                  items: stpNames.map<DropdownMenuItem<String>>(
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
                                    Stpsservices.reportwardoff(
                                            _dateController1.text,
                                            _dateController2.text,
                                            dropdownValueId)
                                        .then((data) {
                                      if (data['error'] == true) {
                                        check = "false";
                                        setState(() {
                                          _dataList = data['data'];
                                        });
                                      } else if (data['error'] == false) {
                                        setState(() {
                                          _dataList = data['data'];
                                        });
                                      }
                                    });
                                  }
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _dataList.isEmpty
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
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _dataList.length,
                                  itemBuilder: (context, index) {
                                    final data = _dataList[index];
                                    String dateString = data['updated_at'];
                                    DateTime date = DateTime.parse(dateString);
                                    String formattedDate =
                                        DateFormat('dd-MM-yyyy').format(date);
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 210,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    child: Text(
                                                      "Serial No:",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (index + 1).toString(),
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 210,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    child: Text(
                                                      "Reciept No:",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "STP/2023/${data['id'].toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 210,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    child: Text(
                                                      "Order Completed on:",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 210,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    child: Text(
                                                      "Water Quantity:",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${data['ni_water_capacity']} Liters",
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 210,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    child: Text(
                                                      "Tanker No :",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['ni_tanker_no'],
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 210,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    child: Text(
                                                      "Site Address:",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['address'].toString(),
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 210,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    child: Text(
                                                      "STP Name:",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['ni_nearest_stp'],
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 210,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    child: Text(
                                                      "Status:",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data['status'] == false
                                                        ? "Pending..."
                                                        : "Completed",
                                                    style: const TextStyle(
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                          height: 2,
                                          color: Colors.black,
                                          indent: 140,
                                          endIndent: 140,
                                        ),
                                      ],
                                    );
                                  },
                                )
                        ],
                      ),
                    ),
                  ]),
                ))));
  }
}
