import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schulte Grid')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.training),
            child: const Text('Start Training'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.history),
            child: const Text('History'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.stats),
            child: const Text('Stats'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRouter.settings),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
