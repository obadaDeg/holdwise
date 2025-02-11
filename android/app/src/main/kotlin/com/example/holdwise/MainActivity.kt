package com.example.holdwise

import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val PHONE_USAGE_CHANNEL = "com.example.holdwise/usage"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PHONE_USAGE_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getCurrentApp") {
                    // Retrieve the current foreground app.
                    val currentApp = getCurrentForegroundApp(this)
                    if (currentApp != null) {
                        result.success(currentApp)
                    } else {
                        result.error("UNAVAILABLE", "No usage data available. Check permissions.", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    fun getCurrentForegroundApp(context: Context): String? {
        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        // Query for the last 10 seconds of usage data.
        val endTime = System.currentTimeMillis()
        val beginTime = endTime - 10_000  // 10 seconds window
        val usageStatsList: List<UsageStats> = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            beginTime,
            endTime
        )

        if (usageStatsList.isEmpty()) {
            // Likely the permission is not granted.
            return null
        }

        // Find the UsageStats with the most recent lastTimeUsed.
        var recentUsageStats: UsageStats? = null
        for (usageStats in usageStatsList) {
            if (recentUsageStats == null || usageStats.lastTimeUsed > recentUsageStats.lastTimeUsed) {
                recentUsageStats = usageStats
            }
        }
        return recentUsageStats?.packageName
    }
}
