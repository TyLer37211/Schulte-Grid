import 'package:flutter/material.dart';

import '../../features/history/presentation/history_page.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/stats/presentation/stats_page.dart';
import '../../features/training/presentation/training_page.dart';
import '../../features/training/presentation/training_result_page.dart';

class AppRouter {
  static const String home = '/';
  static const String training = '/training';
  static const String trainingResult = '/training/result';
  static const String history = '/history';
  static const String stats = '/stats';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(builder: (_) => const HomePage());
      case training:
        return MaterialPageRoute<void>(builder: (_) => const TrainingPage());
      case trainingResult:
        return MaterialPageRoute<void>(
          builder: (_) => const TrainingResultPage(),
        );
      case history:
        return MaterialPageRoute<void>(builder: (_) => const HistoryPage());
      case stats:
        return MaterialPageRoute<void>(builder: (_) => const StatsPage());
      case settings:
        return MaterialPageRoute<void>(builder: (_) => const SettingsPage());
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
