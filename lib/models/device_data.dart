import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../utils/theme.dart';

part 'device_data.g.dart';

@HiveType(typeId: 0)
class DeviceData extends HiveObject {
  @HiveField(0)
  double waterTemp;

  @HiveField(1)
  double ambientTemp;

  @HiveField(2)
  double humidity;

  @HiveField(3)
  double flowRate;

  @HiveField(4)
  bool compressorOn;

  @HiveField(5)
  bool pumpOn;

  @HiveField(6)
  bool coolingMode;

  @HiveField(7)
  bool isConnected;

  @HiveField(8)
  DateTime timestamp;

  DeviceData({
    this.waterTemp = 12.3,
    this.ambientTemp = 26.4,
    this.humidity = 45.0,
    this.flowRate = 2.1,
    this.compressorOn = false,
    this.pumpOn = false,
    this.coolingMode = false,
    this.isConnected = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  DeviceData copyWith({
    double? waterTemp,
    double? ambientTemp,
    double? humidity,
    double? flowRate,
    bool? compressorOn,
    bool? pumpOn,
    bool? coolingMode,
    bool? isConnected,
    DateTime? timestamp,
  }) {
    return DeviceData(
      waterTemp: waterTemp ?? this.waterTemp,
      ambientTemp: ambientTemp ?? this.ambientTemp,
      humidity: humidity ?? this.humidity,
      flowRate: flowRate ?? this.flowRate,
      compressorOn: compressorOn ?? this.compressorOn,
      pumpOn: pumpOn ?? this.pumpOn,
      coolingMode: coolingMode ?? this.coolingMode,
      isConnected: isConnected ?? this.isConnected,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waterTemp': waterTemp,
      'ambientTemp': ambientTemp,
      'humidity': humidity,
      'flowRate': flowRate,
      'compressorOn': compressorOn,
      'pumpOn': pumpOn,
      'coolingMode': coolingMode,
      'isConnected': isConnected,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      waterTemp: json['waterTemp']?.toDouble() ?? 0.0,
      ambientTemp: json['ambientTemp']?.toDouble() ?? 0.0,
      humidity: json['humidity']?.toDouble() ?? 0.0,
      flowRate: json['flowRate']?.toDouble() ?? 0.0,
      compressorOn: json['compressorOn'] ?? false,
      pumpOn: json['pumpOn'] ?? false,
      coolingMode: json['coolingMode'] ?? false,
      isConnected: json['isConnected'] ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }
}

class DeviceDataHelper {
  static double calculateEfficiency(DeviceData data) {
    double efficiency = 0.0;
    if (data.waterTemp < 10) {
      efficiency += 40;
    } else if (data.waterTemp < 20) {
      efficiency += 25;
    } else {
      efficiency += 10;
    }

    if (data.ambientTemp > 35) {
      efficiency += 30;
    } else if (data.ambientTemp > 25) {
      efficiency += 20;
    } else {
      efficiency += 10;
    }

    if (data.humidity < 40) {
      efficiency += 20;
    } else if (data.humidity < 60) {
      efficiency += 10;
    }

    if (data.compressorOn && data.pumpOn && data.coolingMode) efficiency += 10;

    return efficiency.clamp(0, 100);
  }

  static String getStatusText(DeviceData data) {
    if (!data.isConnected) return 'قطع ارتباط';
    if (!data.compressorOn && !data.pumpOn) return 'خاموش';
    if (data.coolingMode && data.compressorOn) return 'خنک‌سازی فعال';
    if (!data.coolingMode) return 'فقط فن';
    return 'در حال کار';
  }

  static Color getStatusColor(DeviceData data) {
    if (!data.isConnected) return Colors.grey;
    if (!data.compressorOn && !data.pumpOn) return AppTheme.warningColor;
    if (data.coolingMode && data.compressorOn) return AppTheme.successColor;
    return AppTheme.primaryColor;
  }
}
