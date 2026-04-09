/// نموذج حالة الطلب
class OrderStatus {
  final String id;
  final String orderId;
  final String status;
  final String? description;
  final String? location;
  final DateTime createdAt;
  final String? createdBy;

  OrderStatus({
    required this.id,
    required this.orderId,
    required this.status,
    this.description,
    this.location,
    required this.createdAt,
    this.createdBy,
  });

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'status': status,
      'description': description,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
    };
  }

  String get statusDisplay {
    final statusMap = {
      'pending': 'قيد الانتظار',
      'confirmed': 'تم التأكيد',
      'processing': 'قيد المعالجة',
      'packed': 'تم التغليف',
      'shipped': 'تم الشحن',
      'in_transit': 'في الطريق',
      'out_for_delivery': 'خارج للتوصيل',
      'delivered': 'تم التوصيل',
      'cancelled': 'ملغي',
      'refunded': 'مسترد',
      'returned': 'تم الإرجاع',
    };
    return statusMap[status] ?? status;
  }

  String get statusIcon {
    final iconMap = {
      'pending': '⏳',
      'confirmed': '✅',
      'processing': '⚙️',
      'packed': '📦',
      'shipped': '🚚',
      'in_transit': '🛣️',
      'out_for_delivery': '📍',
      'delivered': '🎉',
      'cancelled': '❌',
      'refunded': '💰',
      'returned': '↩️',
    };
    return iconMap[status] ?? '📋';
  }
}

/// حالات الطلب المتاحة
class OrderStatusValues {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String processing = 'processing';
  static const String packed = 'packed';
  static const String shipped = 'shipped';
  static const String inTransit = 'in_transit';
  static const String outForDelivery = 'out_for_delivery';
  static const String delivered = 'delivered';
  static const String cancelled = 'cancelled';
  static const String refunded = 'refunded';
  static const String returned = 'returned';

  static const List<String> all = [
    pending,
    confirmed,
    processing,
    packed,
    shipped,
    inTransit,
    outForDelivery,
    delivered,
    cancelled,
    refunded,
    returned,
  ];

  static const List<String> activeStatuses = [
    pending,
    confirmed,
    processing,
    packed,
    shipped,
    inTransit,
    outForDelivery,
  ];

  static const List<String> finalStatuses = [
    delivered,
    cancelled,
    refunded,
    returned,
  ];
}
