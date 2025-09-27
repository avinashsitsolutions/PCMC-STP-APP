import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/tanker/dashboard_tanker.dart';
import 'package:tankerpcmc/tanker/tankerservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  List categoryItemlist = [];
  List categoryItemlist2 = [];
  List<dynamic> fruits = [];
  List<dynamic> selectedFruits = [];
  bool loadingButton = false;

  bool _isLoading = true;
  Future getAllstp() async {
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/stp_name'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    var jsonData = json.decode(response.body);
    // print(jsonData);
    setState(() {
      categoryItemlist = jsonData['data'];
    });
    // print(categoryItemlist);
  }

  String getStpNameById(int id) {
    // Assuming 'fruits' is the list containing the STP data
    var stp = fruits.firstWhere((item) => item['id'] == id, orElse: () => null);
    return stp != null ? stp['full_name'] : null;
  }

  int getStpIdByName(String name) {
    // Assuming 'fruits' is the list containing the STP data
    var stp = fruits.firstWhere((item) => item['full_name'] == name,
        orElse: () => null);
    return stp != null ? stp['id'] : null;
  }

  Future getbuilder() async {
    _isLoading = true;
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/builder_list'),
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

  String dropdownValue2 = 'Public';
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
    setState(() {
      categoryItemlist2 = jsonData['data'];
    });
  }

  void clearDropdown() {
    setState(() {
      dropdownvalue = null;
      dropdownvalue2 = null;
    });
    _formKey.currentState!.reset();
  }

  int maxSelectionLimit = 5;
  // ignore: prefer_typing_uninitialized_variables
  var dropdownvalue;
  // ignore: prefer_typing_uninitialized_variables
  var dropdownvalue1;
  // ignore: prefer_typing_uninitialized_variables
  var dropdownvalue2;

  final _formKey = GlobalKey<FormState>();
  TextEditingController drivermobileController = TextEditingController();
  TextEditingController drivernameController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController stpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllstp();
    getAllcap();
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
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green[50],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Add a Vehicle",
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
                          "Vehicle Number:",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: numberController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Vehicle Number',
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
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (text) {
                            numberController.value =
                                numberController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Vehicle Number';
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
                          "Vehicle Driver Name:",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: drivernameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Drivers Name',
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
                              return 'Please enter Driver Name';
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
                          "Vehicle Driver Mobile No:",
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
                          controller: drivermobileController,
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
                            if (value!.isEmpty) {
                              return 'Please enter Driver Mobile Number';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 18.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Vehicle Capacity :",
                          style: TextStyle(
                              fontSize: 18,
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
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                              ),
                              color: Colors.white),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              hintText: 'Select Water Capacity',
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
                            onChanged: (newVal) {
                              setState(() {
                                dropdownvalue1 = newVal;
                              });
                            },
                            items: categoryItemlist2.map((item) {
                              return DropdownMenuItem(
                                value: item['ni_water_capacity'].toString(),
                                child: Text(
                                    "${item['ni_water_capacity'].toString()} liter"),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Nearest STP:",
                          style: TextStyle(
                              fontSize: 18,
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
                                  color: Colors.white,
                                  width:
                                      1.0, // Set the desired width of the underline
                                ),
                              ),
                              color: Colors.white),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              hintText: 'Select an STP Name',
                              border: InputBorder.none,
                              // suffixIcon: Icon(Icons.arrow_drop_down),
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
                              color: Colors
                                  .green, // Set the desired color of the icon
                            ),
                            onChanged: (newVal) {
                              setState(() {
                                dropdownvalue = newVal;
                              });
                            },
                            items: categoryItemlist.map((item) {
                              return DropdownMenuItem(
                                value: item['ni_stp_name'].toString(),
                                child: Text(item['ni_stp_name'].toString()),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Select Vehicle Type :",
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
                            value: dropdownValue2,
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
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.green,
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                dropdownValue2 = newValue!;
                              });
                            },
                            items: <String>[
                              'Private',
                              'Public',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (dropdownValue2 == 'Private')
                          DropDownMultiSelect(
                            options: fruits
                                .map((item) => item['full_name'].toString())
                                .toList(),
                            selectedValues: selectedFruits
                                .map((id) => getStpNameById(id))
                                .toList(),
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20),
                            ),
                            onChanged: (selectedNames) {
                              if (selectedNames.length <= maxSelectionLimit) {
                                setState(() {
                                  selectedFruits = selectedNames
                                      .map((name) => getStpIdByName(name))
                                      .toList();
                                });
                              } else {
                                setState(() {
                                  selectedFruits = selectedNames
                                      .sublist(0, maxSelectionLimit)
                                      .map((name) => getStpIdByName(name))
                                      .toList();
                                });
                              }
                            },
                            whenEmpty: 'Select your Builder',
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
                          height: 10,
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
                              return 'Please enter password';
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
                          "Confirm Password:",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
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
                              return 'Please enter Confirm password';
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
                                  if (dropdownValue2 == "Public") {
                                    selectedFruits = [];
                                  }
                                  Tankerservices()
                                      .AddVehicle(
                                          numberController.text,
                                          drivernameController.text,
                                          drivermobileController.text,
                                          dropdownvalue1,
                                          dropdownvalue,
                                          passwordController.text,
                                          dropdownValue2,
                                          selectedFruits)
                                      .then((data) {
                                    if (data != null) {
                                      if (data['error'] == false) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(data['message']),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const DashboardTanker()));
                                        numberController.clear();
                                        drivermobileController.clear();
                                        drivernameController.clear();
                                        passwordController.clear();
                                        clearDropdown();
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
                                        numberController.clear();
                                        drivermobileController.clear();
                                        drivernameController.clear();
                                        passwordController.clear();
                                        clearDropdown();
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          content:
                                              Text("Something Went Wrong !!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      numberController.clear();
                                      drivermobileController.clear();
                                      drivernameController.clear();
                                      passwordController.clear();
                                      clearDropdown();
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
                              'Add Vehicle',
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
