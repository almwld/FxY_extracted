import 'package:flutter/material.dart';
import '../models/order/order_model.dart';
import '../models/order/order_status.dart';
import '../services/supabase/order_service.dart';

/// مزود الطلبات
class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  
  List<OrderModel> _orders = [];
  OrderModel? _selectedOrder;
  List<OrderStatus> _orderStatuses = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  // Getters
  List<OrderModel> get orders => List.unmodifiable(_orders);
  OrderModel? get selectedOrder => _selectedOrder;
  List<OrderStatus> get orderStatuses => List.unmodifiable(_orderStatuses);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  bool get isEmpty => _orders.isEmpty;

  /// تحميل طلبات المستخدم
  Future<void> loadUserOrders(
    String userId, {
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _orders.clear();
    }

    if (!_hasMore || _isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      final orders = await _orderService.getUserOrders(
        userId,
        page: _currentPage,
      );

      if (orders.isEmpty) {
        _hasMore = false;
      } else {
        _orders.addAll(orders);
        _currentPage++;
      }
    } catch (e) {
      _setError('فشل تحميل الطلبات');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل طلب بواسطة المعرف
  Future<void> loadOrderById(String orderId) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedOrder = await _orderService.getOrderById(orderId);
      if (_selectedOrder == null) {
        _setError('الطلب غير موجود');
      } else {
        await loadOrderStatuses(orderId);
      }
    } catch (e) {
      _setError('فشل تحميل الطلب');
    } finally {
      _setLoading(false);
    }
  }

  /// تحميل حالات الطلب
  Future<void> loadOrderStatuses(String orderId) async {
    try {
      _orderStatuses = await _orderService.getOrderStatuses(orderId);
      notifyListeners();
    } catch (e) {
      // لا نعرض خطأ هنا
    }
  }

  /// إنشاء طلب جديد
  Future<OrderModel?> createOrder(OrderModel order) async {
    _setLoading(true);
    _clearError();

    try {
      final newOrder = await _orderService.createOrder(order);
      _orders.insert(0, newOrder);
      _setLoading(false);
      notifyListeners();
      return newOrder;
    } catch (e) {
      _setError('فشل إنشاء الطلب');
      _setLoading(false);
      return null;
    }
  }

  /// إلغاء الطلب
  Future<bool> cancelOrder(
    String orderId, {
    String? reason,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedOrder = await _orderService.cancelOrder(
        orderId,
        reason: reason,
      );

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        _orders[index] = updatedOrder;
      }

      if (_selectedOrder?.id == orderId) {
        _selectedOrder = updatedOrder;
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل إلغاء الطلب');
      _setLoading(false);
      return false;
    }
  }

  /// تأكيد استلام الطلب
  Future<bool> confirmDelivery(String orderId) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedOrder = await _orderService.confirmDelivery(orderId);

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        _orders[index] = updatedOrder;
      }

      if (_selectedOrder?.id == orderId) {
        _selectedOrder = updatedOrder;
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل تأكيد الاستلام');
      _setLoading(false);
      return false;
    }
  }

  /// طلب استرداد
  Future<bool> requestRefund(
    String orderId, {
    required String reason,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedOrder = await _orderService.requestRefund(
        orderId,
        reason: reason,
      );

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        _orders[index] = updatedOrder;
      }

      if (_selectedOrder?.id == orderId) {
        _selectedOrder = updatedOrder;
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل طلب الاسترداد');
      _setLoading(false);
      return false;
    }
  }

  /// تحديث حالة الطلب
  Future<bool> updateOrderStatus(
    String orderId,
    String status, {
    String? description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedOrder = await _orderService.updateOrderStatus(
        orderId,
        status,
        description: description,
      );

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        _orders[index] = updatedOrder;
      }

      if (_selectedOrder?.id == orderId) {
        _selectedOrder = updatedOrder;
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل تحديث حالة الطلب');
      _setLoading(false);
      return false;
    }
  }

  /// تعيين الطلب المحدد
  void setSelectedOrder(OrderModel? order) {
    _selectedOrder = order;
    notifyListeners();
  }

  /// مسح الطلبات
  void clearOrders() {
    _orders.clear();
    _currentPage = 1;
    _hasMore = true;
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

  /// مسح الخطأ
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
