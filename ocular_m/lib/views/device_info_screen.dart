import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/device_viewmodel.dart';

class DeviceInfoScreen extends StatelessWidget {
  final DeviceViewModel vm = Get.put(DeviceViewModel());

  DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DeviceViewModel vm = Get.put(DeviceViewModel());

    return Scaffold(
      appBar: AppBar(title: Text("Device & Battery Info")),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Device Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("OS: ${vm.device.value.os}"),
              Text("Version: ${vm.device.value.version}"),
              Text("Model: ${vm.device.value.model}"),
              SizedBox(height: 20),
              Text("CPU Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Speed: ${vm.cpuInfo.value..cpuSpeed} Mhz"),
              Text("Temperature: ${vm.cpuInfo.value.cpuTemp}°C"),
              SizedBox(height: 20),
              Text("Battery Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Level: ${vm.battery.value.level}%"),
              Text("Temperature: ${vm.battery.value.level}°C"),
              Text("Status: ${vm.battery.value.status}"),
            ],
          ),
        );
      }),
    );
  }
}
