import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/features/sensors/data/models/sensor_data.dart';
import 'package:holdwise/features/sensors/data/models/orientation_data.dart';
import 'package:holdwise/features/sensors/data/services/sensors_service.dart';
part 'sensors_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final HoldWiseSensorService _sensorService;

  SensorCubit(this._sensorService) : super(const SensorState());

  void startMonitoring() {
    _sensorService.onSensorUpdate = (sensorData) {
      print("🔄 Sensor Data Updated: ${sensorData.last}");
      emit(state.copyWith(sensorData: sensorData));
    };

    _sensorService.onOrientationChange = (orientation) {
      print("🔄 Orientation Updated: ${orientation.tiltAngle}");
      emit(state.copyWith(orientation: orientation));
    };

    _sensorService.startSensorMonitoring();
  }

  void stopMonitoring() {
    _sensorService.stopSensorMonitoring();
  }

  void clearData() {
    _sensorService.clearSensorData();
    emit(const SensorState());
  }

  /// ✅ **New: Manually update sensor data from background service**
  void updateSensorData(SensorData newData) {
    final updatedSensorData = List<SensorData>.from(state.sensorData)
      ..add(newData);
    emit(state.copyWith(sensorData: updatedSensorData));
  }

  /// ✅ **New: Manually update orientation from background service**
  void updateOrientation(OrientationData newOrientation) {
    emit(state.copyWith(orientation: newOrientation));
  }

  /// Example: 5-second window aggregator for X, Y, and Z
  /// This can be triggered by a Timer that fires every 5 seconds.
  void aggregateAndStoreData() {
    final List<SensorData> dataWindow = state.sensorData;
    if (dataWindow.isEmpty) return;

    final avgX =
        dataWindow.map((e) => e.x).reduce((a, b) => a + b) / dataWindow.length;
    final avgY =
        dataWindow.map((e) => e.y).reduce((a, b) => a + b) / dataWindow.length;
    final avgZ =
        dataWindow.map((e) => e.z).reduce((a, b) => a + b) / dataWindow.length;

    // Optionally, store these in Firestore
    final summaryData = {
      "timestamp": DateTime.now().toIso8601String(),
      "avgX": avgX,
      "avgY": avgY,
      "avgZ": avgZ,
    };

    FirebaseFirestore.instance.collection("sensor_summaries").add(summaryData);

    // Clear data if desired, or keep rolling
    // _sensorService.clearSensorData();
  }

  void _batchUploadToFirebase() {
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (state.sensorData.isEmpty) return;

      final averageX =
          state.sensorData.map((e) => e.x).reduce((a, b) => a + b) /
              state.sensorData.length;
      final averageY =
          state.sensorData.map((e) => e.y).reduce((a, b) => a + b) /
              state.sensorData.length;
      final averageZ =
          state.sensorData.map((e) => e.z).reduce((a, b) => a + b) /
              state.sensorData.length;

      final summaryData = {
        "timestamp": DateTime.now().toIso8601String(),
        "average_x": averageX,
        "average_y": averageY,
        "average_z": averageZ,
      };

      await FirebaseFirestore.instance
          .collection("sensor_logs")
          .add(summaryData);
      print("✅ Firebase Uploaded: $summaryData");
    });
  }
}
