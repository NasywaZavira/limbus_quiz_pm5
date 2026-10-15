import 'package:flutter/material.dart';

import '../theme/limbus_theme.dart';

/// Panel dengan sudut terpotong, mengikuti bentuk bingkai UI game.
class LimbusPanel extends StatelessWidget {
  const LimbusPanel({
    super.key,
    required this.child,
    this.borderColor = LimbusColors.orange,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final Color borderColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: LimbusColors.surface,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
      child: child,
    );
  }
}