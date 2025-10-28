import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: kPrimaryColorLight,
    scaffoldBackgroundColor: kBackgroundColorLight,
    colorScheme: ColorScheme.light(
      primary: kPrimaryColorLight,
      secondary: kSecondaryColorLight,
      surface: kCardColorLight,
      background: kBackgroundColorLight,
      error: kAccentColorLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimaryColorLight,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: kCardColorLight,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColorLight,
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kCardColorLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kTextSecondaryLight.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryColorLight, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: kTextColorLight,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: kTextColorLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: kTextColorLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: kTextSecondaryLight,
      ),
    ),
    iconTheme: const IconThemeData(
      color: kPrimaryColorLight,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: kPrimaryColorDark,
    scaffoldBackgroundColor: kBackgroundColorDark,
    colorScheme: ColorScheme.dark(
      primary: kPrimaryColorDark,
      secondary: kSecondaryColorDark,
      surface: kCardColorDark,
      background: kBackgroundColorDark,
      error: kAccentColorDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kCardColorDark,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: kTextColorDark),
      titleTextStyle: const TextStyle(
        color: kTextColorDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: kCardColorDark,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColorDark,
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kCardColorDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kTextSecondaryDark.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryColorDark, width: 2),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: kTextColorDark,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: kTextColorDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: kTextColorDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: kTextSecondaryDark,
      ),
    ),
    iconTheme: const IconThemeData(
      color: kPrimaryColorDark,
    ),
  );
}
