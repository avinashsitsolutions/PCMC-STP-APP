// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:location/location.dart';
// import 'package:tankerpcmc/builder/builderservices.dart';
// import 'package:tankerpcmc/builder/dashboard_builder.dart';
// import 'package:tankerpcmc/widgets/drawerwidget.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../getx/controller.dart';

// class UpdateProject extends StatefulWidget {
//   const UpdateProject({
//     super.key,
//     required this.projecttype,
//     required this.projectbcpno,
//     required this.mobileno,
//     // required this.tankertype,
//     required this.password,
//     required this.rerano,
//     required this.managername,
//     required this.address,
//     required this.lat,
//     required this.long,
//     required this.projectname,
//     required this.id,
//   });
//   final String projecttype;
//   final String projectbcpno;
//   final String mobileno;
//   // final String tankertype;
//   final String password;
//   final String rerano;
//   final String managername;
//   final String address;
//   final String lat;
//   final String long;
//   final String projectname;
//   final String id;
//   @override
//   State<UpdateProject> createState() => _UpdateProjectState();
// }

// class _UpdateProjectState extends State<UpdateProject> {
//   final latController = TextEditingController();
//   final longController = TextEditingController();

//   TextEditingController nameController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController reraController = TextEditingController();
//   TextEditingController managernameController = TextEditingController();
//   late GoogleMapController mapController;
//   String stpAddress = '';
//   // late LocationData currentLocation;
//   Marker? _marker;
//   final Set<Marker> _markers = {};

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   bool loadingButton = false;
//   MapType _currentMapType = MapType.normal;
//   String mb = '0';

//   final formKey = GlobalKey<FormState>();

//   checkLocationIsEnabledOrNot() async {
//     bool serviceEnabled;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location services are disabled. Please enable the services')));
//       Geolocator.openLocationSettings();
//       return false;
//     } else {
//       // _getCurrentPosition();
//     }
//   }

//   Future<bool> _onWillPop() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Exit App'),
//           content: const Text('Do you want to exit the app?'),
//           actions: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('No'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 SystemNavigator.pop();
//               },
//               child: const Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//     return false;
//   }

//   // TextEditingController latController = TextEditingController();
//   // TextEditingController longController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   @override
//   void dispose() {
//     super.dispose();
//     latController.clear();
//     longController.clear();
//     // addressController.clear();
//   }

//   @override
//   void initState() {
//     super.initState();
//     reraController.text = widget.rerano;
//     nameController.text = widget.projectname;
//     addressController.text = widget.address;
//     latController.text = widget.lat;
//     longController.text = widget.long;
//     managernameController.text = widget.managername;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         centerTitle: true,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             InkWell(
//               // ignore: deprecated_member_use
//               onTap: () => launch('https://pcmcindia.gov.in/index.php'),
//               child: const Image(
//                 image: AssetImage('assets/pcmc_logo.jpg'),
//                 height: 50,
//               ),
//             ),
//             const Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "PCMC",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 15),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   "Treated Water Recycle and Reuse System",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 13),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           Builder(
//             builder: (BuildContext context) {
//               return IconButton(
//                 icon: const Icon(
//                   Icons.menu,
//                   size: 25,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Scaffold.of(context).openEndDrawer();
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       endDrawer: const DrawerWid(),
//       body: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(
//                 left: 20,
//                 right: 20,
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Colors.green[50],
//                 ),
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Center(
//                           child: Text(
//                             "Update a Project",
//                             style: TextStyle(
//                                 fontSize: 21,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         const Text(
//                           "Project Rera No :",
//                           style: TextStyle(
//                               fontSize: 17,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         TextFormField(
//                           controller: reraController,
//                           maxLength: 15,
//                           decoration: const InputDecoration(
//                             hintText: 'Enter  Rera Number',
//                             fillColor: Colors.white,
//                             filled: true,
//                             contentPadding: EdgeInsets.only(bottom: 4.0),
//                             hintStyle: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 17,
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                             ),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value!.length > 15) {
//                               return 'Please enter valid  Rera Number';
//                             }
//                             return null;
//                           },
//                           style: const TextStyle(
//                             fontSize: 17.0,
//                             // fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         const Text(
//                           "Project Name :",
//                           style: TextStyle(
//                               fontSize: 17,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         TextFormField(
//                           controller: nameController,
//                           decoration: const InputDecoration(
//                             fillColor: Colors.white,
//                             filled: true,
//                             hintText: 'Enter Project Name',
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 12.0, horizontal: 16.0),
//                             isDense: true,
//                             hintStyle: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 17,
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter name';
//                             }
//                             return null;
//                           },
//                           style: const TextStyle(
//                             fontSize: 17.0,
//                             // fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         const Text(
//                           "Project Manager Name :",
//                           style: TextStyle(
//                               fontSize: 17,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         TextFormField(
//                           controller: managernameController,
//                           decoration: const InputDecoration(
//                             fillColor: Colors.white,
//                             filled: true,
//                             hintText: 'Enter Name',
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 12.0, horizontal: 16.0),
//                             isDense: true,
//                             hintStyle: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 17,
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter Name';
//                             }
//                             return null;
//                           },
//                           style: const TextStyle(
//                             fontSize: 17.0,
//                             // fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         GetBuilder<LocationController>(
//                             init: LocationController(),
//                             builder: (controller) {
//                               return Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     "Project Address :",
//                                     style: TextStyle(
//                                         fontSize: 17,
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   TextFormField(
//                                     controller: addressController,
//                                     onChanged: (value) =>
//                                         controller.address.value = value,
//                                     decoration: const InputDecoration(
//                                       hintText: 'Select Address From Map Below',
//                                       fillColor: Colors.white,
//                                       filled: true,
//                                       contentPadding:
//                                           EdgeInsets.only(bottom: 4.0),
//                                       hintStyle: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 17,
//                                       ),
//                                       enabledBorder: UnderlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.white),
//                                       ),
//                                       focusedBorder: UnderlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.white),
//                                       ),
//                                     ),
//                                     validator: (value) {
//                                       if (value!.isEmpty) {
//                                         return 'Please enter Address';
//                                       }
//                                       return null;
//                                     },
//                                     style: const TextStyle(
//                                       fontSize: 17.0,
//                                       // fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 15,
//                                   ),
//                                   SizedBox(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "Lattitude:",
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Expanded(
//                                           child: TextFormField(
//                                             controller: latController,
//                                             onChanged: (value) => controller
//                                                 .latitude.value = value,
//                                             decoration: const InputDecoration(
//                                               hintText: 'Enter Lattitude',
//                                               fillColor: Colors.white,
//                                               filled: true,
//                                               contentPadding:
//                                                   EdgeInsets.only(bottom: 4.0),
//                                               hintStyle: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 18,
//                                               ),
//                                               enabledBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Colors.white),
//                                               ),
//                                               focusedBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Colors.white),
//                                               ),
//                                             ),
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return 'Please Enter Lattitude';
//                                               }
//                                               return null;
//                                             },
//                                             style: const TextStyle(
//                                               fontSize: 18.0,
//                                               // fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 15,
//                                   ),
//                                   SizedBox(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "Lattitude:",
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         Expanded(
//                                           child: TextFormField(
//                                             controller: longController,
//                                             onChanged: (value) => controller
//                                                 .longitude.value = value,
//                                             decoration: const InputDecoration(
//                                               hintText: 'Enter Longitude',
//                                               fillColor: Colors.white,
//                                               filled: true,
//                                               contentPadding:
//                                                   EdgeInsets.only(bottom: 4.0),
//                                               hintStyle: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 18,
//                                               ),
//                                               enabledBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Colors.white),
//                                               ),
//                                               focusedBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Colors.white),
//                                               ),
//                                             ),
//                                             validator: (value) {
//                                               if (value!.isEmpty) {
//                                                 return 'Please Enter Longitude';
//                                               }
//                                               return null;
//                                             },
//                                             style: const TextStyle(
//                                               fontSize: 18.0,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             }),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Center(
//                           child: ElevatedButton(
//                             style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   Colors.green),
//                               foregroundColor: MaterialStateProperty.all<Color>(
//                                   Colors.white),
//                               shape: MaterialStateProperty.all<OutlinedBorder>(
//                                 const RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.horizontal(
//                                     left: Radius.circular(20.0),
//                                     right: Radius.circular(20.0),
//                                   ),
//                                 ),
//                               ),
//                               minimumSize: MaterialStateProperty.all<Size>(
//                                   const Size(150, 35)),
//                             ),
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 Builderservices.updateBCP(
//                                         widget.id,
//                                         widget.projectbcpno,
//                                         widget.password,
//                                         widget.mobileno,
//                                         widget.projecttype,
//                                         nameController.text,
//                                         addressController.text,
//                                         latController.text,
//                                         longController.text,
//                                         managernameController.text)
//                                     .then((data) async {
//                                   if (data['error'] == false) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text(
//                                             'BCP Number Updated Successfulyy'),
//                                         backgroundColor: Colors.green,
//                                       ),
//                                     );
//                                     nameController.clear();
//                                     addressController.clear();
//                                     latController.clear();
//                                     longController.clear();
//                                     reraController.clear();
//                                     managernameController.clear();
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const DashboardBuilder()));
//                                   } else if (data['error'] == true) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text(data['message']),
//                                         backgroundColor: Colors.red,
//                                       ),
//                                     );
//                                     nameController.clear();
//                                     addressController.clear();
//                                     latController.clear();
//                                     longController.clear();
//                                     reraController.clear();
//                                     managernameController.clear();
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const DashboardBuilder()));
//                                   } else {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text('Something Went Wrong'),
//                                         backgroundColor: Colors.red,
//                                       ),
//                                     );
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const DashboardBuilder()));
//                                     nameController.clear();
//                                     addressController.clear();
//                                     latController.clear();
//                                     longController.clear();
//                                     reraController.clear();
//                                     managernameController.clear();
//                                   }
//                                 });
//                               }
//                             },
//                             child: const Text(
//                               'Update',
//                               style: TextStyle(fontSize: 17),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
