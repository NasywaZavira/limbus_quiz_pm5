import 'package:flutter/material.dart';

import '../theme/limbus_theme.dart';
import 'quiz_screen.dart';

/// Layar hasil: skor akhir, pesan singkat, dan pilihan main lagi.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.score, required this.total});

  final int score;
  final int total;

  String get _message {
    final ratio = total == 0 ? 0.0 : score / total;
    if (ratio == 1) return 'Sempurna. Semua jawaban tepat.';
    if (ratio >= 0.7) return 'Bagus. Tinggal sedikit lagi.';
    if (ratio >= 0.4) return 'Lumayan. Coba lagi untuk skor lebih tinggi.';
    return 'Belum banyak yang tepat. Coba lagi.';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: LimbusPanel(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Hasil', style: text.titleLarge),
                        const SizedBox(height: 8),
                        Text('$score / $total', style: text.displayLarge),
                        const SizedBox(height: 8),
                        Text(
                          _message,
                          textAlign: TextAlign.center,
                          style: text.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const QuizScreen()),
                  ),
                  child: const Text('Main lagi'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: LimbusColors.parchment,
                    side: const BorderSide(color: LimbusColors.bronze, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: text.titleLarge,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Kembali ke awal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}