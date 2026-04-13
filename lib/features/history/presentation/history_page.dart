import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../training/application/training_record_providers.dart';
import '../../training/domain/training_record.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(historyRecordsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: recordsAsync.when(
        data: (List<TrainingRecord> records) {
          if (records.isEmpty) {
            return const Center(child: Text('暂无训练记录'));
          }

          return ListView.separated(
            itemCount: records.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (BuildContext context, int index) {
              final TrainingRecord item = records[index];
              return ListTile(
                title: Text('网格 ${item.gridSize}x${item.gridSize}'),
                subtitle: Text(
                  '用时 ${_formatDuration(item.elapsedMilliseconds)} · 错误 ${item.errorCount}',
                ),
                trailing: Text(_formatDate(item.createdAt)),
              );
            },
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

  String _formatDate(DateTime time) {
    final String y = time.year.toString();
    final String m = time.month.toString().padLeft(2, '0');
    final String d = time.day.toString().padLeft(2, '0');
    final String hh = time.hour.toString().padLeft(2, '0');
    final String mm = time.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}
