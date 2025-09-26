class DeviceModel {
  final String os;
  final String version;
  final String model;

  DeviceModel({required this.os, required this.version, required this.model});
}

class CpuInfo {
  double batteryTemp;
  double cpuTemp;
  int cpuSpeed;

  CpuInfo({this.batteryTemp = 0, this.cpuTemp = 0, this.cpuSpeed = 0});
}
