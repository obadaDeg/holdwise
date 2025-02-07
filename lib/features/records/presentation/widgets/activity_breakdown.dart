// activity_breakdown.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityBreakdown extends StatelessWidget {
  final Map<String, double> activityData; // Activity name -> Hours spent

  const ActivityBreakdown({Key? key, required this.activityData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent infinite height issue
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "📊 Activity Breakdown",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Pie Chart with fixed height
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _generatePieSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Legend
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generatePieSections() {
    // For a dynamic color assignment, expand this palette or choose randomly
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.brown,
      Colors.teal,
      Colors.cyan,
      Colors.pink,
    ];

    List<String> activities = activityData.keys.toList();
    List<double> values = activityData.values.toList();
    double totalHours = values.fold(0, (sum, item) => sum + item);

    return List.generate(activities.length, (index) {
      final color = colors[index % colors.length];
      double percentage = totalHours == 0 ? 0 : (values[index] / totalHours) * 100;

      return PieChartSectionData(
        color: color,
        value: values[index],
        title: "${percentage.toStringAsFixed(1)}%",
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend() {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.brown,
      Colors.teal,
      Colors.cyan,
      Colors.pink,
    ];

    List<String> activities = activityData.keys.toList();

    return Wrap(
      spacing: 10,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: List.generate(activities.length, (index) {
        final color = colors[index % colors.length];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(activities[index], style: const TextStyle(fontSize: 14)),
          ],
        );
      }),
    );
  }
}
