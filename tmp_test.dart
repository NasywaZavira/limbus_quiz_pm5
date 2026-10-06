import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  final base = ThemeData.dark(useMaterial3: true);

  final body = GoogleFonts.barlowTextTheme(base.textTheme as TextTheme?).apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  );

  final textTheme = body.copyWith(
    displayLarge: GoogleFonts.teko(fontSize: 56, fontWeight: FontWeight.w600, color: Colors.orange),
  );

  final themed = base.copyWith(textTheme: textTheme as TextTheme?);
  if (kDebugMode) {
    print(themed.textTheme.titleLarge?.fontSize);
  }
}
