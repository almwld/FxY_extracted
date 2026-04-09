import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/notification/notification_model.dart';

/// خدمة الإشعارات
class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// إنشاء إشعار جديد
  Future<NotificationModel> createNotification({
    required String userId,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
  }) async {
    final notification = NotificationModel(
      id: '',
      userId: userId,
      type: type,
      title: title,
      body: body,
      data: data,
      imageUrl: imageUrl,
      actionUrl: actionUrl,
      createdAt: DateTime.now(),
    );

    final response = await _supabase
        .from('notifications')
        .insert(notification.toJson())
        .select()
        .single();

    return NotificationModel.fromJson(response);
  }

  /// الحصول على إشعارات المستخدم
  Future<List<NotificationModel>> getUserNotifications(
    String userId, {
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async {
    var query = _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId);

    if (unreadOnly) {
      query = query.eq('is_read', false);
    }

    final response = await query
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => NotificationModel.fromJson(json))
        .toList();
  }

  /// تحديد إشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    await _supabase.from('notifications').update({
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('id', notificationId);
  }

  /// تحديد جميع الإشعارات كمقروءة
  Future<void> markAllAsRead(String userId) async {
    await _supabase.from('notifications').update({
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('user_id', userId).eq('is_read', false);
  }

  /// حذف إشعار
  Future<void> deleteNotification(String notificationId) async {
    await _supabase.from('notifications').delete().eq('id', notificationId);
  }

  /// حذف جميع إشعارات المستخدم
  Future<void> deleteAllNotifications(String userId) async {
    await _supabase.from('notifications').delete().eq('user_id', userId);
  }

  /// الحصول على عدد الإشعارات غير المقروءة
  Future<int> getUnreadCount(String userId) async {
    final response = await _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('is_read', false);

    return (response as List).length;
  }

  /// الاستماع للإشعارات الجديدة
  Stream<List<Map<String, dynamic>>> subscribeToNotifications(String userId) {
    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  /// إرسال إشعار طلب
  Future<void> sendOrderNotification({
    required String userId,
    required String orderNumber,
    required String status,
  }) async {
    final statusMessages = {
      'pending': 'تم استلام طلبك',
      'confirmed': 'تم تأكيد طلبك',
      'processing': 'طلبك قيد المعالجة',
      'shipped': 'تم شحن طلبك',
      'delivered': 'تم توصيل طلبك',
      'cancelled': 'تم إلغاء طلبك',
    };

    await createNotification(
      userId: userId,
      type: 'order',
      title: 'تحديث الطلب #${orderNumber.substring(0, 8)}',
      body: statusMessages[status] ?? 'تحديث جديد على طلبك',
      data: {'order_number': orderNumber, 'status': status},
    );
  }

  /// إرسال إشعار دفع
  Future<void> sendPaymentNotification({
    required String userId,
    required double amount,
    required String type,
  }) async {
    final typeMessages = {
      'deposit': 'تم إيداع مبلغ $amount ر.ي في محفظتك',
      'withdraw': 'تم سحب مبلغ $amount ر.ي من محفظتك',
      'transfer': 'تم تحويل مبلغ $amount ر.ي',
    };

    await createNotification(
      userId: userId,
      type: 'payment',
      title: 'تحديث المحفظة',
      body: typeMessages[type] ?? 'معاملة جديدة',
      data: {'amount': amount, 'type': type},
    );
  }

  /// إرسال إشعار رسالة
  Future<void> sendMessageNotification({
    required String userId,
    required String senderName,
    required String messagePreview,
  }) async {
    await createNotification(
      userId: userId,
      type: 'message',
      title: 'رسالة جديدة من $senderName',
      body: messagePreview,
    );
  }

  /// إرسال إشعار ترويجي
  Future<void> sendPromotionalNotification({
    required String userId,
    required String title,
    required String body,
    String? actionUrl,
  }) async {
    await createNotification(
      userId: userId,
      type: 'promotion',
      title: title,
      body: body,
      actionUrl: actionUrl,
    );
  }
}
