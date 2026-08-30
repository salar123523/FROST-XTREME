import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/device_data.dart';
import '../utils/constants.dart';

class BluetoothService {
  bool _isConnected = false;
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;

  Future<bool> connect() async {
    try {
      if (_isConnected) return true;

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 5),
      );

      final results = await FlutterBluePlus.scanResults.first;
      await FlutterBluePlus.stopScan();

      for (final result in results) {
        if (result.device.platformName.contains(
            AppConstants.bluetoothDeviceName)) {
          _device = result.device;
          await _device!.connect();

          final services = await _device!.discoverServices();
          for (final service in services) {
            if (service.uuid.str128.toLowerCase() ==
                AppConstants.bleServiceUUID) {
              for (final char in service.characteristics) {
                if (char.uuid.str128.toLowerCase() ==
                    AppConstants.bleCharUUID) {
                  _characteristic = char;
                  await _characteristic!.setNotifyValue(true);
                  _isConnected = true;
                  return true;
                }
              }
            }
          }
        }
      }
      return false;
    } catch (e) {
      debugPrint('Bluetooth connection error: $e');
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      await _device?.disconnect();
      _isConnected = false;
      _device = null;
      _characteristic = null;
    } catch (e) {
      debugPrint('Bluetooth disconnect error: $e');
    }
  }

  Future<DeviceData?> readDeviceData() async {
    try {
      if (!_isConnected || _characteristic == null) return null;

      final value = await _characteristic!.read();
      if (value.isNotEmpty) {
        final data = String.fromCharCodes(value);
        return _parseData(data);
      }
      return null;
    } catch (e) {
      debugPrint('Read error: $e');
      return null;
    }
  }

  Future<void> sendCommand(String command) async {
    try {
      if (!_isConnected || _characteristic == null) return;
      await _characteristic!.write(command.codeUnits);
    } catch (e) {
      debugPrint('Send command error: $e');
    }
  }

  DeviceData _parseData(String data) {
    final parts = data.split(',');
    return DeviceData(
      waterTemp: double.tryParse(parts[0]) ?? 0,
      ambientTemp: double.tryParse(parts[1]) ?? 0,
      humidity: double.tryParse(parts[2]) ?? 0,
      flowRate: double.tryParse(parts[3]) ?? 0,
      compressorOn: parts[4] == '1',
      pumpOn: parts[5] == '1',
      coolingMode: parts[6] == '1',
      isConnected: true,
    );
  }

  void dispose() {
    disconnect();
    FlutterBluePlus.stopScan();
  }
}
