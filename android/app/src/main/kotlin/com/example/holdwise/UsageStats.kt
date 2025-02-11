package com.example.holdwise

import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import java.util.Calendar

@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
fun getAppUsageStats(context: Context): List<UsageStats> {
    val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
    val calendar = Calendar.getInstance()
    calendar.add(Calendar.DAY_OF_YEAR, -1)  // Last 24 hours
    val stats = usageStatsManager.queryUsageStats(
        UsageStatsManager.INTERVAL_DAILY, 
        calendar.timeInMillis, 
        System.currentTimeMillis()
    )
    return stats
}
