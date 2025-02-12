import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch patient's posture records
  Stream<List<Map<String, dynamic>>> getPostureRecords(String userId) {
    return _db
        .collection('postureRecords')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Fetch specialist's patient list
  Stream<List<Map<String, dynamic>>> getSpecialistPatients(
      String specialistId) {
    return _db
        .collection('patients')
        .where('assignedSpecialist', isEqualTo: specialistId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Fetch admin system analytics
  Future<Map<String, dynamic>> getAdminAnalytics() async {
    try {
    final activeUsers = await _db.collection('users').count().get();
    final responseRate = await _db
        .collection('alerts')
        .where('responded', isEqualTo: true)
        .count()
        .get();

    return {
      'activeUsers': activeUsers.count,
      'responseRate': responseRate.count
    };
    } catch (e) {
      throw Exception('Error fetching admin analytics: $e');
    }
  }

  /// Fetches posture violation data from Firestore and aggregates counts by app.
  /// You could change this to sum durations if you store a duration field.
  Future<Map<String, double>> getActivityBreakdownReport() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('posture_violations')
          .get();
      final Map<String, double> reportData = {};

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final String appName = data['appInUse'] ?? 'Unknown';
        reportData[appName] = (reportData[appName] ?? 0) + 1.0;
      }

      return reportData;
    } catch (e) {
      throw Exception('Error fetching activity breakdown: $e');
    }
  }
}
