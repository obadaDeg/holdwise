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
  // Default time filter and trends
  String _selectedFilter = 'Week';
  final Set<String> _selectedTrends = {
    'Posture Score Trend'
  }; // Default selected

  // 1. Add new trends here
  final List<String> _availableTrends = [
    'Posture Score Trend',
    'Posture Trend Over Time',
    'Neck Tilt Trend', // NEW
    'Shoulder Tension Trend', // NEW
  ];

  // 2. Update the _chartData map to include data for new trends
  final Map<String, Map<String, List<FlSpot>>> _chartData = {
    'Day': {
      'Posture Score Trend': List.generate(
        24,
        (index) => FlSpot(index.toDouble(), (75 + (index % 5)).toDouble()),
      ),
      'Posture Trend Over Time': List.generate(
        24,
        (index) => FlSpot(index.toDouble(), (65 + (index % 6)).toDouble()),
      ),
      // For demonstration, generate some random or pattern-based data
      'Neck Tilt Trend': List.generate(
        24,
        (index) => FlSpot(index.toDouble(), 10 + (index % 5).toDouble()),
      ),
      'Shoulder Tension Trend': List.generate(
        24,
        (index) => FlSpot(index.toDouble(), 30 + (index % 7).toDouble()),
      ),
    },
    'Week': {
      'Posture Trend Over Time': [
        FlSpot(1, 80),
        FlSpot(2, 75),
        FlSpot(3, 70),
        FlSpot(4, 65),
        FlSpot(5, 85),
        FlSpot(6, 90),
        FlSpot(7, 88),
      ],
      'Posture Score Trend': [
        FlSpot(1, 70),
        FlSpot(2, 72),
        FlSpot(3, 74),
        FlSpot(4, 76),
        FlSpot(5, 78),
        FlSpot(6, 80),
        FlSpot(7, 82),
      ],
      // NEW trends for Week
      'Neck Tilt Trend': [
        FlSpot(1, 12),
        FlSpot(2, 10),
        FlSpot(3, 14),
        FlSpot(4, 16),
        FlSpot(5, 13),
        FlSpot(6, 15),
        FlSpot(7, 17),
      ],
      'Shoulder Tension Trend': [
        FlSpot(1, 32),
        FlSpot(2, 34),
        FlSpot(3, 36),
        FlSpot(4, 38),
        FlSpot(5, 35),
        FlSpot(6, 39),
        FlSpot(7, 37),
      ],
    },
    'Month': {
      'Posture Score Trend': [
        FlSpot(1, 70),
        FlSpot(5, 72),
        FlSpot(10, 75),
        FlSpot(15, 78),
        FlSpot(20, 80),
        FlSpot(25, 83),
        FlSpot(30, 85),
      ],
      'Posture Trend Over Time': [
        FlSpot(1, 60),
        FlSpot(5, 62),
        FlSpot(10, 65),
        FlSpot(15, 68),
        FlSpot(20, 70),
        FlSpot(25, 73),
        FlSpot(30, 75),
      ],
      // NEW trends for Month
      'Neck Tilt Trend': [
        FlSpot(1, 10),
        FlSpot(5, 11),
        FlSpot(10, 13),
        FlSpot(15, 14),
        FlSpot(20, 16),
        FlSpot(25, 12),
        FlSpot(30, 17),
      ],
      'Shoulder Tension Trend': [
        FlSpot(1, 30),
        FlSpot(5, 32),
        FlSpot(10, 34),
        FlSpot(15, 36),
        FlSpot(20, 35),
        FlSpot(25, 37),
        FlSpot(30, 39),
      ],
    },
  };

  /// Opens a modal bottom sheet that lets the user select the time filter
  /// and toggle trends.
  void _openFilterModal() {
    final isDarkMode = context.read<ThemeCubit>().state == ThemeMode.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // <-- allows flexible sizing
      backgroundColor:
          Colors.transparent, // <-- make the background transparent
      builder: (BuildContext context) {
        // Wrap content in a FractionallySizedBox to control height,
        // plus a Container for rounded corners & color.
        return FractionallySizedBox(
          heightFactor: 0.7, // 70% of screen height, adjust as needed
          child: Container(
            padding: EdgeInsets.only(
              // Provide extra bottom padding for the nav bar or any offset you want
              bottom: MediaQuery.of(context).padding.bottom * .80,
            ),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.gray700 : AppColors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: _buildFilterContent(isDarkMode),
          ),
        );
      },
    );
  }

  Widget _buildFilterContent(bool isDarkMode) {
    return Column(
      children: [
        // Header with title and close icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter Options",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: isDarkMode ? AppColors.gray200 : AppColors.gray800,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        // A divider or some spacing
        Divider(height: 1, color: isDarkMode ? AppColors.gray600 : AppColors.gray300),

        // Use an Expanded widget containing a SingleChildScrollView or ListView
        // so the bottom sheet can be scrollable if content grows.
        Expanded(
          child: RawScrollbar(

            child: SingleChildScrollView(
              
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Range
                  const Text(
                    "Time Range",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Day', 'Week', 'Month'].map((filter) {
                      return ChoiceChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        selectedColor: isDarkMode
                            ? AppColors.primary600
                            : AppColors.primary500,
                        backgroundColor:
                            isDarkMode ? AppColors.gray700 : AppColors.gray200,
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
            
                  const SizedBox(height: 20),
            
                  // Trends
                  const Text(
                    "Trends",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTrends.map((trend) {
                      final selected = _selectedTrends.contains(trend);
                      return FilterChip(
                        label: Text(trend),
                        selected: selected,
                        selectedColor: isDarkMode
                            ? AppColors.primary600
                            : AppColors.primary500,
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedTrends.add(trend);
                            } else {
                              _selectedTrends.remove(trend);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),

        Divider(height: 1, color: isDarkMode ? AppColors.gray600 : AppColors.gray300),
        // Bottom Button Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Apply"),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
            // Header row: Title on the left and filter icon on the right.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Posture Trend Over Time",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  onPressed: _openFilterModal,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Chart display
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.transparent,
                  gridData: FlGridData(show: false),
                  lineBarsData: _selectedTrends.map((trend) {
                    return LineChartBarData(
                      spots: _chartData[_selectedFilter]![trend]!,
                      isCurved: true,
                      barWidth: 4,
                      color: isDarkMode
                          ? AppColors.primary600.withOpacity(0.7)
                          : AppColors.primary500.withOpacity(0.7),
                      dotData: const FlDotData(show: false),
                    );
                  }).toList(),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}%', // For demonstration, in reality might not use "%"
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
