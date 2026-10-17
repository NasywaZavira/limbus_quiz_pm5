import 'package:flutter/material.dart';

import '../theme/limbus_theme.dart';

class LimbusPanel extends StatelessWidget {
  const LimbusPanel({
    super.key,
    required this.child,
    this.borderColor = LimbusColors.orange,
    this.padding,
  });

  final Widget child;
  final Color borderColor;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final unit = MediaQuery.sizeOf(context).shortestSide / 100;
    return Container(
      padding: padding ?? EdgeInsets.all(unit * 4),
      decoration: ShapeDecoration(
        color: LimbusColors.surface,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(unit * 4),
          side: BorderSide(color: borderColor, width: unit * 0.5),
        ),
      ),
      child: child,
    );
  }
}