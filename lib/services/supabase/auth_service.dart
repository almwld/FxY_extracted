import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user/user_model.dart';

/// خدمة المصادقة
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// التسجيل بالبريد الإلكتروني وكلمة المرور
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
      },
    );

    if (response.user != null) {
      // إنشاء ملف المستخدم
      await _createUserProfile(
        userId: response.user!.id,
        email: email,
        fullName: fullName,
        phone: phone,
      );
    }

    return response;
  }

  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// تسجيل الدخول كضيف
  Future<AuthResponse> signInAnonymously() async {
    return await _supabase.auth.signInAnonymously();
  }

  /// تسجيل الدخول باستخدام Google
  Future<AuthResponse> signInWithGoogle() async {
    _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutterquickstart://login-callback/',
    );
  }

  /// إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'io.supabase.flutterquickstart://reset-callback/',
    );
  }

  /// تحديث كلمة المرور
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// تحديث البريد الإلكتروني
  Future<void> updateEmail(String newEmail) async {
    await _supabase.auth.updateUser(
      UserAttributes(email: newEmail),
    );
  }

  /// إرسال رمز التحقق OTP
  Future<void> sendOtp(String phone) async {
    await _supabase.auth.signInWithOtp(
      phone: phone,
    );
  }

  /// التحقق من رمز OTP
  Future<AuthResponse> verifyOtp({
    required String phone,
    required String token,
  }) async {
    return await _supabase.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// الحصول على المستخدم الحالي
  User? get currentUser => _supabase.auth.currentUser;

  /// التحقق مما إذا كان المستخدم مسجل الدخول
  bool get isAuthenticated => currentUser != null;

  /// الحصول على معرف المستخدم الحالي
  String? get currentUserId => currentUser?.id;

  /// الاستماع لتغييرات حالة المصادقة
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  /// إنشاء ملف المستخدم
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    required String fullName,
    String? phone,
  }) async {
    await _supabase.from('profiles').insert({
      'id': userId,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// الحصول على ملف المستخدم
  Future<UserModel?> getUserProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  /// تحديث ملف المستخدم
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? bio,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (fullName != null) updates['full_name'] = fullName;
    if (phone != null) updates['phone'] = phone;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (bio != null) updates['bio'] = bio;

    await _supabase
        .from('profiles')
        .update(updates)
        .eq('id', userId);
  }

  /// رفع صورة الملف الشخصي
  Future<String?> uploadAvatar(String userId, String filePath) async {
    final fileName = 'avatar_$userId.jpg';
    
    await _supabase.storage
        .from('avatars')
        .upload(fileName, File(filePath));

    final url = _supabase.storage
        .from('avatars')
        .getPublicUrl(fileName);

    await updateUserProfile(userId: userId, avatarUrl: url);

    return url;
  }

  /// حذف حساب المستخدم
  Future<void> deleteAccount(String userId) async {
    // حذف ملف المستخدم
    await _supabase.from('profiles').delete().eq('id', userId);
    
    // تسجيل الخروج
    await signOut();
  }

  /// تحديث وقت آخر تسجيل دخول
  Future<void> updateLastLogin(String userId) async {
    await _supabase.from('profiles').update({
      'last_login_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }
}
