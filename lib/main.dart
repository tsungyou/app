import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_empty_1/home/home.dart';
import 'package:test_empty_1/onboarding/onboarding_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_empty_1/services/auth_service.dart';
// import "package:test_empty_1/config.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AuthService().getOrCreateUser();
  
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: Home(),));
}
