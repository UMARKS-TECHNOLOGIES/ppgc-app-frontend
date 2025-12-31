import 'package:flutter/material.dart';

class AppColors {
  static const fromColor = Color(0xFFF9F10C);
  static const toColor = Color(0xFF938E07);
  static const green = Color(0xFF008000);
  static const grayColor = Color(0xFFB4B4B2);
  static const lightGrayColor = Color(0xFFF6F6F6);
  static const blueColor = Color(0xFF2E0797);
  static const error = Color(0xFFB00020);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}

final ThemeData customTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF2E0797),
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,

    seedColor: Color(0xFF2E0797),
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 18),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF2E0797),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.deepPurple),
    ),
  ),
);
