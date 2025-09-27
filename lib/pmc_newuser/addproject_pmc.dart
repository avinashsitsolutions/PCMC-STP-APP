import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tankerpcmc/pmc_newuser/dashboard.dart';
import 'package:tankerpcmc/pmc_newuser/services.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';

import '../getx/controller.dart';

class AddProjectPCMC extends StatefulWidget {
  const AddProjectPCMC({super.key});

  @override
  State<AddProjectPCMC> createState() => _AddProjectPCMCState();
}

class _AddProjectPCMCState extends State<AddProjectPCMC> {
  final latController = TextEditingController();
  final longController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var dropdownvalue;
  List<Map<String, dynamic>> categoryItemlist1 = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController inchargenameController = TextEditingController();
  TextEditingController inchargenumberController = TextEditingController();
  late GoogleMapController mapController;
  String stpAddress = '';
  // late LocationData currentLocation;
  Marker? _marker;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool hasData = true;
  bool loadingButton = false;
  MapType _currentMapType = MapType.normal;
  String mb = '0';

  final formKey = GlobalKey<FormState>();
  Future<List<Map<String, dynamic>>> cdepartmentname() async {
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/view_department'),
    );

    var data = json.decode(response.body);

    if (data['error'] == false) {
      categoryItemlist1 = List<Map<String, dynamic>>.from(data['data']);
    } else {}

    return categoryItemlist1;
  }

  checkLocationIsEnabledOrNot() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      Geolocator.openLocationSettings();
      return false;
    } else {
      // _getCurrentPosition();
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    latController.clear();
    longController.clear();
    cdepartmentname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.map_sharp),
        onPressed: () {
          setState(() {
            if (_currentMapType == MapType.satellite) {
              _currentMapType = MapType.normal;
            } else if (_currentMapType == MapType.normal) {
              _currentMapType = MapType.satellite;
            }
          });
        },
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green[50],
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Add a Project",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Project Name :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Project Name',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 17.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Department Name :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
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
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: cdepartmentname(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const LinearProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    hintText: 'Select a Project Name',
                                    border: InputBorder.none,
                                  ),
                                  value: dropdownvalue,
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
                                    setState(() {
                                      dropdownvalue = newVal;
                                    });
                                  },
                                  items: snapshot.data!.map((item) {
                                    return DropdownMenuItem(
                                      value: item['department_name'].toString(),
                                      child: Text(
                                          item['department_name'].toString()),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GetBuilder<LocationController>(
                            init: LocationController(),
                            builder: (controller) {
                              // print(latController.text);
                              // print(longController.text);
                              latController.text = controller.latitude.value;
                              longController.text = controller.longitude.value;
                              addressController.text = controller.address.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Project Address :",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: addressController,
                                    onChanged: (value) =>
                                        controller.address.value = value,
                                    decoration: const InputDecoration(
                                      hintText: 'Select Address From Map Below',
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding:
                                          EdgeInsets.only(bottom: 4.0),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter Address';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Incharge Name:",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: inchargenameController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Incharge Name',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return 'Please enter Name';
                          //   }
                          //   return null;
                          // },
                          style: const TextStyle(
                            fontSize: 17.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Incharge Mobile Number:",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLength: 10,
                          controller: inchargenumberController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Incharge Mobile Number',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return 'Please enter Number';
                          //   }
                          //   return null;
                          // },
                          style: const TextStyle(
                            fontSize: 17.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // print(nameController.text);
                                // print(dropdownvalue);
                                // print(addressController.text);
                                // print(latController.text);
                                // print(longController.text);
                                // print(inchargenameController.text);
                                // print(inchargenumberController.text);
                                Services.AddProjectPCMC(
                                        nameController.text,
                                        dropdownvalue,
                                        addressController.text,
                                        latController.text,
                                        longController.text,
                                        inchargenameController.text,
                                        inchargenumberController.text)
                                    .then((data) async {
                                  if (data['error'] == false) {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Project Added Successfulyy'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DashboardPCMCUSER()));
                                  } else if (data['error'] == true) {
                                    nameController.clear();
                                    addressController.clear();
                                    latController.clear();
                                    longController.clear();
                                    inchargenameController.clear();
                                    inchargenumberController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(data['message']),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
                                    nameController.clear();
                                    addressController.clear();
                                    latController.clear();
                                    longController.clear();
                                    inchargenameController.clear();
                                    inchargenumberController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Something Went Wrong'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                            child: const Text(
                              'Add Project',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
                alignment: Alignment.center,
                color: Colors.green,
                height: 50,
                child: const Text('Google Map',
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
            SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                mapType: _currentMapType,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(18.628197028586005, 73.80619029626678),
                  zoom: 14.0,
                ),
                gestureRecognizers: Set()
                  ..add(Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer()))
                  ..add(Factory<PanGestureRecognizer>(
                      () => PanGestureRecognizer()))
                  ..add(Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer()))
                  ..add(Factory<TapGestureRecognizer>(
                      () => TapGestureRecognizer()))
                  ..add(Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer())),
                // double distance = await Geolocator.distanceBetween(
                //     18.487500, 73.857023, 18.4864727, 73.79683399999999);
                // print('Distance: $distance meters');
                markers: Set.of(_marker != null ? [_marker!] : []),
                onTap: (LatLng latLng) async {
                  final LocationController locationController =
                      Get.put(LocationController());

                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      latLng.latitude, latLng.longitude);

                  Placemark place1 = placemarks[0];
                  Placemark place2 = placemarks[2];

                  locationController.setLocationDetails(
                      latLng.latitude,
                      latLng.longitude,
                      "${place1.name},${place2.name},${place1.subLocality},${place1.locality},${place1.administrativeArea},${place1.postalCode}");

                  setState(() {});
                  _markers.remove(_marker);

                  setState(() {
                    _marker = Marker(
                      markerId: const MarkerId('currentMarker'),
                      position: latLng,
                      draggable: true,
                      onDragEnd: (LatLng newPosition) async {
                        // double latitude = newPosition.latitude;
                        // double longitude = newPosition.longitude;

                        setState(() {
                          _marker =
                              _marker!.copyWith(positionParam: newPosition);
                        });
                      },
                    );
                    _markers.add(_marker!);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
