/// نموذج الطلب
class OrderModel {
  final String id;
  final String orderNumber;
  final String userId;
  final String? userName;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingCost;
  final double tax;
  final double discount;
  final double total;
  final String currency;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String shippingAddress;
  final String? billingAddress;
  final String? trackingNumber;
  final String? shippingCarrier;
  final String? notes;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final String? cancelReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    this.userName,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.tax,
    this.discount = 0.0,
    required this.total,
    this.currency = 'YER',
    this.status = 'pending',
    this.paymentStatus = 'pending',
    required this.paymentMethod,
    required this.shippingAddress,
    this.billingAddress,
    this.trackingNumber,
    this.shippingCarrier,
    this.notes,
    this.shippedAt,
    this.deliveredAt,
    this.cancelledAt,
    this.cancelReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      shippingCost: (json['shipping_cost'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'YER',
      status: json['status'] as String? ?? 'pending',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      paymentMethod: json['payment_method'] as String,
      shippingAddress: json['shipping_address'] as String,
      billingAddress: json['billing_address'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      shippingCarrier: json['shipping_carrier'] as String?,
      notes: json['notes'] as String?,
      shippedAt: json['shipped_at'] != null
          ? DateTime.parse(json['shipped_at'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      cancelReason: json['cancel_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'user_id': userId,
      'user_name': userName,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
      'tax': tax,
      'discount': discount,
      'total': total,
      'currency': currency,
      'status': status,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
      'billing_address': billingAddress,
      'tracking_number': trackingNumber,
      'shipping_carrier': shippingCarrier,
      'notes': notes,
      'shipped_at': shippedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'cancel_reason': cancelReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? userId,
    String? userName,
    List<OrderItem>? items,
    double? subtotal,
    double? shippingCost,
    double? tax,
    double? discount,
    double? total,
    String? currency,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    String? shippingAddress,
    String? billingAddress,
    String? trackingNumber,
    String? shippingCarrier,
    String? notes,
    DateTime? shippedAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancelReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      shippingCarrier: shippingCarrier ?? this.shippingCarrier,
      notes: notes ?? this.notes,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancelReason: cancelReason ?? this.cancelReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isProcessing => status == 'processing';
  bool get isShipped => status == 'shipped';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  bool get isRefunded => status == 'refunded';

  bool get isPaid => paymentStatus == 'paid';
  bool get isPaymentPending => paymentStatus == 'pending';
  bool get isPaymentFailed => paymentStatus == 'failed';

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get statusDisplay {
    final statusMap = {
      'pending': 'قيد الانتظار',
      'processing': 'قيد المعالجة',
      'shipped': 'تم الشحن',
      'delivered': 'تم التوصيل',
      'cancelled': 'ملغي',
      'refunded': 'مسترد',
    };
    return statusMap[status] ?? status;
  }
}

/// عنصر الطلب
class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final double total;
  final String? variant;
  final Map<String, dynamic>? attributes;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    required this.total,
    this.variant,
    this.attributes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      productImage: json['product_image'] as String?,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      total: (json['total'] as num).toDouble(),
      variant: json['variant'] as String?,
      attributes: json['attributes'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'total': total,
      'variant': variant,
      'attributes': attributes,
    };
  }
}
