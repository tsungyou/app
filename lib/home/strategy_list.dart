import 'package:test_empty_1/strategies/strategies.dart' as strats;
import 'package:test_empty_1/descriptions/descriptions.dart' as desc;
import 'package:flutter/material.dart';

Map<String, Widget> strategyList  = {
  "當沖訊號(分點籌碼)": const strats.IntradayT1(),
  "CDP壓力支撐": const strats.CDP(),
  "價值投資": const strats.Value(),
  "短波段持股": const strats.TimeManagement(),
};




Map<String, Widget> descriptionList  = {
  "當沖訊號(分點籌碼)": const desc.IntradayT1(),
  "CDP壓力支撐": const desc.CDP(),
  "價值投資": const desc.Value(),
  "短波段持股": const desc.TimeManagement(),


};