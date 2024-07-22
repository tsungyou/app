import 'package:flutter/material.dart';
import 'package:test_empty_1/login/login.dart';
import 'package:test_empty_1/home/home.dart';
import 'package:test_empty_1/strategies/trend.dart';
import 'package:test_empty_1/strategies/buy_hold.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
      // home: Trend(),
      // home: Home(),
      // home: TestHome(),
      // home: BuyHold(),
    );
  }
}