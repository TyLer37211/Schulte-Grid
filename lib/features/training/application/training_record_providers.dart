import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/training_db.dart';
import '../data/training_record_repository_impl.dart';
import '../domain/training_record.dart';
import '../domain/training_record_repository.dart';
import '../domain/training_stats_summary.dart';

final trainingDbProvider = Provider<TrainingDb>((ProviderRef<TrainingDb> ref) {
  return TrainingDb();
});

final trainingRecordRepositoryProvider =
    Provider<TrainingRecordRepository>((ProviderRef<TrainingRecordRepository> ref) {
  final TrainingDb db = ref.watch(trainingDbProvider);
  return TrainingRecordRepositoryImpl(db);
});

final historyRecordsProvider =
    FutureProvider<List<TrainingRecord>>((FutureProviderRef<List<TrainingRecord>> ref) {
  final TrainingRecordRepository repository =
      ref.watch(trainingRecordRepositoryProvider);
  return repository.fetchRecentRecords(limit: 50);
});

final trainingStatsProvider =
    FutureProvider<TrainingStatsSummary>((FutureProviderRef<TrainingStatsSummary> ref) async {
  final TrainingRecordRepository repository =
      ref.watch(trainingRecordRepositoryProvider);
  final List<TrainingRecord> records = await repository.fetchAllRecords();

  if (records.isEmpty) {
    return const TrainingStatsSummary(
      totalSessions: 0,
      averageElapsedMilliseconds: 0,
      averageErrorCount: 0,
      bestElapsedByGridSize: <int, int>{},
    );
  }

  final int totalSessions = records.length;
  final int totalElapsed = records.fold(
    0,
    (int sum, TrainingRecord item) => sum + item.elapsedMilliseconds,
  );
  final int totalErrors = records.fold(
    0,
    (int sum, TrainingRecord item) => sum + item.errorCount,
  );

  final Map<int, int> bestByGrid = <int, int>{};
  for (final TrainingRecord record in records) {
    final int? currentBest = bestByGrid[record.gridSize];
    if (currentBest == null || record.elapsedMilliseconds < currentBest) {
      bestByGrid[record.gridSize] = record.elapsedMilliseconds;
    }
  }

  return TrainingStatsSummary(
    totalSessions: totalSessions,
    averageElapsedMilliseconds: totalElapsed ~/ totalSessions,
    averageErrorCount: totalErrors / totalSessions,
    bestElapsedByGridSize: bestByGrid,
  );
});
