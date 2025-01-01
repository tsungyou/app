import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// mom yoy close price
class CDP extends StatefulWidget {
  const CDP({super.key});
  @override
  State<CDP> createState() => _CDP();
}

class _CDP extends State<CDP> {
  final TextEditingController _textController = TextEditingController();
  List<double> marginTrading = [0.38, 0.39, 0.38, 0.39, 0.4];
  List<double> shortSelling = [1.5, 1.6, 1, 0.8, 0.9];
  double v1 = 1083.75; 
  double v2 = 1083.75; 
  double v3 = 1083.75; 
  double v4 = 1083.75; 
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void fetchCDPInfo(String code) {
    setState(() {
      shortSelling = [1.5, 1.6, 1, 0.8, 10];
    });
  }

  Widget _buildLineChart({
    required List<double> data,
    required Color lineColor,
    double lineWidth = 2,
    required String title,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title),
        ),
        SizedBox(
          height: 200, // Reduced from 300
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        double min = data.reduce((a, b) => a < b ? a : b);
                        double max = data.reduce((a, b) => a > b ? a : b);
                        if (value == min || value == max) {
                          return Text(value.toStringAsFixed(2));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == 0 || value == data.length - 1) {
                          return Text('${value.toInt()}');
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: data.asMap().entries.map((e) =>
                      FlSpot(e.key.toDouble(), e.value)
                    ).toList(),
                    isCurved: false,
                    color: lineColor,
                    barWidth: lineWidth,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[400]!,
              Colors.grey[600]!,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '輸入股號',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      onPressed: () {
                        print('Search text: ${_textController.text}');
                        fetchCDPInfo(_textController.text);
                      },
                      icon: const Icon(Icons.search)
                    ),
                  ),
                ]
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("近五日三大法人成本"),
                    Text("投信成本: $v1"),
                    Text("外資成本: $v2"),
                    Text("自營商成本: $v3"),
                    const Text("----------"),
                    Text("近五日主力成本: $v4"),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Column(
                children: [
                  _buildLineChart(
                    data: marginTrading,
                    lineColor: Colors.blue,
                    title: "近五日融資率變化",
                  ),
                  _buildLineChart(
                    data: shortSelling,
                    lineColor: Colors.red,
                    title: "近五日融券率變化",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}