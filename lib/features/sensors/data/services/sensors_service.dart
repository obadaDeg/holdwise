import 'dart:async';
import 'dart:math' as math;
import 'package:holdwise/features/sensors/data/models/orientation_data.dart';
import 'package:holdwise/features/sensors/data/models/sensor_data.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:ambient_light/ambient_light.dart';

class HoldWiseSensorService {
  // Subscriptions
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<AccelerometerEvent>?   _orientationSubscription;
  StreamSubscription<AmbientLight>? _lightSubscription;



  // Callbacks for new sensor data & orientation
  Function(List<SensorData> sensorData)? onSensorUpdate;
  Function(OrientationData orientation)? onOrientationChange;

  // In-memory sensor buffer
  final List<SensorData> _sensorDataBuffer = [];

  // Throttle intervals (ms)
  static const int _gyroThrottleMs = 200;
  static const int _accelThrottleMs = 200;
  static const int _lightThrottleMs = 200;

  // For throttling
  int _lastGyroTimestamp = 0;
  int _lastAccelTimestamp = 0;

  // We keep last known data to filter out minor changes
  SensorData? _lastGyroData;
  SensorData? _lastAccelData;
  static const double _changeThreshold = 0.4;

  void startSensorMonitoring() {
    // 1) Gyroscope
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastGyroTimestamp < _gyroThrottleMs) return;

      final data = SensorData(
        type: 'gyroscope',
        timestamp: now,
        x: event.x,
        y: event.y,
        z: event.z,
      );

      if (!_isSignificantChange(data, _lastGyroData)) return;

      _sensorDataBuffer.add(data);
      _lastGyroData = data;
      _lastGyroTimestamp = now;
      onSensorUpdate?.call(_sensorDataBuffer);
    });

    // 2) Accelerometer
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - _lastAccelTimestamp < _accelThrottleMs) return;

      final data = SensorData(
        type: 'accelerometer',
        timestamp: now,
        x: event.x,
        y: event.y,
        z: event.z,
      );

      if (!_isSignificantChange(data, _lastAccelData)) return;

      _sensorDataBuffer.add(data);
      _lastAccelData = data;
      _lastAccelTimestamp = now;
      onSensorUpdate?.call(_sensorDataBuffer);
    });

    // 3) Orientation stream (re-using accelerometer)
    _orientationSubscription = accelerometerEventStream().listen((event) {
      final double angle = _calculateTiltAngle(event.x, event.y, event.z);
      onOrientationChange?.call(OrientationData(
        tiltAngle: angle,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    });
  }

  void stopSensorMonitoring() {
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _orientationSubscription?.cancel();
  }

  void clearSensorData() {
    _sensorDataBuffer.clear();
  }

  /// Return current buffer snapshot
  List<SensorData> getSensorData() => List.of(_sensorDataBuffer);

  /// Basic check for ignoring small changes
  bool _isSignificantChange(SensorData newData, SensorData? lastData) {
    if (lastData == null) return true;
    return (newData.x - lastData.x).abs() > _changeThreshold ||
        (newData.y - lastData.y).abs() > _changeThreshold ||
        (newData.z - lastData.z).abs() > _changeThreshold;
  }

  /// Compute tilt angle in degrees
  double _calculateTiltAngle(double x, double y, double z) {
    final double norm = math.sqrt(x * x + y * y + z * z);
    if (norm == 0) return 0;
    final double angleRadians = math.acos(z / norm);
    return angleRadians * (180 / math.pi);
  }
}
