library holdwise_sensors;

import 'dart:async';
import 'dart:math' as math;
import 'package:holdwise/features/sensors/data/models/orientation_data.dart';
import 'package:holdwise/features/sensors/data/models/sensor_data.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HoldWiseSensorService {
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<AccelerometerEvent>? _orientationSubscription;

  final List<SensorData> _sensorData = [];
  Function(OrientationData angle)? onOrientationChange;
  Function(List<SensorData> sensorData)? onSensorUpdate;

  /// **Throttle Time (Milliseconds)** to reduce data collection overhead
  static const int _throttleInterval = 100; // Adjust as needed

  int _lastGyroTimestamp = 0;
  int _lastAccelTimestamp = 0;
  SensorData? _lastGyroData;
  SensorData? _lastAccelData;
  final int _bufferSize = 10; // For a small rolling average
  final List<SensorData> _recentData = [];

  /// Starts sensor monitoring with optimized data collection.
  void startSensorMonitoring() {
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      if (currentTimestamp - _lastGyroTimestamp < _throttleInterval) return;

      final data = SensorData(
        type: 'gyroscope',
        timestamp: currentTimestamp,
        x: event.x,
        y: event.y,
        z: event.z,
      );

      if (!_isSignificantChange(data, _lastGyroData)) return;

      _sensorData.add(data);
      _lastGyroData = data;
      _lastGyroTimestamp = currentTimestamp;

      onSensorUpdate?.call(_sensorData);
    });

    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      if (currentTimestamp - _lastAccelTimestamp < _throttleInterval) return;

      final data = SensorData(
        type: 'accelerometer',
        timestamp: currentTimestamp,
        x: event.x,
        y: event.y,
        z: event.z,
      );

      if (!_isSignificantChange(data, _lastAccelData))
        return; // Ignore small changes

      _sensorData.add(data);
      _lastAccelData = data;
      _lastAccelTimestamp = currentTimestamp;

      onSensorUpdate?.call(_sensorData);
    });

    _orientationSubscription = accelerometerEventStream().listen((event) {
      final double angle = _calculateTiltAngle(event.x, event.y, event.z);
      onOrientationChange?.call(OrientationData(angle));
    });
  }

  /// **Stops monitoring** sensor data
  void stopSensorMonitoring() {
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _orientationSubscription?.cancel();
  }

  /// **Reduces noise** by filtering out minor variations
  bool _isSignificantChange(SensorData newData, SensorData? lastData,
      {double threshold = 0.1}) {
    if (lastData == null) return true;
    return (newData.x - lastData.x).abs() > threshold ||
        (newData.y - lastData.y).abs() > threshold ||
        (newData.z - lastData.z).abs() > threshold;
  }

  /// **Clears recorded sensor data**
  void clearSensorData() {
    _sensorData.clear();
  }

  /// **Computes the tilt angle (in degrees) relative to the z‑axis**
  double _calculateTiltAngle(double x, double y, double z) {
    final double norm = math.sqrt(x * x + y * y + z * z);
    if (norm == 0) return 0;

    final double angleRadians = math.acos(z / norm);
    // print('Angle: ${angleRadians * (180 / math.pi)}');
    return angleRadians * (180 / math.pi);
  }

  void onNewAccelerometerData(SensorData data) {
    // Add to buffer
    _recentData.add(data);
    if (_recentData.length > _bufferSize) {
      _recentData.removeAt(0);
    }

    // Compute rolling average
    final double avgX = _recentData.map((e) => e.x).reduce((a, b) => a + b) /
        _recentData.length;
    final double avgY = _recentData.map((e) => e.y).reduce((a, b) => a + b) /
        _recentData.length;
    final double avgZ = _recentData.map((e) => e.z).reduce((a, b) => a + b) /
        _recentData.length;

    // Emit these smoother values
    // Or compute a tilt angle from these smoothed x,y,z
  }

  /// **Gets the latest recorded sensor data**
  List<SensorData> getSensorData() => List.from(_sensorData);
}
