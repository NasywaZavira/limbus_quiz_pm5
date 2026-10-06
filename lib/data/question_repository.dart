import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/question.dart';

/// Memuat soal dari file JSON di folder assets.
class QuestionRepository {
  const QuestionRepository({this.assetPath = 'assets/questions.json'});

  final String assetPath;

  /// Semua soal sesuai urutan di file.
  Future<List<Question>> loadAll() async {
    final raw = await rootBundle.loadString(assetPath);
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Satu putaran kuis: soal diacak, pilihan jawaban diacak,
  /// dan jumlahnya dibatasi [count] (opsional: hanya satu [category]).
  Future<List<Question>> loadRound({int count = 10, String? category}) async {
    var questions = await loadAll();
    if (category != null) {
      questions = questions.where((q) => q.category == category).toList();
    }
    questions.shuffle();
    return questions
        .take(count)
        .map((q) => q.withShuffledOptions())
        .toList();
  }
}