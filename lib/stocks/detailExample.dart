import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;


  
class DetailPage extends StatefulWidget {
  final String code;
  DetailPage({super.key, required this.code});
  
  @override
  State<DetailPage> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  List<Map<String, dynamic>> stockPrice = [];
  @override
  void initState() {
    super.initState();
    fetchSingleStock(widget.code);
  }
  
  Future<void> fetchSingleStock(String code) async {
    var uri = Uri.parse("http://localhost:8000/detailed_price").replace(queryParameters: {
      'codes': code,
    });
    var response = await http.get(uri);
    setState(() {
      
      stockPrice = jsonDecode(response.body)
        .map<Map<String, dynamic>>((item) => {
        'da': item['da'],
        'code': item['code'],
        'op': item['op'],
        'hi': item['hi'],
        'lo': item['lo'],
        'cl': item['cl'],
      }).toList();
      print(stockPrice);
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
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back'),
              ),
            ),
            SizedBox(
              child:SfCartesianChart(
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
            ),
            SizedBox(height: 30, child: Column(children: [Text('123'),],),),
            SizedBox(
              height: 160,
              child: CustomPaint(
                size: Size.infinite,
                painter: StockCandleStickPainter(
                  stockData: stockPrice,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StockCandleStickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class CandleStick {
  final double wickHighY;
  final double wickLowY;
  final double candleHighY;
  final double candleLowY;
  final double centerX;
  final Paint candlePaint;
}