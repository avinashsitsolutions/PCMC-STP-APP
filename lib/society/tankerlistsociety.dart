import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:tankerpcmc/society/receiptsociety.dart';
import 'package:tankerpcmc/society/societyservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';

class TankerListSociety extends StatefulWidget {
  const TankerListSociety({
    Key? key,
    required this.list,
    required this.projectname,
    required this.capacity,
    required this.stp,
    required this.amt,
    required this.distance,
    required this.watercharges,
  }) : super(key: key);

  final List<dynamic> list;
  final String projectname;
  final String capacity;
  final String stp;
  final String amt;
  final String distance;
  final String watercharges;

  @override
  State<TankerListSociety> createState() => _TankerListSocietyState();
}

class _TankerListSocietyState extends State<TankerListSociety> {
  bool _isLoading = false;
  bool _isBookingInProgress = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late var url;
  late var url2;

  @override
  void initState() {
    super.initState();
    widget.list.isEmpty ? _isLoading = true : _isLoading = false;
  }

  Future<void> bookTanker(int index) async {
    if (_isBookingInProgress) {
      return; // Booking already in progress, do nothing
    }

    setState(() {
      _isBookingInProgress = true;
    });

    final data = widget.list[index];
    final result = await SocietyServices.OrderSociety(
        widget.projectname,
        widget.capacity,
        widget.stp,
        widget.distance,
        widget.amt,
        data['ni_owner_ful_name'].toString(),
        data['ni_tanker_capacity'].toString(),
        data['ni_contact_no'].toString(),
        data['ni_tanker_no'].toString(),
        data['ni_tanker_mo_no'].toString(),
        data['tanker_id'].toString(),
        widget.watercharges);
    if (result['error'] == false) {
      url = result['url'];
      url2 = result['url1'];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Text("Order Added Successfully !!"),
          duration: Duration(seconds: 2),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ReceiptSociety()),
      );
      final response = await http.get(Uri.parse(url));
      final response1 = await http.get(Uri.parse(url2));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text("Something went wrong. Please Try Again"),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _isBookingInProgress = false;
    });
  }

  /// ✅ Call method for Android & iOS screen not found
  Future<void> _makePhoneCall(String mob) async {
    if (Platform.isIOS) {
      // iOS → open Phone app
      final Uri url = Uri.parse("tel:$mob");
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print("❌ Could not launch dialer on iOS");
      }
    } else {
      // Android → direct call
      await FlutterPhoneDirectCaller.callNumber(mob);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(15),
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Tanker List",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              _isLoading
                  ? const Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            "No Tanker Available...",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: widget.list.length,
                        itemBuilder: (context, index) {
                          final data = widget.list[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              height: 230,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Tanker Owner Name: ${data['ni_owner_ful_name'].toString()}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Tanker Number: ${data['ni_tanker_no'].toString()}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Tanker Capacity: ${data['ni_tanker_capacity'].toString()} Liters",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Mobile No: ${data['ni_tanker_mo_no'].toString()}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            var mob = data['ni_tanker_mo_no']
                                                .toString();
                                            _makePhoneCall(mob);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.call),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Call "),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await bookTanker(index);
                                          },
                                          child: const Text("Book Tanker"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
