import 'package:get/get.dart';
import '../services/device_service.dart';
import 'dart:async';
import '../services/battery_service.dart';
import '../models/device_model.dart';
import '../models/battery_model.dart';

class DeviceViewModel extends GetxController {
  final DeviceService _deviceService = DeviceService();
  final BatteryService _batteryService = BatteryService();

  var device = Rx<DeviceModel>(
    DeviceModel(
      os: '',
      version: '',
      model: '',
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
    ),
  );

  var cpuInfo = Rx<CpuInfo>(CpuInfo());
  var battery = Rx<BatteryModel>(BatteryModel());
  var ramInfo = Rx<RamInfo>(RamInfo());

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchDeviceInfo();
    startRealtimeCpuMonitoring();
  }

  void fetchDeviceInfo() async {
    device.value = await _deviceService.getDeviceInfo();
  }

  void startRealtimeCpuMonitoring() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) async {
      final batteryTemp = await _deviceService.getBatteryTemperature() ?? 0;
      final cpuTemp = await _deviceService.getCpuTemperature() ?? 0;
      final cpuSpeed = await _deviceService.getCpuSpeed() ?? 0;
      battery.value = await _batteryService.getBatteryInfo();
      final ramInfoValue = await _deviceService.getRamInfo();
      // physicalRam = await _deviceService.getPhysicalRam();
      cpuInfo.update((val) {
        val?.batteryTemp = batteryTemp;
        val?.cpuTemp = cpuTemp;
        val?.cpuSpeed = cpuSpeed;
      });

      // final ramInfoValue = await _deviceService.getRamInfo();
      if (ramInfoValue != null) {
        ramInfo.update((val) {
          // val?.totalRamGB = (ramInfoValue['totalRamGB'] ?? 0).toDouble();
          val?.totalRamUsableGB = (ramInfoValue['totalRamUsableGB'] ?? 0).toDouble();
          val?.usedRamGB = (ramInfoValue['usedRamGB'] ?? 0).toDouble();
          val?.usagePercent = ramInfoValue['usagePercent'] ?? 0;
        });
      }
     

    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
