import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/Auth/login.dart';
import 'package:tankerpcmc/TankerDriver/tankerdriverDashboard.dart';
import 'package:tankerpcmc/builder/dashboard_builder.dart';
import 'package:tankerpcmc/garage/dashboard_garage.dart';
import 'package:tankerpcmc/pmc/homepage.dart';
import 'package:tankerpcmc/pmc_newuser/dashboard.dart';
import 'package:tankerpcmc/sitemanager/managerdashboard.dart';
import 'package:tankerpcmc/society/dashboard_society.dart';
import 'package:tankerpcmc/society/getlatlongsociety.dart';
import 'package:tankerpcmc/stp/dashboard_stp.dart';
import 'package:tankerpcmc/tanker/dashboard_tanker.dart';
import 'package:tankerpcmc/wardofficer/wardofficerdashboard.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  String? mb;
  String? version;

  @override
  void initState() {
    super.initState();
    checkIsLogin(); // keep your existing navigation logic
  }

  checkIsLogin() {
    Timer(const Duration(seconds: 5), () async {
      SharedPreferences prefss = await SharedPreferences.getInstance();
      var auth = prefss.getString("isAuthenticated");
      var userType = prefss.getString("user_type");
      var latlong = prefss.getString("updatelatlong");
      var tankerowner = prefss.getString("tankerowner");

      if (auth == "true") {
        if (userType == "admin") {
          Get.off(() => const HomePage());
        } else if (userType == "Stp") {
          Get.off(() => const DashboardStp());
        } else if (userType == "Builder") {
          Get.off(() => const DashboardBuilder());
        } else if (userType == "Tanker") {
          if (tankerowner == "true") {
            Get.off(() => const DashboardTanker());
          } else {
            Get.off(() => const DashboardTankerDriver());
          }
        } else if (userType == "Society") {
          if (latlong == "true") {
            Get.off(() => const DashboardSociety());
          } else {
            Get.off(() => const Societylatlong());
          }
        } else if (userType == "Garage") {
          Get.off(() => const DashboardGarage());
        } else if (userType == "Manager") {
          Get.off(() => const DashboardManager());
        } else if (userType == "Wardofficer") {
          Get.off(() => const DashboardWardOfficer());
        } else if (userType == "PCMC") {
          Get.off(() => const DashboardPCMCUSER());
        }
      } else {
        Get.off(() => const Login());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Responsive sizes using GetX
    double screenHeight = Get.height;
    double screenWidth = Get.width;

    double padding20 = screenHeight * 0.025;
    double imageSmall = screenWidth * 0.20;
    double imageLarge = screenWidth * 0.35;
    double font20 = screenHeight * 0.025;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔹 Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: padding20, left: 10),
                    child: Image.asset(
                      "assets/pcmc_logo.jpg",
                      width: imageSmall,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: padding20, right: 10),
                    child: Image.asset(
                      "assets/bharat.png",
                      width: imageSmall * 0.9,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              // 🔹 Center Logo + Text
              Column(
                children: [
                  Image.asset(
                    "assets/TWRRS.png",
                    width: imageLarge,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Pimpri-Chinchwad Municipal Corporation",
                    style: TextStyle(
                      fontSize: font20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),

              // 🔹 Bottom Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/swachha.jpg",
                    width: imageSmall,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    child: Image.asset(
                      "assets/vasundhara.jpg",
                      width: imageSmall * 1.2,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
