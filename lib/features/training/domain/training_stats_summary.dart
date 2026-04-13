class TrainingStatsSummary {
  const TrainingStatsSummary({
    required this.totalSessions,
    required this.averageElapsedMilliseconds,
    required this.averageErrorCount,
    required this.bestElapsedByGridSize,
  });

  final int totalSessions;
  final int averageElapsedMilliseconds;
  final double averageErrorCount;
  final Map<int, int> bestElapsedByGridSize;
}
