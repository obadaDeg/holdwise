import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:holdwise/features/sensors/data/services/sensors_service.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
    ),
  );
}

void onStart(ServiceInstance service) {
  final sensorService = HoldWiseSensorService();
  sensorService.startSensorMonitoring();

  // Listen to sensor updates and send them to the main app
  sensorService.onSensorUpdate = (sensorData) {
    if (sensorData.isNotEmpty) {
      print("📡 Sending Sensor Data to Main App: ${sensorData.last}");
      service.invoke("update", {"sensorData": sensorData.last.toMap()});
    }
  };

  sensorService.onOrientationChange = (orientation) {
    print("📡 Sending Orientation Data to Main App: ${orientation.tiltAngle}");
    service.invoke("update", {"orientation": orientation.toMap()});
  };

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (!(await service.isForegroundService())) {
        service.setAsForegroundService();
      }
    }

    service.invoke("update", {"message": "Sensors Running in Background"});
  });
}

