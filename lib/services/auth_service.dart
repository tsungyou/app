import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> getOrCreateUser() async {
    if(currentUser == null) {
      await _firebaseAuth.signInAnonymously();
    }
    
    // Use set() with merge to create or update the document
    await FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser?.uid)  // Use the current instance's user
      .set({
        'strategies': {
          'strategy1': {
            'active': false,
            'expirationDate': null
          },
          'strategy2': {
            'active': false,
            'expirationDate': null
          },
          'strategy3': {
            'active': false,
            'expirationDate': null
          },
          'strategy4': {
            'active': false,
            'expirationDate': null
          },
          'strategy5': {
            'active': false,
            'expirationDate': null
          },
          'strategy6': {
            'active': false,
            'expirationDate': null
          },
          'strategy7': {
            'active': false,
            'expirationDate': null
          },
          'strategy8': {
            'active': false,
            'expirationDate': null
          },
          'strategy9': {
            'active': false,
            'expirationDate': null
          },
          'strategy10': {
            'active': false,
            'expirationDate': null
          },
          'strategy11': {
            'active': false,
            'expirationDate': null
          },
          'strategy12': {
            'active': false,
            'expirationDate': null
          }
        }
      }, SetOptions(merge: true));

    return currentUser;
  }
}