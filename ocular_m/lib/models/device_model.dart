class DeviceModel {
  final String os;
  final String version;
  final String model;
  final String brand;
  final String deviceName;
  DeviceModel({
    required this.os, 
    required this.version, 
    required this.model,
    required this.brand,
    required this.deviceName,
    });
}

class CpuInfo {
  double batteryTemp;
  double cpuTemp;
  int cpuSpeed;

  CpuInfo({this.batteryTemp = 0, this.cpuTemp = 0, this.cpuSpeed = 0});
}
