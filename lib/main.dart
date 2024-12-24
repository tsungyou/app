import 'package:flutter/material.dart';
// import 'package:test_empty_1/login/login.dart';
import "package:test_empty_1/login/login.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: "test",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    home: const Login(),
    );
  }
}