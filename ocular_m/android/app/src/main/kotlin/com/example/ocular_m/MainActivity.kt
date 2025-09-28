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

                        // Physical RAM from /proc/meminfo
                        var totalRamGB = -1.0
                        try {
                            val reader = File("/proc/meminfo").bufferedReader()
                            val line = reader.readLine() // "MemTotal:       12190792 kB"
                            reader.close()
                            val parts = line.split("\\s+".toRegex())
                            val memKb = parts[1].toLong()
                            totalRamGB = memKb / (1024.0 * 1024.0) // in GB
                        } catch (_: Exception) { }

                        // CPU info from /proc/cpuinfo
                        // CPU Name
                        var cpuName = "Unknown"
                        try {
                            val reader = File("/proc/cpuinfo").bufferedReader()
                            reader.forEachLine { line ->
                                if (line.startsWith("Hardware") || line.startsWith("Processor") || line.startsWith("model name")) {
                                    cpuName = line.split(":")[1].trim()
                                    return@forEachLine
                                }
                            }
                            reader.close()
                        } catch (_: Exception) { }

                        if (cpuName == "Unknown") {
                            cpuName = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                                Build.SOC_MODEL ?: Build.HARDWARE
                            } else {
                                Build.HARDWARE
                            }
                        }


                        // CPU cores
                        val cpuCores = Runtime.getRuntime().availableProcessors()

                        // CPU max frequency
                        var cpuMaxFreqMHz = -1
                        try {
                            val reader = File("/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq").bufferedReader()
                            val line = reader.readLine()
                            reader.close()
                            cpuMaxFreqMHz = line.toInt() / 1000 // kHz -> MHz
                        } catch (_: Exception) { }

                        val deviceInfo = mapOf(
                            "os" to "Android",
                            "version" to Build.VERSION.RELEASE,
                            "sdkInt" to Build.VERSION.SDK_INT,
                            "brand" to Build.BRAND,
                            "manufacturer" to Build.MANUFACTURER,
                            "model" to Build.MODEL,
                            "deviceName" to deviceNameFromSettings,
                            "board" to Build.BOARD,
                            "hardware" to Build.HARDWARE,
                            "product" to Build.PRODUCT,
                            "cpuAbi" to Build.SUPPORTED_ABIS.joinToString(),
                            "totalRamGB" to String.format("%.2f", totalRamGB),
                            "cpuName" to cpuName,
                            "cpuCores" to cpuCores,
                            "cpuMaxFreqMHz" to cpuMaxFreqMHz
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
                            
                            val totalUsableRamGB = memoryInfo.totalMem / (1024.0 * 1024.0 * 1024.0) // in GB
                            val availRamGB = memoryInfo.availMem / (1024.0 * 1024.0 * 1024.0)  // in GB
                            val usedRamGB = totalUsableRamGB - availRamGB
                            val usagePercent = ((usedRamGB / totalUsableRamGB) * 100).toInt()

                            val ramInfo = mapOf(
                                "totalUsableRamGB" to totalUsableRamGB,
                                "usedRamGB" to usedRamGB,
                                "usagePercent" to usagePercent
                            )
                            result.success(ramInfo)
                        } catch (e: Exception) {
                            result.error("UNAVAILABLE", "Could not fetch RAM info", null)
                        }
                    }

                    
                    "getBatteryInfo" -> {
                        try {
                            val intent: Intent? = applicationContext.registerReceiver(
                                null, IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                            )

                            if (intent == null) {
                                result.error("UNAVAILABLE", "Battery info not available", null)
                                return@setMethodCallHandler
                            }

                            val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                            val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                            val batteryPct = if (level >= 0 && scale > 0) level * 100 / scale else -1

                            val status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
                            val isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                                             status == BatteryManager.BATTERY_STATUS_FULL

                            val health = intent.getIntExtra(BatteryManager.EXTRA_HEALTH, -1)
                            val healthString = when (health) {
                                BatteryManager.BATTERY_HEALTH_GOOD -> "Good"
                                BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheat"
                                BatteryManager.BATTERY_HEALTH_DEAD -> "Dead"
                                BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage"
                                BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "Unspecified Failure"
                                BatteryManager.BATTERY_HEALTH_COLD -> "Cold"
                                else -> "Unknown"
                            }

                            // Battery health percentage
                            val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
                            val capacity = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                            val healthPercent = if (capacity > 0) capacity else batteryPct

                            // Battery temperature
                            val temp = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)
                            val celsius = temp / 10.0

                            val batteryInfo = mapOf(
                                "levelPercent" to batteryPct,
                                "isCharging" to isCharging,
                                "status" to status,
                                "health" to healthString,
                                "healthPercent" to healthPercent,
                                "temperature" to celsius
                            )

                            result.success(batteryInfo)
                        } catch (e: Exception) {
                            result.error("UNAVAILABLE", "Could not fetch battery info", null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
