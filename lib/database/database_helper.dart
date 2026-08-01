import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
  DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath =
    await getDatabasesPath();

    final path = join(
      dbPath,
      'gaming_cafe.db',
    );

    final db = await openDatabase(
      onUpgrade: (db, oldVersion, newVersion) async {

        if (oldVersion < 9) {

          await db.execute(
            'ALTER TABLE sessions ADD COLUMN guestName TEXT NOT NULL DEFAULT ""',
          );

          await db.execute(
            'ALTER TABLE queue ADD COLUMN guestName TEXT NOT NULL DEFAULT ""',
          );
        }
      },
      path,
      version: 9,
      onCreate: _createDatabase,
          onOpen: (db) async {},
    );

    return db;
  }

  Future<void> _createDatabase(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE devices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        halfHourRate REAL NOT NULL,
        isActive INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
      
        deviceId INTEGER NOT NULL,
        deviceName TEXT NOT NULL,
        deviceType TEXT NOT NULL,
      
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
      
        durationMinutes INTEGER NOT NULL,
        amount REAL NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
      
        deviceId INTEGER NOT NULL,
        deviceName TEXT NOT NULL,
        deviceType TEXT NOT NULL,
        guestName TEXT NOT NULL,
      
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
      
        durationMinutes INTEGER NOT NULL,
        amount REAL NOT NULL,
      
        isPaused INTEGER NOT NULL DEFAULT 0,
        pausedAt TEXT,
      
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
     CREATE TABLE queue(  
       id INTEGER PRIMARY KEY AUTOINCREMENT,
        deviceId INTEGER NOT NULL,
        deviceName TEXT NOT NULL,
        deviceType TEXT NOT NULL,
        guestName TEXT NOT NULL,
        durationMinutes INTEGER NOT NULL,
        amount REAL NOT NULL,
        queuedAt TEXT NOT NULL
    )
    ''');

  }

  Future<void> resetDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
