import 'package:flutter/material.dart';

class SinnerPortrait extends StatelessWidget {
  const SinnerPortrait({
    super.key,
    required this.imagePath,
    required this.width,
  });

  final String imagePath;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.person_outline, size: width * 0.4),
    );
  }
}
