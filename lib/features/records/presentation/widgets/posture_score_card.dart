import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/features/records/data/cubits/records_cubit/posture_score_cubit.dart';

class PostureScoreCard extends StatelessWidget {
  final String userId;

  const PostureScoreCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostureScoreCubit()..fetchPostureScore(userId),
      child: BlocBuilder<PostureScoreCubit, PostureScoreState>(
        builder: (context, state) {
          int? postureScore;
          List<int> weeklyScores = [80, 75, 70, 85, 90, 78, 82]; // Mock data
          double weeklyAverage =
              weeklyScores.reduce((a, b) => a + b) / weeklyScores.length;

          String message = "Fetching score...";
          Color cardColor = Theme.of(context).cardColor;
          double? improvement;

          if (state is PostureScoreLoaded) {
            postureScore = state.score;
            cardColor = postureScore > 70 ? AppColors.success : AppColors.error;
            message =
                postureScore > 70 ? "🟢 Good Posture" : "🔴 Needs Improvement";
          } else if (state is PostureScoreError) {
            cardColor = AppColors.warning;
            message =
                state.message.isNotEmpty ? state.message : "An error occurred.";
            improvement =
                ((postureScore ?? 0) - weeklyAverage) / weeklyAverage * 100;
          }

          String insight = improvement == null
              ? "Fetching weekly average..."
              : improvement >= 0
                  ? "📈 Improved by ${improvement.toStringAsFixed(1)}% this week"
                  : "📉 Dropped by ${(-improvement).toStringAsFixed(1)}% this week";

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: cardColor,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.accessibility_new,
                      size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today's Posture Score",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.white)),
                        Text(
                            postureScore != null
                                ? "$postureScore / 100"
                                : "-- / 100",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white)),
                        const SizedBox(height: 10),
                        // should be displayed only when the score is loaded

                        // Loading indicator
                        Text(insight,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
