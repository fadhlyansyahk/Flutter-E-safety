import 'dart:convert';

import 'package:api2/rounded_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/foto_services.dart';
import '../Services/globals.dart';
import '../models/foto.dart';
import 'home_screen.dart';

class EditForm extends StatefulWidget {
  const EditForm({super.key, required this.fotos});
  final Fotos fotos;

  @override
  State<EditForm> createState({fotos}) => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  File? imageFile;

  String _kasus = '';
  String _lokasi = '';
  String _tanggal = '';
  String _deskripsi = '';
  int _id = 0;

  TextEditingController kasusController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  submitFoto() async {
    if (_kasus.isNotEmpty &&
        _lokasi.isNotEmpty &&
        _tanggal.isNotEmpty &&
        _deskripsi.isNotEmpty) {
      var response = await FotoServices.updateDetailFoto(
          _id, _kasus, _lokasi, _tanggal, _deskripsi);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("inputform >>>>");
        print(response);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen(),
            ));
      } else {
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
      errorSnackBar(context, 'Harap Diisi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserFromToken(),
        builder: (BuildContext context, AsyncSnapshot<InputFoto> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.purple,
              backgroundColor: Colors.black,
            ));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              var _user = snapshot.data;

              if (_user!.user == null) {
                return HomeScreen();
              } else {
                _id = widget.fotos.id;
                kasusController.text = widget.fotos.kasus;
                _kasus = widget.fotos.kasus;
                tanggalController.text = widget.fotos.tanggal;
                _tanggal = widget.fotos.tanggal;
                lokasiController.text = widget.fotos.lokasi;
                _lokasi = widget.fotos.lokasi;
                deskripsiController.text = widget.fotos.deskripsi;
                _deskripsi = widget.fotos.deskripsi;
                return Scaffold(
                  appBar: AppBar(title: Text('Edit Form')),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                icon: Icon(Icons.report_problem),
                                border: InputBorder.none,
                                hintText: 'kasus',
                              ),
                              controller: kasusController,
                              onChanged: (value) {
                                _kasus = value;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                icon: Icon(FontAwesomeIcons.mapLocationDot),
                                border: InputBorder.none,
                                hintText: 'lokasi',
                              ),
                              controller: lokasiController,
                              onChanged: (value) {
                                _lokasi = value;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                icon: Icon(FontAwesomeIcons.calendar),
                                border: InputBorder.none,
                                hintText: 'tanggal',
                              ),
                              controller: tanggalController,
                              onChanged: (value) {
                                _tanggal = value;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                icon: Icon(Icons.description),
                                border: InputBorder.none,
                                hintText: 'deskripsi',
                              ),
                              controller: deskripsiController,
                              onChanged: (value) {
                                _deskripsi = value;
                              },
                            ),
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     myAlert();
                        //   },
                        //   child: Text('Upload Foto'),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        //jika gambar ada ditampilkan
                        //jika gambar kosong ada notif
                        imageFile != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    //to show image, you type like this.
                                    File(imageFile!.path),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                  ),
                                ),
                              )
                            :
                            // : Text(
                            //     "Mana Fotonya ?",
                            //     style: TextStyle(fontSize: 20),
                            //   ),
                            SizedBox(
                                height: 20,
                              ),
                        RoundedButton(
                            btnText: 'submit', onBtnPressed: () => submitFoto())
                      ],
                    ),
                  ),
                );
              }
            }
          }
        });
  }

  Future<InputFoto> getUserFromToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token == null) {
      token = 'invalid';
    }

    var url = Uri.parse('${baseURL}auth/check-token?token=${token}');
    http.Response response = await http.post(
      url,
      headers: headers,
    );

    var userFromToken = InputFoto.fromJson(jsonDecode(response.body));

    return Future.value(userFromToken); // return your response
  }
}
