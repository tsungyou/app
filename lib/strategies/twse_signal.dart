import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test_empty_1/models/charts.dart';
import 'package:test_empty_1/config.dart';

class TwseBullbear extends StatefulWidget {
  const TwseBullbear({super.key});

  @override
  State<TwseBullbear> createState() => _TwseBullbearState();
}

class _TwseBullbearState extends State<TwseBullbear> {
  List<String> stockList = ["TWSE Index", "TWOTCI Index", "2330"];
  List<dynamic> stockData = [];
  List<SignalData> stockSignal = [];
  Timeframe _selectedTimeframe = Timeframe.sixMonths;
  Timeframe defaultTimeframe = Timeframe.sixMonths;
  Uri? uri;

  @override
  void initState() {
    super.initState();
    fetchStocks(defaultTimeframe);
    fetchTwseSignal(defaultTimeframe);
  }
  Future<void> fetchTwseSignal(Timeframe timeframe) async {
    var uriSignal = Uri.parse("${Config.baseUrl}/strategy_twse").replace(queryParameters: {
        'day': getDaysForTimeframe(timeframe).toString(),
      });
    var response = await http.get(uriSignal);
    if (response.statusCode == 200) {
      stockSignal = jsonDecode(response.body);
    } else {
      print("twse signal error");
    }
  }
  Future<void> fetchStocks(Timeframe timeframe) async {
    List<StockTimeframePerformance> fetchedData = [];

    for (String code in stockList) {
      uri = Uri.parse("${Config.baseUrl}/detailed_price").replace(queryParameters: {
        'codes': code,
        'day': getDaysForTimeframe(timeframe).toString(),
      });

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
        
        StockTimeframePerformance performance = StockTimeframePerformance(
          timeframe: timeframe,
          timeWindows: timeWindows,
        );

        fetchedData.add(performance);
      } else {
        // Handle error response
        print('Failed to load stock data');
      }
    }

    setState(() {
      stockData = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    final paintWidth = screenWidth * 0.8; // 80% of screen width
    final paintHeight = screenHeight * 0.1; // 10% of screen height

    return Scaffold(
      body: stockData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // 10% margin on each side
                child: SizedBox(
                  width: paintWidth,
                  height: paintHeight,
                  child: CustomPaint(
                    painter: StockCandleStickPainter(
                      stockData: stockData[0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // 10% margin on each side
                child: SizedBox(
                  width: paintWidth,
                  height: paintHeight,
                  child: CustomPaint(
                    painter: StockCandleStickPainter(
                      stockData: stockData[1],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // 10% margin on each side
                child: SizedBox(
                  width: paintWidth,
                  height: paintHeight,
                  child: CustomPaint(
                    painter: StockCandleStickPainter(
                      stockData: stockData[2],
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // 10% margin on each side
              //   child: SizedBox(
              //     width: paintWidth,
              //     height: paintHeight,
              //     child: LineChart(
              //       ),
              //     ),
              //   ),
              // ),
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
                            fetchStocks(_selectedTimeframe);
                            fetchTwseSignal(_selectedTimeframe);
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
                            timeframeLabel(timeframe),
                            style: const TextStyle(fontSize: 20),
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
    );
  }
}

class SignalData {
  final String date;
  final double signal; // Changed to double to match the data type in your response

  SignalData({required this.date, required this.signal});
}