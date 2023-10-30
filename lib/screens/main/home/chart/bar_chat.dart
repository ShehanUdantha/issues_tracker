import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:issues_tracker/models/bar_model.dart';

class BarChartView extends StatelessWidget {
  final int openCount;
  final int progressCount;
  final int closedCount;
  const BarChartView({
    super.key,
    required this.openCount,
    required this.progressCount,
    required this.closedCount,
  });

  @override
  Widget build(BuildContext context) {
    BarModel _barModel = BarModel(
      openCount: openCount,
      progressCount: progressCount,
      closedCount: closedCount,
    );
    _barModel.initializedBarData();

    return BarChart(
      BarChartData(
        maxY: 5,
        minY: 0,
        barGroups: _barModel.barData
            .map(
              (e) => BarChartGroupData(x: e.x, barRods: [
                BarChartRodData(
                  toY: e.y.toDouble(),
                ),
              ]),
            )
            .toList(),
      ),
    );
  }
}
