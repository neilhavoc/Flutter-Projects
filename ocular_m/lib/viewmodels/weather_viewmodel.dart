// lib/viewmodels/weather_viewmodel.dart
import 'package:get/get.dart';
import '../models/weather.dart';

class WeatherViewModel extends GetxController {
  // Rx<Weather?> makes it reactive
  Rx<Weather?> weather = Rx<Weather?>(null);

  // Method to fetch weather
  void fetchWeather() async {
    await Future.delayed(const Duration(seconds: 1)); // Fake API call
    // /weather.value = Weather(26.5, "Sunny");
    weather.value = Weather(40006.5, "FUCKING HOT");
  }
}
