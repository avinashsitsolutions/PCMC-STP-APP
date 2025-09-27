import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Stpsservices {
  static reportstp(
    String date1,
    String date2,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("stp_id");
    var token = prefss.getString("token");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/stp_report'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        "userId": id.toString(),
        "from_date": date1.toString(),
        "to_date": date2.toString(),
      },
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static reportwardoff(String date1, String date2, String id) async {
    final response = await http.post(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/getWardOfficierReport'),
      body: {
        "id": id.toString(),
        "from_date": date1.toString(),
        "to_date": date2.toString(),
      },
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static stplist() async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("wardofficerid");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/getAssignedSTPs'),
      // headers: {
      //   'Authorization': 'Bearer $token',
      //   'Accept': 'application/json',
      //   'Content-Type': 'application/x-www-form-urlencoded',
      // },
      body: {
        "id": id.toString(),
      },
    );

    var data = jsonDecode(response.body);
    return data;
  }
}
