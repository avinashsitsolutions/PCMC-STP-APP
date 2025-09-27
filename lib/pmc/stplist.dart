import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tankerpcmc/widgets/appbar.dart';
import 'dart:convert';

import 'package:tankerpcmc/widgets/drawerWidget.dart';

class StpList extends StatefulWidget {
  const StpList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StpListState createState() => _StpListState();
}

class _StpListState extends State<StpList> {
  List<dynamic> _dataList = [];
  String check = "True";
  bool _isLoading = true;

  Future getAllorder() async {
    // print(token);
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/show_registered_stp'),
    );
    var data = json.decode(response.body);
    if (data['error'] == true) {
      check = "false";
    } else {
      setState(() {
        _dataList = data['data'];
        _isLoading = false; // set isLoading to false when data is loaded
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      // _data[index]['Subtitle']
      body: _isLoading // show loader while isLoading is true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const Text(
                  "Total Number of STP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _dataList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final data = _dataList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(data['ni_stp_name'].toString()),
                            trailing: Text(
                              'Total Order: ${data['order_count']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "${data['ni_stp_name'].toString()} ",
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Water Order(Lt):${data['total_water_capacity'].toString()}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
