part of 'sensors_cubit.dart';

class SensorState extends Equatable {
  final List<SensorData> sensorData;
  final OrientationData? orientation;

  const SensorState({
    this.sensorData = const [],
    this.orientation,
  });

  SensorState copyWith({
    List<SensorData>? sensorData,
    OrientationData? orientation,
  }) {
    return SensorState(
      sensorData: sensorData ?? this.sensorData,
      orientation: orientation ?? this.orientation,
    );
  }

  @override
  List<Object?> get props => [sensorData, orientation];
}
