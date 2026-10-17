import 'package:flutter/material.dart';

import '../theme/limbus_theme.dart';

class LimbusButton extends StatelessWidget {
  const LimbusButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.secondary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    final unit = MediaQuery.sizeOf(context).shortestSide / 100;

    return SizedBox(
      width: double.infinity,
      child: secondary
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: LimbusColors.parchment,
                side: BorderSide(
                  color: LimbusColors.bronze,
                  width: unit * 0.5,
                ),
                padding: EdgeInsets.symmetric(vertical: unit * 3.6),
                textStyle: Theme.of(context).textTheme.titleLarge,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(unit * 3),
                ),
              ),
              child: Text(label),
            )
          : ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}