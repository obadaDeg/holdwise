import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch patient's posture records
  Stream<List<Map<String, dynamic>>> getPostureRecords(String userId) {
    return _db
        .collection('postureRecords')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Fetch specialist's patient list
  Stream<List<Map<String, dynamic>>> getSpecialistPatients(String specialistId) {
    return _db
        .collection('patients')
        .where('assignedSpecialist', isEqualTo: specialistId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Fetch admin system analytics
  Future<Map<String, dynamic>> getAdminAnalytics() async {
    final activeUsers = await _db.collection('users').count().get();
    final responseRate = await _db.collection('alerts').where('responded', isEqualTo: true).count().get();
    
    return {
      'activeUsers': activeUsers.count,
      'responseRate': responseRate.count
    };
  }
}
