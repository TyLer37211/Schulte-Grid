import '../domain/training_record.dart';
import '../domain/training_record_repository.dart';
import 'local/training_db.dart';

class TrainingRecordRepositoryImpl implements TrainingRecordRepository {
  TrainingRecordRepositoryImpl(this._db);

  final TrainingDb _db;

  @override
  Future<void> saveRecord(TrainingRecord record) async {
    final db = await _db.database;
    await db.insert(
      TrainingDb.tableTrainingRecords,
      <String, Object?>{
        'grid_size': record.gridSize,
        'elapsed_ms': record.elapsedMilliseconds,
        'error_count': record.errorCount,
        'created_at': record.createdAt.toIso8601String(),
      },
    );
  }

  @override
  Future<List<TrainingRecord>> fetchRecentRecords({int limit = 50}) async {
    final db = await _db.database;
    final List<Map<String, Object?>> rows = await db.query(
      TrainingDb.tableTrainingRecords,
      orderBy: 'id DESC',
      limit: limit,
    );
    return rows.map(_mapToRecord).toList();
  }

  @override
  Future<List<TrainingRecord>> fetchAllRecords() async {
    final db = await _db.database;
    final List<Map<String, Object?>> rows = await db.query(
      TrainingDb.tableTrainingRecords,
      orderBy: 'id DESC',
    );
    return rows.map(_mapToRecord).toList();
  }

  TrainingRecord _mapToRecord(Map<String, Object?> row) {
    return TrainingRecord(
      id: row['id'] as int?,
      gridSize: row['grid_size'] as int,
      elapsedMilliseconds: row['elapsed_ms'] as int,
      errorCount: row['error_count'] as int,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }
}
