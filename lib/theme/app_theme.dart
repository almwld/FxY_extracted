import 'package:flutter/material.dart';
class AppTheme {
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color goldLight = Color(0xFFFFD700);
  static const Color darkBackground = Color(0xFF121212);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static ThemeData get lightTheme => ThemeData(
    primaryColor: goldColor,
    scaffoldBackgroundColor: lightBackground,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: goldColor,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
  static ThemeData get darkTheme => ThemeData(
    primaryColor: goldColor,
    scaffoldBackgroundColor: darkBackground,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: goldColor,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),
  );
  static Color getCardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkSurface : lightSurface;
  static Color getTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  static Color getSecondaryTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600;
  static Color getDividerColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200;
}
