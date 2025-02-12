// sensor_cubit.dart
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:holdwise/features/notifications/data/cubits/notification_cubit.dart';
import 'package:holdwise/features/notifications/data/models/notification_item.dart';
import 'package:holdwise/features/sensors/data/models/orientation_data.dart';
import 'package:holdwise/features/sensors/data/models/sensor_data.dart';
import 'package:holdwise/features/sensors/data/repositories/sensor_repository.dart';
import 'package:holdwise/features/sensors/data/services/sensors_service.dart';


part 'sensors_state.dart';

class SensorCubit extends Cubit<SensorState> {
  final HoldWiseSensorService _sensorService;
  final NotificationsCubit notificationsCubit;
  final SensorRepository sensorRepository;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Timers for periodic aggregation, posture-check, and cleanup.
  Timer? _aggregateTimer;
  Timer? _violationCheckTimer;
  Timer? _purgeTimer;

  // Configurable posture threshold (could be user-configurable).
  double _postureAngleThreshold = 70.0; // default

  // Define aggregation interval (e.g., 30 seconds)
  final Duration aggregationInterval = const Duration(seconds: 30);
  // Define purge interval (e.g., purge every hour)
  final Duration purgeInterval = const Duration(hours: 1);

  SensorCubit(
    this._sensorService, {
    required this.notificationsCubit,
    required this.sensorRepository,
  }) : super(const SensorState()) {
    _initializeNotifications();

    // Start periodic aggregation
    _aggregateTimer = Timer.periodic(aggregationInterval, (_) => _aggregateAndStoreData());

    // Start posture violation checking
    _violationCheckTimer = Timer.periodic(const Duration(seconds: 15), (_) => _checkPostureViolations());

    // Periodically purge data older than 1 day (or configurable).
    _purgeTimer = Timer.periodic(purgeInterval, (_) => sensorRepository.purgeOldData(daysOld: 1));
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Called from UI to let user adjust threshold.
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
    // Optionally clear in-memory state and/or local DB if needed.
    emit(state.copyWith(sensorData: []));
  }

  /// Called by background service when new sensor data arrives.
  /// Writes the raw data to the local SQLite DB.
  void updateSensorData(SensorData newData) async {
    await sensorRepository.insertSensorData(
      newData.type,
      newData.timestamp,
      newData.x,
      newData.y,
      newData.z,
    );

    // Optionally update in-memory state for immediate UI feedback.
    final updatedList = List<SensorData>.from(state.sensorData)..add(newData);
    emit(state.copyWith(sensorData: updatedList));
  }

  /// Orientation updates continue to update the in-memory state.
  void updateOrientation(OrientationData newOrientation) {
    final isViolation = newOrientation.tiltAngle > _postureAngleThreshold;
    final newViolationCount = isViolation ? state.postureViolations + 1 : state.postureViolations;
    final updatedLog = List<OrientationData>.from(state.orientationLog)..add(newOrientation);

    emit(state.copyWith(
      orientation: updatedLog,
      currentOrientation: newOrientation,
      postureViolations: newViolationCount,
    ));
  }

  /// Aggregates raw sensor data from the last aggregation window, stores a summary locally,
  /// purges the raw data up to that point, and then uploads the summary to Firebase.
  Future<void> _aggregateAndStoreData() async {
    final now = DateTime.now();
    final windowEnd = now.millisecondsSinceEpoch;
    final windowStart = now.subtract(aggregationInterval).millisecondsSinceEpoch;

    // Fetch raw sensor data between windowStart and windowEnd.
    final rawData = await sensorRepository.fetchSensorDataBetween(windowStart, windowEnd);
    if (rawData.isEmpty) return;

    // (Example) Aggregate data for accelerometer events.
    final accelerometerData = rawData.where((d) => d.type == 'accelerometer').toList();
    if (accelerometerData.isEmpty) return;

    final count = accelerometerData.length;
    final sumX = accelerometerData.fold(0.0, (prev, d) => prev + d.x);
    final sumY = accelerometerData.fold(0.0, (prev, d) => prev + d.y);
    final sumZ = accelerometerData.fold(0.0, (prev, d) => prev + d.z);
    final avgX = sumX / count;
    final avgY = sumY / count;
    final avgZ = sumZ / count;

    final minX = accelerometerData.map((d) => d.x).reduce((a, b) => a < b ? a : b);
    final maxX = accelerometerData.map((d) => d.x).reduce((a, b) => a > b ? a : b);

    // Use the current state to determine how many posture violations occurred.
    final postureViolations = state.postureViolations;

    // Store aggregated summary locally.
    await sensorRepository.insertAggregatedData(
      startTimestamp: windowStart,
      endTimestamp: windowEnd,
      avgX: avgX,
      avgY: avgY,
      avgZ: avgZ,
      minX: minX,
      maxX: maxX,
      postureViolations: postureViolations,
    );

    // Purge raw sensor data up to windowEnd to avoid re-aggregating.
    await sensorRepository.deleteSensorDataOlderThan(windowEnd);

    // Attempt to upload aggregated summaries to Firebase.
    await sensorRepository.uploadAggregatedDataToFirebase();
  }

  /// Checks the latest orientation to see if a posture violation occurred.
  void _checkPostureViolations() async {
    final orientationLog = state.orientationLog;
    if (orientationLog.isEmpty) return;
    final lastOrientation = orientationLog.last;
    final isViolation = lastOrientation.tiltAngle > _postureAngleThreshold;
    if (isViolation) {
      // Fetch current app usage info via a method channel.
      String? currentApp;
      try {
        currentApp = await MethodChannel("com.example.holdwise/usage")
            .invokeMethod("getCurrentApp");
      } on PlatformException catch (e) {
        print("Error fetching app usage: ${e.message}");
      }

      // Log the violation with app usage info.
      _logPostureViolation(lastOrientation, currentApp);
      // Optionally display a push notification.
      _sendPushNotification(currentApp);
    }
  }

  Future<void> _logPostureViolation(
      OrientationData orientation, String? appInUse) async {
    final now = DateTime.now();
    final violationData = {
      'timestamp': now.toIso8601String(),
      'tiltAngle': orientation.tiltAngle,
      'appInUse': appInUse ?? "Unknown",
    };

    try {
      await FirebaseFirestore.instance
          .collection("posture_violations")
          .add(violationData);
      print("Violation logged: $violationData");
    } catch (e) {
      print("Error logging violation: $e");
    }
  }

  Future<void> _sendPushNotification(String? currentApp) async {
    String notificationMessage = 'Please adjust your posture.';
    if (currentApp != null) {
      notificationMessage += '\nDetected while using: $currentApp';
    }
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'posture_violation_channel',
      'Posture Violations',
      channelDescription: 'Notifications for posture violations',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      '🚨 Posture Alert',
      notificationMessage,
      platformDetails,
      payload: 'posture_violation',
    );

    // Also update the NotificationsCubit if needed.
    final newNotification = NotificationItem(
      title: 'Posture Alert',
      message: notificationMessage,
      dateTime: DateTime.now(),
    );
    notificationsCubit.addNotification(newNotification);
  }

  @override
  Future<void> close() {
    _aggregateTimer?.cancel();
    _violationCheckTimer?.cancel();
    _purgeTimer?.cancel();
    return super.close();
  }
}
