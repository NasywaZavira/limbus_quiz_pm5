import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/limbus_button.dart';
import '../widgets/limbus_panel.dart';
import 'quiz_screen.dart';

/// Layar hasil: skor akhir atas nama pemain, pesan singkat, dan pilihan lanjut.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  String _message(int score, int total) {
    final ratio = total == 0 ? 0.0 : score / total;
    if (ratio == 1) return 'Sempurna. Semua jawaban tepat.';
    if (ratio >= 0.7) return 'Bagus. Tinggal sedikit lagi.';
    if (ratio >= 0.4) return 'Lumayan. Coba lagi untuk skor lebih tinggi.';
    return 'Belum banyak yang tepat. Coba lagi.';
  }

  void _playAgain(BuildContext context) {
    context.read<QuizProvider>().restart();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final text = Theme.of(context).textTheme;
    final score = quiz.score;
    final total = quiz.total;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final pad = constraints.maxWidth * 0.06;

            return SingleChildScrollView(
              padding: EdgeInsets.all(pad),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - pad * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: LimbusPanel(
                        padding: EdgeInsets.symmetric(
                          horizontal: pad,
                          vertical: pad * 1.4,
                        ),
                        child: Column(
                          children: [
                            Text('Skor ${quiz.playerName}',
                                textAlign: TextAlign.center,
                                style: text.titleLarge),
                            SizedBox(height: pad * 0.3),
                            Text('$score / $total', style: text.displayLarge),
                            SizedBox(height: pad * 0.3),
                            Text(
                              _message(score, total),
                              textAlign: TextAlign.center,
                              style: text.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: pad),
                    LimbusButton(
                      label: 'Main lagi',
                      onPressed: () => _playAgain(context),
                    ),
                    SizedBox(height: pad * 0.5),
                    LimbusButton(
                      label: 'Kembali ke awal',
                      secondary: true,
                      onPressed: () => Navigator.of(context)
                          .popUntil((route) => route.isFirst),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}