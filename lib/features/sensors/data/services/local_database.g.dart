// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $SensorDataTableTable extends SensorDataTable
    with TableInfo<$SensorDataTableTable, SensorDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SensorDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
      'x', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
      'y', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _zMeta = const VerificationMeta('z');
  @override
  late final GeneratedColumn<double> z = GeneratedColumn<double>(
      'z', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, type, timestamp, x, y, z];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sensor_data_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SensorDataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('z')) {
      context.handle(_zMeta, z.isAcceptableOrUnknown(data['z']!, _zMeta));
    } else if (isInserting) {
      context.missing(_zMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SensorDataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SensorDataTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      x: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}x'])!,
      y: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}y'])!,
      z: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}z'])!,
    );
  }

  @override
  $SensorDataTableTable createAlias(String alias) {
    return $SensorDataTableTable(attachedDatabase, alias);
  }
}

class SensorDataTableData extends DataClass
    implements Insertable<SensorDataTableData> {
  final int id;
  final String type;
  final int timestamp;
  final double x;
  final double y;
  final double z;
  const SensorDataTableData(
      {required this.id,
      required this.type,
      required this.timestamp,
      required this.x,
      required this.y,
      required this.z});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['timestamp'] = Variable<int>(timestamp);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['z'] = Variable<double>(z);
    return map;
  }

  SensorDataTableCompanion toCompanion(bool nullToAbsent) {
    return SensorDataTableCompanion(
      id: Value(id),
      type: Value(type),
      timestamp: Value(timestamp),
      x: Value(x),
      y: Value(y),
      z: Value(z),
    );
  }

  factory SensorDataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SensorDataTableData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      z: serializer.fromJson<double>(json['z']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'timestamp': serializer.toJson<int>(timestamp),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'z': serializer.toJson<double>(z),
    };
  }

  SensorDataTableData copyWith(
          {int? id,
          String? type,
          int? timestamp,
          double? x,
          double? y,
          double? z}) =>
      SensorDataTableData(
        id: id ?? this.id,
        type: type ?? this.type,
        timestamp: timestamp ?? this.timestamp,
        x: x ?? this.x,
        y: y ?? this.y,
        z: z ?? this.z,
      );
  SensorDataTableData copyWithCompanion(SensorDataTableCompanion data) {
    return SensorDataTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      z: data.z.present ? data.z.value : this.z,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SensorDataTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('timestamp: $timestamp, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('z: $z')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, timestamp, x, y, z);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SensorDataTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.timestamp == this.timestamp &&
          other.x == this.x &&
          other.y == this.y &&
          other.z == this.z);
}

class SensorDataTableCompanion extends UpdateCompanion<SensorDataTableData> {
  final Value<int> id;
  final Value<String> type;
  final Value<int> timestamp;
  final Value<double> x;
  final Value<double> y;
  final Value<double> z;
  const SensorDataTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.z = const Value.absent(),
  });
  SensorDataTableCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required int timestamp,
    required double x,
    required double y,
    required double z,
  })  : type = Value(type),
        timestamp = Value(timestamp),
        x = Value(x),
        y = Value(y),
        z = Value(z);
  static Insertable<SensorDataTableData> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? timestamp,
    Expression<double>? x,
    Expression<double>? y,
    Expression<double>? z,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (timestamp != null) 'timestamp': timestamp,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (z != null) 'z': z,
    });
  }

  SensorDataTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<int>? timestamp,
      Value<double>? x,
      Value<double>? y,
      Value<double>? z}) {
    return SensorDataTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (z.present) {
      map['z'] = Variable<double>(z.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SensorDataTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('timestamp: $timestamp, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('z: $z')
          ..write(')'))
        .toString();
  }
}

class $AggregatedDataTableTable extends AggregatedDataTable
    with TableInfo<$AggregatedDataTableTable, AggregatedDataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AggregatedDataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startTimestampMeta =
      const VerificationMeta('startTimestamp');
  @override
  late final GeneratedColumn<int> startTimestamp = GeneratedColumn<int>(
      'start_timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endTimestampMeta =
      const VerificationMeta('endTimestamp');
  @override
  late final GeneratedColumn<int> endTimestamp = GeneratedColumn<int>(
      'end_timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _avgXMeta = const VerificationMeta('avgX');
  @override
  late final GeneratedColumn<double> avgX = GeneratedColumn<double>(
      'avg_x', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _avgYMeta = const VerificationMeta('avgY');
  @override
  late final GeneratedColumn<double> avgY = GeneratedColumn<double>(
      'avg_y', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _avgZMeta = const VerificationMeta('avgZ');
  @override
  late final GeneratedColumn<double> avgZ = GeneratedColumn<double>(
      'avg_z', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _minXMeta = const VerificationMeta('minX');
  @override
  late final GeneratedColumn<double> minX = GeneratedColumn<double>(
      'min_x', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxXMeta = const VerificationMeta('maxX');
  @override
  late final GeneratedColumn<double> maxX = GeneratedColumn<double>(
      'max_x', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _postureViolationsMeta =
      const VerificationMeta('postureViolations');
  @override
  late final GeneratedColumn<int> postureViolations = GeneratedColumn<int>(
      'posture_violations', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startTimestamp,
        endTimestamp,
        avgX,
        avgY,
        avgZ,
        minX,
        maxX,
        postureViolations
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'aggregated_data_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AggregatedDataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_timestamp')) {
      context.handle(
          _startTimestampMeta,
          startTimestamp.isAcceptableOrUnknown(
              data['start_timestamp']!, _startTimestampMeta));
    } else if (isInserting) {
      context.missing(_startTimestampMeta);
    }
    if (data.containsKey('end_timestamp')) {
      context.handle(
          _endTimestampMeta,
          endTimestamp.isAcceptableOrUnknown(
              data['end_timestamp']!, _endTimestampMeta));
    } else if (isInserting) {
      context.missing(_endTimestampMeta);
    }
    if (data.containsKey('avg_x')) {
      context.handle(
          _avgXMeta, avgX.isAcceptableOrUnknown(data['avg_x']!, _avgXMeta));
    } else if (isInserting) {
      context.missing(_avgXMeta);
    }
    if (data.containsKey('avg_y')) {
      context.handle(
          _avgYMeta, avgY.isAcceptableOrUnknown(data['avg_y']!, _avgYMeta));
    } else if (isInserting) {
      context.missing(_avgYMeta);
    }
    if (data.containsKey('avg_z')) {
      context.handle(
          _avgZMeta, avgZ.isAcceptableOrUnknown(data['avg_z']!, _avgZMeta));
    } else if (isInserting) {
      context.missing(_avgZMeta);
    }
    if (data.containsKey('min_x')) {
      context.handle(
          _minXMeta, minX.isAcceptableOrUnknown(data['min_x']!, _minXMeta));
    } else if (isInserting) {
      context.missing(_minXMeta);
    }
    if (data.containsKey('max_x')) {
      context.handle(
          _maxXMeta, maxX.isAcceptableOrUnknown(data['max_x']!, _maxXMeta));
    } else if (isInserting) {
      context.missing(_maxXMeta);
    }
    if (data.containsKey('posture_violations')) {
      context.handle(
          _postureViolationsMeta,
          postureViolations.isAcceptableOrUnknown(
              data['posture_violations']!, _postureViolationsMeta));
    } else if (isInserting) {
      context.missing(_postureViolationsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AggregatedDataTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AggregatedDataTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startTimestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}start_timestamp'])!,
      endTimestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_timestamp'])!,
      avgX: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_x'])!,
      avgY: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_y'])!,
      avgZ: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_z'])!,
      minX: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min_x'])!,
      maxX: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_x'])!,
      postureViolations: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}posture_violations'])!,
    );
  }

  @override
  $AggregatedDataTableTable createAlias(String alias) {
    return $AggregatedDataTableTable(attachedDatabase, alias);
  }
}

class AggregatedDataTableData extends DataClass
    implements Insertable<AggregatedDataTableData> {
  final int id;

  /// Start of the aggregation window (epoch ms)
  final int startTimestamp;

  /// End of the aggregation window (epoch ms)
  final int endTimestamp;
  final double avgX;
  final double avgY;
  final double avgZ;
  final double minX;
  final double maxX;

  /// Count of posture violations during the window.
  final int postureViolations;
  const AggregatedDataTableData(
      {required this.id,
      required this.startTimestamp,
      required this.endTimestamp,
      required this.avgX,
      required this.avgY,
      required this.avgZ,
      required this.minX,
      required this.maxX,
      required this.postureViolations});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_timestamp'] = Variable<int>(startTimestamp);
    map['end_timestamp'] = Variable<int>(endTimestamp);
    map['avg_x'] = Variable<double>(avgX);
    map['avg_y'] = Variable<double>(avgY);
    map['avg_z'] = Variable<double>(avgZ);
    map['min_x'] = Variable<double>(minX);
    map['max_x'] = Variable<double>(maxX);
    map['posture_violations'] = Variable<int>(postureViolations);
    return map;
  }

  AggregatedDataTableCompanion toCompanion(bool nullToAbsent) {
    return AggregatedDataTableCompanion(
      id: Value(id),
      startTimestamp: Value(startTimestamp),
      endTimestamp: Value(endTimestamp),
      avgX: Value(avgX),
      avgY: Value(avgY),
      avgZ: Value(avgZ),
      minX: Value(minX),
      maxX: Value(maxX),
      postureViolations: Value(postureViolations),
    );
  }

  factory AggregatedDataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AggregatedDataTableData(
      id: serializer.fromJson<int>(json['id']),
      startTimestamp: serializer.fromJson<int>(json['startTimestamp']),
      endTimestamp: serializer.fromJson<int>(json['endTimestamp']),
      avgX: serializer.fromJson<double>(json['avgX']),
      avgY: serializer.fromJson<double>(json['avgY']),
      avgZ: serializer.fromJson<double>(json['avgZ']),
      minX: serializer.fromJson<double>(json['minX']),
      maxX: serializer.fromJson<double>(json['maxX']),
      postureViolations: serializer.fromJson<int>(json['postureViolations']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTimestamp': serializer.toJson<int>(startTimestamp),
      'endTimestamp': serializer.toJson<int>(endTimestamp),
      'avgX': serializer.toJson<double>(avgX),
      'avgY': serializer.toJson<double>(avgY),
      'avgZ': serializer.toJson<double>(avgZ),
      'minX': serializer.toJson<double>(minX),
      'maxX': serializer.toJson<double>(maxX),
      'postureViolations': serializer.toJson<int>(postureViolations),
    };
  }

  AggregatedDataTableData copyWith(
          {int? id,
          int? startTimestamp,
          int? endTimestamp,
          double? avgX,
          double? avgY,
          double? avgZ,
          double? minX,
          double? maxX,
          int? postureViolations}) =>
      AggregatedDataTableData(
        id: id ?? this.id,
        startTimestamp: startTimestamp ?? this.startTimestamp,
        endTimestamp: endTimestamp ?? this.endTimestamp,
        avgX: avgX ?? this.avgX,
        avgY: avgY ?? this.avgY,
        avgZ: avgZ ?? this.avgZ,
        minX: minX ?? this.minX,
        maxX: maxX ?? this.maxX,
        postureViolations: postureViolations ?? this.postureViolations,
      );
  AggregatedDataTableData copyWithCompanion(AggregatedDataTableCompanion data) {
    return AggregatedDataTableData(
      id: data.id.present ? data.id.value : this.id,
      startTimestamp: data.startTimestamp.present
          ? data.startTimestamp.value
          : this.startTimestamp,
      endTimestamp: data.endTimestamp.present
          ? data.endTimestamp.value
          : this.endTimestamp,
      avgX: data.avgX.present ? data.avgX.value : this.avgX,
      avgY: data.avgY.present ? data.avgY.value : this.avgY,
      avgZ: data.avgZ.present ? data.avgZ.value : this.avgZ,
      minX: data.minX.present ? data.minX.value : this.minX,
      maxX: data.maxX.present ? data.maxX.value : this.maxX,
      postureViolations: data.postureViolations.present
          ? data.postureViolations.value
          : this.postureViolations,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AggregatedDataTableData(')
          ..write('id: $id, ')
          ..write('startTimestamp: $startTimestamp, ')
          ..write('endTimestamp: $endTimestamp, ')
          ..write('avgX: $avgX, ')
          ..write('avgY: $avgY, ')
          ..write('avgZ: $avgZ, ')
          ..write('minX: $minX, ')
          ..write('maxX: $maxX, ')
          ..write('postureViolations: $postureViolations')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startTimestamp, endTimestamp, avgX, avgY,
      avgZ, minX, maxX, postureViolations);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AggregatedDataTableData &&
          other.id == this.id &&
          other.startTimestamp == this.startTimestamp &&
          other.endTimestamp == this.endTimestamp &&
          other.avgX == this.avgX &&
          other.avgY == this.avgY &&
          other.avgZ == this.avgZ &&
          other.minX == this.minX &&
          other.maxX == this.maxX &&
          other.postureViolations == this.postureViolations);
}

class AggregatedDataTableCompanion
    extends UpdateCompanion<AggregatedDataTableData> {
  final Value<int> id;
  final Value<int> startTimestamp;
  final Value<int> endTimestamp;
  final Value<double> avgX;
  final Value<double> avgY;
  final Value<double> avgZ;
  final Value<double> minX;
  final Value<double> maxX;
  final Value<int> postureViolations;
  const AggregatedDataTableCompanion({
    this.id = const Value.absent(),
    this.startTimestamp = const Value.absent(),
    this.endTimestamp = const Value.absent(),
    this.avgX = const Value.absent(),
    this.avgY = const Value.absent(),
    this.avgZ = const Value.absent(),
    this.minX = const Value.absent(),
    this.maxX = const Value.absent(),
    this.postureViolations = const Value.absent(),
  });
  AggregatedDataTableCompanion.insert({
    this.id = const Value.absent(),
    required int startTimestamp,
    required int endTimestamp,
    required double avgX,
    required double avgY,
    required double avgZ,
    required double minX,
    required double maxX,
    required int postureViolations,
  })  : startTimestamp = Value(startTimestamp),
        endTimestamp = Value(endTimestamp),
        avgX = Value(avgX),
        avgY = Value(avgY),
        avgZ = Value(avgZ),
        minX = Value(minX),
        maxX = Value(maxX),
        postureViolations = Value(postureViolations);
  static Insertable<AggregatedDataTableData> custom({
    Expression<int>? id,
    Expression<int>? startTimestamp,
    Expression<int>? endTimestamp,
    Expression<double>? avgX,
    Expression<double>? avgY,
    Expression<double>? avgZ,
    Expression<double>? minX,
    Expression<double>? maxX,
    Expression<int>? postureViolations,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTimestamp != null) 'start_timestamp': startTimestamp,
      if (endTimestamp != null) 'end_timestamp': endTimestamp,
      if (avgX != null) 'avg_x': avgX,
      if (avgY != null) 'avg_y': avgY,
      if (avgZ != null) 'avg_z': avgZ,
      if (minX != null) 'min_x': minX,
      if (maxX != null) 'max_x': maxX,
      if (postureViolations != null) 'posture_violations': postureViolations,
    });
  }

  AggregatedDataTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? startTimestamp,
      Value<int>? endTimestamp,
      Value<double>? avgX,
      Value<double>? avgY,
      Value<double>? avgZ,
      Value<double>? minX,
      Value<double>? maxX,
      Value<int>? postureViolations}) {
    return AggregatedDataTableCompanion(
      id: id ?? this.id,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      avgX: avgX ?? this.avgX,
      avgY: avgY ?? this.avgY,
      avgZ: avgZ ?? this.avgZ,
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
      postureViolations: postureViolations ?? this.postureViolations,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTimestamp.present) {
      map['start_timestamp'] = Variable<int>(startTimestamp.value);
    }
    if (endTimestamp.present) {
      map['end_timestamp'] = Variable<int>(endTimestamp.value);
    }
    if (avgX.present) {
      map['avg_x'] = Variable<double>(avgX.value);
    }
    if (avgY.present) {
      map['avg_y'] = Variable<double>(avgY.value);
    }
    if (avgZ.present) {
      map['avg_z'] = Variable<double>(avgZ.value);
    }
    if (minX.present) {
      map['min_x'] = Variable<double>(minX.value);
    }
    if (maxX.present) {
      map['max_x'] = Variable<double>(maxX.value);
    }
    if (postureViolations.present) {
      map['posture_violations'] = Variable<int>(postureViolations.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AggregatedDataTableCompanion(')
          ..write('id: $id, ')
          ..write('startTimestamp: $startTimestamp, ')
          ..write('endTimestamp: $endTimestamp, ')
          ..write('avgX: $avgX, ')
          ..write('avgY: $avgY, ')
          ..write('avgZ: $avgZ, ')
          ..write('minX: $minX, ')
          ..write('maxX: $maxX, ')
          ..write('postureViolations: $postureViolations')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $SensorDataTableTable sensorDataTable =
      $SensorDataTableTable(this);
  late final $AggregatedDataTableTable aggregatedDataTable =
      $AggregatedDataTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [sensorDataTable, aggregatedDataTable];
}

typedef $$SensorDataTableTableCreateCompanionBuilder = SensorDataTableCompanion
    Function({
  Value<int> id,
  required String type,
  required int timestamp,
  required double x,
  required double y,
  required double z,
});
typedef $$SensorDataTableTableUpdateCompanionBuilder = SensorDataTableCompanion
    Function({
  Value<int> id,
  Value<String> type,
  Value<int> timestamp,
  Value<double> x,
  Value<double> y,
  Value<double> z,
});

class $$SensorDataTableTableFilterComposer
    extends Composer<_$LocalDatabase, $SensorDataTableTable> {
  $$SensorDataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get x => $composableBuilder(
      column: $table.x, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get y => $composableBuilder(
      column: $table.y, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get z => $composableBuilder(
      column: $table.z, builder: (column) => ColumnFilters(column));
}

class $$SensorDataTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $SensorDataTableTable> {
  $$SensorDataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get x => $composableBuilder(
      column: $table.x, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get y => $composableBuilder(
      column: $table.y, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get z => $composableBuilder(
      column: $table.z, builder: (column) => ColumnOrderings(column));
}

class $$SensorDataTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $SensorDataTableTable> {
  $$SensorDataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<double> get z =>
      $composableBuilder(column: $table.z, builder: (column) => column);
}

class $$SensorDataTableTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $SensorDataTableTable,
    SensorDataTableData,
    $$SensorDataTableTableFilterComposer,
    $$SensorDataTableTableOrderingComposer,
    $$SensorDataTableTableAnnotationComposer,
    $$SensorDataTableTableCreateCompanionBuilder,
    $$SensorDataTableTableUpdateCompanionBuilder,
    (
      SensorDataTableData,
      BaseReferences<_$LocalDatabase, $SensorDataTableTable,
          SensorDataTableData>
    ),
    SensorDataTableData,
    PrefetchHooks Function()> {
  $$SensorDataTableTableTableManager(
      _$LocalDatabase db, $SensorDataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SensorDataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SensorDataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SensorDataTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<double> x = const Value.absent(),
            Value<double> y = const Value.absent(),
            Value<double> z = const Value.absent(),
          }) =>
              SensorDataTableCompanion(
            id: id,
            type: type,
            timestamp: timestamp,
            x: x,
            y: y,
            z: z,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required int timestamp,
            required double x,
            required double y,
            required double z,
          }) =>
              SensorDataTableCompanion.insert(
            id: id,
            type: type,
            timestamp: timestamp,
            x: x,
            y: y,
            z: z,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SensorDataTableTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $SensorDataTableTable,
    SensorDataTableData,
    $$SensorDataTableTableFilterComposer,
    $$SensorDataTableTableOrderingComposer,
    $$SensorDataTableTableAnnotationComposer,
    $$SensorDataTableTableCreateCompanionBuilder,
    $$SensorDataTableTableUpdateCompanionBuilder,
    (
      SensorDataTableData,
      BaseReferences<_$LocalDatabase, $SensorDataTableTable,
          SensorDataTableData>
    ),
    SensorDataTableData,
    PrefetchHooks Function()>;
typedef $$AggregatedDataTableTableCreateCompanionBuilder
    = AggregatedDataTableCompanion Function({
  Value<int> id,
  required int startTimestamp,
  required int endTimestamp,
  required double avgX,
  required double avgY,
  required double avgZ,
  required double minX,
  required double maxX,
  required int postureViolations,
});
typedef $$AggregatedDataTableTableUpdateCompanionBuilder
    = AggregatedDataTableCompanion Function({
  Value<int> id,
  Value<int> startTimestamp,
  Value<int> endTimestamp,
  Value<double> avgX,
  Value<double> avgY,
  Value<double> avgZ,
  Value<double> minX,
  Value<double> maxX,
  Value<int> postureViolations,
});

class $$AggregatedDataTableTableFilterComposer
    extends Composer<_$LocalDatabase, $AggregatedDataTableTable> {
  $$AggregatedDataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startTimestamp => $composableBuilder(
      column: $table.startTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endTimestamp => $composableBuilder(
      column: $table.endTimestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgX => $composableBuilder(
      column: $table.avgX, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgY => $composableBuilder(
      column: $table.avgY, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgZ => $composableBuilder(
      column: $table.avgZ, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minX => $composableBuilder(
      column: $table.minX, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxX => $composableBuilder(
      column: $table.maxX, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get postureViolations => $composableBuilder(
      column: $table.postureViolations,
      builder: (column) => ColumnFilters(column));
}

class $$AggregatedDataTableTableOrderingComposer
    extends Composer<_$LocalDatabase, $AggregatedDataTableTable> {
  $$AggregatedDataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startTimestamp => $composableBuilder(
      column: $table.startTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endTimestamp => $composableBuilder(
      column: $table.endTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgX => $composableBuilder(
      column: $table.avgX, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgY => $composableBuilder(
      column: $table.avgY, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgZ => $composableBuilder(
      column: $table.avgZ, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minX => $composableBuilder(
      column: $table.minX, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxX => $composableBuilder(
      column: $table.maxX, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get postureViolations => $composableBuilder(
      column: $table.postureViolations,
      builder: (column) => ColumnOrderings(column));
}

class $$AggregatedDataTableTableAnnotationComposer
    extends Composer<_$LocalDatabase, $AggregatedDataTableTable> {
  $$AggregatedDataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startTimestamp => $composableBuilder(
      column: $table.startTimestamp, builder: (column) => column);

  GeneratedColumn<int> get endTimestamp => $composableBuilder(
      column: $table.endTimestamp, builder: (column) => column);

  GeneratedColumn<double> get avgX =>
      $composableBuilder(column: $table.avgX, builder: (column) => column);

  GeneratedColumn<double> get avgY =>
      $composableBuilder(column: $table.avgY, builder: (column) => column);

  GeneratedColumn<double> get avgZ =>
      $composableBuilder(column: $table.avgZ, builder: (column) => column);

  GeneratedColumn<double> get minX =>
      $composableBuilder(column: $table.minX, builder: (column) => column);

  GeneratedColumn<double> get maxX =>
      $composableBuilder(column: $table.maxX, builder: (column) => column);

  GeneratedColumn<int> get postureViolations => $composableBuilder(
      column: $table.postureViolations, builder: (column) => column);
}

class $$AggregatedDataTableTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $AggregatedDataTableTable,
    AggregatedDataTableData,
    $$AggregatedDataTableTableFilterComposer,
    $$AggregatedDataTableTableOrderingComposer,
    $$AggregatedDataTableTableAnnotationComposer,
    $$AggregatedDataTableTableCreateCompanionBuilder,
    $$AggregatedDataTableTableUpdateCompanionBuilder,
    (
      AggregatedDataTableData,
      BaseReferences<_$LocalDatabase, $AggregatedDataTableTable,
          AggregatedDataTableData>
    ),
    AggregatedDataTableData,
    PrefetchHooks Function()> {
  $$AggregatedDataTableTableTableManager(
      _$LocalDatabase db, $AggregatedDataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AggregatedDataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AggregatedDataTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AggregatedDataTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> startTimestamp = const Value.absent(),
            Value<int> endTimestamp = const Value.absent(),
            Value<double> avgX = const Value.absent(),
            Value<double> avgY = const Value.absent(),
            Value<double> avgZ = const Value.absent(),
            Value<double> minX = const Value.absent(),
            Value<double> maxX = const Value.absent(),
            Value<int> postureViolations = const Value.absent(),
          }) =>
              AggregatedDataTableCompanion(
            id: id,
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            avgX: avgX,
            avgY: avgY,
            avgZ: avgZ,
            minX: minX,
            maxX: maxX,
            postureViolations: postureViolations,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int startTimestamp,
            required int endTimestamp,
            required double avgX,
            required double avgY,
            required double avgZ,
            required double minX,
            required double maxX,
            required int postureViolations,
          }) =>
              AggregatedDataTableCompanion.insert(
            id: id,
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            avgX: avgX,
            avgY: avgY,
            avgZ: avgZ,
            minX: minX,
            maxX: maxX,
            postureViolations: postureViolations,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AggregatedDataTableTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $AggregatedDataTableTable,
    AggregatedDataTableData,
    $$AggregatedDataTableTableFilterComposer,
    $$AggregatedDataTableTableOrderingComposer,
    $$AggregatedDataTableTableAnnotationComposer,
    $$AggregatedDataTableTableCreateCompanionBuilder,
    $$AggregatedDataTableTableUpdateCompanionBuilder,
    (
      AggregatedDataTableData,
      BaseReferences<_$LocalDatabase, $AggregatedDataTableTable,
          AggregatedDataTableData>
    ),
    AggregatedDataTableData,
    PrefetchHooks Function()>;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$SensorDataTableTableTableManager get sensorDataTable =>
      $$SensorDataTableTableTableManager(_db, _db.sensorDataTable);
  $$AggregatedDataTableTableTableManager get aggregatedDataTable =>
      $$AggregatedDataTableTableTableManager(_db, _db.aggregatedDataTable);
}
