package com.example.flutter_hotelapp
import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    private var serviceIntent: Intent? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))

        serviceIntent = Intent(this@MainActivity, MyService::class.java)

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, "com.example.flutter_hotelapp")
                .setMethodCallHandler { methodCall, result ->
                    if (methodCall.method.equals("startService")) {
                        startService()
                        result.success("背景服務已啓動")
                    }

                    if (methodCall.method.equals("stopService")) {
                        stopService()
                        result.success("背景服務已停止")
                    }
                }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopService(serviceIntent)
    }

    private fun startService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }

    private fun stopService() {
        stopService(serviceIntent)
    }
}