import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Builderservices {
  // ignore: non_constant_identifier_names
  static AddProject(String projectname, String address, String lat, String long,
      String rerano, String name) async {
    // print(name);
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("manager_id");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/update_project'),
      body: {
        "id": id,
        "ni_project_name": projectname,
        'ni_rera_no': rerano,
        "ni_project_address": address, 
        "ni_project_lat": lat,
        "ni_project_long": long,
        "site_manger_name": name,
        "status": "1",
      },
    );
    var data = jsonDecode(response.body);
    // print(jsonDecode(response.body));
    return data;
  }

  static addBCP(
    String bcp,
    String mobile,
    String password,
    String projecttype,
    String projectname,
    String address,
    String lat,
    String long,
    String name,
    List<dynamic> bwatertypeid,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/Add_BCP_latest'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'ni_bcp_no': bcp,
        'password': password,
        'ni_site_man_mo_no': mobile,
        'project_type': projecttype,
        'tanker_type': "",
        "ni_project_name": projectname,
        'ni_rera_no': "",
        "ni_project_address": address,
        "ni_project_lat": lat,
        "ni_project_long": long,
        "site_manger_name": name,
        "status": "1",
        "water_type_id": jsonEncode(bwatertypeid),
        // "site_id":
      },
    );
    var data = jsonDecode(response.body);
    // print(jsonDecode(response.body));
    return data;
  }

  static updateBCP(
    String id,
    String projectname,
    String password,
    String mobile,
    String projecttype,
    // String tankertype,
    String bcp,
    String address,
    String lat,
    String long,
    String name,
    List<dynamic> bwatertypeid,
  ) async {
    final prefss = await SharedPreferences.getInstance();

    var token = prefss.getString("token");

    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/update_bcp_new'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'id': id,
        'password': password,
        'ni_site_man_mo_no': mobile,
        'project_type': projecttype,
        'tanker_type': "",
        "ni_project_name": projectname,
        'ni_rera_no': "",
        "ni_project_address": address,
        "ni_project_lat": lat,
        "ni_project_long": long,
        "site_manger_name": name,
        "water_type_id": jsonEncode(bwatertypeid),
      },
    );
    var data = jsonDecode(response.body);
    // print(jsonDecode(response.body));
    return data;
  }

  static viewdetails() async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("manager_id");
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/site_project_details?id=$id'),
    );
    var data = jsonDecode(response.body);
    // print(jsonDecode(response.body));
    return data;
  }

  static watercharges() async {
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/order_price_show'),
    );
    var data = jsonDecode(response.body);
    // print(jsonDecode(response.body));
    return data;
  }

  static bcplist() async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/view_bcp_no_new'),
      body: {
        "userId": id.toString(),
      },
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static builderrrport(String id, String fromdate, String todate) async {
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/getBuilderReport'),
      body: {"userId": id.toString(), "from_date": fromdate, "to_date": todate},
    );

    var data = jsonDecode(response.body);

    return data;
  }

  static builderrrportall(String fromdate, String todate) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("id");
    final response = await http.post(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/getBuilderReportall'),
      body: {"userId": id.toString(), "from_date": fromdate, "to_date": todate},
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static Order(
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
      String id,
      String watercharges) async {
    final prefss = await SharedPreferences.getInstance();
    var projectid = prefss.getString("manager_id");
    var builderid = prefss.getString("builder_id");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/project_orderss'),
      body: {
        "ni_project_name": projectname,
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
        "project_id": projectid,
        "user_id": builderid,
        "price": watercharges
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static OrderPCMC(
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
    var builderid = prefss.getString("PCMC_user_id");

    final response = await http.post(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/project_orders_pmc'),
      body: {
        "ni_project_name": projectname,
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
        "project_id": " ",
        "user_id": builderid
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  // ignore: non_constant_identifier_names
  static Order2(String name, String capacity, String stp) async {
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    // print(token);
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        "ni_project_name": "",
        "ni_society_name": "",
        "ni_garage_name": name,
        "ni_water_capacity": capacity,
        "ni_nearest_stp": stp,
      },
    );
    var data = jsonDecode(response.body);

    return data;
  }

  // ignore: non_constant_identifier_names
  static OrderSociety(String society, String capacity, String stp) async {
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    // print(token);
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        "ni_project_name": "",
        "ni_society_name": society,
        "ni_garage_name": "",
        "ni_water_capacity": capacity,
        "ni_nearest_stp": stp,
      },
    );
    var data = jsonDecode(response.body);
    // print(data);

    return data;
  }

  double calculateCost(double distance, double liters) {
    double rate = 0;
    if (liters == 5000) {
      if (distance <= 5) {
        rate = 400;
      } else {
        rate = 400 + (distance - 5) * 100.toDouble();
      }
    } else if (liters == 1000) {
      if (distance <= 5) {
        rate = 200;
      } else {
        rate = 200 + (distance - 5) * 100.toDouble();
      }
    } else if (liters == 7000) {
      if (distance <= 5) {
        rate = 600;
      } else {
        rate = 600 + (distance - 5) * 200.toDouble();
      }
    } else if (liters == 10000) {
      if (distance <= 5) {
        rate = 800;
      } else {
        rate = 800 + (distance - 5) * 200.toDouble();
      }
    } else if (liters == 20000) {
      if (distance <= 5) {
        rate = 1000;
      } else {
        rate = 1000 + (distance - 5) * 200.toDouble();
      }
    }
    return rate;
  }

  double calculateCost1(
      double distance, double liters, double baseRate, double ratePerUnit) {
    if (distance <= 5) {
      return baseRate;
    } else {
      double extraDistance = distance - 5;
      return baseRate + (extraDistance * ratePerUnit);
    }
  }

  static getprice(
    String capacity,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/water_amount_show?water_qty=$capacity'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static tankerlist(
    String capacity,
    String stp,
  ) async {
    final prefss = await SharedPreferences.getInstance();
    var id = prefss.getString("manager_id");
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/tanker_infoo_new?id=$id&ni_tanker_capacity=$capacity&ni_nearest_stp=$stp&ni_user_type=Tanker'),
    );
    var data = jsonDecode(response.body);
    return data;
  }
}
