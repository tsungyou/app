import 'package:flutter/material.dart';
import 'package:test_empty_1/data_function/http_function.dart';
import 'dart:async';

import 'package:test_empty_1/strategies/3_value.dart';
class TimeManagement extends StatefulWidget {
  const TimeManagement({super.key});

  @override
  State<TimeManagement> createState() => _TimeManagementState();
}

class _TimeManagementState extends State<TimeManagement> {
  List<String> stockList = ["3086", "4563", "4977", "5234"];
  Map<String, dynamic> stockPrice = {};
  final int refreshIntervalMinutes = 5;
  late Timer _refreshTimer;
  int _remainingSeconds = 300; // 5 minutes in seconds

  Future<void> refreshData() async {
    final newStockPrice = await fetchStockPrice(stockList);
    setState(() {
      stockPrice = newStockPrice;
      _remainingSeconds = refreshIntervalMinutes * 60;
    });
  }

  void startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          refreshData();
        }
      });
    });
  }
  
  @override 
  void initState() {
    super.initState();
    refreshData();
    startRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  String formatRemainingTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side information
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('時間: ${DateTime.now().toString().substring(0,10)}'),
                      Text('方向: 作多'),
                      Text('訊號天期: 5天'),
                      Text('目標持倉天期: 10天'),
                    ],
                  ),
                  // Right side placeholders
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('漲跌幅: --%'),
                      Text('成交量: --'),
                      Text('Next refresh in: ${formatRemainingTime()}'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: stockList.length,
                itemBuilder: (context, index) {
                  final code = stockList[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LayoutBuilder(builder: (context, constraints) {
                        double listTileHeight = 120.0;
                        double chartWidth = constraints.maxWidth * 0.5;
                        double chartHeight = listTileHeight * 0.9;
                        return SizedBox(
                          height: listTileHeight,
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Expanded(
                                  child: stockPrice.containsKey(code) ? 
                                    IntradayChart(
                                      code: code,
                                      stockPrice: stockPrice,
                                      chartHeight: chartHeight,
                                      chartWidth: chartWidth
                                    ) 
                                    : const Center(child: Text('Loading data...')),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}