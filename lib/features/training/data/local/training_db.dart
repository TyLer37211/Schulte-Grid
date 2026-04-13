import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class TrainingDb {
  static const String _dbName = 'schulte_grid.db';
  static const int _dbVersion = 1;

  static const String tableTrainingRecords = 'training_records';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String fullPath = path.join(dbPath, _dbName);

    return openDatabase(
      fullPath,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableTrainingRecords (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            grid_size INTEGER NOT NULL,
            elapsed_ms INTEGER NOT NULL,
            error_count INTEGER NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
