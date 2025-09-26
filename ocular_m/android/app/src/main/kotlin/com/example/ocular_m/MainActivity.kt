package com.example.ocular_m

import android.os.Build
import android.os.BatteryManager
import android.content.Intent
import android.content.IntentFilter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.device/info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getDeviceInfo" -> {
                        val deviceInfo = mapOf(
                            "os" to "Android",
                            "version" to Build.VERSION.RELEASE,
                            "model" to Build.MODEL
                        )
                        result.success(deviceInfo)
                    }
                    "getBatteryTemperature" -> {
                        val intent: Intent? = applicationContext.registerReceiver(
                            null, IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                        )
                        val temp = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
                        val celsius = temp / 10.0
                        result.success(celsius)
                    }
                    "getCpuTemperature" -> {
                        try {
                            val reader = File("/sys/class/thermal/thermal_zone0/temp").bufferedReader()
                            val line = reader.readLine()
                            reader.close()
                            val tempC = line.toFloat() / 1000.0
                            result.success(tempC)
                        } catch (e: Exception) {
                            result.error("UNAVAILABLE", "Could not fetch CPU temp", null)
                        }
                    }
                    "getCpuSpeed" -> {
                        try {
                            val reader = File("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq").bufferedReader()
                            val line = reader.readLine()
                            reader.close()
                            val mhz = line.toInt() / 1000
                            result.success(mhz)
                        } catch (e: Exception) {
                            result.error("UNAVAILABLE", "Could not fetch CPU speed", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
