import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_ios/google_maps_flutter_ios.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:tankerpcmc/Auth/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // White background for status bar
    statusBarIconBrightness: Brightness.dark, // Dark icons (Android)
    statusBarBrightness: Brightness.light, // Dark icons (iOS)
    systemNavigationBarColor: Colors.white, // White bottom nav bar
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // Ensure platform-specific configurations for Google Maps
  if (defaultTargetPlatform == TargetPlatform.android) {
    final GoogleMapsFlutterAndroid androidMapImplementation =
        GoogleMapsFlutterAndroid();
    androidMapImplementation.useAndroidViewSurface = true;
    GoogleMapsFlutterPlatform.instance = androidMapImplementation;
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    final GoogleMapsFlutterIOS iosMapImplementation = GoogleMapsFlutterIOS();
    GoogleMapsFlutterPlatform.instance = iosMapImplementation;
  }

  // Check connectivity
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.none) {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PCMC Recycle Water System',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // ✅ solid white everywhere
          elevation: 0,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        primarySwatch:
            createMaterialColor(const Color.fromARGB(255, 186, 226, 171)),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.red,
        ),
      ),
      home: const SpalshScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}
