import 'package:flutter/services.dart';

Future<void> getAppUsage() async {
  const platform = MethodChannel('com.example.holdwise/usage');
  try {
    final result = await platform.invokeMethod('getAppUsage');
    print(result);
  } on PlatformException catch (e) {
    print("Failed to get usage stats: ${e.message}");
  }
}
