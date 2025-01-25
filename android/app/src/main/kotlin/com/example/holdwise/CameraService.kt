package com.example.holdwise

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log

class CameraService : Service() {
    override fun onCreate() {
        super.onCreate()
        Log.d("CameraService", "Camera Service Created")
        // Start your camera functionality here
    }

    override fun onBind(intent: Intent?): IBinder? {
        // This service does not support binding
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Handle background camera service operations here
        Log.d("CameraService", "Camera Service Started")
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d("CameraService", "Camera Service Destroyed")
    }
}
