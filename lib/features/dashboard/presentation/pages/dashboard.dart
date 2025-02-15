import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
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
  bool _profileChecked = false; // Prevents repeated checking
  int _howManyProfileChecked = 0;
  @override
  void initState() {
    super.initState();
    _checkUserProfile();
  }

  /// Checks the current user's profile using the AuthCubit state.
  Future<void> _checkUserProfile() async {
    if (_profileChecked) return;
    _profileChecked = true;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      bool profileIncomplete = false;

      try {
        // If display name is missing, update it using the user's email prefix.
        if (user.displayName == null || user.displayName!.isEmpty) {
          if (user.email != null && user.email!.isNotEmpty) {
            await user.updateDisplayName(user.email!.split('@').first);
          } else {
            profileIncomplete = true;
          }
        }

        // Instead of trying to update the phone number with an incomplete credential,
        // mark the profile as incomplete if phone number is missing.
        if (user.phoneNumber == null || user.phoneNumber!.isEmpty) {
          profileIncomplete = true;
        }

        // Retrieve additional user data from Firestore.
        final Map<String, dynamic> userData =
            await firestoreServices.getDocument(
          path: ApiPath.user(user.uid),
          builder: (data, documentId) => data,
        );

        // Check if any required fields from Firestore are missing.
        if (_isProfileIncomplete(userData)) {
          profileIncomplete = true;
        }

        // If any required profile information is missing, navigate to complete profile.
        if (profileIncomplete) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if(!mounted) return;
            if(_howManyProfileChecked > 0) return;
            _howManyProfileChecked++;
            Navigator.pushNamed(context, AppRoutes.completeProfile);
          });
        }
      } catch (e) {
        debugPrint('Error checking user profile: $e');
      }
    }
  }

  /// Returns true if any required field is empty.
  bool _isProfileIncomplete(Map<String, dynamic> data) {
    final String name = data['name'] as String? ?? '';
    final String phoneNumber = data['phoneNumber'] as String? ?? '';
    final String about = data['about'] as String? ?? '';
    return name.trim().isEmpty ||
        phoneNumber.trim().isEmpty ||
        about.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RoleBasedAppBar(title: 'Dashboard'),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          final orientationLog = state.orientationLog;
          const double threshold = 70.0;
          final violations =
              orientationLog.where((o) => o.tiltAngle > threshold).toList();

          final currentOrientation =
              orientationLog.isNotEmpty ? orientationLog.last : null;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  // Desktop/tablet layout: side-by-side layout
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                        fontSize: 20,
                        color: color,
                        fontWeight: FontWeight.w600),
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
