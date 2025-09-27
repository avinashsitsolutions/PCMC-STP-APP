import 'package:flutter/material.dart';

class Dashcount extends StatefulWidget {
  const Dashcount({super.key});

  @override
  State<Dashcount> createState() => _DashcountState();
}

class _DashcountState extends State<Dashcount> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                SizedBox(
                  height: 3,
                ),
                Text(
                  "72 ",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "Active Tanker",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
            child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                SizedBox(
                  height: 3,
                ),
                Text(
                  "72 ",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "Active Tanker",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}
