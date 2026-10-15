import 'package:flutter/material.dart';

import '../theme/limbus_theme.dart';

/// Tombol selebar penuh. [secondary] = gaya garis tepi (aksi pendamping).
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
    return SizedBox(
      width: double.infinity,
      child: secondary
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: LimbusColors.parchment,
                side: const BorderSide(color: LimbusColors.bronze, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: Theme.of(context).textTheme.titleLarge,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(label),
            )
          : ElevatedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}