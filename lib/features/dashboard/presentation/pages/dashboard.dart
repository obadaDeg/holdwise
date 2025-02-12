import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/app/utils/api_path.dart';
import 'package:holdwise/common/services/firestore_services.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/common/widgets/role_based_side_navbar.dart';
import 'package:holdwise/features/profile/presentation/pages/complete_profile_screen.dart';
import 'package:holdwise/features/sensors/data/cubits/sensors_cubit.dart';
import 'package:holdwise/features/sensors/presentation/widgets/violation_scatter_chart.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirestoreServices firestoreServices = FirestoreServices.instance;
  bool _profileChecked = false; // to avoid checking repeatedly

  @override
  void initState() {
    super.initState();
    _checkUserProfile();
  }

  /// Check if the current user's Firestore document contains complete data.
  Future<void> _checkUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch the user's document from Firestore
        final Map<String, dynamic> userData = await firestoreServices.getDocument(
          path: ApiPath.user(user.uid),
          builder: (data, documentId) => data,
        );

        if (_isProfileIncomplete(userData)) {
          // Use a post-frame callback to navigate so that it doesn't block the build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.completeProfile,              
            );
          });
        }
      } catch (e) {
        // Optionally, handle errors or log them
        debugPrint('Error fetching user data: $e');
      }
    }
  }

  /// Returns true if any required field is empty.
  bool _isProfileIncomplete(Map<String, dynamic> data) {
    // Example: Check if 'name', 'phoneNumber', or 'about' are empty.
    // Adjust the required fields as needed.
    final String name = data['name'] as String? ?? '';
    final String phoneNumber = data['phoneNumber'] as String? ?? '';
    final String about = data['about'] as String? ?? '';

    return name.trim().isEmpty || phoneNumber.trim().isEmpty || about.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // You can also show a loader if you want until _checkUserProfile finishes
    return Scaffold(
      appBar: const RoleBasedAppBar(title: 'Dashboard'),
      // If you are using a side navigation drawer, you could include it here:
      // drawer: const RoleBasedSideNavBar(),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          // Get sensor data (example provided)
          final orientationLog = state.orientationLog;
          const double threshold = 70.0;
          final violations =
              orientationLog.where((o) => o.tiltAngle > threshold).toList();

          final currentOrientation = orientationLog.isNotEmpty
              ? orientationLog.last
              : null;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  // Desktop/tablet layout: side-by-side layout
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
                  // Mobile layout: vertical column layout
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

  /// Helper widget to build a styled statistic card.
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
