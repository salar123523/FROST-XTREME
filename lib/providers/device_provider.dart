import 'dart:async';
import 'package:flutter/material.dart';
import '../models/device_data.dart';
import '../models/alarm.dart';
import '../services/bluetooth_service.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class DeviceProvider extends ChangeNotifier {
  DeviceData _currentData = DeviceData();
  List<Alarm> _alarms = [];
  bool _isLoading = false;
  bool _isConnected = false;
  Timer? _refreshTimer;
  Timer? _alarmTimer;
  final BluetoothService _bluetoothService = BluetoothService();
  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();

  DeviceData get currentData => _currentData;
  List<Alarm> get alarms => _alarms.where((a) => a.isActive).toList();
  List<Alarm> get allAlarms => _alarms;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;

  DeviceProvider() {
    _init();
  }

  Future<void> _init() async {
    await _notificationService.init();
    await _loadData();
    _startAutoRefresh();
    _startAlarmCheck();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedData = await _databaseService.getLastData();
      if (savedData != null) {
        _currentData = savedData;
        _isConnected = savedData.isConnected;
      }
      _alarms = await _databaseService.getActiveAlarms();
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) async {
        await _refreshData();
      },
    );
  }

  Future<void> _refreshData() async {
    try {
      final newData = await _bluetoothService.readDeviceData();
      if (newData != null) {
        _currentData = newData;
        _isConnected = true;
        await _databaseService.saveData(_currentData);
        notifyListeners();
      } else {
        _isConnected = false;
        notifyListeners();
      }
    } catch (e) {
      _isConnected = false;
      notifyListeners();
    }
  }

  void _startAlarmCheck() {
    _alarmTimer?.cancel();
    _alarmTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        await _checkAlarms();
      },
    );
  }

  Future<void> _checkAlarms() async {
    final alarms = <Alarm>[];

    if (_currentData.flowRate < 0.5) {
      alarms.add(Alarm(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: AlarmType.flowError,
        message: 'جریان آب کمتر از حد مجاز است',
        timestamp: DateTime.now(),
      ));
    }

    if (_currentData.waterTemp > 25) {
      alarms.add(Alarm(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: AlarmType.highTemperature,
        message:
            'دمای آب از ${_currentData.waterTemp.toStringAsFixed(1)}°C رسیده است',
        timestamp: DateTime.now(),
      ));
    }

    if (_currentData.humidity > 70) {
      alarms.add(Alarm(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: AlarmType.highHumidity,
        message: 'رطوبت محیط بالا است',
        timestamp: DateTime.now(),
      ));
    }

    if (!_isConnected) {
      alarms.add(Alarm(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: AlarmType.connectionLost,
        message: 'ارتباط با دستگاه قطع شده است',
        timestamp: DateTime.now(),
      ));
    }

    for (final alarm in alarms) {
      if (!_alarms.any((a) => a.type == alarm.type && a.isActive)) {
        _alarms.add(alarm);
        await _databaseService.saveAlarm(alarm);
        await _notificationService.showNotification(
          alarm.typeName,
          alarm.message,
          alarm.type.index,
        );
      }
    }

    for (final alarm in _alarms) {
      if (alarm.isActive && !alarms.any((a) => a.type == alarm.type)) {
        alarm.isActive = false;
        await _databaseService.updateAlarm(alarm);
      }
    }

    notifyListeners();
  }

  Future<bool> connectDevice() async {
    _isLoading = true;
    notifyListeners();

    try {
      final connected = await _bluetoothService.connect();
      if (connected) {
        _isConnected = true;
        await _refreshData();
      }
      return connected;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> disconnectDevice() async {
    await _bluetoothService.disconnect();
    _isConnected = false;
    _currentData = _currentData.copyWith(isConnected: false);
    await _databaseService.saveData(_currentData);
    notifyListeners();
  }

  Future<void> setTargetTemperature(double temp) async {
    await _bluetoothService.sendCommand('SET_TEMP:$temp');
    _currentData = _currentData.copyWith();
    notifyListeners();
  }

  Future<void> toggleCompressor() async {
    await _bluetoothService.sendCommand('TOGGLE_COMPRESSOR');
    _currentData = _currentData.copyWith(
      compressorOn: !_currentData.compressorOn,
    );
    await _databaseService.saveData(_currentData);
    notifyListeners();
  }

  Future<void> togglePump() async {
    await _bluetoothService.sendCommand('TOGGLE_PUMP');
    _currentData = _currentData.copyWith(
      pumpOn: !_currentData.pumpOn,
    );
    await _databaseService.saveData(_currentData);
    notifyListeners();
  }

  Future<void> toggleCoolingMode() async {
    await _bluetoothService.sendCommand('TOGGLE_COOLING');
    _currentData = _currentData.copyWith(
      coolingMode: !_currentData.coolingMode,
    );
    await _databaseService.saveData(_currentData);
    notifyListeners();
  }

  Future<void> clearAlarms() async {
    for (final alarm in _alarms) {
      alarm.isActive = false;
      await _databaseService.updateAlarm(alarm);
    }
    _alarms = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _alarmTimer?.cancel();
    _bluetoothService.dispose();
    super.dispose();
  }
}
