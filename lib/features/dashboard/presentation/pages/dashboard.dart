import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/common/widgets/role_based_side_navbar.dart';
import 'package:holdwise/features/sensors/data/cubits/sensors_cubit.dart';
import 'package:holdwise/features/sensors/presentation/widgets/violation_scatter_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a role-based app bar for a consistent header
      appBar: const RoleBasedAppBar(title: 'Dashboard'),
      // Provide a side navigation drawer (for mobile or as needed)
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          // Get the orientation log and filter for violations
          final orientationLog = state.orientationLog;
          const double threshold = 70.0;
          final violations =
              orientationLog.where((o) => o.tiltAngle > threshold).toList();

          // Get current orientation if available
          final currentOrientation = orientationLog.isNotEmpty
              ? orientationLog.last
              : null;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Desktop/tablet layout: show cards and chart side-by-side
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Statistics cards
                      Expanded(
                        flex: 2,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            _buildStatCard(
                              title: 'Total Violations This Hour',
                              value: '${violations.length}',
                              icon: Icons.error_outline,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(height: 16),
                            _buildStatCard(
                              title: 'Current Tilt Angle',
                              value: currentOrientation != null
                                  ? '${currentOrientation.tiltAngle.toStringAsFixed(1)}°'
                                  : 'No Data',
                              icon: Icons.speed,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(height: 16),
                            _buildStatCard(
                              title: 'Total Sensor Data Points',
                              value: '${state.sensorData.length}',
                              icon: Icons.data_usage,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Chart card
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ViolationScatterChart(
                            violations: violations,
                            referenceDate: DateTime.now(),
                            displayFilter: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 72),
                    ],
                  );
                } else {
                  // Mobile layout: show cards and chart in a column
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildStatCard(
                          title: 'Total Violations This Hour',
                          value: '${violations.length}',
                          icon: Icons.error_outline,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          title: 'Current Tilt Angle',
                          value: currentOrientation != null
                              ? '${currentOrientation.tiltAngle.toStringAsFixed(1)}°'
                              : 'No Data',
                          icon: Icons.speed,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          title: 'Total Sensor Data Points',
                          value: '${state.sensorData.length}',
                          icon: Icons.data_usage,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        ViolationScatterChart(
                          violations: violations,
                          referenceDate: DateTime.now(),
                          displayFilter: false,
                        ),
                        const SizedBox(height: 72),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  /// A helper widget to build a nicely styled stat card.
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
