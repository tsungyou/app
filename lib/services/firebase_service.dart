import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Future<void> updateStrategyExpirationDate(int strategyNumber, uid, int days) async {
    // Get the current document to check existing expiration date
    final docSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();
        
    final DateTime now = DateTime.now();
    final existingExpDate = docSnapshot.data()?['strategies']?['strategy$strategyNumber']?['expirationDate'];
    
    final DateTime expDate = existingExpDate != null
        ? DateTime.fromMillisecondsSinceEpoch(existingExpDate).add(Duration(days: days))
        : now.add(Duration(days: days));

    await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .update({
        'strategies.strategy$strategyNumber.active': true,
        'strategies.strategy$strategyNumber.expirationDate': expDate.toUtc().millisecondsSinceEpoch,
      });
  }
  // bool isStrategyValid(Map<String, dynamic> strategy) {
  //   if (!strategy['active']) return false;
    
  //   final expiration = strategy['expirationDate'];
  //   if (expiration == null) return false;
    
  //   final expirationDate = DateTime.fromMillisecondsSinceEpoch(expiration);
  //   return DateTime.now().isBefore(expirationDate);
  // }
}