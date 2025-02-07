import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'sensors_service.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // This callback is invoked when service starts
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'holdwise_posture_channel',
      // you can set other notification properties here
    ),
    iosConfiguration: IosConfiguration(
      // Only used on foreground fetch
      onForeground: onStart,
    ),
  );
}

void onStart(ServiceInstance service) {
  final sensorService = HoldWiseSensorService();
  sensorService.startSensorMonitoring();

  // Every time we get sensor data, broadcast the last entry
  sensorService.onSensorUpdate = (buffer) {
    if (buffer.isNotEmpty) {
      final latest = buffer.last;
      service.invoke("update", {
        "sensorData": latest.toMap(),
      });
    }
  };

  sensorService.onOrientationChange = (orientation) {
    service.invoke("update", {
      "orientation": {
        "tiltAngle": orientation.tiltAngle,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      }
    });
  };

  // Keep the service alive & broadcast status
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (service is AndroidServiceInstance) {
      // If no longer foreground, bring it back
      if (!(await service.isForegroundService())) {
        service.setAsForegroundService();
      }
    }
    service.invoke("update", {"message": "Background Service Active"});
  });
}
