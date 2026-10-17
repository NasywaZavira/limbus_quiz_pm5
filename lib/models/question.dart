import 'dart:math';

class Question {
  const Question({
    required this.text,
    required this.options,
    required this.answerIndex,
    required this.category,
    this.imagePath,
  });

  final String text;
  final List<String> options;
  final int answerIndex;
  final String category;

  /// Path aset gambar (mis. potret Sinner), opsional.
  final String? imagePath;

  String get correctAnswer => options[answerIndex];

  bool isCorrect(int index) => index == answerIndex;

  factory Question.fromJson(Map<String, dynamic> json) {
    final options = List<String>.from(json['options'] as List);
    final answerIndex = json['answerIndex'] as int;

    if (answerIndex < 0 || answerIndex >= options.length) {
      throw FormatException(
        'answerIndex di luar jangkauan pada soal: ${json['question']}',
      );
    }

    return Question(
      text: json['question'] as String,
      options: options,
      answerIndex: answerIndex,
      category: json['category'] as String? ?? 'Umum',
      imagePath: json['image'] as String?,
    );
  }

  /// Salinan soal dengan urutan pilihan diacak. Indeks jawaban benar
  Question withShuffledOptions([Random? random]) {
    final correct = correctAnswer;
    final shuffled = List<String>.of(options)..shuffle(random);
    return Question(
      text: text,
      options: shuffled,
      answerIndex: shuffled.indexOf(correct),
      category: category,
      imagePath: imagePath,
    );
  }
}