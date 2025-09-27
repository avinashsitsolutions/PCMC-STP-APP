// import 'package:flutter/cupertino.dart';

// import 'package:pie_chart/pie_chart.dart';

// class Piechart extends StatefulWidget {
//   const Piechart({super.key});

//   @override
//   State<Piechart> createState() => _PiechartState();
// }

// class _PiechartState extends State<Piechart> {
//   Map<String, double> datamap = {
//     "10000L Tanker": 20,
//     "7000L Tanker": 10,
//     "5000L Tanker": 10,
//   };
//   List<Color> colorlist = [
//     const Color(0xFF4B0082),
//     const Color(0xFF8A2BE2),
//     const Color(0xFF7986CB),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: PieChart(
//         dataMap: datamap,
//         colorList: colorlist,
//         chartType: ChartType.ring,
//         chartValuesOptions: const ChartValuesOptions(showChartValues: false),
//         legendOptions: const LegendOptions(
//           showLegends: true,
//           legendShape: BoxShape.rectangle,
//           legendTextStyle: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ));
//   }
// }
