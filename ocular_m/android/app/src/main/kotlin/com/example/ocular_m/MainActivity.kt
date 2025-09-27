package com.example.ocular_m

import android.os.Build
import android.os.BatteryManager
import android.content.Intent
import android.content.IntentFilter
import android.provider.Settings
import android.bluetooth.BluetoothAdapter
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.opengl.GLES20
import android.app.ActivityManager
import android.content.Context

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.device/info"

    // Helper to read thermal sensor files
    private fun readThermalTemp(path: String): Float? {
        return try {
            val file = File(path)
            if (file.exists()) {
                val value = file.bufferedReader().readLine().toFloat()
                if (value > 1000) value / 1000 else value  // Convert millidegrees to degrees
            } else null
        } catch (e: Exception) { null }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "getDeviceInfo" -> {
                        val deviceNameFromSettings = Settings.Global.getString(contentResolver, "device_name")
                            ?: BluetoothAdapter.getDefaultAdapter()?.name
                            ?: Build.MODEL

                        val deviceInfo = mapOf(
                            "os" to "Android",
                            "version" to Build.VERSION.RELEASE,
                            "model" to Build.MODEL,
                            "brand" to Build.BRAND,
                            "deviceName" to deviceNameFromSettings
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

                    "getGpuInfo" -> {
                        try {
                            val renderer = GLES20.glGetString(GLES20.GL_RENDERER) ?: "Unknown"
                            val vendor = GLES20.glGetString(GLES20.GL_VENDOR) ?: "Unknown"
                            val version = GLES20.glGetString(GLES20.GL_VERSION) ?: "Unknown"

                            // Attempt to read GPU temperature from common thermal zones
                            val gpuTempPaths = listOf(
                                "/sys/class/thermal/thermal_zone10/temp",
                                "/sys/class/thermal/thermal_zone11/temp",
                                "/sys/class/thermal/thermal_zone12/temp"
                            )
                            var gpuTemp: Float? = null
                            for (path in gpuTempPaths) {
                                gpuTemp = readThermalTemp(path)
                                if (gpuTemp != null) break
                            }

                            val gpuUtilization = -1  // Most devices don’t expose GPU utilization

                            val gpuInfo = mapOf(
                                "renderer" to renderer,
                                "vendor" to vendor,
                                "version" to version,
                                "temperature" to (gpuTemp ?: -1),
                                "utilization" to gpuUtilization
                            )
                            result.success(gpuInfo)
                        } catch (e: Exception) {
                            result.error("UNAVAILABLE", "Could not fetch GPU info", null)
                        }
                    }

                    "getRamInfo" -> {
                        try {
                            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                            val memoryInfo = ActivityManager.MemoryInfo()
                            activityManager.getMemoryInfo(memoryInfo)

                            val totalRamGB = memoryInfo.totalMem / (1024.0 * 1024.0 * 1024.0) // in GB
                            val availRamGB = memoryInfo.availMem / (1024.0 * 1024.0 * 1024.0)  // in GB
                            val usedRamGB = totalRamGB - availRamGB
                            val usagePercent = ((usedRamGB / totalRamGB) * 100).toInt()

                            val ramInfo = mapOf(
                                "totalRamGB" to totalRamGB,
                                "usedRamGB" to usedRamGB,
                                "usagePercent" to usagePercent
                            )
                            result.success(ramInfo)
                        } catch (e: Exception) {
                            result.error("UNAVAILABLE", "Could not fetch RAM info", null)
                        }
                    }




                    else -> result.notImplemented()
                }
            }
    }
}
