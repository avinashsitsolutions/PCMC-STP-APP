import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:tankerpcmc/pmc/pmcservices.dart';
import 'package:tankerpcmc/widgets/drawerWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class OfficerRegistration extends StatefulWidget {
  const OfficerRegistration({super.key});

  @override
  State<OfficerRegistration> createState() => _OfficerRegistrationState();
}

class _OfficerRegistrationState extends State<OfficerRegistration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController mobnoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late GoogleMapController mapController;
  String stpAddress = '';
  // late LocationData currentLocation;
  List<dynamic> fruits = [];
  List<dynamic> selectedFruits = [];
  bool loadingButton = false;

  bool _isLoading = true;
  String getStpNameById(int id) {
    // Assuming 'fruits' is the list containing the STP data
    var stp = fruits.firstWhere((item) => item['id'] == id, orElse: () => null);
    return stp != null ? stp['ni_stp_name'] : null;
  }

  int getStpIdByName(String name) {
    // Assuming 'fruits' is the list containing the STP data
    var stp = fruits.firstWhere((item) => item['ni_stp_name'] == name,
        orElse: () => null);
    return stp != null ? stp['id'] : null;
  }

  Future getstp() async {
    _isLoading = true;
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/stp_name_ward'),
    );
    var data = json.decode(response.body);
    if (data['error'] == true) {
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

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    mobnoController.dispose();

    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _clearTextField() {
    mobnoController.clear();

    nameController.clear();

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
  void initState() {
    super.initState();
    getstp();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                    color: Colors.white,
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
                  "Add Ward Officer",
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
                            "Employee Id :",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: idController,
                            maxLength: 7,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Enter Employee Id',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                              isDense: true,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.length < 6 ||
                                  value.length != 7) {
                                return 'Please enter Valid Id';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 18.0,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Name :",
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
                              hintText: 'Enter Name',
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
                                return 'Please enter Name';
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
                            "Select STP:",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropDownMultiSelect(
                            decoration: const InputDecoration(
                                filled: true, fillColor: Colors.white),
                            options: fruits
                                .map((item) => item['ni_stp_name'].toString())
                                .toList(),
                            selectedValues: selectedFruits
                                .map((id) => getStpNameById(id))
                                .toList(),
                            onChanged: (selectedNames) {
                              setState(() {
                                selectedFruits = selectedNames
                                    .map((name) => getStpIdByName(name))
                                    .toList();
                              });
                            },
                            whenEmpty: 'Select your STP',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Contact Number:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            maxLength: 10,
                            controller: mobnoController,
                            decoration: const InputDecoration(
                              hintText: 'Enter Mobile Number',
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
                                  PCMCservices.addOfficer(
                                          idController.text,
                                          nameController.text,
                                          mobnoController.text,
                                          passwordController.text,
                                          selectedFruits)
                                      .then((data) {
                                    if (data['error'] == false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                              "Ward Officer Registered Successfully !!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      idController.clear();
                                      nameController.clear();
                                      mobnoController.clear();
                                      passwordController.clear();
                                      selectedFruits.clear();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(data['message']),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                              child: const Text(
                                'Add Officer',
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
            ],
          ),
        ),
      ),
    );
  }
}
