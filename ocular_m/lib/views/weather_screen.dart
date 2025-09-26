// lib/views/weather_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/weather_viewmodel.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});

  // Initialize ViewModel
  final WeatherViewModel vm = Get.put(WeatherViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GetX MVVM Weather Appss"),
        centerTitle: false,
        ),
      body: Center(
        // Obx makes the widget reactive
        child: Obx(() {
          if (vm.weather.value == null) {
            return ElevatedButton(
              onPressed: vm.fetchWeather,
              child: const Text("Get Weather"),
            );
          } else {
            return Text(
              "Temp: ${vm.weather.value!.temperature}°C, ${vm.weather.value!.description}",
              style: const TextStyle(fontSize: 22),
            );
          }
        }),
    
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        
      },
      child: const Text("Clicked"),
    ),
      
    );
  }
}
