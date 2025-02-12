// sensors_state.dart
part of 'sensors_cubit.dart';
class SensorState extends Equatable {
  /// A list of recent raw sensor data (may be used for immediate UI feedback).
  final List<SensorData> sensorData;
  /// Log of orientation events.
  final List<OrientationData> orientationLog;
  /// The last known orientation event.
  final OrientationData? currentOrientation;
  /// A running total of posture violations (could also be reset after aggregation).
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
