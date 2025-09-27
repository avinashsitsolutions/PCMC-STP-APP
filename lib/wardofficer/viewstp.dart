import 'package:flutter/material.dart';
import 'package:tankerpcmc/stp/stpservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';

import '../widgets/drawerWidget.dart';

class ViewStp extends StatefulWidget {
  const ViewStp({super.key});

  @override
  State<ViewStp> createState() => _ViewStpState();
}

class _ViewStpState extends State<ViewStp> {
  List<String> stpNames = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Stpsservices.stplist().then((data) {
      if (data['error'] == true) {
        setState(() {
          Map<String, dynamic> response = data;

          Map<String, dynamic> stpData = response['data']['ni_stp_assign'];

          List<String> stpNames = [];

          stpData.forEach((key, value) {
            List<String> parts = value.split(',');
            String name = parts[1].trim();

            stpNames.add(name);
          });
        });
      } else if (data['error'] == false) {
        setState(() {
          Map<String, dynamic> response = data;

          Map<String, dynamic> stpData = response['data']['ni_stp_assign'];

          stpData.forEach((key, value) {
            List<String> parts = value.split(',');
            String name = parts[1].trim();

            stpNames.add(name);
          });
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
              "Assigned STP List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
          ),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: stpNames.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                final name = stpNames[index];
                return Card(
                  child: ListTile(
                    title: Text("STP Name: $name"),
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
    );
  }
}
