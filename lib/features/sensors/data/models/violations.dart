import 'package:holdwise/features/sensors/data/models/orientation_data.dart';

class Violations {
  final int postureViolations;
  List<OrientationData> orientationLog;
  final bool isGoodPosture;

  Violations({
    required this.postureViolations,
    required this.orientationLog,
    required this.isGoodPosture,
  });

  Violations copyWith({
    int? postureViolations,
    List<OrientationData>? orientationLog,
    bool? isGoodPosture,
  }) {
    return Violations(
      postureViolations: postureViolations ?? this.postureViolations,
      orientationLog: orientationLog ?? this.orientationLog,
      isGoodPosture: isGoodPosture ?? this.isGoodPosture,
    );
  }

  @override
  String toString() => 'Violations(postureViolations: $postureViolations, orientationLog: $orientationLog, isGoodPosture: $isGoodPosture)';
}