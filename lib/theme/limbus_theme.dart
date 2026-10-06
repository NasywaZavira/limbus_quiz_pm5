import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final body = GoogleFonts.barlowTextTheme(base.textTheme).apply(
    bodyColor: LimbusColors.parchment,
    displayColor: LimbusColors.parchment,
  );
  final textTheme = body.copyWith(
    displayLarge: GoogleFonts.teko(
        fontSize: 56, fontWeight: FontWeight.w600, color: LimbusColors.orange),
    headlineMedium: GoogleFonts.teko(
        fontSize: 32, fontWeight: FontWeight.w500, color: LimbusColors.parchment),
    titleLarge: GoogleFonts.teko(
        fontSize: 26, fontWeight: FontWeight.w500, color: LimbusColors.parchment),
    titleMedium: GoogleFonts.barlow(
        fontSize: 18, fontWeight: FontWeight.w600, color: LimbusColors.parchment),
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LimbusColors.crimson,
        foregroundColor: LimbusColors.parchment,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        textStyle: GoogleFonts.teko(fontSize: 24, fontWeight: FontWeight.w500),
        shape: bevel.copyWith(
          side: const BorderSide(color: LimbusColors.orange, width: 2),
        ),
      ),
    ),
  );
}

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

enum OptionState { idle, correct, wrong }

/// Satu pilihan jawaban. Warna berubah sesuai [state].
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

    final shape = BeveledRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: border, width: 2),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Ink(
          decoration: ShapeDecoration(color: fill, shape: shape),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}