import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/builder/builderservices.dart';
import 'package:tankerpcmc/pmc/gmap.dart';
import 'package:tankerpcmc/pmc_newuser/tankerlist.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tankerpcmc/widgets/internet.dart';

class OrderTankerPCMC extends StatefulWidget {
  const OrderTankerPCMC({
    super.key,
  });
  @override
  State<OrderTankerPCMC> createState() => _OrderTankerPCMCState();
}

class _OrderTankerPCMCState extends State<OrderTankerPCMC> {
  LatLng? start;
  LatLng? end;
  String? Projectname;
  double liter = 0;
  double result = 0;
  // ignore: prefer_typing_uninitialized_variables
  var lat1;
  // ignore: prefer_typing_uninitialized_variables
  var lat2;
  // ignore: prefer_typing_uninitialized_variables
  var long1;
  // ignore: prefer_typing_uninitialized_variables
  var long2;
  var distance = "0";
  TextEditingController stpController = TextEditingController();
  // final directions =
  //     GoogleMapsDirections(apiKey: 'AIzaSyD9XZBYlnwfrKQ1ZK-EUxJtFePKXW_1sfE');
  List categoryItemlist = [];
  List categoryItemlist1 = [];
  List categoryItemlist2 = [];
  bool hasData = true;
  bool loadingkm = true;

  Future getAllproject() async {
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    var id = prefss.getString("PCMC_user_id");
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/project_name?userId=$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    var jsonData = json.decode(response.body);
    categoryItemlist1 = jsonData['data'];
    if (jsonData['data'].isEmpty) {
      hasData = false;
    } else {
      hasData = true;
    }
    setState(() {});
    return categoryItemlist1;
    // print(categoryItemlist1);
  }

  Future getAllcap() async {
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/water_capacity'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    var jsonData = json.decode(response.body);
    // print(jsonData);
    // setState(() {
    categoryItemlist2 = jsonData['data'];
    setState(() {});
    // });
    // print(categoryItemlist2);
  }

  static stplatlong(String stpname) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/stp_location?ni_stp_name=$stpname'),
    );

    var data = json.decode(response.body);

    // print(data);
    return data;
  }

  // projectname() async {
  //   final prefss = await SharedPreferences.getInstance();
  //   var id = prefss.getString("manager_id");
  //   final response = await http.get(
  //     Uri.parse('https://pcmcstp.stockcare.co.in/public/api/site_project_name?id=$id'),
  //   );

  //   var data = json.decode(response.body);
  //   categoryItemlist1 = data['data'];
  //   if (data['data'].isEmpty) {
  //     hasData = false;
  //   } else {
  //     hasData = true;
  //   }
  //   setState(() {});
  //   return categoryItemlist1;
  // }

  static Projlatlong(String projectname) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/project_location?ni_project_name=$projectname'),
    );

    var data = json.decode(response.body);
    return data;
  }

  Future Projectkm(String projectname) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/stp_distance?ni_project_name=$projectname'),
    );

    var data = json.decode(response.body);
    categoryItemlist = data['data'];
    loadingkm = false;
    // if (data != null) {
    //   for (var i = 0; i < data['data'].length; i++) {
    //     categoryItemlist.add(data['data'][i]['stp_name'].toString());
    //   }
    //   setState(() {});
    // }
    return data;
  }

  LatLng coordinate1 = const LatLng(37.4219999, -122.0840575);
  LatLng coordinate2 = const LatLng(37.4219999, -122.0840575);

  double distanceBetween(LatLng coordinate1, LatLng coordinate2) {
    return Geolocator.distanceBetween(
      coordinate1.latitude,
      coordinate1.longitude,
      coordinate2.latitude,
      coordinate2.longitude,
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var dropdownvalue;
  // ignore: prefer_typing_uninitialized_variables
  var dropdownvalue1;
  // ignore: prefer_typing_uninitialized_variables
  var dropdownvalue2;
  // ignore: prefer_typing_uninitialized_variables
  var url;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    InternetConnection();
    // getAllstp();
    getAllproject();
    // projectname();
    getAllcap();
    // projectname().then((data) {
    //   nameController.text = data['data'][0]['ni_project_name'];
    // });
  }

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green[50],
                ),
                height: 400,
                width: 380,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Order Tanker",
                              style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text.rich(
                            TextSpan(
                              text: "Project Name ",
                              children: [
                                TextSpan(
                                  text: "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            width: 300,
                            child: GestureDetector(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Select a Project Name',
                                  border: InputBorder.none,
                                ),
                                value: dropdownvalue1,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  backgroundColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                dropdownColor: Colors.white,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.green,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select an option';
                                  }
                                  return null;
                                },
                                onChanged: (newVal) {
                                  loadingkm = true;
                                  setState(() {
                                    dropdownvalue1 = newVal;
                                  });
                                  // setState(() {
                                  //   projectname().then((data) {
                                  //     loadingkm = false;
                                  //   });
                                  // });
                                  setState(() {
                                    Projectkm(dropdownvalue1).then((data) {
                                      loadingkm = false;
                                    });
                                  });

                                  Projlatlong(dropdownvalue1).then((data) {
                                    lat1 = double.parse(data['lat']);
                                    long1 = double.parse(data['long']);
                                  });
                                },
                                items: categoryItemlist1.map((item) {
                                  return DropdownMenuItem(
                                    value: item['ni_project_name'].toString(),
                                    child: Text(
                                        item['ni_project_name'].toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text.rich(
                            TextSpan(
                              text: "Required Water ",
                              children: [
                                TextSpan(
                                  text: "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                color: Colors.white),
                            width: 300,
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                hintText: 'Select Water Capacity',
                                border: InputBorder.none,
                              ),
                              value: dropdownvalue2,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                backgroundColor: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select an option';
                                }
                                return null;
                              },
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.green,
                              ),
                              onChanged: (newVal) {
                                setState(() {
                                  dropdownvalue2 = newVal;
                                });
                                String input = dropdownvalue2;
                                RegExp regex = RegExp(r'\d+');
                                String? result1 = regex.stringMatch(input);
                                // liter = result;
                                liter = double.parse(result1.toString());
                              },
                              items: categoryItemlist2.map((item) {
                                return DropdownMenuItem(
                                  value: item['ni_water_capacity'].toString(),
                                  child: Text(
                                      "${item['ni_water_capacity'].toString()} Liters"),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text.rich(
                            TextSpan(
                              text: "Choose STP ",
                              children: [
                                TextSpan(
                                  text: "*",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                ),
                                color: Colors.white),
                            width: 300,
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                hintText: "Select An STP",
                                border: InputBorder.none,
                              ),
                              value: dropdownvalue,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                backgroundColor: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select an option';
                                }
                                return null;
                              },
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors
                                    .green, // Set the desired color of the icon
                              ),
                              onChanged: (newVal) {
                                setState(() {
                                  dropdownvalue = newVal;
                                });
                                setState(() {});
                                stplatlong(dropdownvalue).then((data) {
                                  lat2 = double.parse(data['lat']);
                                  long2 = double.parse(data['long']);

                                  coordinate1 = LatLng(
                                      lat1, long1); // Example coordinates
                                  coordinate2 = LatLng(lat2, long2);
                                  double distanceInMeters =
                                      distanceBetween(coordinate1, coordinate2);
                                  double distanceInKilometers =
                                      distanceInMeters / 1000;
                                  distance = distanceInKilometers.toString();
                                  // print(distanceInKilometers);
                                  result = Builderservices().calculateCost(
                                      distanceInKilometers, liter);
                                  // print(result);
                                  setState(() {});
                                  //     _locationController1 =
                                  //     Get.put(Location2Controller());

                                  // _locationController1.setLocationDetails2(
                                  //     data['lat'].toString(),
                                  //     data['long'].toString());
                                });
                              },
                              items: categoryItemlist.map((item) {
                                return DropdownMenuItem(
                                  value: item['stp_name'].toString(),
                                  child: Text(
                                      "${item['stp_name'].toString()} (${item['distance'].toString()} Km)"),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20.0),
                                      right: Radius.circular(20.0),
                                    ),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(150, 35)),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (result != 0 && distance != 0) {
                                    Builderservices.tankerlist(
                                      dropdownvalue2,
                                      dropdownvalue,
                                    ).then((data) {
                                      if (data['error'] == false) {
                                        // setState(() {
                                        //   _isLoading = false;
                                        // });
                                        List<dynamic> list = data['tanker'];
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TankerListPCMC(
                                                      list: list,
                                                      amt: result
                                                          .toInt()
                                                          .toString(),
                                                      capacity: dropdownvalue2,
                                                      distance:
                                                          double.parse(distance)
                                                              .toInt()
                                                              .toString(),
                                                      projectname:
                                                          dropdownvalue1,
                                                      stp: dropdownvalue,
                                                    )));
                                      }
                                    });
                                  }
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Distance Between :${double.parse(distance).toInt()} Km",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Estimate Amount: ₹${double.parse(result.toString()).toInt()} ",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Mapline(
                              endlocation: coordinate2,
                              startlocation: coordinate1,
                            )));
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Check distance on Map'),
            )
          ],
        ),
      ),
    );
  }
}
