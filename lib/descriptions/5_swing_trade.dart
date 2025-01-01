import 'package:flutter/material.dart';

class TimeManagement extends StatefulWidget {
  const TimeManagement({super.key});

  @override
  State<TimeManagement> createState() => _TimeManagementState();
}

class _TimeManagementState extends State<TimeManagement> {
  final List<Widget> items = [
    const Text(
      '• 此為TICK流打法，意指搶幾個檔就跑跟搶銀行一樣，搶到要跑，沒搶到更要跑！\n'
      '• 早上9:11~13:24就會開始有盤中提示(會至少觀察兩個5分K)\n',
      style: TextStyle(fontSize: 12, height: 1.5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey[400]!,
                Colors.grey[600]!,
              ],
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: items[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}