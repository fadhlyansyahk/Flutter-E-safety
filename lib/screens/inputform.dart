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

class InputForm extends StatefulWidget {
  const InputForm({super.key});

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  File? imageFile;

  String _kasus = '';
  String _lokasi = '';
  String _tanggal = '';
  String _deskripsi = '';
  String _foto = '';

  submitFoto() async {
    if (_kasus.isNotEmpty &&
        _lokasi.isNotEmpty &&
        _tanggal.isNotEmpty &&
        _deskripsi.isNotEmpty) {
      var response = await FotoServices.InputForm(
          _kasus, _lokasi, _tanggal, _deskripsi, imageFile!);
      // Map responseMap = jsonDecode(response.body);
      if (response.isNotEmpty) {
        print("inputform >>>>");
        print(response);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen(),
            ));
      } else {
        errorSnackBar(context, response);
      }
    } else {
      errorSnackBar(context, 'Harap Diisi');
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('pilih foto'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //Button untuk upload foto
                    onPressed: () {
                      Navigator.pop(context);
                      _getFromGallery();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('Buka Galeri'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      _getFromCamera();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('Buka Kamera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Input Form'),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'note: Harap Isi Foto Terlebih Dahulu!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            myAlert();
                          },
                          child: Text('Upload Foto'),
                        ),
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
                            : Text(
                                "Mana Fotonya ?",
                                style: TextStyle(fontSize: 20),
                              ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Kasus',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: 'kasus',
                              icon: Icon(
                                Icons.report_problem,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (value) {
                              _kasus = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Lokasi',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: 'lokasi',
                              icon: Icon(
                                FontAwesomeIcons.mapLocationDot,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (value) {
                              _lokasi = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Tanggal',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: 'tanggal',
                              icon: Icon(
                                FontAwesomeIcons.calendar,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (value) {
                              _tanggal = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Deskripsi',
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: 'deskripsi',
                              icon: Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                            ),
                            onChanged: (value) {
                              _deskripsi = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1000,
      maxHeight: 1000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
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
