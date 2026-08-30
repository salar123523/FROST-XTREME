class AppConstants {
  static const String appName = 'FROST XTREME';
  static const String appVersion = '1.0.0';

  static const String hiveDeviceDataBox = 'deviceData';
  static const String hiveSettingsBox = 'settings';

  static const double minWaterTemp = 0.0;
  static const double maxWaterTemp = 30.0;
  static const double minAmbientTemp = 10.0;
  static const double maxAmbientTemp = 45.0;
  static const double minHumidity = 20.0;
  static const double maxHumidity = 80.0;
  static const double minFlowRate = 0.5;
  static const double maxFlowRate = 5.0;

  static const String bluetoothDeviceName = 'FROST_XTREME';
  static const String bleServiceUUID = '0000fff0-0000-1000-8000-00805f9b34fb';
  static const String bleCharUUID = '0000fff1-0000-1000-8000-00805f9b34fb';

  static const int autoRefreshInterval = 1000;
  static const int alarmCheckInterval = 3000;
  static const int reconnectAttempts = 5;
}
