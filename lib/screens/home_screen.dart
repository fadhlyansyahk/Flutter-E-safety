import 'dart:convert';
import 'package:api2/main.dart';

import 'package:api2/Services/auth_services.dart';
import 'package:api2/screens/editform.dart';
import 'package:api2/screens/inputform.dart';
import 'package:api2/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../Services/foto_services.dart';
import '../Services/globals.dart';
import '../models/foto.dart';
import '../models/user.dart';
import 'detail_page.dart';

class Fotos {
  final int id;
  final String id_user;
  final String kasus;
  final String lokasi;
  final String tanggal;
  final String deskripsi;
  final String foto;

  const Fotos(this.id, this.id_user, this.kasus, this.lokasi, this.tanggal,
      this.deskripsi, this.foto);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _kasus = '';
  String _lokasi = '';
  String _tanggal = '';
  String _deskripsi = '';

  Future getAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var url = Uri.parse('http://10.0.2.2:8000/api/foto?token=${token!}');
    var response = await http.get(url);
    var data = json.decode(response.body);
    return data;
  }

  delForm(int _id) async {
    var response = await FotoServices.deleteForm(
      _id,
    );
    // Map responseMap = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print("inputform >>>>");
      // print(response);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ));
    } else {
      errorSnackBar(context, response as String);
    }
  }

  void myAlert2(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Apakah anda ingin menghapus form ini?'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => delForm(id),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'HAPUS',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      HomeScreen();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.camera),
                        Text('BATAL'),
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
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    PaintingBinding.instance.imageCache.clear();
    return FutureBuilder<UserWithToken>(
      future: getUserFromToken(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<UserWithToken> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            var _user = snapshot.data;

            if (_user!.message == null) {
              if (_user.user?.level == 'ADMIN') {
                return Scaffold(
                  appBar: AppBar(),
                  drawer: SafeArea(
                      child: Drawer(
                    child: Column(
                      children: [
                        DrawerHeader(
                          child: ListTile(
                            title: Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            AuthServices.logout();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return LoginScreen();
                                },
                              ),
                            );
                          },
                          leading: Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  // backgroundColor: Colors.grey[400],
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => InputForm(),
                          ));
                    },
                    child: const Icon(Icons.add),
                  ),
                  body: FutureBuilder(
                      future: getAllData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            itemCount: snapshot.data['fotos'].length,
                            itemBuilder: (context, index) {
                              var url = snapshot.data['fotos'][index]['foto'];
                              // print(url);
                              var urlSplitted = url.split("public");
                              // print(urlSplitted);
                              var BASE_URL = "http://10.0.2.2:8000";
                              // print(BASE_URL + urlSplitted[1]);
                              return Card(
                                // color: Colors.black,
                                child: ListTile(
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        EditForm(
                                                            fotos: Fotos(
                                                  snapshot.data['fotos'][index]
                                                      ['id'],
                                                  snapshot.data['fotos'][index]
                                                          ['id_user']
                                                      .toString(),
                                                  snapshot.data['fotos'][index]
                                                      ['kasus'],
                                                  snapshot.data['fotos'][index]
                                                      ['lokasi'],
                                                  snapshot.data['fotos'][index]
                                                      ['tanggal'],
                                                  snapshot.data['fotos'][index]
                                                      ['deskripsi'],
                                                  snapshot.data['fotos'][index]
                                                      ['foto'],
                                                )),
                                              ));
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      // IconButton(
                                      //   onPressed: () => delForm(snapshot
                                      //       .data['fotos'][index]['id']),
                                      //   icon: const Icon(Icons.delete),
                                      // ),
                                      IconButton(
                                        onPressed: () {
                                          myAlert2(snapshot.data['fotos'][index]
                                              ['id']);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                      snapshot.data['fotos'][index]['kasus']),
                                  subtitle: Text(snapshot.data['fotos'][index]
                                      ['deskripsi']),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return DetailPage(
                                            fotos: Fotos(
                                          snapshot.data['fotos'][index]['id'],
                                          snapshot.data['fotos'][index]
                                                  ['id_user']
                                              .toString(),
                                          snapshot.data['fotos'][index]
                                              ['kasus'],
                                          snapshot.data['fotos'][index]
                                              ['lokasi'],
                                          snapshot.data['fotos'][index]
                                              ['tanggal'],
                                          snapshot.data['fotos'][index]
                                              ['deskripsi'],
                                          snapshot.data['fotos'][index]['foto'],
                                        ));
                                      }),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Divider();
                        }
                      }),
                );
              } else {
                return Scaffold(
                  appBar: AppBar(
                    actions: [
                      IconButton(
                          icon: Icon(
                            Icons.logout,
                          ),
                          onPressed: () {
                            AuthServices.logout();

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginScreen(),
                                ));
                          })
                    ],
                  ),
                  backgroundColor: Colors.blue,
                  body: Center(
                    child: Text('HOMEPAGE USER'),
                  ),
                );
              }
            }

            return LoginScreen();
          } // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }

  Future<UserWithToken> getUserFromToken() async {
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

    var userFromToken = UserWithToken.fromJson(jsonDecode(response.body));

    return Future.value(userFromToken); // return your response
  }
}
