import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../core/theme/app_theme.dart';
import '../services/storage/local_storage_service.dart';

/// مزود السمة
class ThemeProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;
  
  bool get isDarkMode {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    // System mode
    return SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  }

  bool get isLightMode => !isDarkMode;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  ThemeData get currentTheme => isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  /// تهيئة المزود
  Future<void> initialize() async {
    _setLoading(true);
    
    final savedTheme = _storage.getString('theme_mode');
    if (savedTheme != null) {
      _themeMode = _parseThemeMode(savedTheme);
    }
    
    _setLoading(false);
  }

  /// تعيين السمة الداكنة
  Future<void> setDarkMode() async {
    await _setThemeMode(ThemeMode.dark);
  }

  /// تعيين السمة الفاتحة
  Future<void> setLightMode() async {
    await _setThemeMode(ThemeMode.light);
  }

  /// تعيين سمة النظام
  Future<void> setSystemMode() async {
    await _setThemeMode(ThemeMode.system);
  }

  /// تبديل السمة
  Future<void> toggleTheme() async {
    if (isDarkMode) {
      await setLightMode();
    } else {
      await setDarkMode();
    }
  }

  /// تعيين وضع السمة
  Future<void> _setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storage.setString('theme_mode', mode.toString());
    notifyListeners();
  }

  /// تحليل وضع السمة من النص
  ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  /// تعيين حالة التحميل
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
