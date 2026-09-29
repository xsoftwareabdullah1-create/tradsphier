import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_navigation.dart';

class TradeSphereApp extends StatelessWidget {
  const TradeSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TradeSphere',
      theme: AppTheme.dark,
      home: const MainNavigation(),
    );
  }
}
