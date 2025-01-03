import 'package:flutter/material.dart';
class Value extends StatefulWidget {
  const Value({super.key});
  @override
  State<Value> createState() => _Value();
}

class _Value extends State<Value>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Text("1234"),
    );
  }
}
