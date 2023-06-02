import 'dart:convert';
import 'package:api2/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'globals.dart';

class AuthServices {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static Future<http.Response> registerAdmin(
      String name, String username, String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map data = {
      "name": name,
      "username": username,
      "email": email,
      "password": password,
      "level": 'ADMIN'
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    var userWithToken = UserWithToken.fromJson(jsonDecode(response.body));
    if (userWithToken.token != null) {
      await prefs.setString('token', userWithToken.token!);
    }
    return response;
  }

  static Future<http.Response> registerUser(
      String name, String username, String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {
      "name": name,
      "username": username,
      "email": email,
      "password": password,
      "level": 'USER'
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    var userWithToken = UserWithToken.fromJson(jsonDecode(response.body));
    if (userWithToken.token != null) {
      await prefs.setString('token', userWithToken.token!);
    }
    return response;
  }

  static Future<http.Response> login(String username, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {
      "username": username,
      "password": password,
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    var userWithToken = UserWithToken.fromJson(jsonDecode(response.body));
    if (userWithToken.token != null) {
      await prefs.setString('token', userWithToken.token!);
    }
    return response;
  }

  static logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
  }
}
