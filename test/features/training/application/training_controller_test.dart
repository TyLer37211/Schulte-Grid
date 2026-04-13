import 'package:flutter_test/flutter_test.dart';
import 'package:schulte_grid/features/training/application/training_controller.dart';
import 'package:schulte_grid/features/training/domain/training_record.dart';
import 'package:schulte_grid/features/training/domain/training_record_repository.dart';
import 'package:schulte_grid/features/training/domain/training_session.dart';

class _FakeTrainingRecordRepository implements TrainingRecordRepository {
  final List<TrainingRecord> saved = <TrainingRecord>[];

  @override
  Future<List<TrainingRecord>> fetchAllRecords() async {
    return saved;
  }

  @override
  Future<List<TrainingRecord>> fetchRecentRecords({int limit = 50}) async {
    return saved.take(limit).toList();
  }

  @override
  Future<void> saveRecord(TrainingRecord record) async {
    saved.add(record);
  }
}

void main() {
  group('TrainingController', () {
    late _FakeTrainingRecordRepository repository;

    setUp(() {
      repository = _FakeTrainingRecordRepository();
    });

    TrainingController buildController() {
      return TrainingController(repository: repository, onRecordSaved: () {});
    }

    test('startSession creates shuffled grid and resets progress', () {
      final TrainingController controller = buildController();

      controller.startSession(3);
      final TrainingSessionState state = controller.state;

      expect(state.gridSize, 3);
      expect(state.numbers.length, 9);
      expect(state.currentTarget, 1);
      expect(state.errorCount, 0);
      expect(state.status, TrainingStatus.inProgress);

      controller.dispose();
    });

    test('wrong tap increments errorCount', () {
      final TrainingController controller = buildController();
      controller.startSession(3);

      controller.onNumberTapped(99);

      expect(controller.state.errorCount, 1);
      expect(controller.state.currentTarget, 1);

      controller.dispose();
    });

    test('finishes when tapping all targets in order and saves result', () async {
      final TrainingController controller = buildController();
      controller.startSession(3);

      for (int i = 1; i <= 9; i++) {
        controller.onNumberTapped(i);
      }

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(controller.state.status, TrainingStatus.completed);
      expect(controller.state.result, isNotNull);
      expect(controller.state.result?.gridSize, 3);
      expect(repository.saved.length, 1);

      controller.dispose();
    });
  });
}
