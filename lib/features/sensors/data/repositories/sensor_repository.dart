// sensor_repository.dart
import 'package:drift/drift.dart';
import 'package:holdwise/features/sensors/data/services/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SensorRepository {
  final LocalDatabase db;

  SensorRepository(this.db);

  /// Inserts a raw sensor data record into the local DB.
  Future<int> insertSensorData(String type, int timestamp, double x, double y, double z) {
    return db.into(db.sensorDataTable).insert(
      SensorDataTableCompanion(
        type: Value(type),
        timestamp: Value(timestamp),
        x: Value(x),
        y: Value(y),
        z: Value(z),
      ),
    );
  }

  /// Fetch raw sensor data records between [startTimestamp] and [endTimestamp].
  Future<List<SensorDataTableData>> fetchSensorDataBetween(int startTimestamp, int endTimestamp) {
    return (db.select(db.sensorDataTable)
          ..where((tbl) => tbl.timestamp.isBetweenValues(startTimestamp, endTimestamp)))
        .get();
  }

  /// Delete all raw sensor data records older than [cutoffTimestamp].
  Future<int> deleteSensorDataOlderThan(int cutoffTimestamp) {
    return (db.delete(db.sensorDataTable)
          ..where((tbl) => tbl.timestamp.isSmallerThanValue(cutoffTimestamp)))
        .go();
  }

  /// Inserts an aggregated data record into the local DB.
  Future<int> insertAggregatedData({
    required int startTimestamp,
    required int endTimestamp,
    required double avgX,
    required double avgY,
    required double avgZ,
    required double minX,
    required double maxX,
    required int postureViolations,
  }) {
    return db.into(db.aggregatedDataTable).insert(
      AggregatedDataTableCompanion(
        startTimestamp: Value(startTimestamp),
        endTimestamp: Value(endTimestamp),
        avgX: Value(avgX),
        avgY: Value(avgY),
        avgZ: Value(avgZ),
        minX: Value(minX),
        maxX: Value(maxX),
        postureViolations: Value(postureViolations),
      ),
    );
  }

  /// Fetches all aggregated data records.
  Future<List<AggregatedDataTableData>> fetchAggregatedData() {
    return db.select(db.aggregatedDataTable).get();
  }

  /// Delete aggregated data records older than [cutoffTimestamp].
  Future<int> deleteAggregatedDataOlderThan(int cutoffTimestamp) {
    return (db.delete(db.aggregatedDataTable)
          ..where((tbl) => tbl.endTimestamp.isSmallerThanValue(cutoffTimestamp)))
        .go();
  }

  /// Upload all aggregated records to Firebase and, on success, delete them from the local DB.
  Future<void> uploadAggregatedDataToFirebase() async {
    final aggregatedDataList = await fetchAggregatedData();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "unknown";

    for (final agg in aggregatedDataList) {
      // Use the window end timestamp as a unique document ID.
      final docId = "${agg.endTimestamp}";
      final data = {
        'startTimestamp': agg.startTimestamp,
        'endTimestamp': agg.endTimestamp,
        'avgX': agg.avgX,
        'avgY': agg.avgY,
        'avgZ': agg.avgZ,
        'minX': agg.minX,
        'maxX': agg.maxX,
        'postureViolations': agg.postureViolations,
      };
      try {
        await FirebaseFirestore.instance
            .collection("user_posture_summaries")
            .doc(userId)
            .collection("hourly_summaries")
            .doc(docId)
            .set(data);

        print("✅ Aggregated summary uploaded: $data");
        // Remove the record from local storage once uploaded.
        await (db.delete(db.aggregatedDataTable)
          ..where((tbl) => tbl.id.equals(agg.id))).go();
      } catch (e) {
        print("❌ Error uploading aggregated data: $e");
      }
    }
  }

  /// Purge any data older than [daysOld] days to avoid uncontrolled growth.
  Future<void> purgeOldData({int daysOld = 1}) async {
    final cutoff = DateTime.now().subtract(Duration(days: daysOld)).millisecondsSinceEpoch;
    await deleteSensorDataOlderThan(cutoff);
    await deleteAggregatedDataOlderThan(cutoff);
  }
}
