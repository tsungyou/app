
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:test_empty_1/services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});
  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}


const List<String> _prudoctIds = <String>[
  "strategy_1_month_1",
];
class _SubscriptionPageState extends State<SubscriptionPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  bool _isAvailable = false;
  String? _notice;

  @override
  void initState(){
    super.initState();
    initStoreInfo();
  }
  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    setState(() {
      _isAvailable = isAvailable;
    });

    if(_isAvailable) {
      _notice = "There are no upgrades at this time";
      return;
    }

    setState(() {
      _notice = "There is a connection to the store";
    });
    // Get IAP

  }

  // final List<String> _strategies = ['策略A', '策略B', '策略C', '策略D'];
  // final List<bool> _subscribed = [false, false, false, false];
  // void _toggleSubscription(int index) {
  //   setState(() {
  //     _subscribed[index] = !_subscribed[index];
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('訂閱策略'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if(_notice != null) 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_notice!),
              ),
          ],
        ),
      ),
      // ListView.builder(
      //   itemCount: _strategies.length,
      //   itemBuilder: (context, index) {
      //     if (index == 0) {
      //       return Container(
      //         child: IconButton(
      //           onPressed: () {
      //              FirebaseFirestore.instance
      //             .collection("user")
      //             .doc(AuthService().currentUser?.uid)
      //             .collection('strategies')
      //             .add({
      //               "1": false,
      //               "2": false,
      //               "3": false,
      //               "4": false,
      //               "5": false,
      //               "6": false,
      //               "7": false,
      //               "8": false,
      //               "9": false,
      //               "10": false,
      //               "11": false,
      //               "12": false
      //             });
      //             print("inserted into ${AuthService().currentUser?.uid}");

      //             // Get data from Firestore
      //             // var snapshot = await FirebaseFirestore.instance
      //             // .collection("user")
      //             // .doc(AuthService().currentUser?.uid)
      //             // .collection('strategies')
      //             // .get();

      //             // // Convert to map
      //             // Map<String, dynamic> strategiesMap = {};
      //             // for (var doc in snapshot.docs) {
      //             //   strategiesMap[doc.id] = doc.data();
      //             // }
      //             // print(strategiesMap);
      //           },
      //           icon: const Icon(Icons.abc_outlined),
      //         ),
      //       );
      //     } else {
      //       return Card(
      //         child: ListTile(
      //           title: Text(_strategies[index]),
      //           trailing: IconButton(
      //             icon: Icon(
      //               _subscribed[index] ? Icons.check_circle : Icons.circle_outlined,
      //               color: _subscribed[index] ? Colors.green : Colors.grey,
      //             ),
      //             onPressed: () => _toggleSubscription(index),
      //           ),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
