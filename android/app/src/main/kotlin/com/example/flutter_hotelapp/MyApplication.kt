package com.example.flutter_hotelapp

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.app.FlutterApplication


class MyApplication: FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        //Android 8.0 26
        //一種 Notification 對應一個 NotificationChannel
        //在 Application 註冊 channel 可以在 app 啟動時就完成註冊
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel("messages", "Messages", NotificationManager.IMPORTANCE_LOW)
            val manager: NotificationManager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }
}
