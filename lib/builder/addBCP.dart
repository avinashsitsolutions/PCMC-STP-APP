import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
//import 'package:multiselect/multiselect.dart';
import 'package:tankerpcmc/builder/builderservices.dart';
import 'package:tankerpcmc/builder/dashboard_builder.dart';
import 'package:tankerpcmc/widgets/dropdown_multiselect.dart';
import '../getx/controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';

class AddBCP extends StatefulWidget {
  const AddBCP({super.key});

  @override
  State<AddBCP> createState() => _AddBCPState();
}

class _AddBCPState extends State<AddBCP> {
  TextEditingController bcpController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  late GoogleMapController mapController;
  String stpAddress = '';
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController managernameController = TextEditingController();
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
    } else {}
  }

  bool _isLoading = true;
  Future getbuilder() async {
    _isLoading = true;
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/water_type'),
    );
    var data = json.decode(response.body);
    if (data['error'] == false) {
      setState(() {
        fruits = data['data'];

        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Random random = Random();
  List<dynamic> fruits = [];
  List<dynamic> selectedFruits = [];
  final _formKey = GlobalKey<FormState>();
  String getStpNameById(int id) {
    // Assuming 'fruits' is the list containing the STP data
    var stp = fruits.firstWhere((item) => item['id'] == id, orElse: () => null);
    return stp != null ? stp['water_type'] : null;
  }

  int getStpIdByName(String name) {
    // Assuming 'fruits' is the list containing the STP data
    var stp = fruits.firstWhere((item) => item['water_type'] == name,
        orElse: () => null);
    return stp != null ? stp['id'] : null;
  }

  var dropdownValue1;
  String dropdownValue2 = 'Public';
  @override
  void dispose() {
    latController.dispose();
    longController.dispose();
    addressController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    addressController.text = "";
    latController.text = "";
    longController.text = " ";
    getbuilder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                            "Add Project",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                          "Select Project Type :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.green,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: dropdownValue1,

                            menuMaxHeight: 200,
                            decoration: const InputDecoration(
                              suffixIconColor: Colors.green,
                              fillColor: Colors.white,
                              hintText: 'Select an option',
                              border: InputBorder.none,
                              filled: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an option';
                              }
                              return null;
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors
                                  .green, // Set the desired color of the icon
                            ),
                            // dropdownColor: Colors.green,
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValue1 = newValue;

                                if (newValue == 'PCMC Project') {
                                  // Generate PCMC BCP Number
                                  final String yearLastTwoDigits =
                                      DateTime.now()
                                          .year
                                          .toString()
                                          .substring(2);
                                  final int serialNumber = random
                                          .nextInt(9000) +
                                      1000; // Generate random 4-digit number
                                  final String formattedSerialNumber =
                                      serialNumber.toString();
                                  final String bcpNumber =
                                      'PCMC/$formattedSerialNumber/$yearLastTwoDigits';
                                  bcpController.text = bcpNumber;
                                } else {
                                  // Clear BCP Number for Non-PCMC
                                  bcpController.text = '';
                                }
                              });
                            },
                            items: <String>[
                              'PCMC Project',
                              'Non-PCMC Project',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Project Commecement No :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: bcpController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            hintText: 'Enter Commecement Number',
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(bottom: 4.0),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 11) {
                              return 'Please enter valid Commecement Number';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                          onChanged: (text) {
                            bcpController.value = bcpController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Password:",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Password',
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
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Confirm Password:",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: confirmpasswordController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Confirm Password',
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
                              return 'Please enter Confirm Password';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Project Manager Name :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: managernameController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Name',
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
                              return 'Please enter Name';
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
                          "Project Manager Mobile No :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          maxLength: 10,
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter mobile No',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 10) {
                              return 'Please enter Mobile No';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        const Text(
                          "Existing Available Water Source:",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        DropDownMultiSelect(
                          options: fruits
                              .map((item) => item['water_type'].toString())
                              .toList(),
                          selectedValues: selectedFruits
                              .map((id) => getStpNameById(id))
                              .toList(),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          onChanged: (selectedNames) {
                            setState(() {
                              selectedFruits = selectedNames
                                  .map((name) => getStpIdByName(name))
                                  .toList();
                            });
                          },
                          // validator: (selectedNames) {
                          //   if (selectedNames == null ||
                          //       selectedNames.isEmpty) {
                          //     return 'Please select at least one water type.';
                          //   }
                          //   return '';
                          // },
                          whenEmpty:
                              'Please Select Existing Available Water Source',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GetBuilder<LocationController>(
                            init: LocationController(),
                            builder: (controller) {
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
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 4.0),
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
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 4.0),
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
                                if (passwordController.text ==
                                    confirmpasswordController.text) {
                                  Builderservices.addBCP(
                                    bcpController.text,
                                    mobileController.text,
                                    passwordController.text,
                                    dropdownValue1,
                                    nameController.text,
                                    addressController.text,
                                    latController.text,
                                    longController.text,
                                    managernameController.text,
                                    selectedFruits,
                                  ).then((data) async {
                                    if (data['error'] == false) {
                                      final LocationController
                                          locationController =
                                          Get.find<LocationController>();
                                      locationController.latitude.value = '0.0';
                                      locationController.longitude.value =
                                          '0.0';
                                      locationController.address.value = '';

                                      _showRegistrationDialog(
                                          context,
                                          bcpController.text,
                                          passwordController.text);
                                    } else if (data['error'] == true) {
                                      nameController.clear();
                                      addressController.clear();
                                      latController.clear();
                                      longController.clear();
                                      managernameController.clear();
                                      bcpController.clear();
                                      mobileController.clear();
                                      passwordController.clear();
                                      confirmpasswordController.clear();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                      managernameController.clear();
                                      bcpController.clear();
                                      mobileController.clear();
                                      passwordController.clear();
                                      confirmpasswordController.clear();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Something Went Wrong'),
                                          backgroundColor: Colors.red,
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
                    try {
                      final LocationController locationController =
                          Get.put(LocationController());

                      // Fetch placemarks from the coordinates
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              latLng.latitude, latLng.longitude);

                      // Safely access placemarks with a check
                      if (placemarks.isNotEmpty) {
                        Placemark place1 = placemarks[0];
                        Placemark place2 = placemarks.length > 2
                            ? placemarks[2]
                            : Placemark(); // Default empty if not available

                        // Set location details
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
                              setState(() {
                                _marker = _marker!
                                    .copyWith(positionParam: newPosition);
                              });
                            },
                          );
                          _markers.add(_marker!);
                        });
                      } else {
                        // Handle case when no placemarks are found
                        print("No placemarks found for this location");
                        // Optionally, you could show an alert or some fallback behavior
                      }
                    } catch (e) {
                      // Catching any exception that occurs in the try block
                      print("Error: $e");

                      // Optionally, you can show a user-friendly message (e.g., via a snackbar or dialog)
                      // For example:
                      // Get.snackbar("Error", "Failed to fetch location details. Please try again later.");

                      // You could also handle different exceptions separately if needed
                      if (e is RangeError) {
                        print("Range error: Invalid placemark index.");
                        // Handle RangeError specifically, e.g., default to an empty placemark or show a message
                      } else if (e is SocketException) {
                        print(
                            "Network error: Failed to fetch location details.");
                        // Handle network errors, show a user-friendly message
                      } else {
                        // For any other errors
                        print("Unexpected error: $e");
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegistrationDialog(
      BuildContext context, String regId, String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Project details added successfully...      Project Manager Login Details are as folllows'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Username: $regId',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Password: $password',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardBuilder()));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
