import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/device_data.dart';

/// Optional SQLite-based history log (separate from the Hive "last value"
/// store used by DatabaseService) for long-term reporting/analytics.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'frost_xtreme.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE device_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        water_temp REAL,
        ambient_temp REAL,
        humidity REAL,
        flow_rate REAL,
        compressor_on INTEGER,
        pump_on INTEGER,
        cooling_mode INTEGER,
        is_connected INTEGER,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE alarms(
        id TEXT PRIMARY KEY,
        type INTEGER,
        message TEXT,
        timestamp TEXT,
        is_active INTEGER
      )
    ''');
  }

  Future<void> insertData(DeviceData data) async {
    final db = await database;
    await db.insert(
      'device_data',
      {
        'water_temp': data.waterTemp,
        'ambient_temp': data.ambientTemp,
        'humidity': data.humidity,
        'flow_rate': data.flowRate,
        'compressor_on': data.compressorOn ? 1 : 0,
        'pump_on': data.pumpOn ? 1 : 0,
        'cooling_mode': data.coolingMode ? 1 : 0,
        'is_connected': data.isConnected ? 1 : 0,
        'timestamp': data.timestamp.toIso8601String(),
      },
    );
  }
}
