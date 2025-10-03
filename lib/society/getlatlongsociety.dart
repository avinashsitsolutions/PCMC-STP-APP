import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/society/dashboard_society.dart';
import 'package:tankerpcmc/society/societyservices.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../getx/controller.dart';

class Societylatlong extends StatefulWidget {
  const Societylatlong({
    super.key,
  });
  @override
  State<Societylatlong> createState() => _SocietylatlongState();
}

class _SocietylatlongState extends State<Societylatlong> {
  final latController = TextEditingController();
  final longController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late GoogleMapController mapController;
  String stpAddress = '';
  // late LocationData currentLocation;
  Marker? _marker;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool loadingButton = false;
  MapType _currentMapType = MapType.normal;
  String mb = '0';

  final formKey = GlobalKey<FormState>();

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

  Future<bool> _onWillPop() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit the app?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return false;
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    latController.clear();
    longController.clear();
    // addressController.clear();
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
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              // ignore: deprecated_member_use
              onTap: () => launch('https://pcmcindia.gov.in/index.php'),
              child: const Image(
                image: AssetImage('assets/pcmc_logo.jpg'),
                height: 50,
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "PCMC",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 5),
                Text(
                  "Treated Water Recycle and Reuse System",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
              ],
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
                            "Add a Location",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
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
                                    "Society Address :",
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
                                  const Text(
                                    "Latitude:",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: latController,
                                    onChanged: (value) =>
                                        controller.latitude.value = value,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Select Latitude From Map Below',
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
                                      if (value!.isEmpty ||
                                          value == "0.0" ||
                                          value == "0") {
                                        return 'Please enter lattitude';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Longitude:",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: longController,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          value == "0.0" ||
                                          value == "0") {
                                        return 'Please enter longitude';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) =>
                                        controller.longitude.value = value,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Select Longitude From Map Below',
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
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              );
                            }),
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
                                SocietyServices.updatelatlong(
                                        addressController.text,
                                        latController.text,
                                        longController.text)
                                    .then((data) async {
                                  if (data['error'] == false) {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                        'updatelatlong', 'true');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Project Added Successfulyy'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    nameController.clear();
                                    addressController.clear();
                                    latController.clear();
                                    longController.clear();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DashboardSociety()));
                                  } else if (data['error'] == true) {
                                    nameController.clear();
                                    addressController.clear();
                                    latController.clear();
                                    longController.clear();
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
                              'Add Location',
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
