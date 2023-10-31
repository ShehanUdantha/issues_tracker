import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget getBottomTitles(double value, TitleMeta meta) {
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Open');
      break;
    case 1:
      text = const Text('In Progress');
      break;
    case 2:
      text = const Text('Closed');
      break;
    default:
      text = const Text('');
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
