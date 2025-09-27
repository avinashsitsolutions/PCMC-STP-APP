// import 'package:flutter/material.dart';

// class Practice extends StatefulWidget {
//   const Practice({super.key});

//   @override
//   State<Practice> createState() => _PracticeState();
// }

// class _PracticeState extends State<Practice> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }


// loginUser(String email, String password) async {
//       final prefss = await SharedPreferences.getInstance();
//       final response = await http.post(
//         Uri.parse("api url"),
//         body: {
//           'email': email,
//           'password': password,
//           'device_name': password,
//         },
//       );
//       var data = jsonDecode(response.body);
//       setState(() {
//         buttonLoading = false;
//       });
//       if (data['login'] == "true") {
//         var userData = data['user_data'];
//         await prefss.setString('token', data['token'].toString());
//         await prefss.setString('user_id', userData['id'].toString());
//         await prefss.setString('isAuthenticated', 'true');
//         if (userData['user_type'] == 2) {
//           await prefss.setString('user_type', 'supervisor');
//           if (!mounted) return;
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const SupervisorMainScreen()));
//         } else {
//           await prefss.setString('user_type', 'admin');
//           if (!mounted) return;
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => const AdminMainScreen()));
//         }
//       } else {
//         var err = jsonDecode(response.body);
//         var snackBar = SnackBar(
//           content: Text(err['message']),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         );
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         return data;
//       }
//     }




//     static getCounts() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = prefs.getString("token");
//     var response = await http.get(
//       Uri.parse("$baseURL/api/admin/counts"),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );
//     var data = jsonDecode(response.body);
//     return data;
//   }