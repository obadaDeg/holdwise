package com.example.holdwise
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val PHONE_USAGE_CHANNEL = "com.example.holdwise/usage"
    private val MEDIAPIPE_POSE_ESTIMATION_CHANNEL = "com.example.holdwise/pose_estimation"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PHONE_USAGE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAppUsage") {
                val usageStats = UsageStatesManager.getAppUsageStats(this)
                result.success(usageStats.toString()) // Convert to appropriate format
            } else {
                result.notImplemented()
            }
        }
    }
}
