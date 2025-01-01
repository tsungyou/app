import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_empty_1/config.dart';

Future<Map<String, dynamic>> fetchStockPrice(List<String> stockList) async {
  Map<String, dynamic> stockPrice = {};
  if (stockList.isEmpty) return stockPrice;
  
  final symbols = stockList.join(',');
  final uri = Uri.parse('${Config.baseUrl}/price').replace(queryParameters: {
    'codes': symbols,
  });

  var response = await http.get(uri);
  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    final List<Map<String, dynamic>> stockPriceData = responseData.map<Map<String, dynamic>>((item) => {
      'da': item['da'],
      'code': item['code'], 
      'op': item['op'],
      'hi': item['hi'],
      'lo': item['lo'],
      'cl': item['cl'],
    }).toList();

    for (var item in stockPriceData) {
      if (!stockPrice.containsKey(item['code'])) {
        stockPrice[item['code']] = [];
      }
      stockPrice[item['code']]!.add(item);
    }
  } else {
    print('Failed to load stock price data');
  }
  return stockPrice;
}