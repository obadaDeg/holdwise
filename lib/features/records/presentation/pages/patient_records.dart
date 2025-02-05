import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/features/records/presentation/widgets/posture_score_card.dart';
import 'package:holdwise/features/records/presentation/widgets/trend_chart.dart';
import 'package:holdwise/features/records/presentation/widgets/alert_response_gauge.dart';
import 'package:holdwise/features/records/presentation/widgets/streak_badges.dart';
import 'package:holdwise/features/records/presentation/widgets/activity_breakdown.dart';

class PatientRecords extends StatelessWidget {
  const PatientRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          print(state.user.uid);
          return ListView(
            children: [
              const SizedBox(height: 16),
              PostureScoreCard(
                  userId: state.user.uid), // Accessing user ID safely
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
                earnedBadges: ["🏆", "🥇", "🥈", "🥉"], // New: List of all earned badges
              ),
              const SizedBox(height: 16),
              ActivityBreakdown(
                activityData: {
                  "Gaming": 3.5, // 3.5 hours
                  "Studying": 4.0, // 4.0 hours
                  "Working": 2.5, // 2.5 hours
                },
              )
            ],
          );
        } else if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text("Please log in to view records."));
        }
      },
    );
  }
}
