import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PCMCservices {
  static addstp(String name, String uname, String address, String contactname,
      String mobno, String password, String lat, String long) async {
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/stp_register'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': ' application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'ni_user_type': "Stp",
        'ni_stp_name': name,
        'ni_stp_uname': uname,
        'ni_stp_address': address,
        'ni_contact_person': contactname,
        'ni_contact_no': mobno,
        'password': password,
        'ni_stp_lat': lat,
        'ni_stp_long': long,
        'status': "6",
      },
    );
    var data = jsonDecode(response.body);
    // await prefss.setString('token1', data['success']['token'].toString());
    // if (data['error'] == "false") {
    //   await prefss.setString('status', data['data']['status'].toString());
    // }
    return data;
  }

  // ignore: non_constant_identifier_names
  static AddCap(
    String cap,
  ) async {
    // final prefss = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/water_capacity'),
      body: {
        'ni_water_capacity': cap,
      },
    );
    var data = jsonDecode(response.body);
    // print(data);

    return data;
  }

  static addOfficer(
    String id,
    String name,
    String number,
    String password,
    List<dynamic> stpIds,
  ) async {
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/Add_ward_officier'),
      body: {
        "ni_employee_id": id,
        "ni_ward_officier_name": name,
        "ni_stp_assign": jsonEncode(stpIds),
        "ni_contact_no": number,
        "password": password,
        "ni_user_type": "Ward",
      },
    );
    var data = jsonDecode(response.body.toString());
    return data;
  }

  static addDepartment(
    String deptname,
    String name,
    String number,
    String whatsappno,
    String email,
  ) async {
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/Add_department'),
      body: {
        "department_name": deptname,
        "incharge_name": name,
        "incharge_mo_no": number,
        "whatsapp_no": whatsappno,
        "email_id": email,
      },
    );
    var data = jsonDecode(response.body.toString());
    return data;
  }

// https://pcmcstp.stockcare.co.in/public/api/Add_ward_officier
  static builderreport(
    String date1,
    String date2,
    String type,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/generateReportBuilder?from_date=$date1&to_date=$date2&user_type=$type'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static reporttanker(
    String date1,
    String date2,
    String type,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/generateReportTanker?from_date=$date1&to_date=$date2&user_type=$type'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static reportstp(
    String date1,
    String date2,
    String type,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/generateReportstp?from_date=$date1&to_date=$date2&user_type=$type'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static reportsociety(
    String date1,
    String date2,
    String type,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/generate_Report_Society?from_date=$date1&to_date=$date2&user_type=$type'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static report(
    String date1,
    String date2,
    String type,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/generateReport?from_date=$date1&to_date=$date2&user_type=$type'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static todaysrecepits() async {
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/TodaysRecipt'),
    );
    var data = jsonDecode(response.body);
    return data;
  }

  // ignore: non_constant_identifier_names
  DashCount() async {
    final prefss = await SharedPreferences.getInstance();
    var token = prefss.getString("token");
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/countr'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static excelreport1() async {
    final response = await http.get(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/final_order_excel'),
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static excelreport2() async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/stp_wise_tan_reg_count_api'),
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static excelreport3() async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/stp_wise_tan_reg_count_today_api'),
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static excelreport4() async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/generateReportstp_api_new'),
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static reportstp4(
    String date1,
    String date2,
    String id,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/stp_report_admin?userId=$id&from_date=$date1&to_date=$date2'),
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static reportsociety2(
    String date1,
    String date2,
    String id,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/Society_Report_admin?from_date=$date1&to_date=$date2&user_id=$id'),
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static reportbuilder2(
    String date1,
    String date2,
    String firstname,
    String lastname,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/builder_report_admin?from_date=$date1&to_date=$date2&ni_first_name=$firstname&ni_last_name=$lastname'),
    );

    var data = jsonDecode(response.body);
    return data;
  }

  static reporttanker3(
    String date1,
    String date2,
    String tankerno,
  ) async {
    final response = await http.get(
      Uri.parse(
          'https://pcmcstp.stockcare.co.in/public/api/tanker_report_admin?from_date=$date1&to_date=$date2&ni_tanker_no=$tankerno'),
    );

    var data = jsonDecode(response.body);
    return data;
  }
}
