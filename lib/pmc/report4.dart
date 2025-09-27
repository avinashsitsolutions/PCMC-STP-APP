import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tankerpcmc/pmc/pmcservices.dart';
import 'package:tankerpcmc/pmc/stpreport4.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';

class Report4 extends StatefulWidget {
  const Report4(
      {super.key,
      required this.date1,
      required this.date2,
      required this.dropdownValue});
  final String date1;
  final String date2;
  final String dropdownValue;
  @override
  State<Report4> createState() => _Report4State();
}

class _Report4State extends State<Report4> {
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PCMCservices.reportstp(widget.date1, widget.date2, widget.dropdownValue)
        .then((data) {
      if (data['error'] == true) {
        check = "false";
      } else if (data['error'] == false) {
        setState(() {
          _dataList = data['data'];
          Total_Stp = data['total_stp'].toString();
          Total_Orders = data['total_orders'].toString();
          Total_Litters = data['total_litters'].toString();
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

  bool showAll = false;
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
                        "Total STP:   $Total_Stp",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Orders:   $Total_Orders",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Liter's:   $Total_Litters Liter's",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "From-Date :${formatDate(widget.date1)}   To  TO-Date:${formatDate(widget.date2)}",
                        style: const TextStyle(fontSize: 16),
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
                            return Card(
                              child: ListTile(
                                title: Text(
                                    "Name: ${data['ni_stp_name'].toString()} "),
                                // subtitle: Text(
                                //     "Project Name:${data['ni_project_name'].toString()}"),
                                trailing: Text(
                                  'Total Order: ${data['order_count']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Stpreport4(
                                              date1: widget.date1,
                                              date2: widget.date2,
                                              stpname: data['ni_stp_name']
                                                  .toString(),
                                              totalliters:
                                                  data['total_water_capacity']
                                                      .toString(),
                                              totalorder: data['order_count']
                                                  .toString(),
                                              id: data['user_id'],
                                            )),
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
