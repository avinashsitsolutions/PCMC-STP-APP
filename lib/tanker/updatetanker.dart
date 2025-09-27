import 'dart:math';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/tanker/dashboard_tanker.dart';
import 'package:tankerpcmc/tanker/tankerservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateTanker extends StatefulWidget {
  const UpdateTanker({
    super.key,
    required this.tankerno,
    required this.orderCount,
    required this.id,
    required this.drivername,
    required this.drivermobno,
    required this.capacity,
    required this.stp,
    required this.tankertype,
    required this.selectedBuilders,
  });
  final String tankerno;
  final String tankertype;

  final String orderCount;
  final String drivername;
  final String drivermobno;
  final String capacity;
  final String stp;
  final String id;
  final List<dynamic> selectedBuilders;
  @override
  State<UpdateTanker> createState() => _UpdateTankerState();
}

class _UpdateTankerState extends State<UpdateTanker> {
  TextEditingController bcpController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController drivernameController = TextEditingController();
  TextEditingController drivermobileController = TextEditingController();
  String stpAddress = '';
  int maxSelectionLimit = 5;
  List<dynamic> fruits = [];
  List<dynamic> selectedFruits = [];
  bool loadingButton = false;
  List categoryItemlist2 = [];
  List categoryItemlist = [];
  // MapType _currentMapType = MapType.normal;
  String mb = '0';
  Random random = Random();
  final formKey = GlobalKey<FormState>();
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

  final _formKey = GlobalKey<FormState>();
  var dropdownValue1;
  var dropdownValue3;
  bool _isLoading = true;
  String? dropdownValue2 = 'Public';
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

  List<dynamic> selectedBuilders = [];
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

  @override
  void initState() {
    super.initState();
    bcpController.text = widget.tankerno;
    mobileController.text = widget.orderCount;
    drivermobileController.text = widget.drivermobno;
    drivernameController.text = widget.drivername;
    dropdownValue2 = widget.tankertype;
    dropdownValue1 = widget.capacity;
    dropdownValue3 = widget.stp;
    selectedBuilders = widget.selectedBuilders;
    getbuilder();
    getAllstp();
    getAllcap();
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
                            "Update Vehicle Type",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Vehicle Number :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          readOnly: true,
                          onChanged: (text) {
                            bcpController.value = bcpController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                          controller: bcpController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
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
                            if (value!.isEmpty) {
                              return 'Please enter valid Vehicle Number';
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
                              color: Colors
                                  .green, // Set the desired color of the icon
                            ),
                            // dropdownColor: Colors.green,
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
                            value: dropdownValue1,
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
                                dropdownValue1 = newVal;
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
                            value: dropdownValue3,
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
                                dropdownValue3 = newVal;
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
                        if (dropdownValue2 == 'Private')
                          Column(
                            children: [
                              const Text(
                                "Select Builder Name:",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              DropDownMultiSelect(
                                options: fruits
                                    .map((item) => item['full_name'].toString())
                                    .toList(),
                                selectedValues: selectedBuilders
                                    .map((id) => getStpNameById(id))
                                    .toList(),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20),
                                ),
                                onChanged: (selectedNames) {
                                  if (selectedNames.length <=
                                      maxSelectionLimit) {
                                    setState(() {
                                      selectedBuilders = selectedNames
                                          .map((name) => getStpIdByName(name))
                                          .toList();
                                    });
                                  } else {
                                    setState(() {
                                      selectedBuilders = selectedNames
                                          .sublist(0, maxSelectionLimit)
                                          .map((name) => getStpIdByName(name))
                                          .toList();
                                    });
                                  }
                                },
                                whenEmpty: 'Select your Builder',
                              ),
                            ],
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
                                Tankerservices.updateTanker(
                                        selectedBuilders,
                                        dropdownValue2.toString(),
                                        widget.id,
                                        drivernameController.text,
                                        drivermobileController.text,
                                        dropdownValue1,
                                        dropdownValue3)
                                    .then((data) async {
                                  if (data['error'] == false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Vehicle Type Updated Successfulyy'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    bcpController.clear();
                                    mobileController.clear();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DashboardTanker()));
                                  } else if (data['error'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(data['message']),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } else {
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
                              'Update',
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
