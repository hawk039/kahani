import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF031125);
  static const Color secondary = Color(0xFF1349EC);
  static const Color backgroundLight = Color(0xFFF3F4F6);
  static const Color backgroundDark = Colors.black;
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surfaceLight = Colors.white;
  static const Color borderDark = Color(0xFF374151);
  static const Color borderDarker = Color(0xFF21272F);
  static const Color storyCard = Color(0xFF171616);
  static const Color borderLight = Color(0xFFD1D5DB);
  static const Color textLight = Colors.white;
  static const Color textDark = Color(0xFF111827);
  static const Color textMutedLight = Color(0xFF6B7280);
  static const Color textMutedDark = Color(0xFF9CA3AF);

  // Glossy Effect Colors
  static Color glossyBackground = Colors.white.withOpacity(0.05);
  static Color glossyBorder = Colors.white.withOpacity(0.1);

  // Text Styles
  static final TextStyle heading = GoogleFonts.spaceGrotesk(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textLight,
  );

  static final TextStyle label = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textLight,
  );

  static final TextStyle input = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: primary,
  );

  static final TextStyle buttonText = GoogleFonts.spaceGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textLight,
  );

  static final TextStyle spaceGrotesk = GoogleFonts.spaceGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textDark,
  );

  static TextStyle inputStyle(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return input.copyWith(color: isDark ? textMutedDark : textMutedDark);
  }

  // --- ThemeData objects ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundLight,
    textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.light().textTheme),
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
      hintStyle: GoogleFonts.spaceGrotesk(color: textMutedLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: textLight,
        textStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
  static final appBarTheme = TextStyle(
    backgroundColor: primary,
  );
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      background: backgroundDark,
      surface: surfaceDark,
      onPrimary: textLight,
      onSecondary: textLight,
      onBackground: textLight,
      onSurface: textLight,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textLight),
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
      hintStyle: GoogleFonts.spaceGrotesk(color: textMutedDark),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondary,
        foregroundColor: textLight,
        textStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
