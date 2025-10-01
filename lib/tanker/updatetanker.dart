import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/tanker/dashboard_tanker.dart';
import 'package:tankerpcmc/tanker/tankerservices.dart';
import 'package:tankerpcmc/widgets/appbar.dart';
import 'package:tankerpcmc/widgets/drawerwidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tankerpcmc/widgets/dropdown_multiselect.dart';

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

  int maxSelectionLimit = 5;
  List<dynamic> fruits = [];
  List<dynamic> selectedBuilders = [];

  List categoryItemlist2 = [];
  List categoryItemlist = [];
  String mb = '0';
  Random random = Random();

  final _formKey = GlobalKey<FormState>();
  var dropdownValue1;
  var dropdownValue3;
  bool _isLoading = true;
  String? dropdownValue2 = 'Public';

  /// ✅ Safe getters
  String getStpNameById(dynamic id) {
    if (id == null) return "";
    try {
      final stp = fruits.firstWhere(
        (item) => item['id'].toString() == id.toString(),
        orElse: () => {},
      );
      return (stp['full_name'] ?? "").toString();
    } catch (e) {
      return "";
    }
  }

  int? getStpIdByName(String? name) {
    if (name == null || name.isEmpty) return null;
    try {
      final stp = fruits.firstWhere(
        (item) => item['full_name'] == name,
        orElse: () => {},
      );
      return stp['id'];
    } catch (e) {
      return null;
    }
  }

  /// ✅ API Calls
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
    setState(() {
      categoryItemlist = jsonData['data'];
    });
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
                        const SizedBox(height: 20),

                        /// Vehicle Number
                        const Text(
                          "Vehicle Number :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: bcpController,
                          textCapitalization: TextCapitalization.characters,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter valid Vehicle Number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        /// Vehicle Type
                        const Text(
                          "Select Vehicle Type :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonFormField<String>(
                          value: dropdownValue2,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            filled: true,
                          ),
                          items: <String>['Private', 'Public']
                              .map((String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue2 = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 10),

                        /// Driver Name
                        const Text("Vehicle Driver Name:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: drivernameController,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter Driver Name'
                              : null,
                        ),
                        const SizedBox(height: 15),

                        /// Driver Mobile
                        const Text("Vehicle Driver Mobile No:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        TextFormField(
                          maxLength: 10,
                          controller: drivermobileController,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter Driver Mobile Number'
                              : null,
                        ),
                        const SizedBox(height: 15),

                        /// Capacity
                        const Text("Vehicle Capacity:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        DropdownButtonFormField<String>(
                          value: dropdownValue1,
                          decoration: const InputDecoration(
                            hintText: 'Select Water Capacity',
                            border: InputBorder.none,
                          ),
                          items: categoryItemlist2.map((item) {
                            return DropdownMenuItem(
                              value: item['ni_water_capacity'].toString(),
                              child: Text(
                                  "${item['ni_water_capacity'].toString()} liter"),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              dropdownValue1 = newVal;
                            });
                          },
                        ),
                        const SizedBox(height: 15),

                        /// STP Name
                        const Text("Nearest STP:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        DropdownButtonFormField<String>(
                          value: dropdownValue3,
                          decoration: const InputDecoration(
                            hintText: 'Select an STP Name',
                            border: InputBorder.none,
                          ),
                          items: categoryItemlist.map((item) {
                            return DropdownMenuItem(
                              value: item['ni_stp_name'].toString(),
                              child: Text(item['ni_stp_name'].toString()),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              dropdownValue3 = newVal;
                            });
                          },
                        ),
                        const SizedBox(height: 15),

                        /// Builders (only for Private tankers)
                        if (dropdownValue2 == 'Private')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Select Builder Name:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              DropDownMultiSelect(
                                options: fruits
                                    .map((item) => item['full_name'].toString())
                                    .toList(),
                                selectedValues: selectedBuilders
                                    .map((id) => getStpNameById(id))
                                    .where((name) => name.isNotEmpty)
                                    .toList(),
                                onChanged: (selectedNames) {
                                  if (selectedNames.length <=
                                      maxSelectionLimit) {
                                    setState(() {
                                      selectedBuilders = selectedNames
                                          .map((name) => getStpIdByName(name))
                                          .where((id) => id != null)
                                          .toList();
                                    });
                                  }
                                },
                                whenEmpty: 'Select your Builder',
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),

                        /// Update Button
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(150, 40)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Tankerservices.updateTanker(
                                  selectedBuilders,
                                  dropdownValue2.toString(),
                                  widget.id,
                                  drivernameController.text,
                                  drivermobileController.text,
                                  dropdownValue1,
                                  dropdownValue3,
                                ).then((data) {
                                  if (data['error'] == false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Vehicle Updated Successfully'),
                                            backgroundColor: Colors.green));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DashboardTanker()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(data['message']),
                                            backgroundColor: Colors.red));
                                  }
                                });
                              }
                            },
                            child: const Text("Update"),
                          ),
                        )
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
