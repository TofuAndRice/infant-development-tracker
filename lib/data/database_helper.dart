import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/activity.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _databaseName = 'baby_logger.db';
  static const int _databaseVersion = 2; 
  static const String activitiesTable = 'activities';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $activitiesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        date_time INTEGER NOT NULL,
        notes TEXT,
        feeding_type TEXT,
        diaper_type TEXT,
        diaper_size INTEGER,
        height_cm REAL,
        weight_kg REAL,
        sleep_start_time INTEGER,
        sleep_duration_minutes INTEGER
      )
    ''');
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $activitiesTable ADD COLUMN sleep_start_time INTEGER',
      );
    }
  } 


  Future<int> insertActivity(Activity activity) async {
    final db = await database;
    return db.insert(activitiesTable, activity.toMap());
  }

  Future<List<Activity>> getActivities() async {
    final db = await database;
    final maps = await db.query(
      activitiesTable,
      orderBy: 'date_time DESC', 
    );

    return maps.map(Activity.fromMap).toList();
  }

  Future<int> updateActivity(Activity activity) async {
    final db = await database;

    if (activity.id == null) {
      return 0;
    }

    return db.update(
      activitiesTable,
      activity.toMap(),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  Future<int> deleteActivity(int id) async {
    final db = await database;
    return db.delete(
      activitiesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
