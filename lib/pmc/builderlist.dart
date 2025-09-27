import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tankerpcmc/widgets/appbar.dart';
import 'dart:convert';

import 'package:tankerpcmc/widgets/drawerWidget.dart';

class BuilderList extends StatefulWidget {
  const BuilderList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BuilderListState createState() => _BuilderListState();
}

class _BuilderListState extends State<BuilderList> {
  List<dynamic> _dataList = [];
  String check = "True";
  bool _loading = true; // initialize loading state to true
  Future<void> getAllorder() async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/show_registered_builder'),
    );
    var data = json.decode(response.body);
    if (data['error'] == true) {
      check = "false";
    } else {
      setState(() {
        _dataList = data['data'];
        _loading = false;
      });
    }
  }

  bool showAll = false;
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
      body: _loading // check if data is still loading
          ? const Center(
              child:
                  CircularProgressIndicator()) // show loader if data is loading
          : Column(
              children: [
                const Text(
                  "Total Builder",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Text(
                    showAll ? "Back" : "Show All",
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: showAll
                        ? _dataList.length
                        : _dataList
                            .where((data) => data['order_count'] != 0)
                            .length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final data = showAll
                          ? _dataList[index]
                          : _dataList
                              .where((data) => data['order_count'] != 0)
                              .toList()[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(
                                "${data['ni_first_name'].toString()} ${data['ni_last_name'].toString()}"),
                            subtitle: Text(
                                "Mob No:${data['ni_contact_no'].toString()}"),
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
                                      "${data['ni_first_name'].toString()} ${data['ni_last_name'].toString()}",
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Added Project : ${data['project_count'].toString()} \n\nTotal Water Order(Lt):${data['total_water_capacity'].toString()}',
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
