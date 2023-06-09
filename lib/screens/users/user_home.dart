import 'package:flutter/material.dart';

import '../../Services/auth_services.dart';
import '../../auth/login_screen.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User"),
        actions: [
          IconButton(
              onPressed: () {
                AuthServices.logout();

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen(),
                    ));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(child: Text("Halaman User")),
    );
  }
}
