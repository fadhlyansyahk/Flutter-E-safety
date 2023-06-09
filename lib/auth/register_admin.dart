import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/auth_services.dart';
import '../Services/globals.dart';
import '../models/user.dart';
import '../rounded_button.dart';
import '../screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email = '';
  String _username = '';
  String _password = '';
  String _name = '';

  createAccountPressed() async {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    if (emailValid) {
      http.Response response = await AuthServices.registerAdmin(
        _name,
        _username,
        _email,
        _password,
      );
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }
    } else {
      errorSnackBar(context, 'email not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserWithToken>(
      future: getUserFromToken(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<UserWithToken> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
            backgroundColor: Colors.white,
          ));
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var user = snapshot.data;

            if (user!.message == null) {
              return const HomeScreen();
            } else {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  centerTitle: true,
                  elevation: 0,
                  title: const Text(
                    'Registration Admin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                        onChanged: (value) {
                          _name = value;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Username',
                        ),
                        onChanged: (value) {
                          _username = value;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        onChanged: (value) {
                          _email = value;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RoundedButton(
                        btnText: 'Create Account',
                        onBtnPressed: () => createAccountPressed(),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (BuildContext context) => const LoginScreen(),
                      //         ));
                      //   },
                      //   child: const Text(
                      //     'already have an account',
                      //     style: TextStyle(
                      //       decoration: TextDecoration.underline,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              );
            }
          } // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }

  Future<UserWithToken> getUserFromToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    token ??= 'invalid';

    var url = Uri.parse('${baseURL}auth/check-token?token=$token');
    http.Response response = await http.post(
      url,
      headers: headers,
    );

    var userFromToken = UserWithToken.fromJson(jsonDecode(response.body));

    return Future.value(userFromToken); // return your response
  }
}
