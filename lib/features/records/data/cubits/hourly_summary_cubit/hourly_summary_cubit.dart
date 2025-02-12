import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/features/records/data/models/hourly_summary.dart';

class HourlySummariesCubit extends Cubit<List<HourlySummary>> {
  HourlySummariesCubit() : super([]);

  Future<void> fetchSummaries() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    
    try {
      final querySnapshot = await FirebaseFirestore.instance
        .collection("user_poseture_summary")
        .doc(userId)
        .collection('hourly_summaries')
        .orderBy('timestamp', descending: false)
        .get();

      print("✅ Fetched ${querySnapshot.docs.length} summaries");
      final summaries = querySnapshot.docs.map((doc) {
        return HourlySummary.fromJson(doc.data());
      }).toList();

      emit(summaries);
    } catch (e) {
      emit([]);
    }
  }
}
