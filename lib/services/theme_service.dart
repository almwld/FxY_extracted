import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ThemeService {
  static const String _themeColorKey = 'theme_color';
  static const List<Color> availableColors = [
    Color(0xFFD4AF37), // ذهبي
    Color(0xFF2196F3), // أزرق
    Color(0xFF4CAF50), // أخضر
    Color(0xFFE91E63), // وردي
    Color(0xFF9C27B0), // بنفسجي
    Color(0xFFFF9800), // برتقالي
  ];
  static const List<String> colorNames = [
    'ذهبي', 'أزرق', 'أخضر', 'وردي', 'بنفسجي', 'برتقالي'
  ];
  static Future<Color> getThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_themeColorKey);
    if (colorValue != null) {
      return Color(colorValue);
    }
    return availableColors[0];
  }
  static Future<void> saveThemeColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeColorKey, color.value);
  }
}
