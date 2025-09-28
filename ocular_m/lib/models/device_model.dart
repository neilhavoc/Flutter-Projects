class DeviceModel {
  final String os;
  final String version;
  final String model;
  final String brand;
  final String deviceName;
  final String manufacturer;
  final String board;
  final String hardware;
  final String product;
  final String cpuAbi;
  final String totalRamGB;
  final String cpuName;
  final int cpuCores;
  final int cpuMaxFreqMHz;

  DeviceModel({
    required this.os,
    required this.version,
    required this.model,
    required this.brand,
    required this.deviceName,
    required this.manufacturer,
    required this.board,
    required this.hardware,
    required this.product,
    required this.cpuAbi,
    required this.totalRamGB,
    required this.cpuName,
    required this.cpuCores,
    required this.cpuMaxFreqMHz,
  });
}



class CpuInfo {
  double batteryTemp;
  double cpuTemp;
  int cpuSpeed;

  CpuInfo({this.batteryTemp = 0, this.cpuTemp = 0, this.cpuSpeed = 0});
}


class RamInfo {
  // double totalRamGB;
  double totalRamUsableGB;
  double usedRamGB;
  int usagePercent;
  
  RamInfo({
    // this.totalRamGB = 0,
    this.totalRamUsableGB = 0,
    this.usedRamGB = 0,
    this.usagePercent = 0,
  });
}

