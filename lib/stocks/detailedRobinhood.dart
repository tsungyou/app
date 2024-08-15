// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:http/http.dart' as http;


// enum PriceChange {
//   gain,
//   loss,
// }
  
// enum Timeframe {
//   oneDay,
//   oneWeek,
//   oneMonth,
//   threeMonths,
//   oneYear,
//   fiveYears,
// }

// class DetailedRobinhood extends StatefulWidget {
//   final String code;
//   DetailedRobinhood({super.key, required this.code});

//   @override
//   State<DetailedRobinhood> createState() => _DetailedRobinhood();
// }

// class _DetailedRobinhood extends State<DetailedRobinhood> {
//   late List<Map<String, dynamic>> stockData;

//   @override
//   void initState() {
//     super.initState();
//     fetchStockData();
//   }
//   Future<void> fetchStockData() async {
//     var url = Uri.parse('http://localhost:8000/detailed_price').replace(queryParameters: {
//       'codes': widget.code,
//     });
//     var response = await http.get(url);
//     if (response.statusCode == 200) {
//       final List<dynamic> responseData = jsonDecode(response.body);
//       print(responseData);
//       setState(() {
//         stockData = responseData.map<Map<String, dynamic>>((item) => {
//           'da': item['da'],
//           'code': item['code'],
//           'op': item['op'],
//           'hi': item['hi'],
//           'lo': item['lo'],
//           'cl': item['cl'],
//           'vol': item['vol'],
//           'vol_share': item['vol_share'],
//         }).toList();
//       });
//     } else {
//       print('Failed to load detailed price data');

//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             height: 195,
//             color: Colors.green,
//           ),
//           const SizedBox(height: 5,),
//           SizedBox(
//             height: 30,
//             child: CustomPaint(
//               size: Size.infinite,
//               painter: StockVolumePainter(
//                 stockData: stockData,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StockVolumePainter extends CustomPainter {

//   StockVolumePainter({
//     required this.stockData,
//   }) : _gainPaint = Paint()..color = Colors.green.withOpacity(0.5),
//   _lossPaint = Paint()..color = Colors.red.withOpacity(0.5);

//   final StockTimeframePerf stockData;
//   final Paint _gainPaint;
//   final Paint _lossPaint;


//   @override
//   void paint(Canvas canvas, Size size) {
//     if (stockData == null) {
//       return;
//     }
//     // generate
//     // List<Bar> bars = _generateBars(size);

//     // paint
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // throw UnimplementedError();
//     return true;
//   }
// }

// class Bar {
//   Bar({
//     required this.width, 
//     required this.height, 
//     required this.centerX, 
//     required this.paint
//   });
//   final double width;
//   final double height;
//   final double centerX;
//   final Paint paint;

// }



// class StockTimeframePerf {
//   StockTimeframePerf({
//     required this.timeframe,
//     required this.timeWindows,
//   }) : assert(timeWindows.isNotEmpty) {
//     _open = timeWindows.first.open;
//     _close = timeWindows.last.close;
//     _high = timeWindows[0].high;
//     _low = timeWindows[0].low;
//     _volume = timeWindows[0].volume;
//     _maxWindowVolume = timeWindows[0].volume;
//     for (int i = 1; i < timeWindows.length; i++) {
//       if (timeWindows[i].high > _high) {
//         _high = timeWindows[i].high;
//       }
//       if (timeWindows[i].low < _low) {
//         _low = timeWindows[i].low;
//       }

//       _volume += timeWindows[i].volume;

//       _maxWindowVolume = max(_maxWindowVolume, timeWindows[i].volume);
//     }
//   }
//   final Timeframe timeframe;
//   final List<StockTimeWindow> timeWindows;

//   double get open => _open;
//   late double _open;
//   double get high => _high;
//   late double _high;
//   double get low => _low;
//   late double _low;
//   double get close => _close;
//   late double _close;
//   double get volume => _volume;
//   late double _volume;
//   double get maxWindowVolume => _maxWindowVolume;
//   late double _maxWindowVolume;

  
//   double get dollarChange => _close - _open;
//   double get percentageChange => ((_close - _open)/_open) * 100;
// }

// class StockTimeWindow {
//   StockTimeWindow({
//     required this.open,
//     required this.high,
//     required this.low,
//     required this.close,
//     required this.volume,
//     required this.date,
//   });

//   final double open;
//   final double high;
//   final double low;
//   final double close; 
//   final double volume;
//   final DateTime date;
// }
