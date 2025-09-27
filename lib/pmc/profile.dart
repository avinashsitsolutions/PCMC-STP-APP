import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';

import 'package:url_launcher/url_launcher.dart';

import '../Auth/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePCMC extends StatefulWidget {
  const ProfilePCMC({super.key});

  @override
  State<ProfilePCMC> createState() => _ProfilePCMCState();
}

class _ProfilePCMCState extends State<ProfilePCMC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(15),
            ),
            width: MediaQuery.of(context).size.width,
            height: 450,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Profile",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 350,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      // ListTile(
                      //   leading: const Icon(
                      //     Icons.account_circle_outlined,
                      //     color: Colors.black,
                      //   ),
                      //   // dense: true,
                      //   visualDensity:
                      //       const VisualDensity(horizontal: 0, vertical: -3),
                      //   // contentPadding: EdgeInsets.all(0),
                      //   title: const Text("Account"),

                      //   onTap: () async {},
                      // ),
                      // ListTile(
                      //   leading: const Icon(
                      //     Icons.add,
                      //     color: Colors.black,
                      //   ),
                      //   // dense: true,
                      //   visualDensity:
                      //       const VisualDensity(horizontal: 0, vertical: -3),
                      //   // contentPadding: EdgeInsets.all(0),
                      //   title: const Text("Add Tanker Capacity"),

                      //   onTap: () async {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const AddTankerCap()));
                      //   },
                      // ),
                      ListTile(
                        leading: const Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                        // dense: true,
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -3),
                        // contentPadding: EdgeInsets.all(0),
                        title: const Text("Share"),

                        onTap: () async {
                          Share.share("https://PCMC.gov.in");
                          // Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -3),
                        leading: const Icon(
                          Icons.facebook,
                          color: Colors.black,
                        ),
                        title: const Text('Facebook'),
                        // ignore: deprecated_member_use
                        onTap: () => launch(
                            'https://www.facebook.com/PCMCPune?mibextid=ZbWKwL'),
                      ),
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -3),
                        leading: const FaIcon(
                          FontAwesomeIcons.twitter,
                          color: Colors.black,
                        ),
                        title: const Text('Twitter'),
                        onTap: () =>
                            // ignore: deprecated_member_use
                            launch('https://twitter.com/PCMCpune?lang=en'),
                      ),
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -3),
                        leading: const Icon(
                          Icons.wechat_sharp,
                          color: Colors.black,
                        ),
                        title: const Text('Whatsapp'),
                        // ignore: deprecated_member_use
                        onTap: () => launch('https://wa.me/918888251001'),
                      ),

                      ListTile(
                        leading: Image.asset('assets/Group 49.png'),
                        // dense: true,
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -3),
                        // contentPadding: EdgeInsets.all(0),
                        title: const Text("Log Out"),

                        onTap: () async {
                          final prefss = await SharedPreferences.getInstance();
                          await prefss.setString('isAuthenticated', 'false');

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              content: Text("Log Out Successfully !!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
