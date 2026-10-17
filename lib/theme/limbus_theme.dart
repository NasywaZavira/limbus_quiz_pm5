import 'package:flutter/material.dart';

class LimbusColors {
  static const background = Color(0xFF120C0A); // latar utama
  static const surface = Color(0xFF1E1511); // isi panel
  static const bronze = Color(0xFF7A4E2A); // rangka / border tenang
  static const orange = Color(0xFFF07A12); // aksen utama
  static const crimson = Color(0xFF9E1B1B); // tombol aksi & jawaban salah
  static const parchment = Color(0xFFEBDDBD); // teks
  static const correct = Color(0xFF3DBE5A); // jawaban benar
}

ThemeData buildLimbusTheme(double unit) {
  final base = ThemeData.dark(useMaterial3: true);

  // Judul: Teko (condensed, industrial). Isi: Barlow (mudah dibaca).
  final body = base.textTheme
      .apply(
        bodyColor: LimbusColors.parchment,
        displayColor: LimbusColors.parchment,
      )
      .apply(fontFamily: 'Barlow');

  TextStyle teko(double size, FontWeight weight, Color color) => TextStyle(
        fontFamily: 'Teko',
        fontSize: unit * size,
        fontWeight: weight,
        color: color,
      );

  final textTheme = body.copyWith(
    displayLarge: teko(14, FontWeight.w600, LimbusColors.orange),
    headlineMedium: teko(8, FontWeight.w500, LimbusColors.parchment),
    titleLarge: teko(6.5, FontWeight.w500, LimbusColors.parchment),
    titleMedium: TextStyle(
      fontFamily: 'Barlow',
      fontSize: unit * 4.6,
      fontWeight: FontWeight.w600,
      color: LimbusColors.parchment,
    ),
    bodyLarge: body.bodyLarge?.copyWith(fontSize: unit * 4.1),
    bodyMedium: body.bodyMedium?.copyWith(fontSize: unit * 3.6),
    bodySmall: body.bodySmall?.copyWith(fontSize: unit * 3.1),
  );

  final stroke = unit * 0.5; // tebal garis tepi
  final bevel = BeveledRectangleBorder(
    borderRadius: BorderRadius.circular(unit * 3),
  );

  return base.copyWith(
    scaffoldBackgroundColor: LimbusColors.background,
    colorScheme: const ColorScheme.dark(
      primary: LimbusColors.orange,
      onPrimary: LimbusColors.background,
      secondary: LimbusColors.crimson,
      surface: LimbusColors.surface,
      onSurface: LimbusColors.parchment,
      error: LimbusColors.crimson,
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: LimbusColors.background,
      foregroundColor: LimbusColors.parchment,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LimbusColors.surface,
      labelStyle: textTheme.bodyMedium,
      border: _inputBorder(LimbusColors.bronze, unit),
      enabledBorder: _inputBorder(LimbusColors.bronze, unit),
      focusedBorder: _inputBorder(LimbusColors.orange, unit),
      errorBorder: _inputBorder(LimbusColors.crimson, unit),
      focusedErrorBorder: _inputBorder(LimbusColors.crimson, unit),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: LimbusColors.orange,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LimbusColors.crimson,
        foregroundColor: LimbusColors.parchment,
        padding: EdgeInsets.symmetric(
          horizontal: unit * 8,
          vertical: unit * 3.6,
        ),
        textStyle: textTheme.titleLarge,
        shape: bevel.copyWith(
          side: BorderSide(color: LimbusColors.orange, width: stroke),
        ),
      ),
    ),
  );
}

OutlineInputBorder _inputBorder(Color color, double unit) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(unit * 3),
      borderSide: BorderSide(color: color, width: unit * 0.5),
    );