import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> getOrCreateUser() async {
    if(currentUser == null) {
      await _firebaseAuth.signInAnonymously();
    }
    await FirebaseFirestore.instance
    .collection("user")
    .doc(AuthService().currentUser?.uid)
    .collection('strategies')
    .add({
      "1": false,
      "2": false,
      "3": false,
      "4": false,
      "5": false,
      "6": false,
      "7": false,
      "8": false,
      "9": false,
      "10": false,
      "11": false,
      "12": false
    });

    return currentUser;
  }
}