import 'package:flutter/services.dart';
import '../models/battery_model.dart';

class BatteryService {
  static const _channel = MethodChannel('com.example.device/info');

  Future<BatteryModel> getBatteryInfo() async {
    try {
      final Map<dynamic, dynamic> result =
          await _channel.invokeMethod('getBatteryInfo');
      return BatteryModel.fromMap(result);
    } on PlatformException catch (e) {
      print("Error fetching battery info: ${e.message}");
      return BatteryModel(); // return default empty
    }
  }

  Stream<BatteryModel> batteryInfoStream({Duration interval = const Duration(seconds: 1)}) async* {
    while (true) {
      yield await getBatteryInfo();
      await Future.delayed(interval);
    }
  }
}
