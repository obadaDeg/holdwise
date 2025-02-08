import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:holdwise/features/notifications/data/cubits/notification_cubit.dart';
import 'package:holdwise/features/notifications/data/models/notification_item.dart';

import '../models/sensor_data.dart';
import '../models/orientation_data.dart';
import '../services/sensors_service.dart';

part 'sensors_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final HoldWiseSensorService _sensorService;
  final NotificationsCubit notificationsCubit;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Timer? _batchUploadTimer; // to schedule Firestore writes
  Timer? _violationCheckTimer; // to check posture violations

  // You could store user preferences for threshold or aggregator intervals
  double _postureAngleThreshold = 70.0; // default

  SensorCubit(
    this._sensorService, {
    required this.notificationsCubit,
  }) : super(const SensorState()) {
    _initializeNotifications();

    // Start a repeating timer to batch data
    _batchUploadTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _aggregateAndStoreData(),
    );

    // Periodically check posture violations
    _violationCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkPostureViolations(),
    );
  }

  Future<void> _initializeNotifications() async {
    // Android-specific initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS-specific initialization (add more settings if needed)
    // const IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();

    // Combine initialization settings for both platforms.
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Called from UI to let user calibrate or adjust threshold
  void setPostureAngleThreshold(double newThreshold) {
    _postureAngleThreshold = newThreshold;
  }

  void startMonitoring() {
    _sensorService.startSensorMonitoring();
  }

  void stopMonitoring() {
    _sensorService.stopSensorMonitoring();
  }

  void clearData() {
    _sensorService.clearSensorData();
    emit(state.copyWith(sensorData: []));
  }

  /// Called by background service (see main.dart)
  void updateSensorData(SensorData newData) {
    final updatedList = List<SensorData>.from(state.sensorData)..add(newData);
    emit(state.copyWith(sensorData: updatedList));
  }

  /// Called by background service (see main.dart)
  void updateOrientation(OrientationData newOrientation) {
    final isViolation = newOrientation.tiltAngle > _postureAngleThreshold;
    final newViolationCount =
        isViolation ? state.postureViolations + 1 : state.postureViolations;

    final updatedLog = List<OrientationData>.from(state.orientationLog)
      ..add(newOrientation);

    emit(
      state.copyWith(
        orientation: updatedLog,
        currentOrientation: newOrientation,
        postureViolations: newViolationCount,
      ),
    );
  }

  /// 1) Gather the last 30s of data from [state.sensorData].
  /// 2) Compute aggregated stats (avg, min, max).
  /// 3) Upload to Firestore in a single batch or doc.
  Future<void> _aggregateAndStoreData() async {
    final dataWindow = List<SensorData>.from(state.sensorData);

    if (dataWindow.isEmpty) return;

    // Basic stats
    final avgX =
        dataWindow.map((e) => e.x).reduce((a, b) => a + b) / dataWindow.length;
    final avgY =
        dataWindow.map((e) => e.y).reduce((a, b) => a + b) / dataWindow.length;
    final avgZ =
        dataWindow.map((e) => e.z).reduce((a, b) => a + b) / dataWindow.length;

    final minX = dataWindow.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    final maxX = dataWindow.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    // Repeat for Y,Z or posture angles, etc.

    final postureViolations = state.postureViolations;

    final now = DateTime.now();
    final docId = "${now.millisecondsSinceEpoch}";

    // Example data structure
    final summaryData = {
      "timestamp": now.toIso8601String(),
      "avgX": avgX,
      "avgY": avgY,
      "avgZ": avgZ,
      "minX": minX,
      "maxX": maxX,
      "postureViolations": postureViolations,
      // Possibly store userId if multi-user
    };

    // Optionally check network status, skip upload if on cellular
    // (You can use connectivity_plus to check connectivity type)

    try {
      await FirebaseFirestore.instance
          .collection("user_posture_summaries")
          .doc(docId)
          .set(summaryData);

      print("✅ Batch summary uploaded: $summaryData");

      // Clear local buffer if desired
      // _sensorService.clearSensorData();
      // But typically you might only remove the chunk that was aggregated.
    } catch (e) {
      print("❌ Error uploading summary: $e");
    }
  }

  /// Check posture violation logic in certain intervals
  void _checkPostureViolations() {
    final orientationLog = state.orientationLog;
    if (orientationLog.isEmpty) return;

    final lastOrientation = orientationLog.last;
    final isViolation = (lastOrientation.tiltAngle) > _postureAngleThreshold;

    if (isViolation) {
      _sendPushNotification();
    }
  }

  Future<void> _sendPushNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'posture_violation_channel', // channel ID
      'Posture Violations', // channel name
      channelDescription: 'Notifications for posture violations',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // notification ID
      // 'Posture Alert: Your phone is not upright',
      '🚨 Posture Alert :',
      'Please adjust your phone Tilt Angle to avoid neck strain.\nYour posture seems off. Please adjust your position to avoid neck strain.',
      platformChannelSpecifics,
      payload: 'posture_violation',
    );

    // Now update the NotificationsCubit with this event.
    final newNotification = NotificationItem(
      title: 'Posture Alert',
      message: 'Your posture seems off. Please adjust your position.',
      dateTime: DateTime.now(),
    );
    notificationsCubit.addNotification(newNotification);
  }

  @override
  Future<void> close() {
    _batchUploadTimer?.cancel();
    _violationCheckTimer?.cancel();
    return super.close();
  }
}
