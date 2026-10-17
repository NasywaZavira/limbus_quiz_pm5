import 'package:flutter/foundation.dart';

import '../data/question_repository.dart';
import '../models/question.dart';

/// Menyimpan nama pemain dan seluruh progres kuis di luar widget,
/// sehingga progres tidak hilang saat layar dirotasi atau pindah halaman.
class QuizProvider extends ChangeNotifier {
  QuizProvider({
    this._repository = const QuestionRepository(),
    this.roundSize = 10,
  });

  final QuestionRepository _repository;
  final int roundSize;

  String _playerName = '';
  List<Question> _questions = [];
  List<int?> _answers = []; // jawaban yang dipilih tiap soal (null = belum)
  int _index = 0;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isFinished = false;

  String get playerName => _playerName;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isFinished => _isFinished;
  bool get hasQuestions => _questions.isNotEmpty;

  int get total => _questions.length;
  int get currentIndex => _index;
  Question get currentQuestion => _questions[_index];
  int? get pickedAnswer => hasQuestions ? _answers[_index] : null;
  bool get isAnswered => pickedAnswer != null;
  bool get isLastQuestion => _index == _questions.length - 1;

  int get score {
    var correct = 0;
    for (var i = 0; i < _questions.length; i++) {
      final picked = _answers[i];
      if (picked != null && _questions[i].isCorrect(picked)) correct++;
    }
    return correct;
  }

  /// Ada kuis yang sudah dimulai tetapi belum selesai.
  bool get canResume =>
      hasQuestions && !_isFinished && !_isLoading && !_hasError;

  List<bool?>? get results => null;

  /// Mulai kuis baru atas nama [name] (soal baru, progres dikosongkan).
  Future<void> startQuiz(String name) async {
    _playerName = name.trim();
    _questions = [];
    _answers = [];
    _index = 0;
    _isFinished = false;
    _hasError = false;
    _isLoading = true;
    notifyListeners();

    try {
      final round = await _repository.loadRound(count: roundSize);
      if (round.isEmpty) throw StateError('Tidak ada soal.');
      _questions = round;
      _answers = List<int?>.filled(round.length, null);
    } catch (_) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ulangi kuis dengan nama yang sama.
  Future<void> restart() => startQuiz(_playerName);

  void selectAnswer(int option) {
    if (!hasQuestions || isAnswered) return;
    _answers[_index] = option;
    notifyListeners();
  }

  /// Lanjut ke soal berikutnya, atau tandai kuis selesai di soal terakhir.
  void next() {
    if (!isAnswered) return;
    if (isLastQuestion) {
      _isFinished = true;
    } else {
      _index++;
    }
    notifyListeners();
  }
}