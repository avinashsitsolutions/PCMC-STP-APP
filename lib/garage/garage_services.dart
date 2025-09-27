import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Garageservices {
  static updatelatlong(
    String address,
    String lat,
    String long,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/update_garage'),
      body: {
        "id": id,
        "ni_lat": lat,
        "ni_long": long,
        "ni_address": address,
        "garage_status": "1",
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static getlatlong() async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/garage_name_order?id=$id'),
    );
    var data = jsonDecode(response.body);
    // print(jsonDecode(response.body));
    return data;
  }

  static tankerlistgarage(
    String capacity,
    String stp,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/tanker_info_society?id=$id&ni_tanker_capacity=$capacity&ni_nearest_stp=$stp&ni_user_type=Tanker'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static OrderGarage(
      String projectname,
      String capacity,
      String stp,
      String distance,
      String amt,
      String name,
      String tcapacity,
      String mobno,
      String tno,
      String tmob,
      String id) async {
    final prefss = await SharedPreferences.getInstance();
    var garageid = prefss.getString("id");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/garage_orders'),
      body: {
        "ni_garage_name": projectname,
        "ni_water_capacity": capacity,
        "ni_nearest_stp": stp,
        "ni_distance": distance,
        "ni_estimated_amount": amt,
        "ni_owner_ful_name": name,
        "ni_tanker_capacity": tcapacity,
        "ni_contact_no": mobno,
        "ni_tanker_no": tno,
        "ni_tanker_mo_no": tmob,
        "tanker_id": id,
        "user_id": garageid
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static reportgarage(String fromdate, String todate) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/garage_Report?from_date=$fromdate&to_date=$todate&user_id=$id'),
    );
    var data = jsonDecode(response.body);
    return data;
  }
}
