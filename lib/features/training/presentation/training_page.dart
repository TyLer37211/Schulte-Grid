import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_router.dart';
import '../application/training_controller.dart';
import '../domain/training_session.dart';
import 'training_result_page.dart';

class TrainingPage extends ConsumerStatefulWidget {
  const TrainingPage({super.key});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage>
    with SingleTickerProviderStateMixin {
  int _selectedGridSize = 3;
  bool _navigatedToResult = false;

  int? _lastCorrectValue;
  int? _lastWrongValue;
  bool _errorFlash = false;

  late final AnimationController _shakeController;
  late final ProviderSubscription<TrainingSessionState> _trainingSubscription;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _trainingSubscription = ref.listenManual<TrainingSessionState>(
      trainingControllerProvider,
      (TrainingSessionState? previous, TrainingSessionState next) {
        if (next.status == TrainingStatus.completed && !_navigatedToResult) {
          final TrainingResult? result = next.result;
          if (result != null && mounted) {
            _navigatedToResult = true;
            Navigator.pushReplacementNamed(
              context,
              AppRouter.trainingResult,
              arguments: TrainingResultArgs(result: result),
            );
          }
        }
      },
    );

    Future<void>.microtask(() {
      ref.read(trainingControllerProvider.notifier).startSession(_selectedGridSize);
    });
  }

  @override
  void dispose() {
    _trainingSubscription.close();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TrainingSessionState state = ref.watch(trainingControllerProvider);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              _buildGridSelector(),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('目标数字', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${state.currentTarget}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: AnimatedBuilder(
                  animation: _shakeController,
                  builder: (BuildContext context, Widget? child) {
                    final double dx = math.sin(_shakeController.value * math.pi * 6) * 8;
                    return Transform.translate(
                      offset: Offset(dx, 0),
                      child: child,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    decoration: BoxDecoration(
                      color: _errorFlash
                          ? colorScheme.errorContainer.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      itemCount: state.numbers.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: state.gridSize,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final int value = state.numbers[index];
                        final bool correct = _lastCorrectValue == value;
                        final bool wrong = _lastWrongValue == value;

                        return _GridCell(
                          value: value,
                          isCorrectFlash: correct,
                          isWrongFlash: wrong,
                          onTap: () => _onCellTap(value),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _BottomInfoCard(
                      label: '计时',
                      value: _formatDuration(state.elapsedMilliseconds),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BottomInfoCard(
                      label: '错误',
                      value: '${state.errorCount}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridSelector() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: <int>[3, 4, 5].map((int size) {
        return ChoiceChip(
          label: Text('${size}x$size'),
          selected: _selectedGridSize == size,
          onSelected: (bool selected) {
            if (!selected) {
              return;
            }
            setState(() {
              _selectedGridSize = size;
              _navigatedToResult = false;
              _lastCorrectValue = null;
              _lastWrongValue = null;
              _errorFlash = false;
            });
            ref.read(trainingControllerProvider.notifier).startSession(_selectedGridSize);
          },
        );
      }).toList(),
    );
  }

  void _onCellTap(int value) {
    final TrainingSessionState currentState = ref.read(trainingControllerProvider);
    final bool isCorrect = value == currentState.currentTarget;
    ref.read(trainingControllerProvider.notifier).onNumberTapped(value);

    if (isCorrect) {
      setState(() {
        _lastCorrectValue = value;
      });
      Future<void>.delayed(const Duration(milliseconds: 120), () {
        if (!mounted) {
          return;
        }
        setState(() {
          _lastCorrectValue = null;
        });
      });
      return;
    }

    setState(() {
      _lastWrongValue = value;
      _errorFlash = true;
    });
    _shakeController.forward(from: 0);

    Future<void>.delayed(const Duration(milliseconds: 180), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _lastWrongValue = null;
        _errorFlash = false;
      });
    });
  }

  String _formatDuration(int milliseconds) {
    final int seconds = milliseconds ~/ 1000;
    final int min = seconds ~/ 60;
    final int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({
    required this.value,
    required this.isCorrectFlash,
    required this.isWrongFlash,
    required this.onTap,
  });

  final int value;
  final bool isCorrectFlash;
  final bool isWrongFlash;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Color? background;
    if (isCorrectFlash) {
      background = colorScheme.primaryContainer;
    } else if (isWrongFlash) {
      background = colorScheme.errorContainer;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: FilledButton.tonal(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$value',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ),
    );
  }
}

class _BottomInfoCard extends StatelessWidget {
  const _BottomInfoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
