import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

class PageLoadingAnim extends StatefulWidget {
  final String path;
  const PageLoadingAnim({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  State<PageLoadingAnim> createState() => _PageLoadingAnimState();
}

class _PageLoadingAnimState extends State<PageLoadingAnim> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Lottie.asset(widget.path),
        Text(
          "Loading...",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
// loading == true
//           ? const PageLoadingAnim(
//               path: 'assets/lottie/order.json',
//             )
//           :