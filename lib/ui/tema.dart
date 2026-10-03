import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const carvao = Color(0xFF1F1F21);
const creme = Color(0xFFF3F1E8);
const menta = Color(0xFF33E5A1);
const verde = Color(0xFF27BB4E);
const texto = Color(0xFF333333);
const textoNoEscuro = Color(0xFFBFBDB6);
const bege = Color(0xFFC7C4B7);
const branco = Color(0xFFFFFFFC);
const aviso = Color(0xFFC9F4CC);
const erro = Color(0xFFD5455F);

String rotuloImportancia(String nivel) {
  return switch (nivel) {
    'alta' => 'Mais importante',
    'media' => 'Importante',
    'baixa' => 'Menos importante',
    _ => '',
  };
}

ThemeData temaMarcoZero() {
  final corpo = GoogleFonts.inter(color: texto, fontWeight: FontWeight.w500, fontSize: 14, height: 1.45);
  final titulo = GoogleFonts.outfit(color: carvao, fontWeight: FontWeight.w700);
  final botao = GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14);
  const pilula = StadiumBorder();

  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: menta,
      onPrimary: carvao,
      secondary: verde,
      onSecondary: branco,
      surface: branco,
      onSurface: texto,
      error: erro,
      onError: branco,
    ),
    scaffoldBackgroundColor: creme,
    textTheme: TextTheme(
      headlineMedium: titulo.copyWith(fontSize: 32, height: 1.15),
      titleLarge: titulo.copyWith(fontSize: 24),
      titleMedium: titulo.copyWith(fontSize: 18),
      bodyLarge: corpo.copyWith(fontSize: 16),
      bodyMedium: corpo,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: carvao,
      foregroundColor: branco,
      elevation: 0,
      titleTextStyle: titulo.copyWith(color: branco, fontSize: 18),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: menta),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: branco,
      labelStyle: GoogleFonts.inter(color: const Color(0xFF595855), fontWeight: FontWeight.w500),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: bege)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: bege)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: menta, width: 2)),
    ),
    cardTheme: const CardThemeData(
      color: branco,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        side: BorderSide(color: bege),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: menta,
        foregroundColor: carvao,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: botao,
        shape: pilula,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: carvao,
        backgroundColor: branco,
        side: const BorderSide(color: carvao, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: botao,
        shape: pilula,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: carvao,
        backgroundColor: aviso,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: botao,
        shape: pilula,
      ),
    ),
  );
}
