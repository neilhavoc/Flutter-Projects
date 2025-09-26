import 'package:battery_plus/battery_plus.dart';
import '../models/battery_model.dart';

class BatteryService {
  final Battery _battery = Battery();

  Future<BatteryModel> getBatteryInfo() async {
    final level = await _battery.batteryLevel;
    final status = await _battery.batteryState;
    return BatteryModel(level: level, status: status.toString());
  }
  
}
