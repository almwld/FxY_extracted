import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/order/order_model.dart';
import '../../models/order/order_status.dart';
import '../../models/order/order_tracking.dart';

/// خدمة الطلبات
class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// إنشاء طلب جديد
  Future<OrderModel> createOrder(OrderModel order) async {
    final response = await _supabase
        .from('orders')
        .insert(order.toJson())
        .select()
        .single();

    // إضافة حالة الطلب الأولى
    await _addOrderStatus(
      orderId: response['id'],
      status: 'pending',
      description: 'تم تقديم الطلب',
    );

    return OrderModel.fromJson(response);
  }

  /// الحصول على طلب بواسطة المعرف
  Future<OrderModel?> getOrderById(String orderId) async {
    final response = await _supabase
        .from('orders')
        .select()
        .eq('id', orderId)
        .single();

    if (response == null) return null;
    return OrderModel.fromJson(response);
  }

  /// الحصول على طلبات المستخدم
  Future<List<OrderModel>> getUserOrders(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _supabase
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }

  /// الحصول على طلبات البائع
  Future<List<OrderModel>> getSellerOrders(
    String sellerId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _supabase
        .from('orders')
        .select()
        .eq('seller_id', sellerId)
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => OrderModel.fromJson(json))
        .toList();
  }

  /// تحديث حالة الطلب
  Future<OrderModel> updateOrderStatus(
    String orderId,
    String status, {
    String? description,
    String? location,
  }) async {
    final response = await _supabase
        .from('orders')
        .update({'status': status})
        .eq('id', orderId)
        .select()
        .single();

    // إضافة حالة جديدة
    await _addOrderStatus(
      orderId: orderId,
      status: status,
      description: description,
      location: location,
    );

    return OrderModel.fromJson(response);
  }

  /// إضافة حالة للطلب
  Future<void> _addOrderStatus({
    required String orderId,
    required String status,
    String? description,
    String? location,
  }) async {
    await _supabase.from('order_statuses').insert({
      'order_id': orderId,
      'status': status,
      'description': description,
      'location': location,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// الحصول على حالات الطلب
  Future<List<OrderStatus>> getOrderStatuses(String orderId) async {
    final response = await _supabase
        .from('order_statuses')
        .select()
        .eq('order_id', orderId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => OrderStatus.fromJson(json))
        .toList();
  }

  /// إلغاء الطلب
  Future<OrderModel> cancelOrder(
    String orderId, {
    String? reason,
  }) async {
    final response = await _supabase
        .from('orders')
        .update({
          'status': 'cancelled',
          'cancel_reason': reason,
          'cancelled_at': DateTime.now().toIso8601String(),
        })
        .eq('id', orderId)
        .select()
        .single();

    await _addOrderStatus(
      orderId: orderId,
      status: 'cancelled',
      description: reason ?? 'تم إلغاء الطلب',
    );

    return OrderModel.fromJson(response);
  }

  /// إضافة تتبع للطلب
  Future<void> addOrderTracking(OrderTracking tracking) async {
    await _supabase.from('order_tracking').insert(tracking.toJson());
  }

  /// الحصول على تتبع الطلب
  Future<OrderTracking?> getOrderTracking(String orderId) async {
    final response = await _supabase
        .from('order_tracking')
        .select()
        .eq('order_id', orderId)
        .maybeSingle();

    if (response == null) return null;
    return OrderTracking.fromJson(response);
  }

  /// تحديث رقم التتبع
  Future<void> updateTrackingNumber(
    String orderId,
    String trackingNumber,
    String carrier,
  ) async {
    await _supabase.from('orders').update({
      'tracking_number': trackingNumber,
      'shipping_carrier': carrier,
      'shipped_at': DateTime.now().toIso8601String(),
      'status': 'shipped',
    }).eq('id', orderId);

    await _addOrderStatus(
      orderId: orderId,
      status: 'shipped',
      description: 'تم شحن الطلب',
    );
  }

  /// تأكيد استلام الطلب
  Future<OrderModel> confirmDelivery(String orderId) async {
    final response = await _supabase
        .from('orders')
        .update({
          'status': 'delivered',
          'delivered_at': DateTime.now().toIso8601String(),
        })
        .eq('id', orderId)
        .select()
        .single();

    await _addOrderStatus(
      orderId: orderId,
      status: 'delivered',
      description: 'تم توصيل الطلب بنجاح',
    );

    return OrderModel.fromJson(response);
  }

  /// طلب استرداد
  Future<OrderModel> requestRefund(
    String orderId, {
    required String reason,
  }) async {
    final response = await _supabase
        .from('orders')
        .update({
          'status': 'refund_requested',
          'refund_reason': reason,
        })
        .eq('id', orderId)
        .select()
        .single();

    return OrderModel.fromJson(response);
  }

  /// معالجة الاسترداد
  Future<OrderModel> processRefund(
    String orderId, {
    required bool approved,
    String? notes,
  }) async {
    final status = approved ? 'refunded' : 'refund_rejected';
    
    final response = await _supabase
        .from('orders')
        .update({
          'status': status,
          'refund_notes': notes,
        })
        .eq('id', orderId)
        .select()
        .single();

    return OrderModel.fromJson(response);
  }

  /// الحصول على إحصائيات الطلبات
  Future<Map<String, dynamic>> getOrderStats(String userId) async {
    final response = await _supabase
        .from('orders')
        .select('status')
        .eq('user_id', userId);

    final orders = response as List;
    
    return {
      'total': orders.length,
      'pending': orders.where((o) => o['status'] == 'pending').length,
      'processing': orders.where((o) => o['status'] == 'processing').length,
      'shipped': orders.where((o) => o['status'] == 'shipped').length,
      'delivered': orders.where((o) => o['status'] == 'delivered').length,
      'cancelled': orders.where((o) => o['status'] == 'cancelled').length,
    };
  }

  /// الاستماع لتغييرات الطلب
  Stream<List<Map<String, dynamic>>> subscribeToOrderUpdates(String orderId) {
    return _supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', orderId);
  }
}
