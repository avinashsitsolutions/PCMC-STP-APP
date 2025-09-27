import 'package:flutter/material.dart';
import 'package:tankerpcmc/Auth/authservices.dart';
import 'package:tankerpcmc/Auth/login.dart';
import 'package:tankerpcmc/widgets/internet.dart';
import 'package:url_launcher/url_launcher.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _isRegistering = false;

  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Builder';
  // ignore: prefer_typing_uninitialized_variables
  var dropdownvalue1;
  // ignore: prefer_typing_uninitialized_variables
  var dropdownvalue2;
  bool isValidEmail(String email) {
    // Implement your email validation logic here
    return email.contains('@');
  }

  String? _email;
  final bool _isLoading = false;
  String hinttext1 = 'First Name';
  String hinttext2 = 'Last Name';
  String hinttext3 = 'Mobile Number';
  String hinttext4 = 'Email Id';
  String hinttext5 = '';
  String hinttext6 = '';
  String hinttext7 = '';
  bool society = false;
  bool tanker = false;
  bool garage = false;
  bool builder = false;
  bool PCMC = false;
  // ignore: non_constant_identifier_names
  String Status = "2";

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobnoController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tankernoController = TextEditingController();
  TextEditingController ownerfullnameController = TextEditingController();
  TextEditingController tankercapController = TextEditingController();
  TextEditingController neareststpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isRegistering = false;

  @override
  void initState() {
    super.initState();
    InternetConnection();
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    mobnoController.dispose();
    latController.dispose();
    longController.dispose();
    nameController.dispose();
    addressController.dispose();
    tankernoController.dispose();
    ownerfullnameController.dispose();
    tankercapController.dispose();
    neareststpController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _clearTextField() {
    firstnameController.clear();
    lastnameController.clear();
    emailController.clear();
    mobnoController.clear();
    latController.clear();
    longController.clear();
    nameController.clear();
    addressController.clear();
    tankernoController.clear();
    ownerfullnameController.clear();
    tankercapController.clear();
    neareststpController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              InkWell(
                // ignore: deprecated_member_use
                onTap: () => launch('https://pcmcindia.gov.in/index.php'),
                child: const Image(
                  image: AssetImage('assets/pcmc_logo.jpg'),
                  height: 90,
                ),
              ),
              const Column(
                children: [
                  Text(
                    "Pimpri-Chinchwad Municipal Corporation",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    " Treated Water Recycle and Reuse System",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(55.0),
          ),
        ),
        titleSpacing: 0,
        toolbarHeight: 120,
      ),
      body: Stack(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50.0),
                    bottomLeft: Radius.circular(50.0),
                  ),
                  // color: Colors.green
                  color: (Color.fromARGB(255, 186, 226, 171)),
                ),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back),
                                color: Colors.black,
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              const SizedBox(
                                width: 70,
                              ),
                              const Text(
                                "Register",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Select User Type:",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            width: 300,
                            child: DropdownButtonFormField<String>(
                              value: dropdownValue,
                              menuMaxHeight: 200,
                              decoration: const InputDecoration(
                                suffixIconColor: Colors.black,
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
                                color: Colors.black,
                              ),
                              dropdownColor:
                                  const Color.fromARGB(255, 186, 226, 171),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _clearTextField();
                                  dropdownValue = newValue!.toString();
                                  firstnameController.clear();
                                  lastnameController.clear();
                                  emailController.clear();
                                  mobnoController.clear();
                                  latController.clear();
                                  longController.clear();
                                  nameController.clear();
                                  addressController.clear();
                                  tankernoController.clear();
                                  ownerfullnameController.clear();
                                  tankercapController.clear();
                                  neareststpController.clear();
                                  if (dropdownValue == 'Tanker') {
                                    Status = 7.toString();
                                    hinttext1 = "";
                                    hinttext2 = 'Owners First -Last Name';
                                    hinttext3 = 'Owners Mobile Number';
                                  } else if (dropdownValue == 'Builder') {
                                    Status = 2.toString();
                                    hinttext1 = 'First Name';
                                    hinttext2 = 'Last Name';
                                    hinttext3 = 'Mobile Number';
                                    hinttext4 = 'Email Id';
                                  } else if (dropdownValue == 'Society') {
                                    Status = 3.toString();
                                    hinttext1 = 'Society Name';
                                    hinttext2 = '';
                                    hinttext3 = 'Mobile Number';
                                    hinttext4 = '';
                                    hinttext5 = '';
                                  } else if (dropdownValue == 'Garage') {
                                    Status = 4.toString();
                                    hinttext1 = 'Name';
                                    hinttext2 = 'Address';
                                    hinttext3 = 'Mobile Number';
                                  } else if (dropdownValue == 'PCMC') {
                                    Status = 8.toString();
                                    hinttext1 = "Employee Id";
                                    hinttext2 = 'Employee Name';
                                    hinttext3 = 'Mobile Number';
                                  }
                                  setState(() {
                                    if (dropdownValue == 'Society') {
                                      society = true;
                                    } else {
                                      society = false;
                                    }
                                    if (dropdownValue == 'Tanker') {
                                      tanker = true;
                                    } else {
                                      tanker = false;
                                    }
                                    if (dropdownValue == 'Garage') {
                                      garage = true;
                                    } else {
                                      garage = false;
                                    }
                                    if (dropdownValue == 'Builder') {
                                      builder = true;
                                    } else {
                                      builder = false;
                                    }
                                    if (dropdownValue == 'PCMC') {
                                      PCMC = true;
                                    } else {
                                      PCMC = false;
                                    }
                                  });
                                });
                              },
                              items: <String>[
                                'Tanker',
                                'Builder',
                                'Society',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (tanker == false)
                            TextFormField(
                              controller: firstnameController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: hinttext1,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 4.0),
                                hintStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some value ';
                                }
                                if (tanker == true) {
                                  if (value.toUpperCase() != value) {
                                    return 'Please enter only Uppercase letters';
                                  }
                                }
                                if (PCMC == true) {
                                  if (value.length > 8 || value.length < 7) {
                                    return 'Please enter Valid Employee Id';
                                  }
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (society == false)
                            TextFormField(
                              controller: lastnameController,
                              decoration: InputDecoration(
                                hintText: hinttext2,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 4.0),
                                hintStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Text';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                            ),
                          const SizedBox(
                            height: 5,
                          ),

                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: hinttext3,
                              contentPadding:
                                  const EdgeInsets.only(bottom: 4.0),
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            maxLength: 10,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 10) {
                                return 'Please enter Mobile Number';
                              }
                              if (value.length > 10) {
                                value = value.substring(0, 10);
                                emailController.value =
                                    emailController.value.copyWith(
                                  text: value,
                                  selection: TextSelection.collapsed(
                                      offset: value.length),
                                );
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 17.0, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (garage == false &&
                              tanker == false &&
                              PCMC == false &&
                              society == false)
                            TextFormField(
                              controller: mobnoController,
                              keyboardType: society == true
                                  ? TextInputType.number
                                  : TextInputType.text,
                              decoration: InputDecoration(
                                hintText: hinttext4,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 4.0),
                                hintStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an value';
                                } else if (!isValidEmail(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _email = value;
                                });
                              },
                              style: const TextStyle(
                                  fontSize: 17.0, color: Colors.black),
                            ),
                          // if (society == true || garage == true)
                          //   SizedBox(
                          //     width: 300,
                          //     child: Row(
                          //       children: [
                          //         Expanded(
                          //           child: TextFormField(
                          //             controller: latController,
                          //             style: const TextStyle(
                          //                 fontSize: 17.0, color: Colors.black),
                          //             decoration: const InputDecoration(
                          //               hintText: ' Lattitude ',
                          //               contentPadding:
                          //                   EdgeInsets.only(bottom: 4.0),
                          //               hintStyle: TextStyle(
                          //                 color: Colors.black,
                          //                 fontSize: 16,
                          //               ),
                          //               enabledBorder: UnderlineInputBorder(
                          //                 borderSide:
                          //                     BorderSide(color: Colors.black),
                          //               ),
                          //               focusedBorder: UnderlineInputBorder(
                          //                 borderSide:
                          //                     BorderSide(color: Colors.black),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //         const SizedBox(
                          //           width: 20,
                          //         ),
                          //         Expanded(
                          //           child: TextFormField(
                          //             controller: longController,
                          //             style: const TextStyle(
                          //                 fontSize: 17.0, color: Colors.black),
                          //             decoration: const InputDecoration(
                          //               hintText: ' Longitude ',
                          //               contentPadding:
                          //                   EdgeInsets.only(bottom: 4.0),
                          //               hintStyle: TextStyle(
                          //                 color: Colors.black,
                          //                 fontSize: 16,
                          //               ),
                          //               enabledBorder: UnderlineInputBorder(
                          //                 borderSide:
                          //                     BorderSide(color: Colors.black),
                          //               ),
                          //               focusedBorder: UnderlineInputBorder(
                          //                 borderSide:
                          //                     BorderSide(color: Colors.black),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: "Enter Password",
                              contentPadding: EdgeInsets.only(bottom: 4.0),
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Password';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 17.0, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
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
                                  setState(() {
                                    _isRegistering =
                                        true; // Disable the register button and show loading indicator
                                  });
                                  if (dropdownValue == "Builder") {
                                    Authservices.registerUser(
                                            dropdownValue,
                                            firstnameController.text,
                                            lastnameController.text,
                                            mobnoController.text,
                                            emailController.text,
                                            latController.text,
                                            longController.text,
                                            nameController.text,
                                            addressController.text,
                                            tankernoController.text,
                                            ownerfullnameController.text,
                                            Status.toString(),
                                            passwordController.text,
                                            neareststpController.text,
                                            "",
                                            "")
                                        .then((data) {
                                      if (data['error'] == false) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login()));
                                        // call this function after a successful registration
                                        setState(() {
                                          _isRegistering = false;
                                        });
                                        _showRegistrationDialog(
                                            context,
                                            data['data']['ni_contact_no'],
                                            passwordController.text);
                                      } else if (data['error'] == true) {
                                        setState(() {
                                          _isRegistering = false;
                                        });
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
                                  } else if (dropdownValue == "Tanker") {
                                    Authservices.registerUser(
                                            dropdownValue,
                                            tankernoController.text,
                                            ownerfullnameController.text,
                                            tankercapController.text,
                                            latController.text,
                                            latController.text,
                                            longController.text,
                                            nameController.text,
                                            addressController.text,
                                            firstnameController.text,
                                            lastnameController.text,
                                            Status.toString(),
                                            passwordController.text,
                                            emailController.text,
                                            "",
                                            "")
                                        .then((data) {
                                      if (data['error'] == false) {
                                        setState(() {
                                          _isRegistering = false;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login()));
                                        _showRegistrationDialog(
                                            context,
                                            data['data']['ni_tanker_mo_no'],
                                            passwordController.text);
                                      } else {
                                        setState(() {
                                          _isRegistering = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(data['message1']),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    });
                                  } else if (dropdownValue == "Garage") {
                                    Authservices.registerUser(
                                            dropdownValue,
                                            neareststpController.text,
                                            neareststpController.text,
                                            addressController.text,
                                            emailController.text,
                                            latController.text,
                                            longController.text,
                                            firstnameController.text,
                                            lastnameController.text,
                                            tankernoController.text,
                                            ownerfullnameController.text,
                                            Status.toString(),
                                            passwordController.text,
                                            neareststpController.text,
                                            "",
                                            "")
                                        .then((data) {
                                      if (data['error'] == false) {
                                        setState(() {
                                          _isRegistering = false;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login()));
                                        _showRegistrationDialog(
                                            context,
                                            data['data']['ni_contact_no'],
                                            passwordController.text);
                                      } else {
                                        setState(() {
                                          _isRegistering = false;
                                        });
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
                                  } else if (dropdownValue == "Society") {
                                    Authservices.registerUser(
                                            dropdownValue,
                                            neareststpController.text,
                                            neareststpController.text,
                                            mobnoController.text,
                                            emailController.text,
                                            latController.text,
                                            longController.text,
                                            firstnameController.text,
                                            lastnameController.text,
                                            tankernoController.text,
                                            ownerfullnameController.text,
                                            Status.toString(),
                                            passwordController.text,
                                            neareststpController.text,
                                            "",
                                            "")
                                        .then((data) {
                                      if (data['error'] == false) {
                                        setState(() {
                                          _isRegistering = false;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login()));
                                        _showRegistrationDialog(
                                            context,
                                            data['data']['ni_contact_no'],
                                            passwordController.text);
                                      } else {
                                        setState(() {
                                          _isRegistering = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(data['message1']),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    });
                                  } else if (dropdownValue == "PCMC") {
                                    Authservices.registerUser(
                                            dropdownValue,
                                            neareststpController.text,
                                            neareststpController.text,
                                            mobnoController.text,
                                            emailController.text,
                                            latController.text,
                                            longController.text,
                                            "",
                                            "",
                                            tankernoController.text,
                                            ownerfullnameController.text,
                                            Status.toString(),
                                            passwordController.text,
                                            neareststpController.text,
                                            firstnameController.text,
                                            lastnameController.text)
                                        .then((data) {
                                      if (data['error'] == false) {
                                        setState(() {
                                          _isRegistering = false;
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Login()));
                                        _showRegistrationDialog(
                                            context,
                                            data['data']['employee_id'],
                                            passwordController.text);
                                      } else {
                                        setState(() {
                                          _isRegistering = false;
                                        });
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
                                  }
                                }
                              },
                              child: _isRegistering
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Register',
                                      style: TextStyle(fontSize: 17),
                                    ),
                            ),
                          ),
                          Visibility(
                            visible: _isLoading,
                            child: const CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: FloatingActionButton(
                  // ignore: deprecated_member_use
                  onPressed: () => launch('https://nyatitechnologies.com/'),
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(30),
                        topRight: Radius.circular(50),
                      ),
                      color: Colors.white,
                    ),
                    child: const Center(
                        child: Text(
                      "Powered by Nyati Technologies Pvt Ltd",
                      style: TextStyle(fontSize: 11, color: Colors.green),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }

  void _showRegistrationDialog(
      BuildContext context, String regId, String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Registration ID: $regId'),
              const SizedBox(height: 8),
              Text('Password: $password'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
