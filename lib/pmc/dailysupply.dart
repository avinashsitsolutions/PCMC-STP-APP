import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';
import 'package:http/http.dart' as http;

class DailySupply extends StatefulWidget {
  const DailySupply({super.key});

  @override
  State<DailySupply> createState() => _DailySupplyState();
}

class _DailySupplyState extends State<DailySupply> {
  String total_orders = "0";
  String total_litters = "0";
  String total_tanker = "0";
  String date = "0";
  List<dynamic> _dataList = [];
  String check = "True";
  bool isLoading = true; // initialize loading state to true
  Future<void> getdata() async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/Today_supplay_in_litters'),
    );
    var data = json.decode(response.body);
    if (data['error'] == true) {
      setState(() {
        check = "false";
        _dataList = data['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        _dataList = data['data'];
        total_orders = data['Todays_order_count'].toString();
        total_tanker = data['today_stp_order'].toString();
        total_litters = data['Todays_Daily_supply_in_litters'].toString();
        isLoading =
            false; // set loading state to false after receiving response
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Appbarwid(),
        ),
        endDrawer: const DrawerWid(),
        body: isLoading
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
                    child: Column(children: [
                      const Text(
                        " Total Today's Supply",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Todays Date:   $date",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Todays Order Count:   $total_orders",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Today's STP Water Supply in Liter's:  $total_litters ",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Todays STP Order :  $total_tanker ",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _dataList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final data = _dataList[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                    "STP: ${data['ni_stp_name'].toString()} "),
                                subtitle: Text(
                                    "Todays Water Order:${data['total_capacity'].toString()}"),
                                trailing: Text(
                                  ' Total Order: ${data['order_count']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                // onTap: () {
                                //   showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         title: Text(
                                //           "${data['ni_first_name'].toString()} ${data['ni_last_name'].toString()}",
                                //           textAlign: TextAlign.center,
                                //         ),
                                //         content: Row(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.center,
                                //           children: [
                                //             Text(
                                //               'Added Project : ${data['project_count'] ?? 0.toString()} \n\nTotal Water Order(Lt):${data['total_water_capacity'] ?? 0.toString()}',
                                //               overflow: TextOverflow.ellipsis,
                                //             ),
                                //           ],
                                //         ),
                                //         actions: [
                                //           TextButton(
                                //             onPressed: () =>
                                //                 Navigator.pop(context),
                                //             child: const Text('OK'),
                                //           ),
                                //         ],
                                //       );
                                //     },
                                //   );
                                // },
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ));
  }
}
