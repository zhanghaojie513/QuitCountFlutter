import 'package:flutter/material.dart';

import '../features/home/presentation/home_shell_page.dart';
import '../core/theme/app_theme.dart';

class QuitCountApp extends StatelessWidget {
  const QuitCountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '戒烟有数',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeShellPage(),
    );
  }
}
