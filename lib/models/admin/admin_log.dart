/// نموذج سجل الأدمن
class AdminLog {
  final String id;
  final String adminId;
  final String? adminName;
  final String action;
  final String entityType;
  final String? entityId;
  final Map<String, dynamic>? oldData;
  final Map<String, dynamic>? newData;
  final String? description;
  final String? ipAddress;
  final String? userAgent;
  final DateTime createdAt;

  AdminLog({
    required this.id,
    required this.adminId,
    this.adminName,
    required this.action,
    required this.entityType,
    this.entityId,
    this.oldData,
    this.newData,
    this.description,
    this.ipAddress,
    this.userAgent,
    required this.createdAt,
  });

  factory AdminLog.fromJson(Map<String, dynamic> json) {
    return AdminLog(
      id: json['id'] as String,
      adminId: json['admin_id'] as String,
      adminName: json['admin_name'] as String?,
      action: json['action'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String?,
      oldData: json['old_data'] as Map<String, dynamic>?,
      newData: json['new_data'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'admin_name': adminName,
      'action': action,
      'entity_type': entityType,
      'entity_id': entityId,
      'old_data': oldData,
      'new_data': newData,
      'description': description,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AdminLog copyWith({
    String? id,
    String? adminId,
    String? adminName,
    String? action,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? oldData,
    Map<String, dynamic>? newData,
    String? description,
    String? ipAddress,
    String? userAgent,
    DateTime? createdAt,
  }) {
    return AdminLog(
      id: id ?? this.id,
      adminId: adminId ?? this.adminId,
      adminName: adminName ?? this.adminName,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      oldData: oldData ?? this.oldData,
      newData: newData ?? this.newData,
      description: description ?? this.description,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get actionDisplay {
    final actionMap = {
      'create': 'إنشاء',
      'update': 'تحديث',
      'delete': 'حذف',
      'approve': 'موافقة',
      'reject': 'رفض',
      'block': 'حظر',
      'unblock': 'إلغاء حظر',
      'login': 'تسجيل دخول',
      'logout': 'تسجيل خروج',
      'export': 'تصدير',
      'import': 'استيراد',
    };
    return actionMap[action] ?? action;
  }

  String get entityTypeDisplay {
    final typeMap = {
      'user': 'مستخدم',
      'product': 'منتج',
      'order': 'طلب',
      'ad': 'إعلان',
      'category': 'فئة',
      'seller': 'بائع',
      'coupon': 'كوبون',
      'setting': 'إعداد',
      'report': 'بلاغ',
    };
    return typeMap[entityType] ?? entityType;
  }
}

/// أنواع الإجراءات
class LogAction {
  static const String create = 'create';
  static const String update = 'update';
  static const String delete = 'delete';
  static const String approve = 'approve';
  static const String reject = 'reject';
  static const String block = 'block';
  static const String unblock = 'unblock';
  static const String login = 'login';
  static const String logout = 'logout';
  static const String export = 'export';
  static const String import = 'import';

  static const List<String> all = [
    create, update, delete, approve, reject, block, unblock, login, logout, export, import
  ];
}

/// أنواع الكيانات
class EntityType {
  static const String user = 'user';
  static const String product = 'product';
  static const String order = 'order';
  static const String ad = 'ad';
  static const String category = 'category';
  static const String seller = 'seller';
  static const String coupon = 'coupon';
  static const String setting = 'setting';
  static const String report = 'report';
  static const String wallet = 'wallet';

  static const List<String> all = [user, product, order, ad, category, seller, coupon, setting, report, wallet];
}
