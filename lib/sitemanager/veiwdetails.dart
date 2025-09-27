import 'package:flutter/material.dart';
import 'package:tankerpcmc/builder/builderservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({super.key});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  String? bcpno;
  String? projectname;
  String? rerano;
  String? address;
  String? lat;
  String? long;
  String? managername;
  String? managermobileno;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Builderservices.viewdetails().then((data) {
      if (data['error'] == false) {
        bcpno = data['data'][0]['ni_bcp_no'];
        projectname = data['data'][0]['ni_project_name'];
        rerano = data['data'][0]['ni_rera_no'];
        address = data['data'][0]['ni_project_address'];
        lat = data['data'][0]['ni_project_lat'];
        long = data['data'][0]['ni_project_long'];
        managername = data['data'][0]['site_manger_name'];
        managermobileno = data['data'][0]['ni_site_man_mo_no'];
        loading = false;
      } else {}
      setState(() {});
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Project Details",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              buildDataRow("Commecement NO:", bcpno),
              buildDataRow("Project Name:", projectname),
              buildDataRow("Project Address:", address),
              buildDataRow("Lattitude:", lat),
              buildDataRow("Longitude:", long),
              buildDataRow("Project Manager Name:", managername),
              buildDataRow("Manager Mobile No:", managermobileno),
            ],
          ),
        ),
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

Widget buildDataRow(String label, String? value) {
  return Row(
    children: [
      SizedBox(
        width: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 10, bottom: 10, right: 10),
              child: Text(
                label,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 17),
            ),
          ],
        ),
      )
    ],
  );
}
