import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tankerpcmc/widgets/appbar.dart';
import 'dart:convert';
import 'package:tankerpcmc/widgets/drawerWidget.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<dynamic> _dataList = [];
  bool isLoading = true;
  bool _isLoading = true; // added state variable for loader

  Map<String, dynamic> stpData = {};

  String selectedStpId = "";
  String dropdownValueId = "";
  var dropdownValue;
  String cancelcount = "";
  String pendingcount = "";
  String totalcount = "";
  String totalliter = "";
  String completedcount = "";
  List<String> stpNames = ['Completed', 'Pending'];

  Future getcount() async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/total_Order_new_count'),
    );
    var data = json.decode(response.body);
    setState(() {
      cancelcount = data['cancel order'].toString();
      pendingcount = data['pending Order'].toString();
      totalcount = data['Total order'].toString();
      completedcount = data['completed order'].toString();
      totalliter = data['total water liter'].toString();
      _isLoading = false;
    });
  }

  List<String> values = [];
  @override
  void initState() {
    super.initState();
    getcount();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Appbarwid(),
        ),
        endDrawer: const DrawerWid(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Total Orders",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(
                    color: Colors.black,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  children: [
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Completed Orders Count:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            completedcount,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Cancel Orders Count:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cancelcount,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Pending Orders Count:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            pendingcount,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Total Orders Count:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            totalcount,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Total Orders Liters:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            totalliter,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        // body: Column(
        //   children: [
        //
        //     Text(
        //       "Completed Orders Count: ${values[0]} ",
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        //     ),
        //     const SizedBox(
        //       height: 10,
        //     ),
        //     Text(
        //       "Cancel Orders Count: ",
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        //     ),

        //     const SizedBox(
        //       height: 10,
        //     ),
        //     Text(
        //       "Pending Orders Count:  ",
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        //     ),
        //     const SizedBox(
        //       height: 10,
        //     ),
        //     Text(
        //       "Total Orders Count:  ${values[1]}",
        //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        //     ),
        //     // Row(
        //     //   mainAxisAlignment: MainAxisAlignment.center,
        //     //   children: [
        //     //     Container(
        //     //       decoration: const BoxDecoration(
        //     //         border: Border(
        //     //           bottom: BorderSide(
        //     //             color: Colors.green,
        //     //             width: 1.0,
        //     //           ),
        //     //         ),
        //     //       ),
        //     //       width: 150,
        //     //       child: DropdownButtonFormField<String>(
        //     //         value: dropdownValue,
        //     //         menuMaxHeight: 200,
        //     //         decoration: const InputDecoration(
        //     //           suffixIconColor: Colors.green,
        //     //           hintText: 'Select Status',
        //     //           border: InputBorder.none,
        //     //           enabledBorder: UnderlineInputBorder(
        //     //             borderSide: BorderSide.none,
        //     //           ),
        //     //           focusedBorder: UnderlineInputBorder(
        //     //             borderSide: BorderSide.none,
        //     //           ),
        //     //         ),
        //     //         style: const TextStyle(
        //     //           color: Colors.black,
        //     //           fontSize: 17.0,
        //     //           fontWeight: FontWeight.bold,
        //     //         ),
        //     //         validator: (value) {
        //     //           if (value == null || value.isEmpty) {
        //     //             return 'Please select an option';
        //     //           }
        //     //           return null;
        //     //         },
        //     //         icon: const Icon(
        //     //           Icons.arrow_drop_down,
        //     //           color: Colors.green,
        //     //         ),
        //     //         onChanged: (newValue) {
        //     //           setState(() {
        //     //             dropdownValue = newValue;
        //     //             dropdownValueId = stpData.entries.firstWhere((entry) {
        //     //               List<String> parts = entry.value.split(',');
        //     //               String name = parts[1].trim();
        //     //               return name == newValue;
        //     //             }, orElse: () => const MapEntry('', '')).key;
        //     //           });
        //     //           // onchange = true;
        //     //           // Print the selected STP name and ID
        //     //         },
        //     //         items: stpNames.map<DropdownMenuItem<String>>((String value) {
        //     //           return DropdownMenuItem<String>(
        //     //             value: value,
        //     //             child: Text(value),
        //     //           );
        //     //         }).toList(),
        //     //       ),
        //     //     ),
        //     //     const SizedBox(
        //     //       width: 50,
        //     //     ),
        //     //     ElevatedButton(
        //     //       onPressed: () {
        //     //         if (dropdownValue == null) {
        //     //           ScaffoldMessenger.of(context).showSnackBar(
        //     //             const SnackBar(
        //     //               backgroundColor: Colors.red,
        //     //               behavior: SnackBarBehavior.floating,
        //     //               content: Text("Please Select Status First!"),
        //     //               duration: Duration(seconds: 2),
        //     //             ),
        //     //           );
        //     //         } else {
        //     //           if (dropdownValue == 'Pending') {
        //     //             getAllorder1();
        //     //           } else {
        //     //             getAllorder2();
        //     //           }
        //     //         }
        //     //       },
        //     //       child: const Text('Submit'),
        //     //     ),
        //     //   ],
        //     // ),
        //     // const SizedBox(
        //     //   height: 20,
        //     // ),
        //     _isLoading
        //         ? const Center(
        //             child: CircularProgressIndicator(),
        //           )
        //         : Expanded(
        //             child: ListView.builder(
        //               physics: const AlwaysScrollableScrollPhysics(),
        //               itemCount: _dataList.length,
        //               shrinkWrap: true,
        //               itemBuilder: (BuildContext context, int index) {
        //                 final data = _dataList[index];
        //                 return Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Card(
        //                       child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                     children: [
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Row(
        //                           // mainAxisAlignment: MainAxisAlignment.center,
        //                           children: [
        //                             Text(
        //                               "Order no: ${data['id']}",
        //                               style: const TextStyle(
        //                                   fontSize: 15,
        //                                   fontWeight: FontWeight.bold),
        //                             ),
        //                             const SizedBox(
        //                               width: 20,
        //                             ),
        //                             Text("Date: ${data['created_at']}",
        //                                 style: const TextStyle(
        //                                     fontSize: 15,
        //                                     fontWeight: FontWeight.bold))
        //                           ],
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Row(
        //                           // mainAxisAlignment: MainAxisAlignment.center,
        //                           children: [
        //                             Expanded(
        //                               child: Text(
        //                                   "Builder Name: ${data['ni_first_name']} ${data['ni_last_name']}",
        //                                   style: const TextStyle(
        //                                       fontSize: 15,
        //                                       fontWeight: FontWeight.bold,
        //                                       overflow: TextOverflow.ellipsis)),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.center,
        //                           children: [
        //                             Expanded(
        //                               child: Text(
        //                                   "Project Name:${data['ni_project_name'].toString()}",
        //                                   style: const TextStyle(
        //                                       fontSize: 15,
        //                                       fontWeight: FontWeight.bold,
        //                                       overflow: TextOverflow.ellipsis)),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Row(
        //                           // mainAxisAlignment: MainAxisAlignment.center,
        //                           children: [
        //                             Text("Liter: ${data['total_water_capacity']}",
        //                                 style: const TextStyle(
        //                                     fontSize: 15,
        //                                     fontWeight: FontWeight.bold)),
        //                           ],
        //                         ),
        //                       )
        //                     ],
        //                   )),
        //                 );
        //               },
        //             ),
        //           ),
        //   ],
        // ),
        );
  }
}
