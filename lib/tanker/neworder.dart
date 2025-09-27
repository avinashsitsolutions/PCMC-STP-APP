// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:io';
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

class NewOrder extends StatefulWidget {
  const NewOrder({Key? key}) : super(key: key);

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  GlobalKey globalKey = GlobalKey();
  List<dynamic> _dataList = [];
  // Map<String, dynamic> result = {};
  late ImageSaveResult result;
  bool check = false;
  bool _isCompletedSelected = false;
  bool _isPendingSelected = false;
  bool isLoading = false;
  Future getAllorder() async {
    setState(() {
      isLoading = true;
    });
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.post(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/tanker_owner_orders_recipt_completed'),
      body: {
        "id": id.toString(),
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

  var status;
  Future getPendingorder() async {
    setState(() {
      isLoading = true;
    });
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    print(id);
    final response = await http.post(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/tanker_owner_orders_recipt_new'),
      body: {
        "id": id.toString(),
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

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

// Check if storage permission is granted
  Future<bool> checkStoragePermission() async {
    var status = await Permission.storage.status;
    return status == PermissionStatus.granted;
  }

  Future<void> _captureAndSave(GlobalKey itemKey, BuildContext context) async {
    // var storagePermissionGranted = await checkStoragePermission();
    // if (!storagePermissionGranted) {
    //   var requestedPermission = await requestStoragePermission();
    //   if (!requestedPermission) {
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text('Permission Denied'),
    //           content: Text('Unable to save image without storage permission.'),
    //           actions: <Widget>[
    //             TextButton(
    //               child: Text('OK'),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //     return;
    //   }
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        RenderRepaintBoundary? boundary = itemKey.currentContext
            ?.findRenderObject() as RenderRepaintBoundary?;
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

            if (result != null && result.isSuccess) {
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error Saving Image'),
                    content:
                        Text('Failed to save the image. Please try again.'),
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
            throw Exception('Failed to capture image. ByteData is null.');
          }
        } else {
          throw Exception('RenderRepaintBoundary is null or needs paint.');
        }
      } catch (e, stackTrace) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'An error occurred while capturing and saving the image.'),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _captureAndSave();
      //   },
      //   child: Icon(Icons.save),
      // ),
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
              // height: MediaQuery.of(context).size.height,
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
                                DateTime date = DateTime.parse(dateString);
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(date);
                                status = data['status'];
                                // final String status = "false";
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
                                      // height: MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
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
                                          //   ElevatedButton(
                                          //       onPressed: () {
                                          //         _captureAndSave(
                                          //             itemKey, context);
                                          //         // _shareImage(itemKey);
                                          //       },
                                          //       child: Icon(Icons
                                          //           .screen_share_outlined)),
                                          SizedBox(
                                            height: 10,
                                          ),
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
                                                          "${data['ni_distance'].toString()}Km",
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
                                                          "₹${data['ni_estimated_amount'].toString()}",
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
                                                          formattedDate
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
                                                        if (status.toString() ==
                                                            "false")
                                                          Text(
                                                            "Pending",
                                                            style: TextStyle(
                                                                fontSize: 17),
                                                          ),
                                                        if (status.toString() ==
                                                            "null")
                                                          Text(
                                                            "Cancelled",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 17),
                                                          ),
                                                        if (status.toString() ==
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
