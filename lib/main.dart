import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/quiz_provider.dart';
import 'screens/home_screen.dart';
import 'theme/limbus_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => QuizProvider(),
      child: const LimbusQuizApp(),
    ),
  );
}

class LimbusQuizApp extends StatelessWidget {
  const LimbusQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limbus Quiz',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final unit = MediaQuery.sizeOf(context).shortestSide / 100;
        return Theme(data: buildLimbusTheme(unit), child: child!);
      },
      home: const HomeScreen(),
    );
  }
}