import 'package:flutter/material.dart';

import '../data/question_repository.dart';
import '../models/question.dart';
import '../theme/limbus_theme.dart';
import 'result_screen.dart';

/// Layar kuis: memuat satu putaran soal, lalu menampilkannya satu per satu.
class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    this.repository = const QuestionRepository(),
    this.roundSize = 10,
  });

  final QuestionRepository repository;
  final int roundSize;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.loadRound(count: widget.roundSize);
  }

  void _reload() {
    setState(() {
      _future = widget.repository.loadRound(count: widget.roundSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return FutureBuilder<List<Question>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final questions = snapshot.data;
        if (snapshot.hasError || questions == null || questions.isEmpty) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Soal gagal dimuat.', style: text.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Periksa assets/questions.json dan daftar assets di pubspec.yaml.',
                      textAlign: TextAlign.center,
                      style: text.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return _QuizBody(questions: questions);
      },
    );
  }
}

class _QuizBody extends StatefulWidget {
  const _QuizBody({required this.questions});

  final List<Question> questions;

  @override
  State<_QuizBody> createState() => _QuizBodyState();
}

class _QuizBodyState extends State<_QuizBody> {
  int _index = 0;
  int _score = 0;
  int? _picked;

  Question get _question => widget.questions[_index];
  bool get _answered => _picked != null;
  bool get _isLast => _index == widget.questions.length - 1;

  void _pick(int i) {
    if (_answered) return;
    setState(() {
      _picked = i;
      if (_question.isCorrect(i)) _score++;
    });
  }

  void _next() {
    if (_isLast) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            score: _score,
            total: widget.questions.length,
          ),
        ),
      );
    } else {
      setState(() {
        _index++;
        _picked = null;
      });
    }
  }

  OptionState _stateFor(int i) {
    if (!_answered) return OptionState.idle;
    if (_question.isCorrect(i)) return OptionState.correct;
    if (i == _picked) return OptionState.wrong;
    return OptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final total = widget.questions.length;
    final question = _question;
    final gotItRight = _answered && question.isCorrect(_picked!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Soal ${_index + 1} / $total'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('Skor $_score', style: text.titleLarge),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (_index + (_answered ? 1 : 0)) / total,
                minHeight: 6,
                backgroundColor: LimbusColors.surface,
                color: LimbusColors.orange,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LimbusPanel(
                        padding: const EdgeInsets.all(20),
                        child: Text(question.text, style: text.headlineMedium),
                      ),
                      const SizedBox(height: 20),
                      for (var i = 0; i < question.options.length; i++) ...[
                        LimbusOptionTile(
                          label: question.options[i],
                          state: _stateFor(i),
                          onTap: _answered ? null : () => _pick(i),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_answered) ...[
                        const SizedBox(height: 4),
                        LimbusPanel(
                          borderColor: gotItRight
                              ? LimbusColors.correct
                              : LimbusColors.crimson,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gotItRight ? 'Benar' : 'Salah',
                                style: text.titleLarge,
                              ),
                              if (!gotItRight) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Jawaban yang benar: ${question.correctAnswer}',
                                  style: text.bodyLarge,
                                ),
                              ],
                              if (question.explanation != null) ...[
                                const SizedBox(height: 8),
                                Text(question.explanation!,
                                    style: text.bodyMedium),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _answered ? _next : null,
                child: Text(_isLast ? 'Lihat hasil' : 'Soal berikutnya'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}