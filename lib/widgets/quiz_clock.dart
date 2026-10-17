import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../theme/limbus_theme.dart';

class QuizClock extends StatelessWidget {
  const QuizClock({
    super.key,
    required this.size,
    required this.total,
    required this.currentIndex,
    required this.results,
    this.animateFromIndex,
    this.duration = const Duration(milliseconds: 600),
  });

  final double size;
  final int total;
  final int currentIndex;

  /// true = benar, false = salah, null = belum dijawab (satu entri per soal).
  final List<bool?> results;
  final int? animateFromIndex;
  final Duration duration;

  double _angleFor(int index) =>
      total == 0 ? 0 : index / total * 2 * math.pi;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: animateFromIndex == null ? null : _angleFor(animateFromIndex!),
        end: _angleFor(currentIndex),
      ),
      duration: duration,
      curve: Curves.easeOutBack,
      builder: (context, handAngle, _) {
        return SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _QuizClockPainter(
              total: total,
              currentIndex: currentIndex,
              results: results,
              handAngle: handAngle,
            ),
          ),
        );
      },
    );
  }
}

class _QuizClockPainter extends CustomPainter {
  _QuizClockPainter({
    required this.total,
    required this.currentIndex,
    required this.results,
    required this.handAngle,
  });

  final int total;
  final int currentIndex;
  final List<bool?> results;
  final double handAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2;

    // Cincin luar, senada dengan jam di layar awal.
    canvas.drawCircle(
      center,
      r * 0.97,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.04
        ..color = LimbusColors.bronze,
    );

    // Satu penanda per soal; soal ke-1 berada di posisi jam 12.
    for (var i = 0; i < total; i++) {
      final angle = i / total * 2 * math.pi - math.pi / 2;
      final isCurrent = i == currentIndex;

      final Color color;
      final result = i < results.length ? results[i] : null;
      if (result == true) {
        color = LimbusColors.correct;
      } else if (result == false) {
        color = LimbusColors.crimson;
      } else {
        color = isCurrent ? LimbusColors.orange : LimbusColors.bronze;
      }

      final from = r * 0.86;
      final to = isCurrent ? r * 0.62 : r * 0.72;
      final paint = Paint()
        ..strokeWidth = isCurrent ? r * 0.09 : r * 0.06
        ..strokeCap = StrokeCap.round
        ..color = color;

      canvas.drawLine(
        center + Offset(math.cos(angle) * from, math.sin(angle) * from),
        center + Offset(math.cos(angle) * to, math.sin(angle) * to),
        paint,
      );
    }

    // Jarum dari tengah menuju penanda soal saat ini.
    final a = handAngle - math.pi / 2;
    canvas.drawLine(
      center + Offset(math.cos(a) * r * 0.1, math.sin(a) * r * 0.1),
      center + Offset(math.cos(a) * r * 0.5, math.sin(a) * r * 0.5),
      Paint()
        ..strokeWidth = r * 0.07
        ..strokeCap = StrokeCap.round
        ..color = LimbusColors.orange,
    );

    // Poros jam.
    canvas.drawCircle(center, r * 0.09, Paint()..color = LimbusColors.orange);
    canvas.drawCircle(center, r * 0.035, Paint()..color = LimbusColors.background);
  }

  @override
  bool shouldRepaint(covariant _QuizClockPainter old) =>
      old.handAngle != handAngle ||
      old.currentIndex != currentIndex ||
      old.total != total ||
      !listEquals(old.results, results);
}