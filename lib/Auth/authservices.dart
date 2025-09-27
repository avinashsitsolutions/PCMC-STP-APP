import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authservices {
  static registerUser(
    String usertype,
    String firstname,
    String lastname,
    String email,
    String mobno,
    String lattitude,
    String longitude,
    String name,
    String address,
    String tankerno,
    String ownerfullname,
    String status,
    String password,
    String tankermob,
    // ignore: non_constant_identifier_names
    String PCMCid,
    String PCMCname,
  ) async {
    final response = await http.post(
      Uri.parse('https://pcmcstp.stockcare.co.in/public/api/register_new'),
      body: {
        'ni_user_type': usertype,
        'ni_first_name': firstname,
        'ni_last_name': lastname,
        'ni_email': email,
        'ni_contact_no': mobno,
        'ni_lat': lattitude,
        'ni_long': longitude,
        'ni_name': name,
        'ni_address': address,
        'ni_owner_ful_name': ownerfullname,
        'status': status,
        'password': password,
        'ni_tanker_mo_no': tankermob,
        'employee_id': PCMCid,
        'ni_employee_name': PCMCname
      },
    );
    var data = jsonDecode(response.body.toString());

    return data;
  }

  static loginUser(
      String mobno, String password, Function(bool) setLoading) async {
    setLoading(true);

    final prefss = await SharedPreferences.getInstance();

    var token = prefss.getString("token");

    final response = await http.post(
      Uri.parse("https://pcmcstp.stockcare.co.in/public/api/login_new"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'ni_contact_no': mobno,
        'ni_tanker_mo_no': mobno,
        'password': password,
      },
    );
    var data = jsonDecode(response.body);
    setLoading(false);
    return data;
  }

  static loginWardOfficer(
      String id, String password, Function(bool) setLoading) async {
    setLoading(true);
    final response = await http.post(
      Uri.parse("https://pcmcstp.stockcare.co.in/public/api/PCMC_login"),
      body: {
        'ni_employee_id': id,
        'password': password,
      },
    );
    var data = jsonDecode(response.body);
    setLoading(false);
    return data;
  }

  static logincheck(
      String id, String password, Function(bool) setLoading) async {
    setLoading(true);
    final response = await http.post(
      Uri.parse("https://pcmcstp.stockcare.co.in/public/api/PCMC_login"),
      body: {
        'employee_id': id,
        'password': password,
        'ni_employee_id': id,
      },
    );
    var data = jsonDecode(response.body);
    setLoading(false);
    return data;
  }

  static forgetpassword(
    String mobno,
    String password,
    String newpassword,
  ) async {
    final response = await http.post(
      Uri.parse(
          "https://pcmcstp.stockcare.co.in/public/api/updatePassword_tanker_owner"),
      body: {
        'tanker_mo_no_or_contact_no': mobno,
        'password': password,
        'password_confirmation': newpassword,
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static forgetpassword1(
    String tankerno,
    String password,
    String newpassword,
  ) async {
    final response = await http.post(
      Uri.parse(
          "https://pcmcstp.stockcare.co.in/public/api/users/password/tanker"),
      body: {
        'ni_tanker_no': tankerno,
        'password': password,
        'password_confirmation': newpassword,
      },
    );
    var data = jsonDecode(response.body);

    return data;
  }

  static forgetpassword2(
    String tankerno,
    String password,
    String newpassword,
  ) async {
    final response = await http.post(
      Uri.parse(
          "https://pcmcstp.stockcare.co.in/public/api/updatePassword_bcp"),
      body: {
        'ni_bcp_no': tankerno,
        'password': password,
        'password_confirmation': newpassword,
      },
    );
    var data = jsonDecode(response.body);

    return data;
  }

  static loginstp(
      String name, String password, Function(bool) setLoading) async {
    final prefss = await SharedPreferences.getInstance();

    var token = prefss.getString("token");
    // print(token1);
    final response = await http.post(
      Uri.parse("https://pcmcstp.stockcare.co.in/public/api/stp_login"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'ni_stp_uname': name,
        'password': password,
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static logintanker(
      String tankerno, String password, Function(bool) setLoading) async {
    final prefss = await SharedPreferences.getInstance();

    var token = prefss.getString("token");
    // print(token);
    final response = await http.post(
      Uri.parse("https://pcmcstp.stockcare.co.in/public/api/tanker_login"),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'ni_tanker_no': tankerno,
        'password': password,
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static loginmanager(
      String bcpno, String password, Function(bool) setLoading) async {
    // print(token);
    final response = await http.post(
      Uri.parse(
          "https://pcmcstp.stockcare.co.in/public/api/site_manager_login"),
      body: {
        'ni_bcp_no': bcpno,
        'password': password,
      },
    );
    var data = jsonDecode(response.body);
    return data;
  }

  static update() async {
    final response = await http.get(
      Uri.parse("https://pcmcstp.stockcare.co.in/public/api/version"),
    );
    var data = jsonDecode(response.body);
    return data;
  }
}
