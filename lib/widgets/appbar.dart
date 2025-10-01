import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Appbarwid extends StatefulWidget {
  const Appbarwid({super.key});

  @override
  State<Appbarwid> createState() => _AppbarwidState();
}

class _AppbarwidState extends State<Appbarwid> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0, // Ensures title starts from the left edge
      toolbarHeight: 150,
      centerTitle: false, // Aligns title to the left
      title: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align logo and text vertically
        children: [
          InkWell(
            onTap: () => launch('https://pcmcindia.gov.in/index.php'),
            child: const Image(
              image: AssetImage('assets/pcmc_logo.jpg'),
              height: 50,
            ),
          ),
          const SizedBox(width: 8), // Add spacing between logo and text
          Flexible(
            // Prevent text overflow
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the left
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Pimpri-Chinchwad Municipal Corporation",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 5),
                Text(
                  "Treated Water Recycle and Reuse System",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                size: 25,
                color: Colors.black,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    );
  }
}
