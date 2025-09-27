import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tankerpcmc/pmc/builderlist.dart';
import 'package:tankerpcmc/pmc/dailysupply.dart';
import 'package:tankerpcmc/pmc/orderlist.dart';

import 'package:http/http.dart' as http;
import 'package:tankerpcmc/pmc/stplist.dart';
import 'package:tankerpcmc/pmc/tankerlist.dart';
import 'package:tankerpcmc/pmc/todayreceipt.dart';
import 'package:tankerpcmc/widgets/dimensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/drawerWidget.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
    // required this.myList
  });
  // final List<dynamic> myList;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool get wantKeepAlive => true;
  List<dynamic> count = [];

  bool loading = true;
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
//  'Total No.of Registered Tankers',
//     'Total Orders',
//     'Daily Supply(in liters)',
//     'Today Orders',
//     'Total No.of Registered STP',
//     'Total No.of Registered Builders',
  @override
  void initState() {
    finalList();
    super.initState();
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
    // super.build(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: LayoutBuilder(builder: (context, constraints) {
            return count.isNotEmpty
                ? GridView.builder(
                    itemCount: count.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 20,
                      crossAxisCount: 2,
                      childAspectRatio:
                          constraints.maxWidth / (constraints.maxHeight * 0.7),
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BuilderList()),
                              );

                              break;
                            case 1:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TankerList()));

                              break;
                            case 2:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StpList()),
                              );

                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrderList()),
                              );

                              break;
                            case 4:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TodayReceipt()),
                              );
                              break;
                            case 5:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DailySupply()),
                              );
                              break;
                          }
                        },
                        child: SizedBox(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                    radius: 20,
                                    child: Image.asset(
                                      imagePaths[index],
                                      fit: BoxFit.cover,
                                      scale: 1.2,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  count[index],
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  text[index].toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )),
                      );
                    },
                  )
                : SizedBox(
                    height: Dimensions.screenHeight / 2,
                    child: const Center(
                        // widthFactor: ,
                        child: CircularProgressIndicator()),
                  );
          }),
        ),
      ),
    );
    // ));
  }
}
