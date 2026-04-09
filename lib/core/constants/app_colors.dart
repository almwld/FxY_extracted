import 'package:flutter/material.dart';

/// ثوابت الألوان في التطبيق
class AppColors {
  AppColors._();

  // الألوان الذهبية
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color goldAccent = Color(0xFFFFC107);
  static const Color goldShimmer = Color(0xFFF4E4BC);

  // الألوان الأساسية
  static const Color primary = goldColor;
  static const Color primaryLight = goldLight;
  static const Color primaryDark = goldDark;

  // ألوان الخلفية - الوضع الفاتح
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  // ألوان الخلفية - الوضع الداكن
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);

  // ألوان النصوص
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF000000);

  // ألوان الحالات
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // ألوان إضافية
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1F000000);
  static const Color overlay = Color(0x80000000);

  // ألوان المحفظة
  static const Color walletBalance = Color(0xFF1B5E20);
  static const Color walletIncome = Color(0xFF2E7D32);
  static const Color walletExpense = Color(0xFFC62828);
  static const Color walletPending = Color(0xFFF57C00);

  // ألوان الفئات
  static const Color categoryElectronics = Color(0xFF3F51B5);
  static const Color categoryFashion = Color(0xFFE91E63);
  static const Color categoryHome = Color(0xFF795548);
  static const Color categorySports = Color(0xFF4CAF50);
  static const Color categoryBeauty = Color(0xFF9C27B0);
  static const Color categoryFood = Color(0xFFFF5722);
  static const Color categoryCars = Color(0xFF607D8B);
  static const Color categoryRealEstate = Color(0xFF009688);
}
