import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test_empty_1/stocks/detailExample.dart';
import 'package:http/http.dart' as http;

class Trend extends StatefulWidget {
  const Trend({super.key});
  
  @override
  State<Trend> createState() => _TrendState();
}

class _TrendState extends State<Trend> {
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
    fetchStockPrice();
    fetchFundamentals();
  }
  Future<void> fetchFundamentals() async {
    var url = Uri.parse('http://localhost:8080/fundamentals?symbols=2330,2317,2454,3231');
    var response = await http.get(url);
    setState(() {
      trendStockFundamentals = jsonDecode(response.body)
        .map<String, stockFundamentals>((item) => {
              stockFundamentals(item['symbol'], item['codename'], item['industry']),
          })
        .toList();
    });
    print(trendStockFundamentals);
  }

  Future<void> fetchStrategyTrend() async {
    var url = Uri.parse('http://localhost:8080/trend'); // Replace with your server URL
    var response = await http.get(url);
    setState(() {
      trendData = jsonDecode(response.body)
        .map<Map<String, dynamic>>((item) => {
              'da': item['da'],
              'codename': item['codename'],
              'strategy': item['strategy'],
              'rank': item['rank'],
          })
        .toList();

      for (var item in trendData) {
        trendStockList.add(item['codename']);
      }
    });
  }

  Future<void> fetchStockPrice() async {
    var uri = Uri.parse("http://localhost:8080/price?start=$start&symbols=2330,2317,2454,3231");
    var response = await http.get(uri);
    setState(() {
      trendStockPrice = jsonDecode(response.body)
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
    for (var item in trendStockPrice) {
      if (!groupedTrendStockPrice.containsKey(item['symbol'])) {
        groupedTrendStockPrice[item['symbol']] = [];
      }
      groupedTrendStockPrice[item['symbol']]!.add(item);
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
            final symbol = trendStockList[index];
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
                            builder: (context) => DetailPage(symbol: symbol,),
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
                                item: trendStockFundamentals[symbol] ?? const stockFundamentals('2330', '2330', '2330'),
                              ),
                            ),
                            Expanded(
                              flex: 6, // Adjust flex values as per your design
                              child: IntradayChart(
                                symbol: symbol,
                                groupedTrendStockPrice: groupedTrendStockPrice,
                                chartHeight: chartHeight,
                                chartWidth: chartWidth,
                              ),
                            ), 
                            IntradayTrailing(item: trendStockFundamentals[symbol] ?? const stockFundamentals('2330', '2330', '2330')),
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
        Text(item.symbol),
        Text(item.codename),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(item.industry,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                )),
//             Text(item.volume.toString(),
//                 style: const TextStyle(
//                   fontSize: 10,
//                   color: Colors.blue,
//                 )),
//             Text(
//               item.investOrder,
//               style: const TextStyle(fontSize: 10, color: Colors.green),
//             ),
          ],
        ),
      ],
    );
  }
}
class IntradayChart extends StatelessWidget {
  final String symbol;
  final double chartWidth;
  final double chartHeight;
  final Map<String, dynamic> groupedTrendStockPrice;

  IntradayChart({Key? key, required this.symbol, required this.groupedTrendStockPrice, required this.chartHeight, required this.chartWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: chartWidth,
      height: chartHeight,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          LineSeries<ChartData, String>(
            dataSource: getChartData(symbol, groupedTrendStockPrice),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
          ),
        ],
      ),
    );
  }

  List<ChartData> getChartData(String symbol, Map<String, dynamic> groupedTrendStockPrice) {
    List<ChartData> chartData = [];

    // Check if groupedTrendStockPrice[symbol] is not null before iterating
    if (groupedTrendStockPrice[symbol] != null) {
      for (var item in groupedTrendStockPrice[symbol]!) {
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
      Text(item.symbol),
      ],
    );
  }
}

class stockFundamentals {
  final String symbol;
  final String codename;
  final String industry;

  const stockFundamentals(
    this.symbol, 
    this.codename, 
    this.industry,);
}


class StockPrice {
  final DateTime date;
  final String codename;
  final String symbol;
  final String industry;
  final double open;
  final double high;
  final double low;
  final double close;

  StockPrice({
    required this.date,
    required this.codename,
    required this.symbol,
    required this.industry,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}