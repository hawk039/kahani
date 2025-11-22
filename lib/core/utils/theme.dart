import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primary = Colors.black;
  static const Color secondary = Color(0xFF023BB0);
  static const Color backgroundLight = Color(0xFFF3F4F6);
  static const Color backgroundDark = Colors.black;
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surfaceLight = Colors.white;
  static const Color borderDark = Color(0xFF374151);
  static const Color borderLight = Color(0xFFD1D5DB);
  static const Color textLight =Colors.white;
  static const Color textDark = Color(0xFF111827);
  static const Color textMutedLight = Color(0xFF6B7280);
  static const Color textMutedDark = Color(0xFF9CA3AF);

  // Fonts
  static const String fontFamily = "SpaceGrotesk";

  // Text Styles
  static final TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textLight,
  );

  static final TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color:textLight,
  );

  static final TextStyle input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: primary,
  );

  static final TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textLight,
  );

  // --- ThemeData objects ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: fontFamily,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: backgroundLight,
      surface: surfaceLight,
      onPrimary: textDark,
      onSecondary: textDark,
      onBackground: textLight,
      onSurface: textLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary),
      ),
      hintStyle: TextStyle(color: textMutedLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: textLight,
        textStyle: buttonText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: fontFamily,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      background: backgroundDark,
      surface: surfaceDark,
      onPrimary: textDark,
      onSecondary: textDark,
      onBackground: textDark,
      onSurface: textDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: secondary),
      ),
      hintStyle: TextStyle(color: textMutedDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: textDark,
        textStyle: buttonText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
