import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpcmc/Auth/authservices.dart';
import 'package:tankerpcmc/Auth/registration.dart';
import 'package:tankerpcmc/TankerDriver/tankerdriverDashboard.dart';
import 'package:tankerpcmc/builder/dashboard_builder.dart';
import 'package:tankerpcmc/garage/dashboard_garage.dart';
import 'package:tankerpcmc/pmc/homepage.dart';
import 'package:tankerpcmc/pmc_newuser/dashboard.dart';
import 'package:tankerpcmc/sitemanager/managerdashboard.dart';
import 'package:tankerpcmc/society/dashboard_society.dart';
import 'package:tankerpcmc/stp/dashboard_stp.dart';
import 'package:tankerpcmc/tanker/dashboard_tanker.dart';
import 'package:tankerpcmc/wardofficer/wardofficerdashboard.dart';
import 'package:tankerpcmc/widgets/internet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:core';

import '../society/getlatlongsociety.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;
  bool _isLoading = false;
  bool show = false;
  var dropdownValue;
  Color buttonColor = Colors.grey;
  void _changeColor() {
    setState(() {
      buttonColor = (const Color.fromARGB(255, 186, 226, 171));
    });
  }

  RegExp numericRegex = RegExp(r'^[0-9]+$');
  RegExp alphanumericRegex = RegExp(r'^[A-Z0-9/]+$');
  RegExp alphabeticRegex = RegExp(r'^[A-Z]+$');
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  TextEditingController textController3 = TextEditingController();
  TextEditingController textController4 = TextEditingController();
  TextEditingController textController5 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void showPopup(String popupMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Hello,'),
            content: Text(popupMessage),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    InternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              InkWell(
                // ignore: deprecated_member_use
                onTap: () => launch('https://pcmcindia.gov.in/index.php'),
                child: const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Image(
                    image: AssetImage('assets/pcmc_logo.jpg'),
                    height: 50,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Column(
                children: [
                  Text(
                    "Pimpri-Chinchwad Municipal Corporation",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    "Treated Water Recycle and Reuse System",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
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
        toolbarHeight: 100,
      ),
      body: SafeArea(
        bottom: true,
        child: Stack(children: [
          Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const Center(
                  child: Text(
                "Log In",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: textController1,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            hintText: 'Mobile No/Tanker No/Commecement  No',
                            hintStyle: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          onChanged: (text) {
                            textController1.value =
                                textController1.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your User Id';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: textController2,
                          onChanged: (value) {
                            _changeColor();
                          },
                          decoration: InputDecoration(
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText =
                                          !_obscureText; // Toggle password visibility
                                    });
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Form(
                                          key: _formKey1,
                                          child: AlertDialog(
                                            title:
                                                const Text("Forget Password"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  onChanged: (value) {
                                                    textController1.value =
                                                        textController1.value
                                                            .copyWith(
                                                      text: value.toUpperCase(),
                                                      selection: TextSelection
                                                          .collapsed(
                                                              offset:
                                                                  value.length),
                                                    );
                                                  },
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .characters,
                                                  controller: textController3,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'enter Tanker No/Mobile No/Commecement  No';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Enter Tanker No/Mobile No/Commecement  No',
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: textController4,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter your Password';
                                                    }
                                                    return null;
                                                  },
                                                  obscureText: true,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Enter new password',
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: textController5,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter your Password';
                                                    }
                                                    return null;
                                                  },
                                                  obscureText: true,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText:
                                                        'Confirm new password',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  if (_formKey1.currentState!
                                                      .validate()) {
                                                    final text =
                                                        textController3.text;

                                                    if (numericRegex
                                                        .hasMatch(text)) {
                                                      Authservices.forgetpassword(
                                                              textController3
                                                                  .text,
                                                              textController4
                                                                  .text,
                                                              textController5
                                                                  .text)
                                                          .then((data) {
                                                        if (data['error'] ==
                                                            false) {
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              content: Text(data[
                                                                  'message']),
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                            ),
                                                          );
                                                          textController3
                                                              .clear();
                                                          textController4
                                                              .clear();
                                                          textController5
                                                              .clear();
                                                        } else if (data[
                                                                'error'] ==
                                                            true) {
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              content: Text(data[
                                                                  'message']),
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          2),
                                                            ),
                                                          );
                                                          textController3
                                                              .clear();
                                                          textController4
                                                              .clear();
                                                          textController5
                                                              .clear();
                                                        }
                                                      });
                                                    } else {
                                                      if (text.length == 10) {
                                                        Authservices.forgetpassword1(
                                                                textController3
                                                                    .text,
                                                                textController4
                                                                    .text,
                                                                textController5
                                                                    .text)
                                                            .then((data) {
                                                          if (data['error'] ==
                                                              false) {
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                content: Text(data[
                                                                    'message']),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            );
                                                            textController3
                                                                .clear();
                                                            textController4
                                                                .clear();
                                                            textController5
                                                                .clear();
                                                          } else if (data[
                                                                  'error'] ==
                                                              true) {
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                content: Text(data[
                                                                    'message']),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            );
                                                            textController3
                                                                .clear();
                                                            textController4
                                                                .clear();
                                                            textController5
                                                                .clear();
                                                          }
                                                        });
                                                      } else {
                                                        Authservices.forgetpassword2(
                                                                textController3
                                                                    .text,
                                                                textController4
                                                                    .text,
                                                                textController5
                                                                    .text)
                                                            .then((data) {
                                                          if (data['error'] ==
                                                              false) {
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                content: Text(data[
                                                                    'message']),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            );
                                                            textController3
                                                                .clear();
                                                            textController4
                                                                .clear();
                                                            textController5
                                                                .clear();
                                                          } else if (data[
                                                                  'error'] ==
                                                              true) {
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                content: Text(data[
                                                                    'message']),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                              ),
                                                            );
                                                            textController3
                                                                .clear();
                                                            textController4
                                                                .clear();
                                                            textController5
                                                                .clear();
                                                          }
                                                        });
                                                      }
                                                    }
                                                  }
                                                },
                                                child: const Text('Submit'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Forgot Password?'),
                                ),
                              ],
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Password';
                            }

                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20.0),
                        right: Radius.circular(20.0),
                      ),
                    ),
                  ),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(150, 35)),
                ),
                onPressed: () async {
                  String enteredValue = textController1.text;
                  final prefss = await SharedPreferences.getInstance();
                  setState(() {});
                  if (_formKey.currentState!.validate()) {
                    if (numericRegex.hasMatch(enteredValue)) {
                      setState(() {
                        _isLoading = true;
                      });
                      if (enteredValue.length == 10) {
                        Authservices.loginUser(textController1.text,
                                textController2.text, _setLoading)
                            .then((data) async {
                          setState(() {
                            _isLoading = false;
                          });

                          if (data['error'] == false) {
                            await prefss.setString(
                                'id', data['success']['userId'].toString());
                            // print(data['success']['token']);
                            await prefss.setString(
                                'token', data['success']['token'].toString());
                            await prefss.setString(
                                'ownername',
                                data['success']['ni_owner_ful_name']
                                    .toString());
                            // print(prefss.getString('token'));
                            await prefss.setString('user_type',
                                data['success']['ni_user_type'].toString());
                            await prefss.setString(
                                'token2', data['success']['token'].toString());
                            await prefss.setString('Tankerownermobile',
                                data['success']['ni_tanker_mo_no'].toString());
                            await prefss.setString('isAuthenticated', 'true');
                            if (data['success']['status'] == "5") {
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Login Successfully !!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else if (data['success']['status'] == "7") {
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardTanker()));
                              await prefss.setString('tankerowner', 'true');
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Login Successfully !!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              // showPopup(
                              //     "Please update the information of your Vehicle, such as the Vehicle Type. Please go to View Vehicle List, select the desired Vehicle, choose the Edit option, and then update the Vehicle Type accordingly.");
                            } else if (data['success']['status'] == "2") {
                              await prefss.setString('user_type', 'Builder');
                              // print(user_type);
                              // if (!mounted) return;
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardBuilder()));
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Login Successfully !!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              // showPopup(
                              //     "Please, update the information of your project, like Project Type -> PCMC Project or Non-PCMC Project & Tanker Preferences.Please go to View Project -> Edit -> Select Project Type -> Select Tanker preferences -> Update.");
                            } else if (data['success']['ni_user_type'] ==
                                "Garage") {
                              await prefss.setString('user_type', 'Garage');
                              // if (!mounted) return;
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardGarage()));
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Login Successfully !!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else if (data['success']['ni_user_type'] ==
                                "Society") {
                              await prefss.setString('user_type', 'Society');
                              var society = prefss.getString("updatelatlong");
                              // if (!mounted) return;
                              // ignore: use_build_context_synchronously
                              // Societylatlong
                              if (data['success']['society_status'] == "1") {
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DashboardSociety()));
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Societylatlong()));
                              }

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Login Successfully !!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else if (data['error'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                content: Text(data['message']),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top +
                                        8.0),
                                content: const Text(
                                    "Something Went Wrong,Please Try Again later"),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }

                          // return data;
                        });
                      } else {
                        // ****************************************************
                        Authservices.logincheck(textController1.text,
                                textController2.text, _setLoading)
                            .then((data) async {
                          setState(() {
                            _isLoading = false;
                          });
                          if (data['error'] == false) {
                            if (data['success']['ni_user_type'] == "PCMC") {
                              await prefss.setString('isAuthenticated', 'true');

                              await prefss.setString('user_type', 'PCMC');
                              await prefss.setString('PCMC_user_id',
                                  data['success']['userId'].toString());
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Login Successfully !!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardPCMCUSER()));
                            } else if (data['success']['ni_user_type'] ==
                                "Ward") {
                              await prefss.setString('wardofficerid',
                                  data['success']['wardId'].toString());
                              // await prefss.setString(
                              //     'token', data['success']['token'].toString());
                              await prefss.setString('user_type',
                                  data['success']['ni_user_type'].toString());

                              await prefss.setString('isAuthenticated', 'true');

                              await prefss.setString(
                                  'user_type', 'Wardofficer');
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text("Login Successfully !!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );

                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardWardOfficer()));
                            }
                          } else if (data['error'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                content: Text(data['message']),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
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
                    } else if (alphabeticRegex.hasMatch(enteredValue)) {
                      setState(() {
                        _isLoading = true;
                      });
                      Authservices.loginstp(textController1.text,
                              textController2.text, _setLoading)
                          .then((data) async {
                        // print(data);
                        setState(() {
                          _isLoading = false;
                        });
                        if (data['error'] == false) {
                          await prefss.setString(
                              'stp_id', data['success']['userId'].toString());
                          await prefss.setString(
                              'token', data['success']['token'].toString());
                          await prefss.setString('user_type',
                              data['success']['ni_user_type'].toString());

                          await prefss.setString('isAuthenticated', 'true');

                          await prefss.setString('user_type', 'Stp');
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              content: Text("Login Successfully !!"),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DashboardStp()));
                        } else if (data['error'] == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              content: Text(data['message']),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                  "Something Went Wrong,Please Try Again later"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      });
                    } else if (alphanumericRegex.hasMatch(enteredValue)) {
                      setState(() {
                        _isLoading = true;
                      });
                      if (enteredValue.length == 10) {
                        Authservices.logintanker(textController1.text,
                                textController2.text, _setLoading)
                            .then((data) async {
                          setState(() {
                            _isLoading = false;
                          });
                          if (data['error'] == false) {
                            await prefss.setString('tankerowner', 'false');
                            await prefss.setString('tanker_id',
                                data['success']['userId'].toString());
                            await prefss.setString(
                                'token', data['success']['token'].toString());
                            await prefss.setString('user_type',
                                data['success']['ni_user_type'].toString());

                            await prefss.setString('isAuthenticated', 'true');

                            await prefss.setString('user_type', 'Tanker');
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                content: Text("Login Successfully !!"),
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardTankerDriver()));
                          } else if (data['error'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                content: Text(data['message']),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                    "Something Went Wrong,Please Try Again later"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        });
                      } else if (enteredValue.length > 10) {
                        Authservices.loginmanager(textController1.text,
                                textController2.text, _setLoading)
                            .then((data) async {
                          setState(() {
                            _isLoading = false;
                          });
                          if (data['error'] == false) {
                            await prefss.setString('manager_id',
                                data['success']['userId'].toString());
                            await prefss.setString('user_type', 'Manager');
                            await prefss.setString('isAuthenticated', 'true');

                            await prefss.setString('builder_id',
                                data['success']['user_id'].toString());
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                content: Text("Login Successfully !!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            // if (data["success"]["status"] == "1") {
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardManager()));
                            // } else {
                            //   // ignore: use_build_context_synchronously
                            //   Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               const AddProject1()));
                            // }
                            // ignore: use_build_context_synchronously
                          } else if (data['error'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                content: Text(data['message']),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                    "Something Went Wrong,Please Try Again later"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        });
                      }
                    } else {
                      // Invalid input
                    }
                  }
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Registration()));
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
              TextButton(
                  onPressed: () {
                    // ignore: deprecated_member_use
                    launch(
                        'https://pcmcstp.stockcare.co.in/public/STP%20Project%20User%20Manual.pdf');
                  },
                  child: const Text(
                    "User Manual",
                    style: TextStyle(color: Colors.green),
                  )),
              Visibility(
                visible: _isLoading,
                child: const CircularProgressIndicator(),
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
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          // topLeft: Radius.circular(30),
                          topRight: Radius.circular(50),
                        ),
                        color: (Color.fromARGB(255, 186, 226, 171)),
                      ),
                      child: const Center(
                          child: Text(
                        "Powered by Nyati Technologies Pvt Ltd",
                        style: TextStyle(fontSize: 11),
                      )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
