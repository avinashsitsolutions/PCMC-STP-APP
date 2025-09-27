import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tankerpcmc/widgets/appbar.dart';
import 'dart:convert';

import 'package:tankerpcmc/widgets/drawerWidget.dart';

class TankerList extends StatefulWidget {
  const TankerList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TankerListState createState() => _TankerListState();
}

class _TankerListState extends State<TankerList> {
  List<dynamic> _dataList = [];
  String check = "True";
  bool isLoading = true;

  Future getAllorder() async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/show_registered_tanker_new'),
    );
    var data = json.decode(response.body);
    if (data['error'] == true) {
      check = "false";
    } else {
      setState(() {
        _dataList = data['data'];
        isLoading = false; // Set isLoading to false when data is fetched
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
      body: isLoading // Use conditional rendering to display loader
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const Text(
                  "Total Number of Tankers",
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
                            .where((data) => data['tanker_count'] != 0)
                            .length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final data = showAll
                          ? _dataList[index]
                          : _dataList
                              .where((data) => data['tanker_count'] != 0)
                              .toList()[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(data['ni_owner_ful_name'].toString()),
                            trailing: Text(
                              'Tanker Count: ${data['tanker_count']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Order Count : ${data['order_count']}",
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Water Order(Lt): ${data['total_water_capacity']}',
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
