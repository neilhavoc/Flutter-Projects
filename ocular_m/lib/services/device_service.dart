import 'package:flutter/services.dart';
import '../models/device_model.dart';

class DeviceService {
  static const platform = MethodChannel('com.example.device/info');

  
  Future<DeviceModel> getDeviceInfo() async {
    try {
      final Map info = await platform.invokeMethod('getDeviceInfo');
      return DeviceModel(
        brand: info['brand'] ?? 'Unknown',
        deviceName: info['deviceName'] ?? 'Unknown',
        os: info['os'] ?? 'Unknown',
        version: info['version'] ?? 'Unknown',
        model: info['model'] ?? 'Unknown',
      );
    } on PlatformException catch (e) {
      return DeviceModel(os: 'Error', version: 'Error', model: e.message ?? '', brand: '', deviceName: '');
    }
  }

  Future<Map<String, String>?> getGpuInfo() async {
    final info = await platform.invokeMethod('getGpuInfo');
    return Map<String, String>.from(info);
  }


  Future<double?> getBatteryTemperature() async {
    return await platform.invokeMethod("getBatteryTemperature");
  }

  Future<double?> getCpuTemperature() async {
    return await platform.invokeMethod("getCpuTemperature");
  }

  Future<int?> getCpuSpeed() async {
    return await platform.invokeMethod("getCpuSpeed");
  }

  Future<Map<String, dynamic>?> getRamInfo() async {
    final info = await platform.invokeMethod('getRamInfo');
    return Map<String, dynamic>.from(info);
  }

}
