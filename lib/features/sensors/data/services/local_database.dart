// local_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'local_database.g.dart';

/// Define the table for raw sensor data.
class SensorDataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // e.g., 'accelerometer' or 'gyroscope'
  IntColumn get timestamp => integer()(); // epoch milliseconds
  RealColumn get x => real()();
  RealColumn get y => real()();
  RealColumn get z => real()();
}

/// Define the table for aggregated sensor summaries.
class AggregatedDataTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// Start of the aggregation window (epoch ms)
  IntColumn get startTimestamp => integer()();
  /// End of the aggregation window (epoch ms)
  IntColumn get endTimestamp => integer()();
  RealColumn get avgX => real()();
  RealColumn get avgY => real()();
  RealColumn get avgZ => real()();
  RealColumn get minX => real()();
  RealColumn get maxX => real()();
  /// Count of posture violations during the window.
  IntColumn get postureViolations => integer()();
}

/// Creates a LazyDatabase instance that initializes the database file.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dir.path, 'sensor_data.sqlite'));
    return NativeDatabase(dbFile);
  });
}

/// The main database class which provides access to the tables.
@DriftDatabase(tables: [SensorDataTable, AggregatedDataTable])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
