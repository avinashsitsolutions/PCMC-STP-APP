import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tankerpcmc/pmc/pmcservices.dart';
import 'package:tankerpcmc/pmc/tankerreport3.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';

class Report3 extends StatefulWidget {
  const Report3(
      {super.key,
      required this.date1,
      required this.date2,
      required this.dropdownValue});
  final String date1;
  final String date2;
  final String dropdownValue;
  @override
  State<Report3> createState() => _Report3State();
}

class _Report3State extends State<Report3> {
  List<dynamic> _dataList = [];
  bool isLoading = true;
  bool onchange = false;
  String check = "True";
  // ignore: non_constant_identifier_names
  String total_orders = "0";
  // ignore: non_constant_identifier_names
  String total_litters = "0";
  // ignore: non_constant_identifier_names
  String total_tanker = "0";
  // ignore: non_constant_identifier_names
  String total_stp = "0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PCMCservices.reporttanker(widget.date1, widget.date2, widget.dropdownValue)
        .then((data) {
      if (data['error'] == true) {
        check = "false";
      } else if (data['error'] == false) {
        setState(() {
          _dataList = data['data'];
          total_tanker = data['total_tanker'].toString();
          total_orders = data['total orders'].toString();
          total_litters = data['total litters'].toString();
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
                        "Total Tanker:   $total_tanker",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Total Orders:   $total_orders",
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
                                    "Name: ${data['ni_owner_ful_name'].toString()} "),
                                subtitle: Text(
                                    "Tanker No:${data['ni_tanker_no'].toString()}"),
                                trailing: Text(
                                  'Total Order: ${data['order_count']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TankerReport3(
                                              date1: widget.date1,
                                              date2: widget.date2,
                                              totalliters:
                                                  data['total_water_capacity']
                                                      .toString(),
                                              totalorder: data['order_count']
                                                  .toString(),
                                              tankerno: data['ni_tanker_no'],
                                              tankerowner:
                                                  data['ni_owner_ful_name']
                                                      .toString(),
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
