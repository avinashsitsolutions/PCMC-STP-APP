import 'package:flutter/material.dart';
import 'package:tankerpcmc/builder/builderservices.dart';
import 'package:tankerpcmc/builder/updatebcp.dart';
import 'package:tankerpcmc/widgets/appbar.dart';

import '../widgets/drawerWidget.dart';

class ViewProject extends StatefulWidget {
  const ViewProject({Key? key}) : super(key: key);

  @override
  State<ViewProject> createState() => _ViewProjectState();
}

class _ViewProjectState extends State<ViewProject> {
  List<Map<String, dynamic>> bcpList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Builderservices.bcplist().then((data1) {
      setState(() {
        isLoading = true;
        if (data1['error'] == true || data1['error'] == false) {
          List<dynamic> data = data1['data'];

          // Update the 'water_type_id' field for all items in bcpList
          bcpList = data.map<Map<String, dynamic>>((item) {
            // Parse the string into a list of integers
            String waterTypeIdString = item['water_type_id'] as String;
            waterTypeIdString = waterTypeIdString
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll('"', '');
            List<int> waterTypeIdList = waterTypeIdString
                .split(',')
                .map<int>((str) => int.tryParse(str.trim()) ?? 0)
                .toList();
            // List<int> waterTypeIdList = (item['water_type_id'] as String)
            //     .replaceAll('[', '')
            //     .replaceAll(']', '')
            //     .replaceAll('"', '')
            //     .split(',')
            //     .map<int>((str) => int.parse(str.trim()))
            //     .toList();

            return {
              ...item,
              'water_type_id': waterTypeIdList,
            };
          }).toList();
          isLoading = false;
        }
      });
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
                "View Project List",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : bcpList.isEmpty
                  ? const Text("No Project Name Available")
                  : Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: bcpList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final bcpItem = bcpList[index];
                          final projectName = bcpItem['ni_project_name'] ?? '';
                          final bcpNo = bcpItem['ni_bcp_no'] ?? '';
                          final mobile = bcpItem['ni_site_man_mo_no'] ?? '';
                          final address = bcpItem['ni_project_address'] ?? '';
                          final lat = bcpItem['ni_project_lat'] ?? '';
                          final long = bcpItem['ni_project_long'] ?? '';
                          final managername = bcpItem['site_manger_name'] ?? '';
                          final rerano = bcpItem['ni_rera_no'] ?? '';
                          final projecttype = bcpItem['project_type'] ?? ' ';
                          final tankertype = (bcpItem['tanker_type'] != null &&
                                  bcpItem['tanker_type'].isNotEmpty)
                              ? bcpItem['tanker_type']
                              : 'Select Tanker Type';
                          final tankerid = (bcpItem['water_type_id']);
                          return Card(
                            child: ListTile(
                              subtitle: Text("Commecement No: $bcpNo"),
                              title: Text("Project Name: $projectName"),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateBCP(
                                                  bcpno: bcpNo.toString(),
                                                  mobileno: mobile.toString(),
                                                  id: bcpItem['id'].toString(),
                                                  projectName: projectName,
                                                  address: address,
                                                  lat: lat,
                                                  long: long,
                                                  managername: managername,
                                                  projecttype: projecttype,
                                                  tankertype: tankertype,
                                                  selectedBuilders: tankerid,
                                                )));
                                  },
                                  icon: const Icon(Icons.edit)),
                              onTap: () {
                                // Perform an action when the ListTile is tapped
                              },
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
