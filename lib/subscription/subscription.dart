import 'package:flutter/material.dart';
class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('訂閱策略'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Subscription Page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}