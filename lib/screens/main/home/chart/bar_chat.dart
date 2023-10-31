// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:issues_tracker/common/widgets/bottom_titles.dart';
import 'package:issues_tracker/models/bar_model.dart';
import 'package:issues_tracker/utils/constants/colors.dart';

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
    BarModel barModel = BarModel(
      openCount: openCount,
      progressCount: progressCount,
      closedCount: closedCount,
    );
    barModel.initializedBarData();

    double maxY = 50;

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        alignment: BarChartAlignment.spaceAround,
        gridData: const FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        titlesData: titlesData,
        barGroups: barModel.barData
            .map(
              (e) => BarChartGroupData(x: e.x, barRods: [
                BarChartRodData(
                  toY: e.y.toDouble(),
                  color: AppColors.primary,
                  width: 80,
                  borderRadius: BorderRadius.zero,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: AppColors.selectBg,
                  ),
                ),
              ]),
            )
            .toList(),
      ),
    );
  }
}

FlTitlesData get titlesData => FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getBottomTitles,
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
