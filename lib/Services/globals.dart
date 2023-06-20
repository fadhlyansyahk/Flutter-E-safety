import 'package:flutter/material.dart';

// const String baseURL = "http://10.0.2.2:8000/api/"; //emulator localhost
const String baseURL = "http://192.168.4.25:8000/api/"; // real hp
const Map<String, String> headers = {
  "Content-Type": "application/json",
  "Accept": "application/json"
};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}
