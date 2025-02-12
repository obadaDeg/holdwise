class HourlySummary {
  final DateTime dateTime; 
  final double avgX;
  final double avgY;
  final double avgZ;
  final double maxX;
  final double minX;
  final int postureViolations;

  HourlySummary({
    required this.dateTime,
    required this.avgX,
    required this.avgY,
    required this.avgZ,
    required this.maxX,
    required this.minX,
    required this.postureViolations,
  });

  factory HourlySummary.fromJson(Map<String, dynamic> json) {
    return HourlySummary(
      dateTime: DateTime.parse(json['timestamp']), 
      avgX: json['avgX']?.toDouble() ?? 0.0,
      avgY: json['avgY']?.toDouble() ?? 0.0,
      avgZ: json['avgZ']?.toDouble() ?? 0.0,
      maxX: json['maxX']?.toDouble() ?? 0.0,
      minX: json['minX']?.toDouble() ?? 0.0,
      postureViolations: json['postureViolations'] ?? 0,
    );
  }
}
