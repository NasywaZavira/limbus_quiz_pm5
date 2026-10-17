import 'package:flutter/material.dart';

import '../theme/limbus_theme.dart';

enum OptionState { idle, correct, wrong }

class LimbusOptionTile extends StatelessWidget {
  const LimbusOptionTile({
    super.key,
    required this.label,
    required this.onTap,
    this.state = OptionState.idle,
  });

  final String label;
  final VoidCallback? onTap;
  final OptionState state;

  @override
  Widget build(BuildContext context) {
    final Color border;
    final Color fill;
    switch (state) {
      case OptionState.correct:
        border = LimbusColors.correct;
        fill = LimbusColors.correct.withValues(alpha: 0.18);
        break;
      case OptionState.wrong:
        border = LimbusColors.crimson;
        fill = LimbusColors.crimson.withValues(alpha: 0.30);
        break;
      case OptionState.idle:
        border = LimbusColors.bronze;
        fill = LimbusColors.surface;
    }

    final unit = MediaQuery.sizeOf(context).shortestSide / 100;

    final shape = BeveledRectangleBorder(
      borderRadius: BorderRadius.circular(unit * 3),
      side: BorderSide(color: border, width: unit * 0.5),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Ink(
          decoration: ShapeDecoration(color: fill, shape: shape),
          padding: EdgeInsets.symmetric(
            horizontal: unit * 4.6,
            vertical: unit * 3.6,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}