import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user/user_model.dart';
import '../services/supabase/auth_service.dart';

/// مزود المصادقة
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  bool get isGuest => _user == null;

  /// تهيئة المزود
  Future<void> initialize() async {
    _setLoading(true);
    
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      await _loadUserProfile(currentUser.id);
    }
    
    _setLoading(false);
  }

  /// تسجيل الدخول بالبريد الإلكتروني
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!.id);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }

    return false;
  }

  /// إنشاء حساب جديد
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      if (response.user != null) {
        _isAuthenticated = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }

    return false;
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    _setLoading(true);

    try {
      await _authService.signOut();
      _user = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  /// إعادة تعيين كلمة المرور
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// تحديث الملف الشخصي
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? bio,
  }) async {
    if (_user == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await _authService.updateUserProfile(
        userId: _user!.id,
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
        bio: bio,
      );

      await _loadUserProfile(_user!.id);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return false;
    }
  }

  /// رفع صورة الملف الشخصي
  Future<String?> uploadAvatar(String filePath) async {
    if (_user == null) return null;

    _setLoading(true);

    try {
      final url = await _authService.uploadAvatar(_user!.id, filePath);
      await _loadUserProfile(_user!.id);
      _setLoading(false);
      return url;
    } catch (e) {
      _setError(_getErrorMessage(e));
      _setLoading(false);
      return null;
    }
  }

  /// تحميل ملف المستخدم
  Future<void> _loadUserProfile(String userId) async {
    try {
      _user = await _authService.getUserProfile(userId);
      _isAuthenticated = _user != null;
    } catch (e) {
      _user = null;
      _isAuthenticated = false;
    }
  }

  /// مسح الخطأ
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// تعيين حالة التحميل
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// تعيين الخطأ
  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  /// مسح الخطأ
  void _clearError() {
    _error = null;
  }

  /// ترجمة رسائل الخطأ
  String _getErrorMessage(dynamic error) {
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'بيانات الدخول غير صحيحة';
        case 'Email not confirmed':
          return 'البريد الإلكتروني غير مؤكد';
        case 'User already registered':
          return 'المستخدم مسجل بالفعل';
        case 'Password should be at least 6 characters':
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        default:
          return error.message;
      }
    }
    return 'حدث خطأ غير متوقع';
  }
}
