import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';

class TrendChart extends StatefulWidget {
  const TrendChart({super.key});

  @override
  _TrendChartState createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  String _selectedFilter = 'Week';

  final Map<String, List<FlSpot>> _chartData = {
    'Day': List.generate(
      24,
      (index) => FlSpot(index.toDouble(), (75 + (index % 5)).toDouble()),
    ), // 24 points for hours
    'Week': [
      FlSpot(1, 80),
      FlSpot(2, 75),
      FlSpot(3, 70),
      FlSpot(4, 65),
      FlSpot(5, 85),
      FlSpot(6, 90),
      FlSpot(7, 88),
    ],
    'Month': [
      FlSpot(1, 70),
      FlSpot(5, 72),
      FlSpot(10, 75),
      FlSpot(15, 78),
      FlSpot(20, 80),
      FlSpot(25, 83),
      FlSpot(30, 85),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Posture Trend Over Time",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            // Toggle Buttons for Filtering
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Day', 'Week', 'Month'].map((filter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    selectedColor: isDarkMode? AppColors.primary600 : AppColors.primary500,
                    backgroundColor:
                        isDarkMode ? AppColors.gray700 : AppColors.gray200,
                    labelStyle: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.transparent,
                  gridData: FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _chartData[_selectedFilter]!,
                      isCurved: true,
                      barWidth: 4,
                      color: isDarkMode? AppColors.primary600 :  AppColors.primary500,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Gradients.primaryGradient.colors.first
                                .withValues(alpha: .3),
                            Gradients.primaryGradient.colors.last
                                .withValues(alpha: 0.01),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        reservedSize: 25, // Adds spacing from chart bottom
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6), // Adds spacing
                            child: Text(
                              _selectedFilter == 'Day'
                                  ? '${value.toInt()}'
                                  : '${value.toInt()}',
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
