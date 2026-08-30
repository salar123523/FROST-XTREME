import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  double _targetTemperature = 8.0;
  int _compressorDelay = 3;
  double _hysteresis = 2.0;
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;
  String _language = 'fa';
  String _themeMode = 'dark';

  SettingsProvider(this._prefs) {
    _loadSettings();
  }

  double get targetTemperature => _targetTemperature;
  int get compressorDelay => _compressorDelay;
  double get hysteresis => _hysteresis;
  bool get soundEnabled => _soundEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  String get themeMode => _themeMode;

  Future<void> _loadSettings() async {
    _targetTemperature = _prefs.getDouble('targetTemperature') ?? 8.0;
    _compressorDelay = _prefs.getInt('compressorDelay') ?? 3;
    _hysteresis = _prefs.getDouble('hysteresis') ?? 2.0;
    _soundEnabled = _prefs.getBool('soundEnabled') ?? true;
    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    _language = _prefs.getString('language') ?? 'fa';
    _themeMode = _prefs.getString('themeMode') ?? 'dark';
    notifyListeners();
  }

  Future<void> setTargetTemperature(double value) async {
    _targetTemperature = value;
    await _prefs.setDouble('targetTemperature', value);
    notifyListeners();
  }

  Future<void> setCompressorDelay(int value) async {
    _compressorDelay = value;
    await _prefs.setInt('compressorDelay', value);
    notifyListeners();
  }

  Future<void> setHysteresis(double value) async {
    _hysteresis = value;
    await _prefs.setDouble('hysteresis', value);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _prefs.setBool('soundEnabled', value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _prefs.setString('language', value);
    notifyListeners();
  }

  Future<void> setThemeMode(String value) async {
    _themeMode = value;
    await _prefs.setString('themeMode', value);
    notifyListeners();
  }

  Future<void> resetSettings() async {
    await _prefs.clear();
    await _loadSettings();
  }
}
