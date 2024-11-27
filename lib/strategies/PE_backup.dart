import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test_empty_1/stocks/detailExample.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:test_empty_1/config.dart';
class PE extends StatefulWidget {
  const PE({super.key});
  
  @override
  State<PE> createState() => _PEState();
}

class _PEState extends State<PE> {
  final String start = DateTime.now().subtract(const Duration(days: 90)).toString().substring(0, 10);
  late List<Map<String, dynamic>> trendData;
  late List<Map<String, dynamic>> trendStockPrice;
  late Map<String, stockFundamentals> trendStockFundamentals = {};
  Map<String, dynamic> groupedTrendStockPrice = {};
  List<String> trendStockList = [];

  @override
  void initState() {
    super.initState();
    fetchStrategyTrend();
    // fetchStockPrice(); // Moved to fetch after trendData is populated
  }

  Future<void> fetchStrategyTrend() async {
    var url = Uri.parse('${Config.baseUrl}/strategy'); // Replace with your server URL
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        trendData = responseData.map<Map<String, dynamic>>((item) => {
              'da': item['da'],
              'code': item['code'],
              'cl': item['cl'],
            }).toList();
        for (var item in trendData) {
          trendStockList.add(item['code']);
        }
      });
      // Fetch stock price after trendStockList is populated
      fetchStockPrice();
    } else {
      print('Failed to load strategy trend data');
    }
  }

  Future<void> fetchStockPrice() async {
    if (trendStockList.isEmpty) return; // Early exit if list is empty
    final symbols = trendStockList.join(',');
    print('Symbols for stock price request: $symbols');
    final uri = Uri.parse('${Config.baseUrl}/price').replace(queryParameters: {
      'codes': symbols,
    });
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        trendStockPrice = responseData.map<Map<String, dynamic>>((item) => {
          'da': item['da'],
          'code': item['code'],
          'op': item['op'],
          'hi': item['hi'],
          'lo': item['lo'],
          'cl': item['cl'],
        }).toList();
        for (var item in trendStockPrice) {
          if (!groupedTrendStockPrice.containsKey(item['code'])) {
            groupedTrendStockPrice[item['code']] = [];
          }
          groupedTrendStockPrice[item['code']]!.add(item);
        }
      });
    } else {
      print('Failed to load stock price data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [
              Colors.grey[400] ?? Colors.grey,
              Colors.grey[800] ?? Colors.grey,
              Colors.grey[200] ?? Colors.grey,
              Colors.grey[800] ?? Colors.grey,
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: trendStockList.length,
          itemBuilder: (context, index) {
            final code = trendStockList[index];
            return Card(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Set a fixed height for the ListTile
                  double listTileHeight = 100.0; // Set your desired height
                  double chartWidth =
                      constraints.maxWidth * 0.5; // 50% of ListTile's width
                  double chartHeight =
                      listTileHeight * 1.0; // 60% of ListTile's height
                  return SizedBox(
                    height: listTileHeight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(code: code,),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(Icons.battery_1_bar_outlined),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1, // Adjust flex values as per your design
                              child: IntradayTitle(
                                item: trendStockFundamentals[code] ?? stockFundamentals(DateFormat('y/M/d').format(DateTime.parse(trendData[index]['da'])), code, trendData[index]['cl'].toString()),
                              ),
                            ),
                            Expanded(
                              flex: 6, // Adjust flex values as per your design
                              child: IntradayChart(
                                code: code,
                                groupedTrendStockPrice: groupedTrendStockPrice,
                                chartHeight: chartHeight,
                                chartWidth: chartWidth,
                              ),
                            ), 
                            IntradayTrailing(item: trendStockFundamentals[code] ?? const stockFundamentals('2330', '2330', '2330')),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

class IntradayTitle extends StatelessWidget {
  final stockFundamentals item;

  const IntradayTitle({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.codename,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          item.code,
          style: const TextStyle(
            fontSize: 10,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(item.industry,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.red,
              )),
          ],
        ),
      ],
    );
  }
}

class IntradayChart extends StatelessWidget {
  final String code;
  final double chartWidth;
  final double chartHeight;
  final Map<String, dynamic> groupedTrendStockPrice;

  IntradayChart({Key? key, required this.code, required this.groupedTrendStockPrice, required this.chartHeight, required this.chartWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: chartWidth,
      height: chartHeight,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          LineSeries<ChartData, String>(
            dataSource: getChartData(code, groupedTrendStockPrice),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
          ),
        ],
      ),
    );
  }

  List<ChartData> getChartData(String code, Map<String, dynamic> groupedTrendStockPrice) {
    List<ChartData> chartData = [];

    // Check if groupedTrendStockPrice[code] is not null before iterating
    if (groupedTrendStockPrice[code] != null) {
      for (var item in groupedTrendStockPrice[code]!) {
        if (item != null) {
          chartData.add(ChartData(item['da'], item['cl']));
        }
      }
    }

    return chartData;
  }
}

class IntradayTrailing extends StatelessWidget {
  final stockFundamentals item;
  const IntradayTrailing({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Text(item.codename),
      Text(item.code),
      ],
    );
  }
}

class stockFundamentals {
  final String code;
  final String codename;
  final String industry;

  const stockFundamentals(
    this.code, 
    this.codename,
    this.industry,
  );
}