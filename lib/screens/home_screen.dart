import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/limbus_theme.dart';

/// Layar awal: jam dengan judul di tengah, tombol mulai di bawah.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 340),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: CustomPaint(painter: _ClockDialPainter()),
                          ),
                          // Teks berada di dalam lingkaran dalam jam.
                          Padding(
                            padding: const EdgeInsets.all(70),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Limbus', style: text.displayLarge),
                                  Text('Company', style: text.headlineMedium),
                                  const SizedBox(height: 4),
                                  Text('Kuis pilihan ganda',
                                      style: text.bodyMedium),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onStart,
                  child: const Text('Mulai kuis'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Aplikasi fan-made, tidak berafiliasi dengan Project Moon.',
                textAlign: TextAlign.center,
                style: text.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gambar muka jam: dua cincin dan 60 garis penanda (kelipatan 5 lebih tebal).
class _ClockDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2;

    final outerRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = LimbusColors.bronze;
    final innerRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = LimbusColors.bronze;
    final majorTick = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = LimbusColors.orange;
    final minorTick = Paint()
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = LimbusColors.bronze;

    canvas.drawCircle(center, r - 2, outerRing);
    canvas.drawCircle(center, r * 0.82, innerRing);

    for (var i = 0; i < 60; i++) {
      final angle = i * 2 * math.pi / 60 - math.pi / 2;
      final isMajor = i % 5 == 0;
      final from = r * 0.82;
      final to = isMajor ? r * 0.68 : r * 0.75;
      canvas.drawLine(
        center + Offset(math.cos(angle) * from, math.sin(angle) * from),
        center + Offset(math.cos(angle) * to, math.sin(angle) * to),
        isMajor ? majorTick : minorTick,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}