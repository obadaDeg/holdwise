import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/records/data/cubits/records_cubit/posture_score_cubit.dart';
import 'package:holdwise/features/records/presentation/widgets/posture_score_card.dart';
import 'package:holdwise/features/records/presentation/widgets/trend_chart.dart';
import 'package:holdwise/features/records/presentation/widgets/alert_response_gauge.dart';
import 'package:holdwise/features/records/presentation/widgets/streak_badges.dart';
import 'package:holdwise/features/records/presentation/widgets/activity_breakdown.dart';
import 'package:holdwise/features/sensors/data/cubits/sensors_cubit.dart';
import 'package:holdwise/features/sensors/presentation/widgets/violation_scatter_chart.dart';

class PersonalRecords extends StatelessWidget {
  const PersonalRecords({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).role
        : AppRoles.patient;

    log('$role records screen');

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (authState is! AuthAuthenticated) {
          return const Center(child: Text("Please log in to view records."));
        }

        Widget recordsContent = BlocProvider(
          create: (context) => PostureScoreCubit()
            ..fetchHourlyPostureScore(authState.user.uid),
          child: Builder(
            builder: (context) {
              return RefreshIndicator(
                onRefresh: () async {
                  log("Refreshing records...");
                  context
                      .read<PostureScoreCubit>()
                      .fetchHourlyPostureScore(authState.user.uid);
                },
                child: BlocBuilder<SensorCubit, SensorState>(
                  builder: (context, sensorState) {
                    final orientationLog = sensorState.orientationLog;
                    final threshold = 70.0;
                    final violations = orientationLog
                        .where((o) => o.tiltAngle > threshold)
                        .toList();

                    return ListView(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).padding.bottom + 16,
                      ),
                      children: [
                        const SizedBox(height: 16),
                        const PostureScoreCard(),
                        const SizedBox(height: 16),
                        ViolationScatterChart(
                          violations: violations,
                          referenceDate: DateTime.now(),
                        ),
                        const SizedBox(height: 16),
                        const TrendChart(),
                        const SizedBox(height: 16),
                        const AlertResponseGauge(responseRate: 90),
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
                ),
              );
            },
          ),
        );

        // Finally, wrap content in Scaffold if user is not patient
        if (role != AppRoles.patient) {
          log("Building records screen for $role");
          return Scaffold(
            appBar: RoleBasedAppBar(
              title: 'Your Records',
              displayActions: false,
            ),
            body: recordsContent,
          );
        } else {
          // If the user is a patient, just return the content (no Scaffold).
          log("Building records screen for patient");
          return recordsContent;
        }
      },
    );
  }
}
