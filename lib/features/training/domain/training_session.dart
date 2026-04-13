enum TrainingStatus { idle, inProgress, completed }

class TrainingResult {
  const TrainingResult({
    required this.gridSize,
    required this.elapsedMilliseconds,
    required this.errorCount,
  });

  final int gridSize;
  final int elapsedMilliseconds;
  final int errorCount;
}

class TrainingSessionState {
  const TrainingSessionState({
    required this.gridSize,
    required this.numbers,
    required this.currentTarget,
    required this.errorCount,
    required this.elapsedMilliseconds,
    required this.status,
    this.result,
  });

  factory TrainingSessionState.initial() {
    return const TrainingSessionState(
      gridSize: 3,
      numbers: <int>[],
      currentTarget: 1,
      errorCount: 0,
      elapsedMilliseconds: 0,
      status: TrainingStatus.idle,
    );
  }

  final int gridSize;
  final List<int> numbers;
  final int currentTarget;
  final int errorCount;
  final int elapsedMilliseconds;
  final TrainingStatus status;
  final TrainingResult? result;

  int get maxNumber => gridSize * gridSize;

  TrainingSessionState copyWith({
    int? gridSize,
    List<int>? numbers,
    int? currentTarget,
    int? errorCount,
    int? elapsedMilliseconds,
    TrainingStatus? status,
    TrainingResult? result,
    bool clearResult = false,
  }) {
    return TrainingSessionState(
      gridSize: gridSize ?? this.gridSize,
      numbers: numbers ?? this.numbers,
      currentTarget: currentTarget ?? this.currentTarget,
      errorCount: errorCount ?? this.errorCount,
      elapsedMilliseconds: elapsedMilliseconds ?? this.elapsedMilliseconds,
      status: status ?? this.status,
      result: clearResult ? null : (result ?? this.result),
    );
  }
}
