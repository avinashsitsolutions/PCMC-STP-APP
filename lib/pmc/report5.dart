import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tankerpcmc/pmc/pmcservices.dart';
import 'package:tankerpcmc/pmc/societyreport5.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';

class Report5 extends StatefulWidget {
  const Report5(
      {super.key,
      required this.date1,
      required this.date2,
      required this.dropdownValue});
  final String date1;
  final String date2;
  final String dropdownValue;
  @override
  State<Report5> createState() => _Report5State();
}

class _Report5State extends State<Report5> {
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
    PCMCservices.reportsociety(widget.date1, widget.date2, widget.dropdownValue)
        .then((data) {
      if (data['error'] == true) {
        check = "false";
      } else if (data['error'] == false) {
        setState(() {
          _dataList = data['data'];
          Total_Stp = data['total_society'].toString();
          Total_Orders = data['total orders'].toString();
          Total_Litters = data['total litters'].toString();
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
                        "Total Society:   $Total_Stp",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Order's:   $Total_Orders",
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
                                    "Name: ${data['ni_name'].toString()} "),
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
                                        builder: (context) => Societyreport5(
                                              date1: widget.date1,
                                              date2: widget.date2,
                                              stpname:
                                                  data['ni_name'].toString(),
                                              id: data['id'].toString(),
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
