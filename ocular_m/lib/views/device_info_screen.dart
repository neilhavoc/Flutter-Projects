import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/device_viewmodel.dart';

class DeviceInfoScreen extends StatelessWidget {
  final DeviceViewModel vm = Get.put(DeviceViewModel());

  DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final DeviceViewModel vm = Get.put(DeviceViewModel());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xAA222f3e),
        title: Text("Device & Battery Info",
        style: TextStyle(
            // color: Colors.white,
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
      )),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(  //Device Information
                width: double.infinity, // takes full width, you can set fixed too
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black26,
                  //     blurRadius: 6,
                  //     offset: Offset(-2, -4), // Shadow position
                  //   ),
                  // ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // left align texts
                children: [
                  Text(
                    "Device Info",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // spacing between title and details
                  Text("Brand: ${vm.device.value.brand}"),
                  Text("Device Name: ${vm.device.value.deviceName}"),
                  Text("OS: ${vm.device.value.os}"),
                  Text("Version: ${vm.device.value.version}"),
                  Text("Model: ${vm.device.value.model}"),
                ],
              ),
              ),
              
              SizedBox(height: 15),

              Container(  //CPU details container
              width: double.infinity, // takes full width, you can set fixed too
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black26,
                //     blurRadius: 6,
                //     offset: Offset(2, 4), // Shadow position
                //   ),
                // ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // left align texts
              children: [
                Text("CPU Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Speed: ${vm.cpuInfo.value.cpuSpeed} Mhz"),
                Text("Temperature: ${vm.cpuInfo.value.cpuTemp.toStringAsFixed(1)}°C"),
                  ],
                ),
              ),


              SizedBox(height: 15),

              Container(  //RAM details container
              width: double.infinity, // takes full width, you can set fixed too
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black26,
                //     blurRadius: 6,
                //     offset: Offset(2, 4), // Shadow position
                //   ),
                // ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // left align texts
              children: [
                Text("RAM Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Total RAM: ${vm.ramInfo.value.totalRamGB.toStringAsFixed(2)} GB"),
                Text("Current RAM Usage: ${vm.ramInfo.value.usedRamGB.toStringAsFixed(2)} GB"),
                Text("Usage Percent: ${vm.ramInfo.value.usagePercent} %"),
                  ],
                ),
              ),


              
              SizedBox(height: 15),

              Container(  //Battery details container
              width: double.infinity, // takes full width, you can set fixed too
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black26,
                //     blurRadius: 6,
                //     offset: Offset(4, 2), // Shadow position
                //   ),
                // ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // left align texts
              children: [
                Text("Battery Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8,),
                Text("Level: ${vm.battery.value.level}%"),
                Text("Temperature: ${vm.cpuInfo.value.batteryTemp.toStringAsFixed(1)}°C"),
                Text("Status: ${vm.battery.value.status}"),
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
