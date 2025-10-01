import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tankerpcmc/builder/builderservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';
import 'package:get/get.dart';
import 'package:tankerpcmc/widgets/dropdown_multiselect.dart';

import '../getx/controller.dart';
import 'dashboard_builder.dart';

class UpdateBCP extends StatefulWidget {
  const UpdateBCP({
    super.key,
    required this.bcpno,
    required this.mobileno,
    required this.id,
    required this.projectName,
    required this.managername,
    required this.address,
    required this.lat,
    required this.long,
    required this.projecttype,
    required this.tankertype,
    required this.selectedBuilders,
  });
  final String bcpno;
  final String mobileno;
  final String id;
  final String projectName;
  final String managername;
  final String address;
  final String lat;
  final String long;
  final String projecttype;
  final String tankertype;
  final List<dynamic> selectedBuilders;
  @override
  State<UpdateBCP> createState() => _UpdateBCPState();
}

class _UpdateBCPState extends State<UpdateBCP> {
  TextEditingController bcpController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController projecttypeController = TextEditingController();
  late GoogleMapController mapController;
  bool _isLoading = true;
  final latController = TextEditingController();
  final longController = TextEditingController();
  String projecttype11 = "";
  TextEditingController projectnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController managernameController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool loadingButton = false;
  final MapType _currentMapType = MapType.normal;

  final formKey = GlobalKey<FormState>();

  Random random = Random();

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

  List<dynamic> fruits = [];
  List<dynamic> selectedFruits = [];
  final _formKey = GlobalKey<FormState>();

  /// ✅ Null safe version
  String getStpNameById(dynamic id) {
    if (id == null) return "Unknown";
    var stp = fruits.firstWhere(
      (item) => item['id'].toString() == id.toString(),
      orElse: () => {},
    );
    return stp['water_type']?.toString() ?? "Unknown";
  }

  /// ✅ Null safe version
  int? getStpIdByName(String? name) {
    if (name == null) return null;
    var stp = fruits.firstWhere(
      (item) => item['water_type'] == name,
      orElse: () => {},
    );
    return stp['id'];
  }

  var dropdownValue1 = 'PCMC Project';
  var dropdownValue2 = "Private";
  List<dynamic> selectedBuilders = [];

  @override
  void initState() {
    super.initState();
    projectnameController.text = widget.projectName;
    bcpController.text = widget.bcpno;
    mobileController.text = widget.mobileno;
    addressController.text = widget.address;
    latController.text = widget.lat;
    longController.text = widget.long;
    managernameController.text = widget.managername;
    projecttypeController.text = widget.projecttype;
    selectedBuilders = widget.selectedBuilders;
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
                            "Update Project",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Project Type
                        const Text(
                          "Select Project Type :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        widget.projecttype == "PCMC Project" ||
                                widget.projecttype == "Non-PCMC Project"
                            ? TextFormField(
                                controller: projecttypeController,
                                enabled: false,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(fontSize: 17.0),
                              )
                            : DropdownButtonFormField<String>(
                                value: dropdownValue1,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                ),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                                onChanged: (newValue) {
                                  setState(() {
                                    dropdownValue1 = newValue!;
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
                        const SizedBox(height: 15),

                        /// Project Name
                        const Text("Project Name:",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: projectnameController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// Commencement Number
                        const Text("Project Commencement No :",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: bcpController,
                          enabled: false,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// Password
                        const Text("Password:",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Password',
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// Manager
                        const Text("Project Manager Name :",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: managernameController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Name',
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// Mobile
                        const Text("Project Manager Mobile No :",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter mobile No',
                          ),
                        ),

                        /// Water Source MultiSelect
                        const Text("Existing Available Water Source :",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        DropDownMultiSelect(
                          options: fruits
                              .map((item) => item['water_type'].toString())
                              .toList(),
                          selectedValues: selectedBuilders
                              .map((id) => getStpNameById(id))
                              .where((name) => name != "Unknown")
                              .toList(),
                          onChanged: (selectedNames) {
                            setState(() {
                              selectedBuilders = selectedNames
                                  .map((name) => getStpIdByName(name))
                                  .where((id) => id != null)
                                  .toList();
                            });
                          },
                          whenEmpty:
                              'Select your Existing Available Water Source',
                        ),

                        const SizedBox(height: 20),

                        /// Address, Lat, Long etc... (rest of your code remains same)
                        // ...

                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(150, 35)),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                projecttype11 = widget.projectName == ""
                                    ? dropdownValue1
                                    : projecttypeController.text;

                                Builderservices.updateBCP(
                                  widget.id,
                                  projectnameController.text,
                                  passwordController.text,
                                  mobileController.text,
                                  projecttype11,
                                  bcpController.text,
                                  addressController.text,
                                  latController.text,
                                  longController.text,
                                  managernameController.text,
                                  selectedBuilders,
                                ).then((data) async {
                                  if (data['error'] == false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Project Updated Successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DashboardBuilder()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(data['message'] ??
                                            'Something went wrong'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                });
                              }
                            },
                            child: const Text('Update Project',
                                style: TextStyle(fontSize: 17)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bottomimage.png'),
          ),
        ),
        height: 70,
      ),
    );
  }
}
