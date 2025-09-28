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
          manufacturer: info['manufacturer'] ?? 'Unknown',
          board: info['board'] ?? 'Unknown',
          hardware: info['hardware'] ?? 'Unknown',
          product: info['product'] ?? 'Unknown',
          cpuAbi: info['cpuAbi'] ?? 'Unknown',
          totalRamGB: info['totalRamGB'] ?? 'Unknown',
          cpuName: info['cpuName'] ?? 'Unknown',
          cpuCores: info['cpuCores'] ?? 0,
          cpuMaxFreqMHz: info['cpuMaxFreqMHz'] ?? 0,
        );
      } on PlatformException catch (e) {
    return DeviceModel(
      os: 'Error',
      version: 'Error',
      model: e.message ?? '',
      brand: '',
      deviceName: '',
      manufacturer: '',
      board: '',
      hardware: '',
      product: '',
      cpuAbi: '',
      totalRamGB: '',
      cpuName: '',
      cpuCores: 0,
      cpuMaxFreqMHz: 0,
    );
  }

  //  final double totalCpu = 100.0;


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

  Future<int?> getPhysicalRam() async {
    return await platform.invokeMethod("getPhysicalRam");
  }


  Future<Map<String, dynamic>?> getRamInfo() async {
    final info = await platform.invokeMethod('getRamInfo');
    return Map<String, dynamic>.from(info);
  }

}
