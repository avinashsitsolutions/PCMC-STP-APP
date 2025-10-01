import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tankerpcmc/getx/controller.dart';
import 'package:tankerpcmc/pmc/homepage.dart';
import 'package:tankerpcmc/pmc/pmcservices.dart';
import 'package:tankerpcmc/widgets/dimensions.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class AddStp extends StatefulWidget {
  const AddStp({super.key});

  @override
  State<AddStp> createState() => _AddStpState();
}

class _AddStpState extends State<AddStp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactnameController = TextEditingController();
  TextEditingController mobnoController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

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
    mobnoController.dispose();
    usernameController.clear();
    latController.dispose();
    longController.dispose();
    nameController.dispose();
    contactnameController.dispose();
    addressController.dispose();

    super.dispose();
  }

  void _clearTextField() {
    mobnoController.clear();
    usernameController.clear();
    latController.clear();
    longController.clear();
    nameController.clear();
    contactnameController.clear();
    addressController.clear();
    passwordController.clear();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                // ignore: deprecated_member_use
                onTap: () => launch('https://www.pmc.gov.in/mr?main=marathi'),
                child: const Image(
                  image: AssetImage('assets/pcmc_logo.jpg'),
                  height: 50,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pimpri-Chinchwad Municipal Corporation",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Treated Water Recycle and Reuse System",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
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
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "Add STP Center",
                  style: TextStyle(
                      fontSize: 21,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
                          const Text(
                            "STP Name :",
                            style: TextStyle(
                                fontSize: 18,
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
                              hintText: 'Enter STP Name',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              isDense: true,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter STP Name';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "STP  User Name :",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: usernameController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Enter STP  User Name',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              isDense: true,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter STP User Name';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Password:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Password',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.only(bottom: 4.0),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Confirm Password:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: confirmpasswordController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Confirm Password',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.only(bottom: 4.0),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Confirm Password';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Contact Persons Name:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: contactnameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Name',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.only(bottom: 4.0),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Name';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Contact Number:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            maxLength: 10,
                            controller: mobnoController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Number',
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.only(bottom: 4.0),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 10) {
                                return 'Please Enter Contact No';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GetBuilder<LocationController>(
                              init: LocationController(),
                              builder: (controller) {
                                latController.text = controller.latitude.value;
                                longController.text =
                                    controller.longitude.value;
                                addressController.text =
                                    controller.address.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "STP Address:",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      controller: addressController,
                                      onChanged: (value) =>
                                          controller.address.value = value,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter Address',
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding:
                                            EdgeInsets.only(bottom: 4.0),
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
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
                                          return 'Please Enter Address';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Lattitude:",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: latController,
                                              onChanged: (value) => controller
                                                  .latitude.value = value,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter Lattitude',
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 4.0),
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Enter Lattitude';
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Longitude:",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: longController,
                                              onChanged: (value) => controller
                                                  .longitude.value = value,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter Longitude',
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 4.0),
                                                hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Enter Longitude';
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              }),
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (passwordController.text ==
                                      confirmpasswordController.text) {
                                    PCMCservices.addstp(
                                      nameController.text,
                                      usernameController.text,
                                      addressController.text,
                                      contactnameController.text,
                                      mobnoController.text,
                                      passwordController.text,
                                      latController.text,
                                      longController.text,
                                    ).then((data) {
                                      if (data['error'] == false) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(
                                                "STP Registered Successfully !!"),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Choose an option"),
                                              content: const Text(
                                                  "Do you want to add another STP?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HomePage()));
                                                    _clearTextField();
                                                  },
                                                  child: const Text(
                                                      "Back to Home"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    _clearTextField();
                                                  },
                                                  child: const Text(
                                                      "Add Another STP"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(data['message']),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Check your Password and Confirm Password"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                'Add STP',
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
                height: Dimensions.height500,
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
      ),
    );
  }
}
