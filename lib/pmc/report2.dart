import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tankerpcmc/pmc/builderreport2.dart';
import 'package:tankerpcmc/pmc/pmcservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';

class Report2 extends StatefulWidget {
  const Report2(
      {super.key,
      required this.date1,
      required this.date2,
      required this.dropdownValue});
  final String date1;
  final String date2;
  final String dropdownValue;
  @override
  State<Report2> createState() => _Report2State();
}

class _Report2State extends State<Report2> {
  List<dynamic> _dataList = [];
  bool isLoading = true;
  bool onchange = false;
  String check = "True";
  // ignore: non_constant_identifier_names
  String total_builder = "0";
  // ignore: non_constant_identifier_names
  String total_orders = "0";
  String total_litters = "0";
  String total_tanker = "0";
  // ignore: non_constant_identifier_names
  String total_stp = "0";
  bool showAll = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PCMCservices.builderreport(widget.date1, widget.date2, widget.dropdownValue)
        .then((data) {
      if (data['error'] == true) {
        check = "false";
      } else if (data['error'] == false) {
        setState(() {});
        _dataList = data['data'];
        total_builder = data['total_builder'].toString();
        total_orders = data['total orders'].toString();
        total_litters = data['total litters'].toString();
        isLoading = false;
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
                    child: Column(children: [
                      Text(
                        " ${widget.dropdownValue} Reports",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Total Builder's:   $total_builder",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Order's:   $total_orders ",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Liter's:   $total_litters",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "From-Date :${formatDate(widget.date1)}   To  TO-Date:${formatDate(widget.date2)}",
                        style: const TextStyle(fontSize: 16),
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
                            return Card(
                              child: ListTile(
                                title: Text(
                                  "Name: ${data['ni_first_name'].toString()} ${data['ni_last_name'].toString()}",
                                ),
                                trailing: Text(
                                  'Total Order: ${data['order_count']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BuilderReport2(
                                        date1: widget.date1,
                                        date2: widget.date2,
                                        firstname:
                                            data['ni_first_name'].toString(),
                                        lastname:
                                            data['ni_last_name'].toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ));
  }
}
