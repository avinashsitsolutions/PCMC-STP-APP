import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tankerpcmc/Auth/splashscreen.dart';

class CheckInternetConnectionWidget extends StatelessWidget {
  final AsyncSnapshot<ConnectivityResult> snapshot;
  final Widget widget;
  const CheckInternetConnectionWidget(
      {Key? key, required this.snapshot, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (snapshot.connectionState) {
      case ConnectionState.active:
        final state = snapshot.data!;
        switch (state) {
          case ConnectivityResult.none:
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded),
                Text(
                  'Internet Not connected',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ],
            ));
          default:
            return widget;
        }
      default:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded),
              Text(
                'Check your Internet Connection!',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        );
    }
  }
}

// ignore: must_be_immutable
class InternetConnectivityScreen extends StatelessWidget {
  InternetConnectivityScreen({Key? key}) : super(key: key);

  Random random = Random();

  @override
  Widget build(BuildContext context) {
    Connectivity connectivity = Connectivity();
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<ConnectivityResult>(
          stream: connectivity.onConnectivityChanged,
          builder: (_, snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CheckInternetConnectionWidget(
                  snapshot: snapshot, widget: const SpalshScreen()),
            );
          },
        ),
      ),
    );
  }
}
