import 'package:flutter/material.dart';

import '../../Services/auth_services.dart';
import '../../auth/login_screen.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
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
      body: const Center(child: Text("Halaman Admin")),
    );
  }
}
