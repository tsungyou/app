import 'package:flutter/material.dart';
import 'package:test_empty_1/home/home.dart';
import 'package:test_empty_1/onboarding/onboarding_view.dart';
import 'package:firebase_core/firebase_core.dart';
// import "package:test_empty_1/config.dart";

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: Home(),));
}