import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test_empty_1/stocks/detailExample.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  }

  Future<void> fetchStrategyTrend() async {
    var url = Uri.parse('http://localhost:8000/pe'); // Replace with your server URL
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
      fetchStockPrice();
    } else {
      print('Failed to load strategy trend data');
    }
  }

  Future<void> fetchStockPrice() async {
    if (trendStockList.isEmpty) return;
    final symbols = trendStockList.join(',');
    final uri = Uri.parse('http://localhost:8000/price').replace(queryParameters: {
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
              Colors.grey[200]!,
              Colors.grey[400]!,
              Colors.grey[600]!,
              Colors.grey[800]!,
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: trendStockList.length,
          itemBuilder: (context, index) {
            final code = trendStockList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double listTileHeight = 120.0; // Adjust height as needed
                    double chartWidth = constraints.maxWidth * 0.5; // 50% of ListTile's width
                    double chartHeight = listTileHeight * 0.9; // 60% of ListTile's height
                    return SizedBox(
                      height: listTileHeight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(code: code),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: IntradayTitle(
                                item: trendStockFundamentals[code] ?? stockFundamentals(
                                    DateFormat('y/M/d').format(DateTime.parse(trendData[index]['da'])),
                                    code,
                                    trendData[index]['cl'].toString()),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: IntradayChart(
                                code: code,
                                groupedTrendStockPrice: groupedTrendStockPrice,
                                chartHeight: chartHeight,
                                chartWidth: chartWidth,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IntradayTrailing(
                                item: trendStockFundamentals[code] ?? const stockFundamentals('2330', '2330', '2330'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
            fontSize: 16,
            color: Colors.teal,
          ),
        ),
        Text(
          item.code,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          children: [
            Icon(
              Icons.trending_up,
              color: Colors.green[600],
            ),
            const SizedBox(width: 4.0),
            Text(
              item.industry,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
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
        primaryXAxis: const CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
          axisBorderType: AxisBorderType.withoutTopAndBottom,
        ),
        primaryYAxis: const NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
        ),
        series: <CartesianSeries>[
          LineSeries<ChartData, String>(
            dataSource: getChartData(code, groupedTrendStockPrice),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            color: Colors.teal,
            width: 1,
          ),
        ],
        crosshairBehavior: CrosshairBehavior(enable: true,),
        // zoomPanBehavior: ZoomPanBehavior(enableMouseWheelZooming: true,),
        // tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  List<ChartData> getChartData(String code, Map<String, dynamic> groupedTrendStockPrice) {
    List<ChartData> chartData = [];
    if (groupedTrendStockPrice[code] != null) {
      for (var item in groupedTrendStockPrice[code]!) {
        chartData.add(ChartData(item['da'], item['cl']));
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          item.codename,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.teal,
          ),
        ),
        Text(
          item.code,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
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
