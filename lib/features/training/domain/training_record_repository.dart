import 'training_record.dart';

abstract class TrainingRecordRepository {
  Future<void> saveRecord(TrainingRecord record);

  Future<List<TrainingRecord>> fetchRecentRecords({int limit = 50});

  Future<List<TrainingRecord>> fetchAllRecords();
}
