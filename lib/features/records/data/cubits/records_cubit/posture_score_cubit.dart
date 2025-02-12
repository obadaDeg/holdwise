import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'posture_score_state.dart';

class PostureScoreCubit extends Cubit<PostureScoreState> {
  final FirebaseFirestore _firestore;

  PostureScoreCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(PostureScoreInitial());

  void fetchHourlyPostureScore(String userId) async {
    emit(PostureScoreLoading());

    try {
      final querySnapshot = await _firestore
          .collection("user_posture_summaries")
          .doc(userId)
          .collection('hourly_summaries')
          // .where('timestamp',
          //     isGreaterThan: DateTime.now().subtract(Duration(hours: 1)))
          .get();
      log("✅ Fetched ${querySnapshot.docs.length} summaries");

      if (querySnapshot.docs.isNotEmpty) {
        int totalViolations = 0;
        int totalRecords = querySnapshot.docs.length;

        for (var doc in querySnapshot.docs) {
          totalViolations += (doc.data()['postureViolations'] ?? 0) as int;
          log("📊 ${doc.id}: ${doc.data()['postureViolations']} violations");
        }

        // Calculate the average violations
        double averageViolations = totalViolations / totalRecords;

        // Normalize the average to a 0 - 100 scale
        // For example, if 350 is the worst (score 0), and 0 is the best (score 100)
        double normalizedScore = ((350 - averageViolations) / 350) * 100;

        // Ensure the score stays within bounds
        int score = normalizedScore.clamp(0, 100).round();
        log("📊 Average violations: $averageViolations");
        log("📊 Normalized score: $normalizedScore");
        log("📊 Final score: $score");

        emit(PostureScoreLoaded(score));
      } else {
        emit(PostureScoreError("No hourly summaries found."));
      }
    } catch (error) {
      emit(PostureScoreError("Error fetching hourly summaries!"));
    }
  }
}
