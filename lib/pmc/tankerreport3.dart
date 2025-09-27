import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tankerpcmc/pmc/pmcservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';

class TankerReport3 extends StatefulWidget {
  const TankerReport3(
      {super.key,
      required this.date1,
      required this.date2,
      required this.tankerno,
      required this.totalorder,
      required this.totalliters,
      required this.tankerowner});
  final String date1;
  final String date2;
  final String tankerno;
  final String totalorder;
  final String totalliters;
  final String tankerowner;
  @override
  State<TankerReport3> createState() => _TankerReport3State();
}

class _TankerReport3State extends State<TankerReport3> {
  List<dynamic> _dataList = [];
  bool isLoading = true;
  bool onchange = false;
  String check = "True";
  // ignore: non_constant_identifier_names
  String Total_Orders = "0";
  // ignore: non_constant_identifier_names
  String Total_Litters = "0";
  // ignore: non_constant_identifier_names
  String Total_Tanker = "0";
  // ignore: non_constant_identifier_names
  String Total_Stp = "0";
  int complatedorders = 0;
  int complatedliters = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PCMCservices.reporttanker3(widget.date1, widget.date2, widget.tankerno)
        .then((data) {
      if (data['error'] == true) {
        check = "false";
        setState(() {
          _dataList = data['data'];
          complatedorders = data['completed orders'];
          complatedliters = data['Total Liter'];
        });
        setState(() {
          isLoading = false;
        });
      } else if (data['error'] == false) {
        setState(() {
          _dataList = data['data'];
          complatedorders = data['completed orders'];
          complatedliters = data['Total Liter'];
        });
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  String formatDate(String dateString) {
    final parts = dateString.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    final dateTime = DateTime(year, month, day);
    final formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Appbarwid(),
        ),
        endDrawer: const DrawerWid(),
        body: isLoading == true
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
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            " ${widget.tankerno} ",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Total Order's:  $complatedorders",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Total Liter's:   $complatedliters Liter's",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Tanker Owner Name:   ${widget.tankerowner}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "From-Date :${formatDate(widget.date1)}   To  TO-Date:${formatDate(widget.date2)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
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
                                                  "${data['ni_water_capacity'] ?? 0} Liters",
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
                                                    "Project Name:",
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
                                                  data['ni_project_name'] ?? 0,
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
                                                    "Builder Name:",
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
                                                  " ${data['ni_first_name'].toString()} ${data['ni_last_name'].toString()}",
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
                                        height: 20,
                                      ),
                                      const Divider(),
                                    ],
                                  );
                                }),
                          )
                        ]),
                  ));
  }
}
