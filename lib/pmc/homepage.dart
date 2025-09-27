import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tankerpcmc/pmc/adddepartment.dart';
import 'package:tankerpcmc/pmc/addstp.dart';
import 'package:tankerpcmc/pmc/dashboard.dart';
import 'package:tankerpcmc/pmc/report_pmc.dart';
import 'package:tankerpcmc/pmc/wardofficerreg.dart';
import 'package:tankerpcmc/widgets/dimensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// ignore: non_constant_identifier_names
List<Map> Services = [];
List<dynamic> count = [];
// ignore: non_constant_identifier_names
String RegisteredBuilders = '';
// ignore: non_constant_identifier_names
String RegisteredSTPs = '';

// getCounts() async {
//   var response = await http.get(
//     Uri.parse("https://pcmcstp.stockcare.co.in/public/api/count"),
//   );
//   final Map<String, dynamic> data = jsonDecode(response.body);
//   return data;
// }

@override
class _HomePageState extends State<HomePage> {
  int pageIdx = 0;
  int currentIdx = 0;

  List Pages = [
    const Dashboard(),
    const AddStp(),
    const ReportPCMC(),
    const OfficerRegistration(),
    const AddDepartment(),
    // const ProfilePCMC(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          // context,

          backgroundColor: Colors.white,
          // controller: controler,
          currentIndex: pageIdx,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.house_fill,
                  size: 35,
                  color: Colors.green,
                ),
                label: ''),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_home_outlined,
                  size: 35,
                  color: Colors.green,
                ),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.summarize_outlined,
                  size: Dimensions.height35,
                  color: Colors.green,
                ),
                label: ''),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.app_registration,
                  size: 35,
                  color: Colors.green,
                ),
                label: ''),
            const BottomNavigationBarItem(
                icon: Icon(
                  Icons.add,
                  size: 35,
                  color: Colors.green,
                ),
                label: ''),
          ],
          onTap: (idx) {
            setState(() {
              pageIdx = idx;
            });
          },
        ),
        body: Pages[pageIdx],
      ),
    );
  }
}
