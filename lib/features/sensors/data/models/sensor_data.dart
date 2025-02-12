class SensorData {
  final String type;       // 'accelerometer' or 'gyroscope'
  final int timestamp;     // epoch ms
  final double x;
  final double y;
  final double z;

  SensorData({
    required this.type,
    required this.timestamp,
    required this.x,
    required this.y,
    required this.z,
  });

  factory SensorData.fromMap(Map<String, dynamic> map) {
    return SensorData(
      type: map['type'],
      timestamp: map['timestamp'] as int,
      x: map['x'] as double,
      y: map['y'] as double,
      z: map['z'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'timestamp': timestamp,
      'x': x,
      'y': y,
      'z': z,
    };
  }

  @override
  String toString() {
    return 'SensorData(type: $type, ts: $timestamp, x: $x, y: $y, z: $z)';
  }
}
