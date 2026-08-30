import 'package:hive/hive.dart';
import '../models/device_data.dart';

/// Manual Hive adapter for DeviceData.
/// Note: `device_data.dart` also declares `part 'device_data.g.dart'` with
/// @HiveType/@HiveField annotations, intended for the generated adapter via
/// `flutter pub run build_runner build`. Use EITHER the generated adapter
/// OR this manual one (registering both under typeId 0 will conflict) —
/// see README.md for the recommended (generated) path.
class DeviceDataAdapter extends TypeAdapter<DeviceData> {
  @override
  final int typeId = 0;

  @override
  DeviceData read(BinaryReader reader) {
    return DeviceData(
      waterTemp: reader.readDouble(),
      ambientTemp: reader.readDouble(),
      humidity: reader.readDouble(),
      flowRate: reader.readDouble(),
      compressorOn: reader.readBool(),
      pumpOn: reader.readBool(),
      coolingMode: reader.readBool(),
      isConnected: reader.readBool(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, DeviceData obj) {
    writer.writeDouble(obj.waterTemp);
    writer.writeDouble(obj.ambientTemp);
    writer.writeDouble(obj.humidity);
    writer.writeDouble(obj.flowRate);
    writer.writeBool(obj.compressorOn);
    writer.writeBool(obj.pumpOn);
    writer.writeBool(obj.coolingMode);
    writer.writeBool(obj.isConnected);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
  }
}
