part of 'sensors_cubit.dart';

class SensorState extends Equatable {
  final List<SensorData> sensorData;     // Current in-memory data
  final List<OrientationData> orientationLog;    // Current orientation
  final OrientationData? currentOrientation;     // Last known orientation
  final int postureViolations;

  const SensorState({
    this.sensorData = const [],
    this.orientationLog = const [],
    this.currentOrientation,
    this.postureViolations = 0,
  });

  SensorState copyWith({
    List<SensorData>? sensorData,
    List<OrientationData>? orientation,
    OrientationData? currentOrientation,
    int? postureViolations,
  }) {
    return SensorState(
      sensorData: sensorData ?? this.sensorData,
      orientationLog: orientation ?? this.orientationLog,
      currentOrientation: currentOrientation,
      postureViolations: postureViolations ?? this.postureViolations,
    );
  }

  @override
  List<Object?> get props => [
        sensorData,
        orientationLog,
        postureViolations,
      ];
}
