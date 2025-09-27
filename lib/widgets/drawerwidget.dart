import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Auth/login.dart';

class DrawerWid extends StatefulWidget {
  const DrawerWid({super.key});

  @override
  State<DrawerWid> createState() => _DrawerWidState();
}

class _DrawerWidState extends State<DrawerWid> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(child: Image.asset('assets/Group 59.png')),
            Expanded(
              child: ListView(
                children: [
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
                      Share.share(
                          "https://play.google.com/store/search?q=PCMC+stp+water+tanker&c=apps");
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
                    // ignore: deprecated_member_use
                    onTap: () => launch('https://twitter.com/PCMCpune?lang=en'),
                  ),
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -3),
                    leading: const Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.black,
                    ),
                    title: const Text('Whatsapp'),
                    // ignore: deprecated_member_use
                    onTap: () => launch('https://wa.me/+918888006666'),
                  ),
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -3),
                    leading: const Icon(
                      Icons.contact_page,
                      color: Colors.black,
                    ),
                    title: const Text('User Manual'),
                    // ignore: deprecated_member_use
                    onTap: () => launch(
                        'https://pcmcstp.stockcare.co.in/public/STP%20Project%20User%20Manual.pdf'),
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
                      await prefss.setString('token2', '');
                      // print(prefss.getString('token2'));
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                          (route) => false);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          content: Text("Log Out Successfully !!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
