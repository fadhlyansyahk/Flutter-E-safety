import 'dart:convert';

import 'package:api2/screens/inputform.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

import '../models/user.dart';
import 'dart:io';
import 'globals.dart';

class FotoServices {
  static Future<String> InputForm(String kasus, String lokasi, String tanggal,
      String deskripsi, File imageFile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = await prefs.getString('token');
    Map<String, String> data = {
      "token": token!,
      "kasus": kasus,
      "lokasi": lokasi,
      "tanggal": tanggal,
      "deskripsi": deskripsi,
    };

    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var url = Uri.parse('${baseURL}foto');

    var request = http.MultipartRequest('POST', url)
      ..fields.addAll(data)
      ..files.add(http.MultipartFile('foto', stream, length,
          filename: basename(imageFile.path)));

    var response = await request.send();

    if (response.statusCode == 201) {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      return responseString;
    } else {
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      return responseString;
    }
  }

  static Future<http.Response> updateDetailFoto(int id, String kasus,
      String lokasi, String tanggal, String deskripsi) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = await prefs.getString('token');

    Map data = {
      "id": id,
      "kasus": kasus,
      "lokasi": lokasi,
      "tanggal": tanggal,
      "deskripsi": deskripsi,
      "token": token!,
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}foto');
    http.Response response = await http.put(
      url,
      headers: headers,
      body: body,
    );
    print(response);
    return response;
  }

  static Future<http.Response> deleteForm(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = await prefs.getString('token');
    Map data = {
      "id": id,
      "token": token!,
    };
    var body = json.encode(data);
    var url = Uri.parse('${baseURL}foto');
    http.Response response = await http.delete(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }
}
