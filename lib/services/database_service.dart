import 'package:hive_flutter/hive_flutter.dart';
import '../models/device_data.dart';
import '../models/alarm.dart';
import '../utils/constants.dart';

/// Persists device readings and alarms locally with Hive.
/// (Reconstructed to match the boxes/constants used elsewhere in the app —
/// this file was referenced by DeviceProvider but not included in the
/// original export.)
class DatabaseService {
  Future<Box<DeviceData>> get _dataBox async {
    if (!Hive.isBoxOpen(AppConstants.hiveDeviceDataBox)) {
      return Hive.openBox<DeviceData>(AppConstants.hiveDeviceDataBox);
    }
    return Hive.box<DeviceData>(AppConstants.hiveDeviceDataBox);
  }

  Future<Box> get _alarmBox async {
    const boxName = 'alarms';
    if (!Hive.isBoxOpen(boxName)) {
      return Hive.openBox(boxName);
    }
    return Hive.box(boxName);
  }

  Future<void> saveData(DeviceData data) async {
    final box = await _dataBox;
    await box.put('last', data);
  }

  Future<DeviceData?> getLastData() async {
    final box = await _dataBox;
    return box.get('last');
  }

  Future<void> saveAlarm(Alarm alarm) async {
    final box = await _alarmBox;
    await box.put(alarm.id, alarm.toJson());
  }

  Future<void> updateAlarm(Alarm alarm) async {
    final box = await _alarmBox;
    await box.put(alarm.id, alarm.toJson());
  }

  Future<List<Alarm>> getActiveAlarms() async {
    final box = await _alarmBox;
    return box.values
        .map((json) => Alarm.fromJson(Map<String, dynamic>.from(json)))
        .where((alarm) => alarm.isActive)
        .toList();
  }

  Future<List<Alarm>> getAllAlarms() async {
    final box = await _alarmBox;
    return box.values
        .map((json) => Alarm.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}
