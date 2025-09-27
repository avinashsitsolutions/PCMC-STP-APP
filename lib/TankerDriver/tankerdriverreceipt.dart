// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class ImageSaveResult {
  final bool isSuccess;
  final String message;

  ImageSaveResult({required this.isSuccess, required this.message});
}

class TankerDriverReceipt extends StatefulWidget {
  const TankerDriverReceipt({Key? key}) : super(key: key);

  @override
  State<TankerDriverReceipt> createState() => _TankerDriverReceiptState();
}

class _TankerDriverReceiptState extends State<TankerDriverReceipt> {
  GlobalKey globalKey = GlobalKey();
  List<dynamic> _dataList = [];
  ImageSaveResult result = ImageSaveResult(
      isSuccess: false, message: ''); // Initialize result variable
  bool check = false;
  bool _isCompletedSelected = false;
  bool _isPendingSelected = false;
  bool isLoading = false;
  Future getAllorder() async {
    setState(() {
      isLoading = true;
    });
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    // print(token);
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/show_tanker_orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    var data = json.decode(response.body);
    if (data['error'] == true) {
      check = true;
      setState(() {
        _dataList = data['data'];
      });
    } else {
      setState(() {
        _dataList = data['data'];
      });
    }

    setState(() {
      isLoading = false;
    });
    return data;
  }

  String getGoogleMapsUrl(
      double originLat, double originLng, double destLat, double destLng) {
    const apiKey = 'AIzaSyD9XZBYlnwfrKQ1ZK-EUxJtFePKXW_1sfE';
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLng&destination=$destLat,$destLng&key=$apiKey';
    return url;
  }

// https://www.google.com/maps/dir/?api=1&origin=18.6422,73.748&destination=18.629821046666656,73.79543323069811&key=AIzaSyD9XZBYlnwfrKQ1ZK-EUxJtFePKXW_1sfE
  bool isSnackbarVisible = false;
  bool status1 = false;
  Future getPendingorder() async {
    setState(() {
      isLoading = true;
    });
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    // print(token);
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/show_tanker_orders_pending_new'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    var data = json.decode(response.body);
    if (data['error'] == true) {
      check = true;
      setState(() {
        _dataList = data['data'];
      });
    } else {
      setState(() {
        _dataList = data['data'];
      });
    }

    setState(() {
      isLoading = false;
    });
    return data;
  }

  Future cancelorder(String id) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/tanker_cancel_order'),
      body: {
        'id': id,
      },
    );
    var data = json.decode(response.body);
    setState(() {
      isLoading = false;
    });
    return data;
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

// Check if storage permission is granted
  Future<bool> checkStoragePermission() async {
    var status = await Permission.storage.status;
    return status == PermissionStatus.granted;
  }

  Future<void> _captureAndSave(GlobalKey itemKey) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      RenderRepaintBoundary? boundary =
          itemKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null && boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
      if (boundary != null) {
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();

          final directory = await getExternalStorageDirectory();
          String filePath =
              '${directory!.path}/list_item_${DateTime.now().millisecondsSinceEpoch}.png';

          File file = File(filePath);
          await file.writeAsBytes(pngBytes);
          ImageSaveResult result = ImageSaveResult(
              isSuccess: true, message: 'Image saved successfully');
          // var result = await ImageGallerySaver.saveFile(filePath);

          // ignore: unnecessary_null_comparison
          if (result != null) {
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Image Saved'),
                  content: Text('The image has been saved to the gallery.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Share'),
                      onPressed: () {
                        _shareImage(filePath);
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error Saving Image'),
                  content: Text('Failed to save the image. Please try again.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error Capturing Image'),
                content: Text('Failed to capture the image. Please try again.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  void _shareImage(String imagePath) {
    // ignore: deprecated_member_use
    Share.shareFiles([imagePath]);
  }

  @override
  void initState() {
    super.initState();
    getPendingorder();
    _isCompletedSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(15),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "New Order Receipt",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<bool?>(
                        value: true,
                        groupValue: _isCompletedSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCompletedSelected = value!;
                            _isPendingSelected = false;
                            getPendingorder();
                          });
                        },
                      ),
                      Text('On Going'),
                      SizedBox(width: 20),
                      Radio<bool?>(
                        value: true,
                        groupValue: _isPendingSelected,
                        onChanged: (value) {
                          setState(() {
                            _isPendingSelected = value!;
                            _isCompletedSelected = false;
                            getAllorder();
                          });
                        },
                      ),
                      Text('Completed'),
                    ],
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : _dataList.isEmpty
                          ? Text('No data available')
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _dataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final data = _dataList[index];
                                String dateString = data['created_at'];
                                final projectLat = double.tryParse(
                                        data["ni_project_lat"] ??
                                            data["ni_society_lat"]) ??
                                    0.0;
                                final projectLong = double.tryParse(
                                        data["ni_project_long"] ??
                                            data["ni_society_long"]) ??
                                    0.0;
                                final stpLat = double.tryParse(
                                        data["ni_stp_lat"] ?? "0.0") ??
                                    0.0;
                                final stpLong = double.tryParse(
                                        data["ni_stp_long"] ?? "0.0") ??
                                    0.0;

                                DateTime date = DateTime.parse(dateString);
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(date);
                                var status = data['status'].toString();
                                GlobalKey itemKey = GlobalKey();
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RepaintBoundary(
                                    key: itemKey,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                                child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Image.asset(
                                                'assets/pcmc_logo.jpg',
                                                scale: 0.3,
                                              ),
                                            )),
                                            // if (_isCompletedSelected == true)
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.all(8.0),
                                            //   child: ElevatedButton(
                                            //       onPressed: () {
                                            //         Navigator.push(
                                            //             context,
                                            //             MaterialPageRoute(
                                            //                 builder: (context) =>
                                            //                     const MapRoute()));
                                            //         // _captureAndSave(itemKey);
                                            //         // _shareImage(itemKey);
                                            //       },
                                            //       child: Text("View Map")),
                                            // ),

                                            QrImageView(
                                              data: data['id'].toString(),
                                              version: QrVersions.auto,
                                              size: 100.0,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "Reciept No:",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "STP/2023/${data['id'].toString()}",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "STP Name:",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data['ni_nearest_stp']
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        17),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "Water Capacity:",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${data['ni_tanker_capacity'].toString()} Liters",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "Tanker No:",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data['ni_tanker_no']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "Distance:",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${data['ni_distance']}Km",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "Amount:",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "₹${data['ni_estimated_amount']}",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "Order Date:",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            formattedDate,
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "Address:",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            data['address']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "Status:",
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (status
                                                                  .toString() ==
                                                              "false")
                                                            Text(
                                                              "Pending",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                          if (status
                                                                  .toString() ==
                                                              "null")
                                                            Text(
                                                              "Cancelled",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 17),
                                                            ),
                                                          if (status
                                                                  .toString() ==
                                                              "true")
                                                            Text(
                                                              "Complete",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                if (status == "false")
                                                  Visibility(
                                                    visible: !isSnackbarVisible,
                                                    child: ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors.red),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          isSnackbarVisible =
                                                              true;
                                                        });
                                                        cancelorder(data['id']
                                                            .toString());
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                              SnackBar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                content: Text(
                                                                    "Order Cancelled Successfully"),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            )
                                                            .closed
                                                            .then((_) {
                                                          setState(() {
                                                            isSnackbarVisible =
                                                                false;
                                                          });
                                                        });
                                                      },
                                                      child: Text("Cancel"),
                                                    ),
                                                  ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Divider(
                                                  height: 1,
                                                  color: Colors.black,
                                                  indent: 120,
                                                  endIndent: 120,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (status.toString() == "false")
                                          Positioned(
                                            right: 10,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                String googleMapsUrl =
                                                    getGoogleMapsUrl(
                                                  stpLat,
                                                  stpLong,
                                                  projectLat,
                                                  projectLong,
                                                );
                                                // ignore: deprecated_member_use
                                                launch(googleMapsUrl);

                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         MapRoute(
                                                //       startlocation: LatLng(
                                                //           double.parse(
                                                //               projectLong),
                                                //           double.parse(
                                                //               projectLat)),
                                                //       endlocation: LatLng(
                                                //           double.parse(stpLat),
                                                //           double.parse(stpLong)),
                                                //     ),
                                                //   ),
                                                // );
                                              },
                                              child: Row(
                                                children: const [
                                                  Text("Route"),
                                                  Icon(Icons.location_on)
                                                ],
                                              ),
                                            ),
                                          ),
                                      ]),
                                    ),
                                  ),
                                );
                              },
                            ),
                ],
              )),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
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
