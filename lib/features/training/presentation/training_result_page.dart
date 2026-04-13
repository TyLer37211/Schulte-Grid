import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../domain/training_session.dart';

class TrainingResultArgs {
  const TrainingResultArgs({required this.result});

  final TrainingResult result;
}

class TrainingResultPage extends StatelessWidget {
  const TrainingResultPage({super.key, this.args});

  final TrainingResultArgs? args;

  @override
  Widget build(BuildContext context) {
    final Object? routeArguments = ModalRoute.of(context)?.settings.arguments;
    final TrainingResultArgs? routeArgs =
        args ?? (routeArguments is TrainingResultArgs ? routeArguments : null);
    final TrainingResult? result = routeArgs?.result;

    final String timeText =
        result == null ? '--:--' : _formatDuration(result.elapsedMilliseconds);
    final String errorText = result == null ? '--' : '${result.errorCount}';
    final String gridText = result == null ? '--' : '${result.gridSize}x${result.gridSize}';

    return Scaffold(
      appBar: AppBar(title: const Text('训练结果')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '完成时长',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              timeText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '错误次数: $errorText\n网格大小: $gridText',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '做得很好，继续挑战下一次！',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                AppRouter.training,
              ),
              child: const Text('再来一次'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRouter.home,
                (Route<dynamic> route) => false,
              ),
              child: const Text('返回首页'),
            ),
          ],
        ),
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
