import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_empty_1/config.dart';
class DetailPage extends StatefulWidget {
  final String code;
  DetailPage({super.key, required this.code});
  
  @override
  State<DetailPage> createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  StockTimeframePerformance? stockData;
  Timeframe _selectedTimeframe = Timeframe.sixMonths;
  Uri? uri;
  @override
  void initState() {
    super.initState();
    fetchSingleStock(widget.code, Timeframe.sixMonths);
  }

  Future<void> fetchSingleStock(String code, Timeframe timeframe) async {
    if (timeframe == Timeframe.oneDay || timeframe == Timeframe.oneWeek){
      uri = Uri.parse("${Config.baseUrl}/detailed_price").replace(queryParameters: {
        'codes': code,
        'day': getDaysForTimeframe(timeframe).toString(),
      });
    }
    else{
      uri = Uri.parse("${Config.baseUrl}/detailed_price").replace(queryParameters: {
        'codes': code,
        'day': getDaysForTimeframe(timeframe).toString(),
      });
    }
    var response = await http.get(uri!);
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<StockTimeWindow> timeWindows = data.map<StockTimeWindow>((item) {
        return StockTimeWindow(
          open: item['op'].toDouble(),
          high: item['hi'].toDouble(),
          low: item['lo'].toDouble(),
          close: item['cl'].toDouble(),
          volume: item['vol'].toDouble(),
          date: DateTime.parse(item['da']),
        );
      }).toList();
      print(timeWindows[0]);
      Timeframe timeframe = Timeframe.oneDay;
      StockTimeframePerformance performance = StockTimeframePerformance(
        timeframe: timeframe,
        timeWindows: timeWindows,
      );

      setState(() {
        stockData = performance;
      });
    } else {
      // Handle error response
      print('Failed to load stock data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.code),
      ),
      body: stockData == null
        ? const Center(child: CircularProgressIndicator())
        : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildStockInfo(),
            SizedBox(
              height: 160,
              child: CustomPaint(
                size: Size.infinite,
                painter: StockCandleStickPainter(
                  stockData: stockData,
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: CustomPaint(
                size: Size.infinite,
                painter: StockVolumePainter(
                  stockData: stockData,
                ),
              ),
            ),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: Timeframe.values.map((timeframe) {
                  final isSelected = timeframe == _selectedTimeframe;
                  return Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0), // Adjust padding as needed
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedTimeframe = timeframe;
                            fetchSingleStock(widget.code, _selectedTimeframe);
                            print(_selectedTimeframe);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.black : Colors.white,
                          foregroundColor: isSelected ? Colors.white : Colors.black,
                          elevation: isSelected ? 8.0 : 2.0, // Optional: add elevation for the selected button
                        ),
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            _timeframeLabel(timeframe),
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildStockInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.code, 
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),),
        Text(
          '台積電', 
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            
          ),),
        Text(
          '${stockData?.close.toStringAsFixed(2)}(${stockData?.percentageChange.toStringAsFixed(2)}%)', 
          style: TextStyle(
            color: stockData!.percentageChange > 0 ? Colors.red : Colors.green,
            fontSize: 10, 
          ),
        ),
      ],
    );
  }
}
String _timeframeLabel(Timeframe timeframe) {
    switch (timeframe) {
      case Timeframe.oneDay:
        return '1D';
      case Timeframe.oneWeek:
        return '1W';
      case Timeframe.oneMonth:
        return '1M';
      case Timeframe.threeMonths:
        return '3M';
      case Timeframe.sixMonths:
        return '6M';
      case Timeframe.oneYear:
        return '1Y';
      default:
        return timeframe.toString();
    }
    
}
class StockCandleStickPainter extends CustomPainter {

  StockCandleStickPainter({
    required this.stockData,
  }) : _wickPaint = Paint()..color = Colors.grey,
  _gainPaint = Paint()..color = Colors.green,
  _lossPaint = Paint()..color = Colors.red;

  final StockTimeframePerformance? stockData;
  final Paint _wickPaint;
  final Paint _gainPaint;
  final Paint _lossPaint;
  final double _wickWidth = 1.0;
  final double _candleWidth = 3.0;

  @override 
  void paint(Canvas canvas, Size size) {
    List<CandleStick> candlesticks = _generateCandlesticks(size);

    for (CandleStick candlestick in candlesticks) {
      canvas.drawRect(
        Rect.fromLTRB(
          candlestick.centerX - (_wickWidth / 2),
          size.height - candlestick.wickHighY, 
          candlestick.centerX + (_wickWidth / 2), 
          size.height - candlestick.wickLowY,
        ), 
      _wickPaint,);

      canvas.drawRect(
        Rect.fromLTRB(
          candlestick.centerX - (_candleWidth / 2),
          size.height - candlestick.candleLowY, 
          candlestick.centerX + (_candleWidth / 2), 
          size.height - candlestick.candleHighY,
        ), 
        candlestick.candlePaint,
      );
    }
  }

  List<CandleStick> _generateCandlesticks(Size availableSpace){
    final pixelPerWindow = availableSpace.width / (stockData!.timeWindows.length + 1);
    final pixelPerDollar = availableSpace.height / (stockData!.high - stockData!.low);
    
    final List<CandleStick> candlesticks = [];
    for (int i = 0; i < (stockData?.length ?? 1); i++) {
      final StockTimeWindow window = stockData!.timeWindows[i];
      candlesticks.add(
        CandleStick(
          centerX: (i+1)*pixelPerWindow, 
          wickHighY: (window.high - stockData!.low) * pixelPerDollar, 
          wickLowY: (window.low - stockData!.low) * pixelPerDollar, 
          candleHighY: (window.open - stockData!.low) * pixelPerDollar, 
          candleLowY: (window.close - stockData!.low) * pixelPerDollar, 
          candlePaint: window.isGain ? _gainPaint : _lossPaint,
        ),
      );
    }

    return candlesticks;
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
  
}

class CandleStick {
  CandleStick({
    required this.wickHighY, 
    required this.wickLowY, 
    required this.candleHighY, 
    required this.candleLowY, 
    required this.centerX, 
    required this.candlePaint
  });
  final double wickHighY;
  final double wickLowY;
  final double candleHighY;
  final double candleLowY;
  final double centerX;
  final Paint candlePaint;

}

class StockTimeframePerformance {
  StockTimeframePerformance({
    required this.timeframe,
    required this.timeWindows,
  }) : assert(timeWindows.isNotEmpty) {
    _open = timeWindows.first.open;
    _close = timeWindows.last.close;
    _high = timeWindows[0].high;
    _low = timeWindows[0].low;
    _volume = timeWindows[0].volume;
    _maxWindowVolume = timeWindows[0].volume;
    _length = 0;
    for (int i = 1; i < timeWindows.length; i++) {
      if (timeWindows[i].high > _high) {
        _high = timeWindows[i].high;
      }
      if (timeWindows[i].low < _low) {
        _low = timeWindows[i].low;
      }

      _volume += timeWindows[i].volume;
      _maxWindowVolume = max(_maxWindowVolume, timeWindows[i].volume);
    }
    _length = timeWindows.length;
  }
  final Timeframe timeframe;
  final List<StockTimeWindow> timeWindows;

  double get open => _open;
  late double _open;
  double get high => _high;
  late double _high;
  double get low => _low;
  late double _low;
  double get close => _close;
  late double _close;
  double get volume => _volume;
  late double _volume;
  double get maxWindowVolume => _maxWindowVolume;
  late double _maxWindowVolume;
  int get length => _length;
  late int _length;
  
  double get dollarChange => _close - _open;
  double get percentageChange => ((_close - _open)/_open) * 100;
}

enum Timeframe {
  oneDay,
  oneWeek,
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear,
}
int getDaysForTimeframe(Timeframe timeframe) {
  const timeframeDays = {
    Timeframe.oneDay: 1,
    Timeframe.oneWeek: 7,
    Timeframe.oneMonth: 40,
    Timeframe.threeMonths: 90,
    Timeframe.sixMonths: 180,
    Timeframe.oneYear: 360, // Approximate number of days in 5 years
  };

  return timeframeDays[timeframe] ?? 0;
}
class StockTimeWindow {
  StockTimeWindow({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.date,
  });

  final double open;
  final double high;
  final double low;
  final double close; 
  final double volume;
  final DateTime date;
  @override
  String toString() {
    return 'StockTimeWindow(date: $date, open: $open, high: $high, low: $low, close: $close, volume: $volume)';
  }

  bool get isGain => close - open > 0 ? true : false;
}


class StockVolumePainter extends CustomPainter {

  StockVolumePainter({
    this.stockData,
  }) : _gainPaint = Paint()..color = Colors.green.withOpacity(0.5),
       _lossPaint = Paint()..color = Colors.red.withOpacity(0.5);
  
  final StockTimeframePerformance? stockData;
  final Paint _gainPaint;
  final Paint _lossPaint;
  
  @override
  void paint(Canvas canvas, Size size){
    List<Bar> bars = _generateBars(size);

    for (Bar bar in bars) {
      canvas.drawRect(
        Rect.fromLTWH(
          bar.centerX - (bar.width / 2), 
          size.height - bar.height, 
          bar.width, 
          bar.height,
        ), 
        bar.paint
      );
    }
  }

  List<Bar> _generateBars(Size availableSpace) {
    final pixelPerTimeWindow = availableSpace.width / (stockData!.timeWindows.length + 1);
    final pixelPerStockOrder = availableSpace.height / (stockData!.maxWindowVolume - 0);

    List<Bar> bars = [];
    for (int i = 0; i < stockData!.timeWindows.length; i++){
      final StockTimeWindow window = stockData!.timeWindows[i];
      bars.add(
        Bar(
          width : 3.0,
          height : window.volume * pixelPerStockOrder,
          centerX : (i+1) * pixelPerTimeWindow,
          paint : window.isGain ? _gainPaint : _lossPaint,
        ),
      );
    }
    return bars;
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class Bar {
  Bar({
    required this.width,
    required this.height,
    required this.centerX,
    required this.paint 
  });
  final double width;
  final double height;
  final double centerX;
  final Paint paint;

}
// class TimeframeButtons extends StatefulWidget {
//   final StockTimeframePerformance? stockData;
//   const TimeframeButtons({super.key, required this.stockData});

//   @override
//   _TimeframeButtonsState createState() => _TimeframeButtonsState();
// }
// class _TimeframeButtonsState extends State<TimeframeButtons> {
//   Timeframe? _selectedTimeframe;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: Timeframe.values.map((timeframe) {
//         final isSelected = timeframe == _selectedTimeframe;
//         return Flexible(
//           fit: FlexFit.tight,
//           child: Padding(
//             padding: const EdgeInsets.all(4.0), // Adjust padding as needed
//             child: ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _selectedTimeframe = timeframe;
//                   print(_selectedTimeframe);
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isSelected ? Colors.black : Colors.white,
//                 foregroundColor: isSelected ? Colors.white : Colors.black,
//                 elevation: isSelected ? 8.0 : 2.0, // Optional: add elevation for the selected button
//               ),
//               child: FittedBox(
//                 fit: BoxFit.fitWidth,
//                 child: Text(
//                   _timeframeLabel(timeframe),
//                   style: TextStyle(fontSize: 10),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//     String _timeframeLabel(Timeframe timeframe) {
//     switch (timeframe) {
//       case Timeframe.oneDay:
//         return '1D';
//       case Timeframe.oneWeek:
//         return '1W';
//       case Timeframe.oneMonth:
//         return '1M';
//       case Timeframe.threeMonths:
//         return '3M';
//       case Timeframe.sixMonths:
//         return '1Y';
//       case Timeframe.oneYear:
//         return '5Y';
//       default:
//         return timeframe.toString().split('.').last;
//     }
//   }
// }