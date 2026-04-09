import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user/user_model.dart';
import '../../models/user/user_address.dart';
import '../../models/user/user_payment_method.dart';
import '../../models/user/user_settings.dart';

/// خدمة المستخدمين
class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

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
  Future<UserModel> updateUserProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
  }) async {
    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (fullName != null) updates['full_name'] = fullName;
    if (phone != null) updates['phone'] = phone;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (bio != null) updates['bio'] = bio;
    if (dateOfBirth != null) updates['date_of_birth'] = dateOfBirth.toIso8601String();
    if (gender != null) updates['gender'] = gender;

    final response = await _supabase
        .from('profiles')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();

    return UserModel.fromJson(response);
  }

  /// رفع صورة الملف الشخصي
  Future<String> uploadAvatar(String userId, String filePath) async {
    final fileName = 'avatar_$userId.jpg';
    
    await _supabase.storage
        .from('avatars')
        .upload(fileName, filePath, fileOptions: const FileOptions(upsert: true));

    return _supabase.storage
        .from('avatars')
        .getPublicUrl(fileName);
  }

  /// ========== العناوين ==========

  /// إضافة عنوان
  Future<UserAddress> addAddress(UserAddress address) async {
    final response = await _supabase
        .from('addresses')
        .insert(address.toJson())
        .select()
        .single();

    return UserAddress.fromJson(response);
  }

  /// الحصول على عناوين المستخدم
  Future<List<UserAddress>> getUserAddresses(String userId) async {
    final response = await _supabase
        .from('addresses')
        .select()
        .eq('user_id', userId)
        .order('is_default', ascending: false);

    return (response as List)
        .map((json) => UserAddress.fromJson(json))
        .toList();
  }

  /// تحديث عنوان
  Future<UserAddress> updateAddress(UserAddress address) async {
    final response = await _supabase
        .from('addresses')
        .update(address.toJson())
        .eq('id', address.id)
        .select()
        .single();

    return UserAddress.fromJson(response);
  }

  /// حذف عنوان
  Future<void> deleteAddress(String addressId) async {
    await _supabase.from('addresses').delete().eq('id', addressId);
  }

  /// تعيين عنوان كافتراضي
  Future<void> setDefaultAddress(String userId, String addressId) async {
    // إزالة العنوان الافتراضي الحالي
    await _supabase.from('addresses').update({
      'is_default': false,
    }).eq('user_id', userId).eq('is_default', true);

    // تعيين العنوان الجديد كافتراضي
    await _supabase.from('addresses').update({
      'is_default': true,
    }).eq('id', addressId);
  }

  /// ========== طرق الدفع ==========

  /// إضافة طريقة دفع
  Future<UserPaymentMethod> addPaymentMethod(UserPaymentMethod method) async {
    final response = await _supabase
        .from('payment_methods')
        .insert(method.toJson())
        .select()
        .single();

    return UserPaymentMethod.fromJson(response);
  }

  /// الحصول على طرق دفع المستخدم
  Future<List<UserPaymentMethod>> getUserPaymentMethods(String userId) async {
    final response = await _supabase
        .from('payment_methods')
        .select()
        .eq('user_id', userId)
        .order('is_default', ascending: false);

    return (response as List)
        .map((json) => UserPaymentMethod.fromJson(json))
        .toList();
  }

  /// حذف طريقة دفع
  Future<void> deletePaymentMethod(String methodId) async {
    await _supabase.from('payment_methods').delete().eq('id', methodId);
  }

  /// تعيين طريقة دفع كافتراضية
  Future<void> setDefaultPaymentMethod(String userId, String methodId) async {
    // إزالة الافتراضي الحالي
    await _supabase.from('payment_methods').update({
      'is_default': false,
    }).eq('user_id', userId).eq('is_default', true);

    // تعيين الجديد كافتراضي
    await _supabase.from('payment_methods').update({
      'is_default': true,
    }).eq('id', methodId);
  }

  /// ========== الإعدادات ==========

  /// الحصول على إعدادات المستخدم
  Future<UserSettings?> getUserSettings(String userId) async {
    final response = await _supabase
        .from('user_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserSettings.fromJson(response);
  }

  /// إنشاء إعدادات المستخدم
  Future<UserSettings> createUserSettings(String userId) async {
    final settings = UserSettings(
      userId: userId,
      updatedAt: DateTime.now(),
    );

    final response = await _supabase
        .from('user_settings')
        .insert(settings.toJson())
        .select()
        .single();

    return UserSettings.fromJson(response);
  }

  /// تحديث إعدادات المستخدم
  Future<UserSettings> updateUserSettings(UserSettings settings) async {
    final response = await _supabase
        .from('user_settings')
        .update(settings.toJson())
        .eq('user_id', settings.userId)
        .select()
        .single();

    return UserSettings.fromJson(response);
  }

  /// ========== الإحصائيات ==========

  /// الحصول على إحصائيات المستخدم
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final ordersCount = await _supabase
        .from('orders')
        .select()
        .eq('user_id', userId)
        .count();

    final favoritesCount = await _supabase
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .count();

    final adsCount = await _supabase
        .from('ads')
        .select()
        .eq('user_id', userId)
        .count();

    return {
      'orders_count': ordersCount,
      'favorites_count': favoritesCount,
      'ads_count': adsCount,
    };
  }

  /// ========== قائمة الحظر ==========

  /// حظر مستخدم
  Future<void> blockUser(String userId, String blockedUserId) async {
    await _supabase.from('blocked_users').insert({
      'user_id': userId,
      'blocked_user_id': blockedUserId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// إلغاء حظر مستخدم
  Future<void> unblockUser(String userId, String blockedUserId) async {
    await _supabase
        .from('blocked_users')
        .delete()
        .eq('user_id', userId)
        .eq('blocked_user_id', blockedUserId);
  }

  /// الحصول على قائمة المحظورين
  Future<List<String>> getBlockedUsers(String userId) async {
    final response = await _supabase
        .from('blocked_users')
        .select('blocked_user_id')
        .eq('user_id', userId);

    return (response as List)
        .map((r) => r['blocked_user_id'] as String)
        .toList();
  }

  /// التحقق مما إذا كان المستخدم محظوراً
  Future<bool> isBlocked(String userId, String otherUserId) async {
    final response = await _supabase
        .from('blocked_users')
        .select()
        .eq('user_id', userId)
        .eq('blocked_user_id', otherUserId)
        .maybeSingle();

    return response != null;
  }
}
