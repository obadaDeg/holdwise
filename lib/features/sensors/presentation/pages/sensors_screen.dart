import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/features/sensors/data/cubits/sensors_cubit.dart';
import 'package:holdwise/features/sensors/data/models/orientation_data.dart';
import 'package:holdwise/features/sensors/presentation/widgets/violation_scatter_chart.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  // Default filter is "day" with referenceDate set to today.
  ViolationFilter selectedFilter = ViolationFilter.day;
  DateTime referenceDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posture Violations')),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          // Use your orientationLog from the cubit and count only those above the threshold.
          final orientationLog = state.orientationLog;
          final threshold = 70.0;
          final violations = orientationLog
              .where((o) => o.tiltAngle < threshold)
              .toList();

          // Filter violations according to the selected filter.
          List<OrientationData> filteredViolations = [];
          switch (selectedFilter) {
            case ViolationFilter.day:
              filteredViolations = violations.where((v) {
                DateTime dt = DateTime.fromMillisecondsSinceEpoch(v.timestamp);
                return dt.year == referenceDate.year &&
                    dt.month == referenceDate.month &&
                    dt.day == referenceDate.day;
              }).toList();
              break;
            case ViolationFilter.week:
              DateTime monday = referenceDate
                  .subtract(Duration(days: referenceDate.weekday - 1));
              DateTime sunday = monday.add(const Duration(days: 6));
              filteredViolations = violations.where((v) {
                DateTime dt = DateTime.fromMillisecondsSinceEpoch(v.timestamp);
                return dt.isAfter(monday.subtract(const Duration(seconds: 1))) &&
                    dt.isBefore(sunday.add(const Duration(days: 1)));
              }).toList();
              break;
            case ViolationFilter.month:
              filteredViolations = violations.where((v) {
                DateTime dt = DateTime.fromMillisecondsSinceEpoch(v.timestamp);
                return dt.year == referenceDate.year &&
                    dt.month == referenceDate.month;
              }).toList();
              break;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Filter toggle buttons using ChoiceChips
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Day"),
                      selected: selectedFilter == ViolationFilter.day,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedFilter = ViolationFilter.day;
                            referenceDate = DateTime.now();
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text("Week"),
                      selected: selectedFilter == ViolationFilter.week,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedFilter = ViolationFilter.week;
                            referenceDate = DateTime.now();
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text("Month"),
                      selected: selectedFilter == ViolationFilter.month,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedFilter = ViolationFilter.month;
                            referenceDate = DateTime.now();
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Our new scatter chart visualization
                ViolationScatterChart(
                  violations: filteredViolations,
                  referenceDate: referenceDate,
                ),
                const SizedBox(height: 24),
                // (Optional) Other UI elements such as current tilt angle, violation count, etc.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          context.read<SensorCubit>().startMonitoring(),
                      child: const Text('Start'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<SensorCubit>().stopMonitoring(),
                      child: const Text('Stop'),
                    ),
                    ElevatedButton(
                      onPressed: () => context.read<SensorCubit>().clearData(),
                      child: const Text('Clear'),
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
}
