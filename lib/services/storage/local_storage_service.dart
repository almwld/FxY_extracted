import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة التخزين المحلي
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  SharedPreferences? _prefs;

  /// تهيئة التخزين المحلي
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// حفظ قيمة نصية
  Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  /// الحصول على قيمة نصية
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// حفظ قيمة عددية صحيحة
  Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  /// الحصول على قيمة عددية صحيحة
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// حفظ قيمة عددية عشرية
  Future<bool> setDouble(String key, double value) async {
    return await _prefs?.setDouble(key, value) ?? false;
  }

  /// الحصول على قيمة عددية عشرية
  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  /// حفظ قيمة منطقية
  Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  /// الحصول على قيمة منطقية
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// حفظ قائمة نصية
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value) ?? false;
  }

  /// الحصول على قائمة نصية
  List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  /// حفظ كائن JSON
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await _prefs?.setString(key, jsonEncode(value)) ?? false;
  }

  /// الحصول على كائن JSON
  Map<String, dynamic>? getJson(String key) {
    final jsonString = _prefs?.getString(key);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// حذف قيمة
  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  /// التحقق من وجود مفتاح
  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  /// مسح جميع البيانات
  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }

  /// الحصول على جميع المفاتيح
  Set<String> getKeys() {
    return _prefs?.getKeys() ?? {};
  }

  /// إعادة تحميل البيانات
  Future<void> reload() async {
    await _prefs?.reload();
  }
}

/// مفاتيح التخزين المحلي
class StorageKeys {
  StorageKeys._();

  static const String token = 'token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userAvatar = 'user_avatar';
  static const String isLoggedIn = 'is_logged_in';
  static const String isFirstTime = 'is_first_time';
  static const String theme = 'theme';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String biometricEnabled = 'biometric_enabled';
  static const String cart = 'cart';
  static const String favorites = 'favorites';
  static const String searchHistory = 'search_history';
  static const String recentViews = 'recent_views';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String lastSync = 'last_sync';
  static const String cachedCategories = 'cached_categories';
  static const String cachedProducts = 'cached_products';
}
