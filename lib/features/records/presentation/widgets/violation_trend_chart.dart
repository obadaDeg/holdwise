// violation_trend_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ViolationBarChart extends StatelessWidget {
  const ViolationBarChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 200,
          // child: BarChart(
          //   BarChartData(
          //     gridData: FlGridData(show: true),
          //     borderData: FlBorderData(show: true),
          //     titlesData: FlTitlesData(
          //       leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          //       bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          //     ),
          //     barTouchData: BarTouchData(enabled: true),
          //     barGroups:
          //   ),

          // ),
          child: SizedBox(),
        ),
      ),
    );
  }
}
