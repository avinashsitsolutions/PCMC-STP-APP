import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Services {
  static AddProjectPCMC(
      String projectname,
      String dept,
      String address,
      String lat,
      String long,
      String inchargename,
      String inchargenumber) async {
    // print(name);
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("PCMC_user_id");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/Add_PCMC_project'),
      body: {
        "department_name": dept,
        "ni_project_name": projectname,
        "ni_project_address": address,
        "ni_project_lat": lat,
        "ni_project_long": long,
        "incharge_name": inchargename,
        "incharge_mobile_no": inchargenumber,
        "user_id": id,
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static reportPCMCuser(
    String date1,
    String date2,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("PCMC_user_id");
    final response = await http.post(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/getPCMCprojectReport'),
      body: {
        "userId": id.toString(),
        "from_date": date1.toString(),
        "to_date": date2.toString(),
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }
}
