import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Tankerservices {
  AddVehicle(
    String number,
    String drivername,
    String drivermobile,
    String capacity,
    String nearststp,
    String password,
    String tankertype,
    List<dynamic> builderIds,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    var name = prefss.getString("ownername");
    var ownermonileno = prefss.getString("Tankerownermobile");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/Add_tanker_new'),
      body: {
        'ni_owner_ful_name': name,
        'tanker_id': id,
        'status': "1",
        "ni_tanker_mo_no": ownermonileno,
        'ni_user_type': "Tanker",
        'ni_tanker_no': number,
        'ni_tanker_capacity': capacity,
        'ni_nearest_stp': nearststp,
        'password': password,
        'tanker_type': tankertype,
        "builder_id": jsonEncode(builderIds),
        "tanker_driver_name": drivername,
        "tanker_driver_mo_no": drivermobile,
      },
    );
    var data = jsonDecode(response.body); 
    return data;
  }

  static viewtankerlist() async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/view_tanker'),
      body: {
        "id": id.toString(),
      },
    );

    var data = jsonDecode(response.body);
    return data;
  }

  // ignore: non_constant_identifier_names
  Allocate(
    String rno,
    String vehicleno,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/Allocate_tanker'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        "order_id": rno,
        "ni_vehicle_no": vehicleno,
      },
    );
    var data = jsonDecode(response.body);
    // print(data);
    return data;
  }

  static reportankerDriver(
    String tankerno,
    String date1,
    String date2,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/getTankerReport'),
      body: {
        "id": id,
        "ni_tanker_no": tankerno,
        "from_date": date1.toString(),
        "to_date": date2.toString(),
      },
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static reportankerDriverall(
    String date1,
    String date2,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.post(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/getTankerReportall'),
      body: {
        "id": id,
        "from_date": date1.toString(),
        "to_date": date2.toString(),
      },
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static reportanker(
    String date1,
    String date2,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("tanker_id");
    var token = prefss.getString("token");

    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/tanker_report'),
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

  static updateTanker(
    List<dynamic> builderIds,
    String type,
    String id,
    String drivername,
    String driverno,
    String capacity,
    String stp,
  ) async {
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/updateTanker'),
      body: {
        "tanker_id": id,
        "builder_id": jsonEncode(builderIds),
        'tanker_type': type,
        'ni_tanker_capacity': capacity,
        'ni_nearest_stp': stp,
        'tanker_driver_mo_no': driverno,
        'tanker_driver_name': drivername,
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }
}
// 'ni_tanker_no');
//        ('ni_tanker_capacity');
//      ni_nearest_stp');
//      'ni_tanker_mo_no');
//        'tanker_driver_mo_no');
//        tanker_driver_name');
//       'ni_owner_ful_name');
//       tanker_type');
//       builder_id'));
       