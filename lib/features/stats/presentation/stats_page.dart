import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../training/application/training_record_providers.dart';
import '../../training/domain/training_stats_summary.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(trainingStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: statsAsync.when(
        data: (TrainingStatsSummary stats) {
          if (stats.totalSessions == 0) {
            return const Center(child: Text('暂无统计数据'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              _StatItem(label: '总训练次数', value: '${stats.totalSessions}'),
              _StatItem(
                label: '平均时长',
                value: _formatDuration(stats.averageElapsedMilliseconds),
              ),
              _StatItem(
                label: '平均错误数',
                value: stats.averageErrorCount.toStringAsFixed(2),
              ),
              const SizedBox(height: 12),
              Text('各网格最佳成绩', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...<int>[3, 4, 5].map((int gridSize) {
                final int? bestMs = stats.bestElapsedByGridSize[gridSize];
                final String value = bestMs == null ? '--' : _formatDuration(bestMs);
                return _StatItem(label: '${gridSize}x$gridSize', value: value);
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) =>
            Center(child: Text('读取失败: $error')),
      ),
    );
  }

  String _formatDuration(int milliseconds) {
    final int seconds = milliseconds ~/ 1000;
    final int min = seconds ~/ 60;
    final int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}
