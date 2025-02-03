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
          String message = "Fetching score...";
          Color cardColor = Theme.of(context).cardColor;

          if (state is PostureScoreLoaded) {
            postureScore = state.score;
            cardColor = postureScore > 70 ? AppColors.success : AppColors.error;
            message = postureScore > 70 ? "🟢 Good Posture" : "🔴 Needs Improvement";
          } else if (state is PostureScoreError) {
            cardColor = AppColors.warning;
            print(state.message);
            message = state.message.contains("permission")
                ? "Permission denied."
                : state.message.isNotEmpty
                    ? state.message
                    : "An error occurred.";
          }
          print(new DateTime.now().toString() + " - Posture Score: $postureScore");
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: cardColor,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.accessibility_new, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Posture Score",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                        ),
                        Text(
                          postureScore != null ? "$postureScore / 100" : "-- / 100",
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                        ),
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
