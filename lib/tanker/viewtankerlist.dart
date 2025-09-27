import 'package:flutter/material.dart';
import 'package:tankerpcmc/tanker/tankerservices.dart';
import 'package:tankerpcmc/tanker/updatetanker.dart';
import 'package:tankerpcmc/widgets/appbar.dart';

import '../widgets/drawerWidget.dart';

class ViewTanker extends StatefulWidget {
  const ViewTanker({super.key});

  @override
  State<ViewTanker> createState() => _ViewTankerState();
}

class _ViewTankerState extends State<ViewTanker> {
  bool isLoading = true;
  List<String> stpNames = [];
  List<Map<String, dynamic>> _tankerDataList = [];

  @override
  void initState() {
    super.initState();
    Tankerservices.viewtankerlist().then((data) {
      if (data['error'] == false) {
        setState(() {
          List<dynamic> responseData = data['data'];

          for (var tankData in responseData) {
            String tankerNo = tankData['ni_tanker_no'].toString();
            String stp = tankData['ni_nearest_stp'];
            String capacity = tankData['ni_tanker_capacity'].toString();
            String drivername = tankData['tanker_driver_name'].toString();
            String drivermobno = tankData['tanker_driver_mo_no'].toString();
            int orderCount = tankData['orderCount'];
            String tankertype = tankData['tanker_type'];
            int id = tankData['id'];
            dynamic builderIds = tankData['builder_id'];

            List<int> selectedbuilder = [];

            if (builderIds is String) {
              List<String> nonEmptyStrings = (builderIds)
                  .split(',')
                  .map((s) => s.replaceAll(RegExp(r'[^0-9]'), ''))
                  .toList();
              selectedbuilder = nonEmptyStrings
                  .map<int>((id) {
                    try {
                      return int.parse(id);
                    } catch (e) {
                      return 0; // Replace with a default value if parsing fails
                    }
                  })
                  .where((id) => id != 0)
                  .toList();
            } else if (builderIds is List<dynamic>) {
              selectedbuilder = builderIds.map<int>((id) => id as int).toList();
            }
            _tankerDataList.add({
              'id': id,
              'tankerNo': tankerNo,
              'tankertype': tankertype,
              'orderCount': orderCount,
              'drivername': drivername,
              'drivermobno': drivermobno,
              'capacity': capacity,
              'stp': stp,
              'selectedbuilder': selectedbuilder
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "Vehicle List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _tankerDataList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final tankerData = _tankerDataList[index];

                final tankerNo = tankerData['tankerNo'];
                final tankertype = tankerData['tankertype'];
                final tankerid = tankerData['id'];
                final orderCount = tankerData['orderCount'];
                final drivername = tankerData['drivername'] ?? "";
                final drivermobno = tankerData['drivermobno'] ?? "";
                final capacity = tankerData['capacity'] ?? "";
                final stp = tankerData['stp'] ?? "";
                final selectedbuilder = tankerData['selectedbuilder'] ?? [];
                return Card(
                  child: ListTile(
                    title: Text("Vehicle Number: $tankerNo"),
                    subtitle: Text("Order Count: $orderCount"),
                    onTap: () {
                      // Perform an action when the ListTile is tapped
                    },
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateTanker(
                                tankerno: tankerNo?.toString() ?? '',
                                orderCount: orderCount?.toString() ?? '',
                                id: tankerid?.toString() ?? '',
                                capacity: capacity?.toString() ?? '',
                                drivermobno: drivermobno?.toString() ?? '',
                                drivername: drivername?.toString() ?? '',
                                stp: stp?.toString() ?? '',
                                tankertype: tankertype?.toString() ?? '',
                                selectedBuilders:
                                    selectedbuilder ?? [0, 0, 0, 0, 0],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/bottomimage.png'), // Replace with your image path
          ),
        ),
        height: 70, // Adjust the height of the image
      ),
    );
  }
}
