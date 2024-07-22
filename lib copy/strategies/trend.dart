import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:test_empty_1/stocks/detailExample.dart';
import 'package:test_empty_1/strategies/intraday.dart';
import 'buy_hold.dart';
class TodoItem {
  final String title;
  final String description;
  final String classification;
  final int volume;
  final String investOrder;
  final double closePrice;
  final double percentage;

  const TodoItem(
    this.title, 
    this.description, 
    this.classification, 
    this.volume,
    this.investOrder,
    this.closePrice,
    this.percentage,);
}

class Trend extends StatelessWidget {
  const Trend({super.key});

  // Sample data
  final List<TodoItem> items = const [
    TodoItem('台積電', '2330', "IC", 12345, "(1)", 1000, 2.3),
    TodoItem('聯發科', '1111', "IC", 12345, '(2)', 255, 3.6),
    TodoItem('黑松', '1234', "IC", 23456, "(3)", 13, 1),
    TodoItem('鴻海', '2317', "IC", 23456, "(4)", 200, 9.9),
  ];

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
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Set a fixed height for the ListTile
                  double listTileHeight = 100.0; // Set your desired height
                  double chartWidth =
                      constraints.maxWidth * 0.5; // 50% of ListTile's width
                  double chartHeight =
                      listTileHeight * 1.0; // 60% of ListTile's height

                  return Container(
                    height: listTileHeight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(Icons.battery_1_bar_outlined),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IntradayTitle(item: item),
                            IntradayChart(item: item, chartHeight: chartHeight, chartWidth: chartWidth),
                            IntradayTrailing(item: item),
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
  final TodoItem item;

  const IntradayTitle({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.title),
        Text(item.description),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(item.classification,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                )),
            Text(item.volume.toString(),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.blue,
                )),
            Text(
              item.investOrder,
              style: const TextStyle(fontSize: 10, color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }
}

class IntradayChart extends StatelessWidget {
  final TodoItem item;
  final double chartWidth;
  final double chartHeight;
  const IntradayChart({super.key, required this.item, required this.chartHeight, required this.chartWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: chartWidth,
      height: chartHeight,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          LineSeries<ChartData, String>(
            dataSource: getChartData(),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
          ),
        ],
      ),
    );
  }
    // Sample data for the chart
  List<ChartData> getChartData() {
    return [
      ChartData('Jan', 35),
      ChartData('Feb', 28),
      ChartData('Mar', 34),
      ChartData('Apr', 32),
      ChartData('May', 40),
    ];
  }
}

class IntradayTrailing extends StatelessWidget {
  final TodoItem item;
  const IntradayTrailing({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Text(item.closePrice.toString()),
      Text('${item.percentage.toString()}%'),
      ],
    );
  }
}

