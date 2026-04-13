import 'package:flutter/material.dart';

import 'router/app_router.dart';

class SchulteGridApp extends StatelessWidget {
  const SchulteGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schulte Grid',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
