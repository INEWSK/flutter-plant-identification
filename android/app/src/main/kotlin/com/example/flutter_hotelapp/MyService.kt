package com.example.flutter_hotelapp

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class MyService : Service() {
    override fun onCreate() {
        super.onCreate()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val builder = NotificationCompat.Builder(this, "messages")
                    .setContentText("正在後台運行模型訓練")
                    .setContentTitle("Tree Doctor")
                    .setSmallIcon(R.drawable.launch_background)
            startForeground(101, builder.build())
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}