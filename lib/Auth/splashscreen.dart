import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/Auth/authservices.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'internet_connection.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  String? mb;
  String? version;
  Future<bool> checkAppUpdateStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool updated = prefs.getBool('appUpdated') ?? false;
    return updated;
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
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (userType == "Stp") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const DashboardStp()));
        } else if (userType == "Builder") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardBuilder()));
        } else if (userType == "Tanker") {
          if (tankerowner == "true") {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardTanker()));
          } else {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardTankerDriver()));
          }
        } else if (userType == "Society") {
          if (latlong == "true") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardSociety()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Societylatlong()));
          }
          // ignore: use_build_context_synchronously
        } else if (userType == "Garage") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const DashboardGarage()));
        } else if (userType == "Manager") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardManager()));

          //   // ignore: use_build_context_synchronously
          //   Navigator.pushReplacement(context,
          //       MaterialPageRoute(builder: (context) => const AddProject1()));
          // }
          // ignore: use_build_context_synchronously
        } else if (userType == "Wardofficer") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardWardOfficer()));
        } else if (userType == "PCMC") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardPCMCUSER()));
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    });
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.location,
      Permission.camera,
      Permission.phone,
    ].request();

    bool allGranted = status[Permission.location]!.isGranted &&
        status[Permission.camera]!.isGranted &&
        status[Permission.phone]!.isGranted;

    return allGranted;
  }

  Future<void> checkAndUpdateAppVersion() async {
    Authservices.update().then((data) {
      if (data['error'] == "false") {
        version = data['data'][0]['version'];
      }
    });
    final String latestVersion = version.toString();
    final String currentVersion = Platform.version.split(' ')[0];
    // Compare versions
    if (currentVersion.compareTo(latestVersion) < 0) {
      // Show an update dialog
      InAppUpdate.checkForUpdate().then((updateInfo) {
        if (updateInfo.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          if (updateInfo.immediateUpdateAllowed) {
            // Perform immediate update
            InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
              if (appUpdateResult == AppUpdateResult.success) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text(
                        'App Update Successful',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      content: const Text(
                        'Please reopen the app to load the updated version.',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      actions: [
                        ElevatedButton(
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            // Close the app
                            SystemNavigator.pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            });
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text(
                    'App Update Required',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  content: const Text(
                    'Please update the app to continue.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  actions: [
                    Row(
                      children: [
                        ElevatedButton(
                          child: const Text(
                            'Update Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            // Open the Google Play Store link
                            // ignore: deprecated_member_use
                            launch(
                                'https://play.google.com/store/search?q=PCMC+stp+water+tanker&c=apps&pli=1');
                          },
                        ),
                        ElevatedButton(
                          child: const Text(
                            'Exit',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            // Close the app
                            SystemNavigator.pop();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
        }
      });
    }
  }

  void showPermissionErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Permission Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: const Text(
            'Please grant the required permissions.',
            style: TextStyle(fontSize: 16.0),
          ),
          actions: [
            ElevatedButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkPermissions() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasPermissions = await requestPermissions();
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => InternetConnectivityScreen()));
    }
    if (connectivityResult == ConnectivityResult.none) {
    } else if (!hasPermissions) {
      showPermissionErrorDialog(context);
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    // checkAndUpdateAppVersion();
    checkIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  child: Image.asset("assets/pcmc_logo.jpg", scale: 4),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 10),
                  child: Image.asset("assets/bharat.png", scale: 7),
                ),
              ],
            ),
            Column(
              children: [
                Image.asset("assets/TWRRS.png", scale: 6),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Pimpri-Chinchwad Municipal Corporation",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/swachha.jpg", scale: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 10),
                  child: Image.asset("assets/vasundhara.jpg", scale: 5),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
