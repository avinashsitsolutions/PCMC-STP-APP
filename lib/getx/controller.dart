import 'package:get/get.dart';

class LocationController extends GetxController {
  // Initialize latitude and longitude properties
  var latitude = RxString('0.0');
  var longitude = RxString('0.0');
  var address = RxString('');

  // Function to update latitude and longitude values
  void setLocationDetails(
      double newLatitude, double newLongitude, String newadress) {
    latitude.value = newLatitude.toString();
    longitude.value = newLongitude.toString();
    address.value = newadress.toString();
  }
}

class CountController extends GetxController {
  String tanker = "0";
  String order = "0";
  String supply = "0";
  String receipt = "0";
  String stp = "0";
  String builder = "0";

  setcount(
    String tank,
    String ord,
    String supp,
    String rec,
    String st,
    String bui,
  ) {
    tanker = tank;
    order = ord;
    supply = supp;
    receipt = rec;
    stp = st;
    builder = bui;
    update();
  }
}

class Location1Controller extends GetxController {
  String lattitude1 = "Lattitude";
  String longitude1 = "Longitude";

  setLocationDetails1(String lat, String long) {
    lattitude1 = lat;
    longitude1 = long;
    update();
  }
}

class Location2Controller extends GetxController {
  String lattitude2 = "Lattitude";
  String longitude2 = "Longitude";

  setLocationDetails2(String latt, String longg) {
    lattitude2 = latt;
    longitude2 = longg;
    update();
  }
}

class LocationMapController extends GetxController {
  RxDouble latitude = RxDouble(0.0);
  RxDouble longitude = RxDouble(0.0);

  void updateLocation(double lat, double lng) {
    latitude.value = lat;
    longitude.value = lng;
  }
}
