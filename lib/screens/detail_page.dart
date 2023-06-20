import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'home_screen.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.fotos});
  final Fotos fotos;

  @override
  Widget build(BuildContext context) {
    var url = this.fotos.foto;
    // print(url);
    var urlSplitted = url.split("public");
    // print(urlSplitted);
    // var BASE_URL = "http://10.0.2.2:8000"; //emulator
    var BASE_URL = "http://192.168.4.25:8000"; //real hp
    var scaffoldComponent = Scaffold(
        appBar: AppBar(
          title: Text('Detail Page'),
          centerTitle: true,
        ),
        body: Card(
          color: Colors.black,
          elevation: 4,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(FontAwesomeIcons.idCard),
                  iconColor: Colors.white,
                  title: Text(fotos.id_user),
                  textColor: Colors.white,
                ),
                ListTile(
                  leading: Icon(Icons.report_problem),
                  iconColor: Colors.white,
                  title: Text(fotos.kasus),
                  textColor: Colors.white,
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.mapLocationDot),
                  iconColor: Colors.white,
                  title: Text(fotos.lokasi),
                  textColor: Colors.white,
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.calendar),
                  iconColor: Colors.white,
                  title: Text(fotos.tanggal),
                  textColor: Colors.white,
                ),
                ListTile(
                  leading: Icon(Icons.description),
                  iconColor: Colors.white,
                  title: Text(fotos.deskripsi),
                  textColor: Colors.white,
                ),
                ListTile(
                  title: Image.network(
                    BASE_URL + urlSplitted[1],
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ));
    PaintingBinding.instance.imageCache.clear();
    return scaffoldComponent;
  }
}
