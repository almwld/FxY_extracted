import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/ad/ad_model.dart';

/// خدمة الإعلانات
class AdService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// إنشاء إعلان جديد
  Future<AdModel> createAd(AdModel ad) async {
    final response = await _supabase
        .from('ads')
        .insert(ad.toJson())
        .select()
        .single();

    return AdModel.fromJson(response);
  }

  /// الحصول على إعلان بواسطة المعرف
  Future<AdModel?> getAdById(String adId) async {
    final response = await _supabase
        .from('ads')
        .select()
        .eq('id', adId)
        .single();

    if (response == null) return null;
    return AdModel.fromJson(response);
  }

  /// الحصول على جميع الإعلانات
  Future<List<AdModel>> getAds({
    String? categoryId,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    var query = _supabase.from('ads').select();

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    if (status != null) {
      query = query.eq('status', status);
    } else {
      query = query.eq('status', 'active');
    }

    final response = await query
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => AdModel.fromJson(json))
        .toList();
  }

  /// الحصول على إعلانات المستخدم
  Future<List<AdModel>> getUserAds(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _supabase
        .from('ads')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => AdModel.fromJson(json))
        .toList();
  }

  /// تحديث إعلان
  Future<AdModel> updateAd(AdModel ad) async {
    final response = await _supabase
        .from('ads')
        .update(ad.toJson())
        .eq('id', ad.id)
        .select()
        .single();

    return AdModel.fromJson(response);
  }

  /// حذف إعلان
  Future<void> deleteAd(String adId) async {
    await _supabase.from('ads').delete().eq('id', adId);
  }

  /// البحث في الإعلانات
  Future<List<AdModel>> searchAds(String query) async {
    final response = await _supabase
        .from('ads')
        .select()
        .eq('status', 'active')
        .or('title.ilike.%$query%,description.ilike.%$query%');

    return (response as List)
        .map((json) => AdModel.fromJson(json))
        .toList();
  }

  /// تحديث حالة الإعلان
  Future<void> updateAdStatus(
    String adId,
    String status, {
    String? rejectionReason,
  }) async {
    final updates = <String, dynamic>{
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (rejectionReason != null) {
      updates['rejection_reason'] = rejectionReason;
    }

    await _supabase.from('ads').update(updates).eq('id', adId);
  }

  /// زيادة عدد المشاهدات
  Future<void> incrementViewCount(String adId) async {
    await _supabase.rpc('increment_ad_views', params: {'ad_id': adId});
  }

  /// زيادة عدد المفضلة
  Future<void> incrementFavoriteCount(String adId) async {
    await _supabase.rpc('increment_ad_favorites', params: {'ad_id': adId});
  }

  /// تقليل عدد المفضلة
  Future<void> decrementFavoriteCount(String adId) async {
    await _supabase.rpc('decrement_ad_favorites', params: {'ad_id': adId});
  }

  /// الإبلاغ عن إعلان
  Future<void> reportAd({
    required String adId,
    required String reporterId,
    required String reason,
    String? description,
  }) async {
    await _supabase.from('reports').insert({
      'reported_type': 'ad',
      'reported_id': adId,
      'reporter_id': reporterId,
      'reason': reason,
      'description': description,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// تجديد إعلان
  Future<void> renewAd(String adId, {int days = 30}) async {
    final newExpiry = DateTime.now().add(Duration(days: days));
    
    await _supabase.from('ads').update({
      'status': 'active',
      'expires_at': newExpiry.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', adId);
  }

  /// تحديد إعلان كمباع
  Future<void> markAsSold(String adId) async {
    await _supabase.from('ads').update({
      'status': 'sold',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', adId);
  }

  /// الحصول على الإعلانات المميزة
  Future<List<AdModel>> getFeaturedAds({int limit = 10}) async {
    final response = await _supabase
        .from('ads')
        .select()
        .eq('status', 'active')
        .order('view_count', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => AdModel.fromJson(json))
        .toList();
  }

  /// رفع صورة إعلان
  Future<String> uploadAdImage(String adId, String filePath) async {
    final fileName = 'ad_${adId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    await _supabase.storage
        .from('ad_images')
        .upload(fileName, filePath);

    return _supabase.storage
        .from('ad_images')
        .getPublicUrl(fileName);
  }

  /// حذف صورة إعلان
  Future<void> deleteAdImage(String imageUrl) async {
    final fileName = imageUrl.split('/').last;
    await _supabase.storage.from('ad_images').remove([fileName]);
  }
}
