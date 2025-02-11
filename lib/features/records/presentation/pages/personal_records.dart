import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/records/presentation/widgets/posture_score_card.dart';
import 'package:holdwise/features/records/presentation/widgets/trend_chart.dart';
import 'package:holdwise/features/records/presentation/widgets/alert_response_gauge.dart';
import 'package:holdwise/features/records/presentation/widgets/streak_badges.dart';
import 'package:holdwise/features/records/presentation/widgets/activity_breakdown.dart';
import 'package:holdwise/features/sensors/data/cubits/sensors_cubit.dart';
import 'package:holdwise/features/sensors/presentation/widgets/violation_scatter_chart.dart';
import 'package:holdwise/features/sensors/data/models/orientation_data.dart'; // Make sure this model has a constructor like below

class PersonalRecords extends StatelessWidget {
  const PersonalRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoleBasedAppBar(title: 'Your Records', displayActions: false),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            return BlocBuilder<SensorCubit, SensorState>(
              builder: (context, sensorState) {
                final orientationLog = sensorState.orientationLog;
                final threshold = 70.0;
                final violations =
                    orientationLog.where((o) => o.tiltAngle > threshold).toList();
                return ListView(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).padding.bottom + 16),
                  children: [
                    const SizedBox(height: 16),
                    PostureScoreCard(userId: authState.user.uid),
                    const SizedBox(height: 16),
                    // Add the scatter plot here:
                    ViolationScatterChart(
                      violations: violations,
                     referenceDate: DateTime
                          .now(), // Reference date for grouping violations
                    ),
                    const SizedBox(height: 16),
                    TrendChart(),
                    const SizedBox(height: 16),
                    AlertResponseGauge(
                      responseRate: 90,
                    ),
                    const SizedBox(height: 16),
                    StreakBadges(
                      currentStreak: 5,
                      longestStreak: 10,
                      latestBadge: "🏆",
                      nextBadgeGoal: 15,
                      earnedBadges: ["🏆", "🥇", "🥈", "🥉"],
                    ),
                    const SizedBox(height: 16),
                    ActivityBreakdown(
                      activityData: {
                        "Gaming": 3.5,
                        "Studying": 4.0,
                        "Working": 2.5,
                      },
                    ),
                  ],
                );
              },
            );
          } else if (authState is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text("Please log in to view records."));
          }
        },
      ),
    );
  }
}
