import 'package:flutter/material.dart';
import '../utils/theme.dart';

enum AlarmType {
  flowError,
  waterSensorError,
  highTemperature,
  antiShortCycle,
  lowFlow,
  highHumidity,
  connectionLost,
  compressorOverload,
}

class Alarm {
  final String id;
  final AlarmType type;
  final String message;
  final DateTime timestamp;
  bool isActive;

  Alarm({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    this.isActive = true,
  });

  String get typeName {
    switch (type) {
      case AlarmType.flowError:
        return 'خطای جریان آب';
      case AlarmType.waterSensorError:
        return 'خطای سنسور آب';
      case AlarmType.highTemperature:
        return 'دمای بالا';
      case AlarmType.antiShortCycle:
        return 'محافظت از کمپرسور';
      case AlarmType.lowFlow:
        return 'جریان کم آب';
      case AlarmType.highHumidity:
        return 'رطوبت بالا';
      case AlarmType.connectionLost:
        return 'قطع ارتباط';
      case AlarmType.compressorOverload:
        return 'اضافه‌بار کمپرسور';
    }
  }

  Color get color {
    switch (type) {
      case AlarmType.flowError:
      case AlarmType.waterSensorError:
      case AlarmType.connectionLost:
        return AppTheme.dangerColor;
      case AlarmType.highTemperature:
      case AlarmType.compressorOverload:
        return AppTheme.dangerColor;
      case AlarmType.antiShortCycle:
        return AppTheme.warningColor;
      case AlarmType.lowFlow:
      case AlarmType.highHumidity:
        return AppTheme.warningColor;
    }
  }

  IconData get icon {
    switch (type) {
      case AlarmType.flowError:
        return Icons.water_damage;
      case AlarmType.waterSensorError:
        return Icons.sensor_occupied;
      case AlarmType.highTemperature:
        return Icons.thermostat;
      case AlarmType.antiShortCycle:
        return Icons.timer;
      case AlarmType.lowFlow:
        return Icons.speed;
      case AlarmType.highHumidity:
        return Icons.water;
      case AlarmType.connectionLost:
        return Icons.wifi_off;
      case AlarmType.compressorOverload:
        return Icons.power;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: AlarmType.values[json['type'] ?? 0],
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
    );
  }
}
