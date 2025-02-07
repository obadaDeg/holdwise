class OrientationData {
  final double tiltAngle; // in degrees
  final int timestamp; // epoch ms

  OrientationData({
    required this.tiltAngle,
    required this.timestamp,
  });

  bool isCorrectAngle({double threshold = 70.0}) {
    return tiltAngle > threshold;
  }

  // Map<String, dynamic> toMap() => { 'tiltAngle': tiltAngle };
  Map<String, dynamic> toMap() => { 'tiltAngle': tiltAngle, 'timestamp': timestamp };

  factory OrientationData.fromMap(Map<String, dynamic> map) {
    return OrientationData(
      tiltAngle: map['tiltAngle'],
      timestamp: map['timestamp'],
    );
  }

  @override  
  String toString() => 'OrientationData(tiltAngle: $tiltAngle, timestamp: $timestamp)';
}
