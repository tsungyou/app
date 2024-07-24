import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;


  
class DetailPage extends StatefulWidget {
  final String symbol;
  DetailPage({super.key, required this.symbol});
  
  @override
  State<DetailPage> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  List<Map<String, dynamic>> stockPrice = [];
  String start = '2024-01-01';
  @override
  void initState() {
    super.initState();
    fetchSingleStock(widget.symbol);
  }
  
  Future<void> fetchSingleStock(String symbol) async {
    var uri = Uri.parse("http://localhost:8080/price?start=$start&symbols=$symbol");
    var response = await http.get(uri);
    setState(() {
      stockPrice = jsonDecode(response.body)
        .map<Map<String, dynamic>>((item) => {
        'da': item['da'],
        'codename': item['codename'],
        'symbol': item['symbol'],
        'industry': item['industry'],
        'op': item['op'],
        'hi': item['hi'],
        'lo': item['lo'],
        'cl': item['cl'],
        })
      .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Individual Stock Detail Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
            SfCartesianChart(
              primaryXAxis: const DateTimeAxis(),
              series: <CartesianSeries>[
                CandleSeries<dynamic, DateTime>(
                  dataSource: stockPrice,
                  xValueMapper: (data, _) => DateTime.parse(data['da']),
                  lowValueMapper: (data, _) => data['lo'],
                  highValueMapper: (data, _) => data['hi'],
                  openValueMapper: (data, _) => data['op'],
                  closeValueMapper: (data, _) => data['cl'],
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}