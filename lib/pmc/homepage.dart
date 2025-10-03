import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _HomePageState extends State<HomePage> {
  int pageIdx = 0;

  final List Pages = [
    const Dashboard(),
    const AddStp(),
    const ReportPCMC(),
    const OfficerRegistration(),
    const AddDepartment(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // ✅ white status bar
        statusBarIconBrightness: Brightness.dark, // ✅ Android dark icons
        statusBarBrightness: Brightness.light, // ✅ iOS dark icons
      ),
      child: Scaffold(
        backgroundColor: Colors.white, // ✅ fixes iOS black background issue
        extendBody: true, // ✅ allows body color to flow under status bar
        body: Pages[pageIdx],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white, // ✅ no black strip on iOS
          type: BottomNavigationBarType.fixed,
          currentIndex: pageIdx,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house_fill, size: 30),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_home_outlined, size: 30),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize_outlined, size: Dimensions.height35),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.app_registration, size: 30),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add, size: 30),
              label: '',
            ),
          ],
          onTap: (idx) {
            setState(() {
              pageIdx = idx;
            });
          },
        ),
      ),
    );
  }
}
