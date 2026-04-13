import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/training_record.dart';
import '../domain/training_record_repository.dart';
import '../domain/training_session.dart';
import 'training_record_providers.dart';

final trainingControllerProvider =
    StateNotifierProvider<TrainingController, TrainingSessionState>(
  (StateNotifierProviderRef<TrainingController, TrainingSessionState> ref) {
    final TrainingRecordRepository repository =
        ref.watch(trainingRecordRepositoryProvider);
    final TrainingController controller = TrainingController(
      repository: repository,
      onRecordSaved: () {
        ref.invalidate(historyRecordsProvider);
        ref.invalidate(trainingStatsProvider);
      },
    );
    ref.onDispose(controller.dispose);
    return controller;
  },
);

class TrainingController extends StateNotifier<TrainingSessionState> {
  TrainingController({
    required TrainingRecordRepository repository,
    required void Function() onRecordSaved,
  })  : _repository = repository,
        _onRecordSaved = onRecordSaved,
        super(TrainingSessionState.initial());

  final TrainingRecordRepository _repository;
  final void Function() _onRecordSaved;

  Timer? _ticker;
  DateTime? _startAt;

  void startSession(int gridSize) {
    _ticker?.cancel();

    final int total = gridSize * gridSize;
    final List<int> shuffled = List<int>.generate(total, (int i) => i + 1)
      ..shuffle(Random());

    state = TrainingSessionState(
      gridSize: gridSize,
      numbers: shuffled,
      currentTarget: 1,
      errorCount: 0,
      elapsedMilliseconds: 0,
      status: TrainingStatus.inProgress,
    );

    _startAt = DateTime.now();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final DateTime? started = _startAt;
      if (started == null || state.status != TrainingStatus.inProgress) {
        return;
      }
      final int elapsed = DateTime.now().difference(started).inMilliseconds;
      state = state.copyWith(elapsedMilliseconds: elapsed);
    });
  }

  void onNumberTapped(int value) {
    if (state.status != TrainingStatus.inProgress) {
      return;
    }

    if (value != state.currentTarget) {
      state = state.copyWith(errorCount: state.errorCount + 1);
      return;
    }

    if (state.currentTarget == state.maxNumber) {
      _ticker?.cancel();
      final int elapsed = _startAt == null
          ? state.elapsedMilliseconds
          : DateTime.now().difference(_startAt!).inMilliseconds;
      final TrainingResult result = TrainingResult(
        gridSize: state.gridSize,
        elapsedMilliseconds: elapsed,
        errorCount: state.errorCount,
      );
      state = state.copyWith(
        elapsedMilliseconds: elapsed,
        status: TrainingStatus.completed,
        result: result,
      );

      unawaited(_saveRecord(result));
      return;
    }

    state = state.copyWith(currentTarget: state.currentTarget + 1);
  }

  Future<void> _saveRecord(TrainingResult result) async {
    try {
      await _repository.saveRecord(
        TrainingRecord(
          gridSize: result.gridSize,
          elapsedMilliseconds: result.elapsedMilliseconds,
          errorCount: result.errorCount,
          createdAt: DateTime.now(),
        ),
      );
      _onRecordSaved();
    } catch (_) {
      // Ignore save errors in MVP to avoid interrupting result flow.
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
