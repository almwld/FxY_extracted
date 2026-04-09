/// نموذج الإشعار
class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final String? actionUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.imageUrl,
    this.actionUrl,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>?,
      imageUrl: json['image_url'] as String?,
      actionUrl: json['action_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get icon {
    final iconMap = {
      'order': '📦',
      'payment': '💰',
      'message': '💬',
      'promotion': '🎁',
      'system': '🔔',
      'wallet': '💳',
      'product': '🛍️',
      'review': '⭐',
      'admin': '👤',
      'security': '🔒',
    };
    return iconMap[type] ?? '🔔';
  }

  String get typeDisplay {
    final typeMap = {
      'order': 'طلب',
      'payment': 'دفع',
      'message': 'رسالة',
      'promotion': 'عرض',
      'system': 'نظام',
      'wallet': 'محفظة',
      'product': 'منتج',
      'review': 'تقييم',
      'admin': 'إداري',
      'security': 'أمان',
    };
    return typeMap[type] ?? type;
  }
}

/// أنواع الإشعارات
class NotificationType {
  static const String order = 'order';
  static const String payment = 'payment';
  static const String message = 'message';
  static const String promotion = 'promotion';
  static const String system = 'system';
  static const String wallet = 'wallet';
  static const String product = 'product';
  static const String review = 'review';
  static const String admin = 'admin';
  static const String security = 'security';

  static const List<String> all = [
    order,
    payment,
    message,
    promotion,
    system,
    wallet,
    product,
    review,
    admin,
    security,
  ];
}
