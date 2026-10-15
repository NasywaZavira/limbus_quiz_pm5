import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/limbus_theme.dart';

/// Muka jam dekoratif berukuran [size], dengan [child] di tengahnya.
class ClockDial extends StatelessWidget {
  const ClockDial({super.key, required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CustomPaint(painter: _ClockDialPainter())),
          // Ruang untuk isi dihitung relatif terhadap ukuran jam.
          Padding(
            padding: EdgeInsets.all(size * 0.2),
            child: FittedBox(fit: BoxFit.scaleDown, child: child),
          ),
        ],
      ),
    );
  }
}

/// Dua cincin dan 60 garis penanda (kelipatan 5 lebih tebal).
class _ClockDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2;

    final outerRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.018
      ..color = LimbusColors.bronze;
    final innerRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.009
      ..color = LimbusColors.bronze;
    final majorTick = Paint()
      ..strokeWidth = r * 0.018
      ..strokeCap = StrokeCap.round
      ..color = LimbusColors.orange;
    final minorTick = Paint()
      ..strokeWidth = r * 0.009
      ..strokeCap = StrokeCap.round
      ..color = LimbusColors.bronze;

    canvas.drawCircle(center, r * 0.99, outerRing);
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