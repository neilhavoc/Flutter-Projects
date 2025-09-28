class BatteryModel {
  int level;           // Battery percentage
  String status;       // Charging, Full, Discharging, etc.
  bool isCharging;     // true if charging
  String health;       // Good, Overheat, Dead, etc.
  int healthPercent;   // Battery health percentage
  double temperature;  // Battery temperature in °C

  BatteryModel({
    this.level = 0,
    this.status = '',
    this.isCharging = false,
    this.health = 'Unknown',
    this.healthPercent = 0,
    this.temperature = 0.0,
  });

  factory BatteryModel.fromMap(Map<dynamic, dynamic> map) {
    return BatteryModel(
      level: map['levelPercent'] ?? 0,
      status: map['status']?.toString() ?? '',
      isCharging: map['isCharging'] ?? false,
      health: map['health'] ?? 'Unknown',
      healthPercent: map['healthPercent'] ?? 0,
      temperature: map['temperature']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'levelPercent': level,
      'status': status,
      'isCharging': isCharging,
      'health': health,
      'healthPercent': healthPercent,
      'temperature': temperature,
    };
  }
}
