import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:ocular_m/views/piechart_screen.dart';
import '../viewmodels/device_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/two_slice_piechart.dart';

// import 'piechart_screen.dart';
class DeviceInfoScreen extends StatelessWidget {
  final DeviceViewModel vm = Get.put(DeviceViewModel());

  DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xAA222f3e),
        title: Text(
          "Device & Battery Info",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Info + CPU Info side by side
              IntrinsicHeight(
                child: Row(
                children: [
                  // Device Info
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Row(
                            children: [
                              Icon(Icons.phone_android, size: 24, color: Colors.black),
                              SizedBox(width: 6), // spacing between icon and text
                              Text("Device Info",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),

                          SizedBox(height: 8),
                          Text("Brand: ${vm.device.value.brand}"),
                          Text("Device Name: ${vm.device.value.deviceName}"),
                          Text("OS: ${vm.device.value.os}"),
                          Text("Version: ${vm.device.value.version}"),
                          Text("Model: ${vm.device.value.model}"),
                          Text("Manufacturer: ${vm.device.value.manufacturer}"),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 15),

                  // CPU Info
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Icon(FontAwesomeIcons.microchip, size: 24, color: Colors.black),
                              SizedBox(width: 6), // spacing between icon and text
                              Text("CPU Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),

                          
                          SizedBox(height: 8),
                          Text("CPU Name: ${vm.device.value.cpuName}"),
                          Text("CPU Max Frequency: ${vm.device.value.cpuMaxFreqMHz} Mhz"),
                          Text("CPU Total Cores: ${vm.device.value.cpuCores}"),
                          Text("Current Speed: ${vm.cpuInfo.value.cpuSpeed} Mhz"),
                          Text("Temperature: ${vm.cpuInfo.value.cpuTemp.toStringAsFixed(1)}°C"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ),
              

              SizedBox(height: 15),

              // RAM Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.memory, size: 24, color: Colors.black),
                        SizedBox(width: 6), // spacing between icon and text
                        Text("RAM Info",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      ],
                      
                    ),
                    // Texts and Pie Chart side by side
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text Column
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total RAM: ${vm.device.value.totalRamGB} GB"),
                              Text("Current RAM Usage: ${vm.ramInfo.value.usedRamGB.toStringAsFixed(2)} GB"),
                              Text("Usage Percent: ${vm.ramInfo.value.usagePercent} %"),
                            ],
                          ),
                        ),
                        // Pie Chart
                        Expanded(
                          flex: 1,
                          child: TwoSlicePieChart(
                            mainLabel: "CPU Usage",
                            mainValue: (vm.ramInfo.value.usagePercent.toDouble()).obs,
                            totalValue: 100.0,
                            mainColor: Colors.blue,
                            secondaryColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              SizedBox(height: 15),

              // Battery Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                      Row(
                        children: [
                          Icon(FontAwesomeIcons.batteryFull, size: 24, color: Colors.black),
                          SizedBox(width: 6), // spacing between icon and text
                          Text(" Battery Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),

                    // Text("Battery Info",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Charge Level: ${vm.battery.value.level}%"),
                    Text("Temperature: ${vm.cpuInfo.value.batteryTemp.toStringAsFixed(1)}°C"),
                    // Text("Status: ${vm.battery.value.status}"),
                    Text("Charging: ${vm.battery.value.isCharging ? 'Yes' : 'No'}"),
                    Text("Heath Status: ${vm.battery.value.health}"),
                    // Text("Health Percentage: ${vm.battery.value.healthPercent}"),
                    // Text("Status: ${vm.battery.value.status}"),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
