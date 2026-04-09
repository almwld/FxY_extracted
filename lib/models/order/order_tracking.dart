/// نموذج تتبع الطلب
class OrderTracking {
  final String id;
  final String orderId;
  final String trackingNumber;
  final String carrier;
  final String? carrierUrl;
  final List<TrackingEvent> events;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderTracking({
    required this.id,
    required this.orderId,
    required this.trackingNumber,
    required this.carrier,
    this.carrierUrl,
    required this.events,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      trackingNumber: json['tracking_number'] as String,
      carrier: json['carrier'] as String,
      carrierUrl: json['carrier_url'] as String?,
      events: (json['events'] as List<dynamic>)
          .map((e) => TrackingEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'tracking_number': trackingNumber,
      'carrier': carrier,
      'carrier_url': carrierUrl,
      'events': events.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TrackingEvent? get latestEvent => events.isNotEmpty ? events.first : null;
  bool get isDelivered => events.any((e) => e.status == 'delivered');
  DateTime? get estimatedDelivery {
    final event = events.firstWhere(
      (e) => e.status == 'out_for_delivery',
      orElse: () => events.first,
    );
    return event.estimatedDelivery;
  }
}

/// حدث التتبع
class TrackingEvent {
  final String id;
  final String status;
  final String? description;
  final String? location;
  final DateTime timestamp;
  final DateTime? estimatedDelivery;
  final bool isCompleted;

  TrackingEvent({
    required this.id,
    required this.status,
    this.description,
    this.location,
    required this.timestamp,
    this.estimatedDelivery,
    this.isCompleted = false,
  });

  factory TrackingEvent.fromJson(Map<String, dynamic> json) {
    return TrackingEvent(
      id: json['id'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'] as String)
          : null,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'description': description,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
      'is_completed': isCompleted,
    };
  }

  String get statusDisplay {
    final statusMap = {
      'order_placed': 'تم تقديم الطلب',
      'order_confirmed': 'تم تأكيد الطلب',
      'order_processed': 'تم معالجة الطلب',
      'order_packed': 'تم تغليف الطلب',
      'shipped': 'تم الشحن',
      'in_transit': 'في الطريق',
      'out_for_delivery': 'خارج للتوصيل',
      'delivered': 'تم التوصيل',
      'failed_delivery': 'فشل التوصيل',
      'returned': 'تم الإرجاع',
    };
    return statusMap[status] ?? status;
  }

  String get statusIcon {
    final iconMap = {
      'order_placed': '🛒',
      'order_confirmed': '✅',
      'order_processed': '⚙️',
      'order_packed': '📦',
      'shipped': '🚚',
      'in_transit': '🛣️',
      'out_for_delivery': '📍',
      'delivered': '🎉',
      'failed_delivery': '⚠️',
      'returned': '↩️',
    };
    return iconMap[status] ?? '📋';
  }
}

/// شركات الشحن
class ShippingCarriers {
  static const Map<String, Map<String, String>> carriers = {
    'aramex': {
      'name': 'Aramex',
      'url': 'https://www.aramex.com/track',
    },
    'dhl': {
      'name': 'DHL',
      'url': 'https://www.dhl.com/track',
    },
    'fedex': {
      'name': 'FedEx',
      'url': 'https://www.fedex.com/track',
    },
    'ups': {
      'name': 'UPS',
      'url': 'https://www.ups.com/track',
    },
    'local': {
      'name': 'الشحن المحلي',
      'url': '',
    },
  };

  static String getCarrierName(String code) {
    return carriers[code]?['name'] ?? code;
  }

  static String? getCarrierUrl(String code) {
    return carriers[code]?['url'];
  }
}
