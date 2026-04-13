class TrainingRecord {
  const TrainingRecord({
    this.id,
    required this.gridSize,
    required this.elapsedMilliseconds,
    required this.errorCount,
    required this.createdAt,
  });

  final int? id;
  final int gridSize;
  final int elapsedMilliseconds;
  final int errorCount;
  final DateTime createdAt;
}
