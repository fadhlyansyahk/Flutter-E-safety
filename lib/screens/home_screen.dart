import 'dart:convert';

import 'package:api2/Services/auth_services.dart';
import 'package:api2/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../Services/globals.dart';
import '../models/user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

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
                    child: Text('HOMEPAGE ADMIN'),
                  ),
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
