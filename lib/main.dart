import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'theme/limbus_theme.dart';

void main() => runApp(const LimbusQuizApp());

class LimbusQuizApp extends StatelessWidget {
  const LimbusQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limbus Quiz',
      debugShowCheckedModeBanner: false,
      theme: buildLimbusTheme(),
      home: Builder(
        builder: (context) => HomeScreen(
          onStart: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const QuizScreen()),
          ),
        ),
      ),
    );
  }
}