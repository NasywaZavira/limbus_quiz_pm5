import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../theme/limbus_theme.dart';
import '../widgets/limbus_button.dart';
import '../widgets/limbus_option_tile.dart';
import '../widgets/limbus_panel.dart';
import '../widgets/quiz_clock.dart';
import '../widgets/sinner_portrait.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  OptionState _stateFor(QuizProvider quiz, int i) {
    if (!quiz.isAnswered) return OptionState.idle;
    if (quiz.currentQuestion.isCorrect(i)) return OptionState.correct;
    if (i == quiz.pickedAnswer) return OptionState.wrong;
    return OptionState.idle;
  }

  void _onNext(BuildContext context) {
    final quiz = context.read<QuizProvider>();
    final wasLast = quiz.isLastQuestion;
    quiz.next();
    if (wasLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final text = Theme.of(context).textTheme;
    final unit = MediaQuery.sizeOf(context).shortestSide / 100;

    if (quiz.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (quiz.hasError || !quiz.hasQuestions) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.06),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Soal gagal dimuat.', style: text.headlineMedium),
                SizedBox(height: unit * 2),
                Text(
                  'Periksa assets/questions.json dan daftar assets di pubspec.yaml.',
                  textAlign: TextAlign.center,
                  style: text.bodyMedium,
                ),
                SizedBox(height: unit * 5),
                LimbusButton(
                  label: 'Coba lagi',
                  onPressed: () => context.read<QuizProvider>().restart(),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = quiz.currentQuestion;
    final picked = quiz.pickedAnswer;
    final gotItRight = picked != null && question.isCorrect(picked);
    final screen = MediaQuery.sizeOf(context);
    final pad = screen.width * 0.04;

    final clockSize = math.min(screen.width * 0.22, screen.height * 0.16);
    final portraitWidth = math.min(screen.width * 0.45, screen.height * 0.26);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(pad, pad * 0.5, pad, pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (question.imagePath != null)
                      SinnerPortrait(
                        imagePath: question.imagePath!,
                        width: portraitWidth,
                      ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: QuizClock(
                        size: clockSize,
                        total: quiz.total,
                        currentIndex: quiz.currentIndex,
                        results: quiz.results,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: pad),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LimbusPanel(
                        padding: EdgeInsets.all(pad * 1.2),
                        child: Text(question.text, style: text.headlineMedium),
                      ),
                      SizedBox(height: pad * 1.2),
                      for (var i = 0; i < question.options.length; i++) ...[
                        LimbusOptionTile(
                          label: question.options[i],
                          state: _stateFor(quiz, i),
                          onTap: quiz.isAnswered
                              ? null
                              : () => context.read<QuizProvider>().selectAnswer(
                                  i,
                                ),
                        ),
                        SizedBox(height: pad * 0.7),
                      ],
                      if (quiz.isAnswered)
                        LimbusPanel(
                          borderColor: gotItRight
                              ? LimbusColors.correct
                              : LimbusColors.crimson,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gotItRight ? 'Benar' : 'Belum tepat',
                                style: text.titleLarge,
                              ),
                              if (!gotItRight) ...[
                                SizedBox(height: pad * 0.25),
                                Text(
                                  'Jawaban yang benar: ${question.correctAnswer}',
                                  style: text.bodyLarge,
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: pad * 0.7),
              LimbusButton(
                label: quiz.isLastQuestion ? 'Lihat hasil' : 'Soal berikutnya',
                onPressed: quiz.isAnswered ? () => _onNext(context) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}