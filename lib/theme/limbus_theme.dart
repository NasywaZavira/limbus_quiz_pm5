import 'package:flutter/material.dart';

/// Palet warna diambil dari UI game: latar gelap, rangka perunggu,
/// aksen oranye, tombol merah, dan teks warna kertas tua.
class LimbusColors {
  static const background = Color(0xFF120C0A); // latar utama
  static const surface = Color(0xFF1E1511); // isi panel
  static const bronze = Color(0xFF7A4E2A); // rangka / border tenang
  static const orange = Color(0xFFF07A12); // aksen utama
  static const crimson = Color(0xFF9E1B1B); // tombol aksi & jawaban salah
  static const parchment = Color(0xFFEBDDBD); // teks
  static const correct = Color(0xFF3DBE5A); // jawaban benar
}

ThemeData buildLimbusTheme() {
  final base = ThemeData.dark(useMaterial3: true);

  // Judul: Teko (condensed, industrial). Isi: Barlow (mudah dibaca).
  final body = base.textTheme
      .apply(
        bodyColor: LimbusColors.parchment,
        displayColor: LimbusColors.parchment,
      )
      .apply(fontFamily: 'Barlow');
  final textTheme = body.copyWith(
    displayLarge: const TextStyle(
      fontFamily: 'Teko',
      fontSize: 56,
      fontWeight: FontWeight.w600,
      color: LimbusColors.orange,
    ),
    headlineMedium: const TextStyle(
      fontFamily: 'Teko',
      fontSize: 32,
      fontWeight: FontWeight.w500,
      color: LimbusColors.parchment,
    ),
    titleLarge: const TextStyle(
      fontFamily: 'Teko',
      fontSize: 26,
      fontWeight: FontWeight.w500,
      color: LimbusColors.parchment,
    ),
    titleMedium: const TextStyle(
      fontFamily: 'Barlow',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: LimbusColors.parchment,
    ),
  );

  const bevel = BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
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
      border: _inputBorder(LimbusColors.bronze),
      enabledBorder: _inputBorder(LimbusColors.bronze),
      focusedBorder: _inputBorder(LimbusColors.orange),
      errorBorder: _inputBorder(LimbusColors.crimson),
      focusedErrorBorder: _inputBorder(LimbusColors.crimson),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: LimbusColors.orange,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LimbusColors.crimson,
        foregroundColor: LimbusColors.parchment,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: 'Teko',
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        shape: bevel.copyWith(
          side: const BorderSide(color: LimbusColors.orange, width: 2),
        ),
      ),
    ),
  );
}

OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: BorderSide(color: color, width: 2),
);
