import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/stp/neworderstp.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/drawerWidget.dart';

class ScannedDataPage extends StatefulWidget {
  const ScannedDataPage({
    Key? key, // corrected line
    required this.scannedData,
  }) : super(key: key); // corrected line
  final String scannedData;

  @override
  State<ScannedDataPage> createState() => _ScannedDataPageState();
}

class _ScannedDataPageState extends State<ScannedDataPage> {
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  var url;
  // ignore: prefer_typing_uninitialized_variables
  var url2;
  bool check = false;
  bool isLoading = false;
  Future getData() async {
    var id = widget.scannedData;
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/qr/$id'),
    );
    var data = json.decode(response.body);
    if (data['error'] == true) {
      check = true;
    } else if (data['error'] == false) {
      check = false;
    }
    return data;
  }

  Future updateData(String name1, String number1) async {
    var id = widget.scannedData;
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final response = await http.post(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/project_orders_update/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        "ni_driver_name": name1,
        "ni_driver_contact": number1,
        "status": "true",
      },
    );
    var data = json.decode(response.body);
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

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
        body: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data['data'];
                String dateString = data['created_at'];
                DateTime date = DateTime.parse(dateString);
                String formattedDate = DateFormat('dd-MM-yyyy').format(date);
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          check == true
                              ? Center(
                                  child: Text(
                                  snapshot.data['message'],
                                  style: const TextStyle(fontSize: 20),
                                ))
                              : Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Order Details",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
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
                                                // "hf",
                                                data['id'].toString(),
                                                // data['id'].toString(),
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
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  "Order Date:",
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
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
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
                                                "${data['ni_water_capacity'].toString()}Liters",
                                                // data['created_at'],
                                                maxLines: 6,
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
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
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
                                                data['ni_nearest_stp']
                                                    .toString(),
                                                // data['ni_water_capacity'],
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
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  "Tanker Number:",
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
                                                data['ni_tanker_no'].toString(),
                                                // data['ni_address'],
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
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  "Distance:",
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
                                                "${data['ni_distance']}Km",
                                                // data['ni_nearest_stp'],
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
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  "Estimate Amount:",
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
                                                "₹${data['ni_estimated_amount'].toString()}",
                                                // data['ni_nearest_stp'],
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
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  "Tanker Owner Name:",
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
                                                data['ni_owner_ful_name']
                                                    .toString(),
                                                // data['ni_nearest_stp'],
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
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  "Tanker Capacity:",
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
                                                "${data['ni_tanker_capacity'].toString()} Liters",
                                                // data['ni_nearest_stp'],
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
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(
                                                  "Tanker Owner Contact No:",
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
                                                data['ni_tanker_mo_no']
                                                    .toString(),
                                                // data['ni_nearest_stp'],
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    const Center(
                                      child: Text(
                                        "Driver Details",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: TextFormField(
                                              controller: textController1,
                                              decoration: const InputDecoration(
                                                hintText: 'Driver Name',
                                                hintStyle: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter name';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20, left: 20),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: textController2,
                                              onChanged: (value) {},
                                              decoration: const InputDecoration(
                                                hintText: 'Driver Number',
                                                hintStyle: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty ||
                                                    value.length != 10) {
                                                  return 'Please enter Valid Number';
                                                }

                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: Colors.black,
                                      indent: 120,
                                      endIndent: 120,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.horizontal(
                                              left: Radius.circular(20.0),
                                              right: Radius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                                const Size(150, 35)),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          updateData(textController1.text,
                                                  textController2.text)
                                              .then((data) async {
                                            url = data['URL'];
                                            url2 = data['URL2'];
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.green,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content: Text(
                                                    "Order Completed Successfully"),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                            final response =
                                                await http.get(Uri.parse(url));
                                            final response1 =
                                                await http.get(Uri.parse(url2));

                                            textController1.clear();
                                            textController2.clear();
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NewOrderStp()));
                                          });
                                        }
                                      },
                                      child: const Text(
                                        'Fill Tanker',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                // show loading indicator
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
