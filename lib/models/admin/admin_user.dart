/// نموذج مستخدم الأدمن
class AdminUser {
  final String id;
  final String userId;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final List<String> permissions;
  final bool isActive;
  final DateTime? lastLoginAt;
  final String? lastLoginIp;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminUser({
    required this.id,
    required this.userId,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    required this.permissions,
    this.isActive = true,
    this.lastLoginAt,
    this.lastLoginIp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      permissions: (json['permissions'] as List<dynamic>).cast<String>(),
      isActive: json['is_active'] as bool? ?? true,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      lastLoginIp: json['last_login_ip'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'role': role,
      'permissions': permissions,
      'is_active': isActive,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'last_login_ip': lastLoginIp,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AdminUser copyWith({
    String? id,
    String? userId,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? role,
    List<String>? permissions,
    bool? isActive,
    DateTime? lastLoginAt,
    String? lastLoginIp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminUser(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastLoginIp: lastLoginIp ?? this.lastLoginIp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isSuperAdmin => role == 'super_admin';
  bool get isAdmin => role == 'admin';
  bool get isModerator => role == 'moderator';
  bool get isSupport => role == 'support';

  bool hasPermission(String permission) {
    return permissions.contains(permission) || isSuperAdmin;
  }

  String get roleDisplay {
    final roleMap = {
      'super_admin': 'مدير النظام',
      'admin': 'مدير',
      'moderator': 'مشرف',
      'support': 'دعم فني',
    };
    return roleMap[role] ?? role;
  }
}

/// أدوار الأدمن
class AdminRole {
  static const String superAdmin = 'super_admin';
  static const String admin = 'admin';
  static const String moderator = 'moderator';
  static const String support = 'support';

  static const List<String> all = [superAdmin, admin, moderator, support];

  static const Map<String, List<String>> defaultPermissions = {
    superAdmin: [
      'users.view', 'users.manage', 'users.block',
      'products.view', 'products.manage', 'products.approve',
      'orders.view', 'orders.manage',
      'ads.view', 'ads.manage', 'ads.approve',
      'categories.view', 'categories.manage',
      'reports.view', 'reports.manage',
      'sellers.view', 'sellers.manage', 'sellers.approve',
      'coupons.view', 'coupons.manage',
      'settings.view', 'settings.manage',
      'logs.view',
      'admins.view', 'admins.manage',
    ],
    admin: [
      'users.view', 'users.block',
      'products.view', 'products.manage', 'products.approve',
      'orders.view', 'orders.manage',
      'ads.view', 'ads.manage', 'ads.approve',
      'categories.view', 'categories.manage',
      'reports.view', 'reports.manage',
      'sellers.view', 'sellers.manage', 'sellers.approve',
      'coupons.view', 'coupons.manage',
      'settings.view',
      'logs.view',
    ],
    moderator: [
      'users.view',
      'products.view', 'products.approve',
      'orders.view',
      'ads.view', 'ads.approve',
      'reports.view',
      'sellers.view', 'sellers.approve',
    ],
    support: [
      'users.view',
      'orders.view',
      'reports.view',
    ],
  };
}
