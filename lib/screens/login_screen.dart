import 'dart:convert';

import 'package:api2/screens/register_screen.dart';
import 'package:api2/screens/register_screen_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/auth_services.dart';
import '../Services/globals.dart';
import '../models/user.dart';
import '../rounded_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String _username = '';
  String _password = '';

  loginPressed() async {
    if (_username.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await AuthServices.login(
        _username,
        _password,
      );
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
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
    return FutureBuilder<UserWithToken>(
      future: getUserFromToken(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<UserWithToken> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.purple,
            backgroundColor: Colors.white,
          ));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            var _user = snapshot.data;

            if (_user!.message == null) {
              return HomeScreen();
            } else {
              return Scaffold(
                  backgroundColor: Colors.grey[350],
                  body: SingleChildScrollView(
                    child: SafeArea(
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/bumnlogo.png",
                                    height: 150,
                                    width: 125,
                                  ),
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Image.asset(
                                    "images/baratalogo.png",
                                    height: 150,
                                    width: 125,
                                  ),
                                ]),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Aplikasi Report! ",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Silakan Login ",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueGrey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      icon: Icon(
                                        FontAwesomeIcons.user,
                                        color: Colors.black,
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Username',
                                    ),
                                    onChanged: (value) {
                                      _username = value;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueGrey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        icon: Icon(
                                          FontAwesomeIcons.lock,
                                          color: Colors.black,
                                        ),
                                        border: InputBorder.none,
                                        hintText: 'Password'),
                                    onChanged: (value) {
                                      _password = value;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            RoundedButton(
                              btnText: 'LOG IN',
                              onBtnPressed: () => loginPressed(),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const RegisterScreen(),
                                    ));
                              },
                              child: const Text(
                                'Belum Punya Akun Admin?',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const RegisterScreenUser(),
                                    ));
                              },
                              child: const Text(
                                'Belum Punya Akun?',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            }
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
