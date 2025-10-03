import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Your other screens
import 'builderlist.dart';
import 'dailysupply.dart';
import 'orderlist.dart';
import 'stplist.dart';
import 'tankerlist.dart';
import 'todayreceipt.dart';
import '../widgets/drawerWidget.dart';

// ✅ Dashboard Screen
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> count = [];

  List<String> imagePaths = [
    'assets/buildings.png',
    'assets/truckfast.png',
    'assets/Water damage1.png',
    'assets/Calendar today.png',
    'assets/Receipt long.png',
    'assets/Opacity.png',
  ];

  List<String> text = [
    'Total No.of Registered Builders',
    'Total No.of Registered Tankers',
    'Total No.of Registered STP',
    'Total Orders',
    'Today Orders',
    'Today\'s Supply(in liters)',
  ];

  @override
  void initState() {
    super.initState();
    finalList();
  }

  getCounts() async {
    var response = await http.get(
      Uri.parse("https://pcmcstp.stockcare.co.in/public/api/count_new"),
    );
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  }

  finalList() {
    getCounts().then((data) {
      final List<String> dataList = [];
      data.forEach((key, value) {
        dataList.add(value.toString());
      });
      setState(() {
        count = dataList;
      });
    });
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
  Widget build(BuildContext context) {
    // ✅ Responsive values using GetX
    double screenHeight = Get.height;
    double screenWidth = Get.width;

    double height10 = screenHeight / 84.4;
    double height20 = screenHeight / 42.2;
    double height30 = screenHeight / 28.1;

    double width10 = screenWidth / 84.4;
    double width20 = screenWidth / 42.2;

    double font12 = screenHeight / 70.3;
    double font16 = screenHeight / 52.7;
    double font20 = screenHeight / 42.2;

    double icon25 = screenHeight / 33.7;

    // ✅ Adjust grid column count based on screen width
    int crossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 900
            ? 3
            : 4;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // ✅ White background
        statusBarIconBrightness: Brightness.dark, // ✅ Android dark icons
        statusBarBrightness: Brightness.light, // ✅ iOS dark icons
      ),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white, // ✅ background fills screen
          extendBody: true, // ✅ fixes iOS black bar issue
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark, // ✅ dark icons
            titleSpacing: 0,
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => launchUrl(
                      Uri.parse('https://pcmcindia.gov.in/index.php')),
                  child: Image.asset('assets/pcmc_logo.jpg',
                      height: height30 * 1.5),
                ),
                SizedBox(width: width10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Pimpri-Chinchwad Municipal Corporation",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: font12, color: Colors.black),
                    ),
                    SizedBox(height: height10 / 2),
                    Text(
                      "Treated Water Recycle and Reuse System",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: font12 - 2, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu, size: icon25, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                },
              ),
            ],
          ),
          endDrawer: const DrawerWid(),
          body: SafeArea(
            // ✅ keeps content below notch
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width10),
              child: count.isNotEmpty
                  ? GridView.builder(
                      itemCount: count.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: width20,
                        mainAxisSpacing: height20,
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Get.to(() => const BuilderList());
                                break;
                              case 1:
                                Get.to(() => const TankerList());
                                break;
                              case 2:
                                Get.to(() => const StpList());
                                break;
                              case 3:
                                Get.to(() => const OrderList());
                                break;
                              case 4:
                                Get.to(() => const TodayReceipt());
                                break;
                              case 5:
                                Get.to(() => const DailySupply());
                                break;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(width10),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: height20,
                                  child: Image.asset(
                                    imagePaths[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: height10),
                                Text(
                                  count[index],
                                  style: TextStyle(
                                    fontSize: font20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: height10),
                                Text(
                                  text[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: font16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      height: screenHeight / 2,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
            ),
          ),
          // ✅ Bottom Navigation included
          // bottomNavigationBar: BottomNavigationBar(
          //   backgroundColor: Colors.white, // ✅ no black strip
          //   selectedItemColor: Colors.green,
          //   unselectedItemColor: Colors.grey,
          //   items: const [
          //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          //     BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
          //   ],
          // ),
        ),
      ),
    );
  }
}
