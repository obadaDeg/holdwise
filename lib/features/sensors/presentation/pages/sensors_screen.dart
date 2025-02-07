import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:holdwise/features/sensors/data/cubits/sensors_cubit.dart';
import 'package:holdwise/features/sensors/data/models/sensor_data.dart';
import 'package:intl/intl.dart';

class SensorScreen extends StatelessWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sensor Overview')),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          final orientation = state.orientation;
          final sensorData = state.sensorData;

          final double tiltAngle = orientation?.tiltAngle ?? 0;
          final bool goodAngle = orientation?.isCorrectAngle() ?? false;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 1. Big numeric indicator for tilt angle
                Text(
                  '${tiltAngle.toStringAsFixed(1)}°',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // 2. Text status
                Text(
                  goodAngle
                      ? "Angle is within a healthy range"
                      : "Angle is above recommended range",
                  style: TextStyle(
                    color: goodAngle ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Expansion tile to show the line chart
                ExpansionTile(
                  title: const Text("View Detailed Chart"),
                  children: [
                    SizedBox(
                      height: 200,
                      child: _buildSensorGraph(sensorData),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.read<SensorCubit>().startMonitoring(),
                      child: const Text('Start'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => context.read<SensorCubit>().stopMonitoring(),
                      child: const Text('Stop'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSensorGraph(List<SensorData> sensorData) {
    if (sensorData.length < 2) {
      return const Center(child: Text("Not enough data to plot."));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          _generateLineChart(sensorData, 'x', Colors.red),
          _generateLineChart(sensorData, 'y', Colors.green),
          _generateLineChart(sensorData, 'z', Colors.blue),
        ],
      ),
    );
  }

  LineChartBarData _generateLineChart(
      List<SensorData> sensorData, String axis, Color color) {
    return LineChartBarData(
      spots: sensorData.asMap().entries.map((entry) {
        final index = entry.key.toDouble();
        final data = entry.value;
        double value;
        switch (axis) {
          case 'x':
            value = data.x;
            break;
          case 'y':
            value = data.y;
            break;
          case 'z':
          default:
            value = data.z;
        }
        return FlSpot(index, value);
      }).toList(),
      isCurved: true,
      color: color,
      barWidth: 2,
      dotData: FlDotData(show: false),
    );
  }

  String _formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('hh:mm:ss a').format(date);
  }
}
