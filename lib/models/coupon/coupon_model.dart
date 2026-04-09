/// نموذج الكوبون
class CouponModel {
  final String id;
  final String code;
  final String? description;
  final String discountType; // percentage, fixed_amount
  final double discountValue;
  final double? minOrderAmount;
  final double? maxDiscountAmount;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final int? usageLimit;
  final int usageCount;
  final int? perUserLimit;
  final List<String>? applicableCategories;
  final List<String>? applicableProducts;
  final List<String>? excludedProducts;
  final List<String>? applicableUsers;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CouponModel({
    required this.id,
    required this.code,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.minOrderAmount,
    this.maxDiscountAmount,
    this.startsAt,
    this.expiresAt,
    this.usageLimit,
    this.usageCount = 0,
    this.perUserLimit,
    this.applicableCategories,
    this.applicableProducts,
    this.excludedProducts,
    this.applicableUsers,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      discountType: json['discount_type'] as String,
      discountValue: (json['discount_value'] as num).toDouble(),
      minOrderAmount: json['min_order_amount'] != null
          ? (json['min_order_amount'] as num).toDouble()
          : null,
      maxDiscountAmount: json['max_discount_amount'] != null
          ? (json['max_discount_amount'] as num).toDouble()
          : null,
      startsAt: json['starts_at'] != null
          ? DateTime.parse(json['starts_at'] as String)
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      usageLimit: json['usage_limit'] as int?,
      usageCount: json['usage_count'] as int? ?? 0,
      perUserLimit: json['per_user_limit'] as int?,
      applicableCategories: (json['applicable_categories'] as List<dynamic>?)
          ?.cast<String>(),
      applicableProducts: (json['applicable_products'] as List<dynamic>?)
          ?.cast<String>(),
      excludedProducts: (json['excluded_products'] as List<dynamic>?)
          ?.cast<String>(),
      applicableUsers: (json['applicable_users'] as List<dynamic>?)
          ?.cast<String>(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_order_amount': minOrderAmount,
      'max_discount_amount': maxDiscountAmount,
      'starts_at': startsAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'usage_limit': usageLimit,
      'usage_count': usageCount,
      'per_user_limit': perUserLimit,
      'applicable_categories': applicableCategories,
      'applicable_products': applicableProducts,
      'excluded_products': excludedProducts,
      'applicable_users': applicableUsers,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CouponModel copyWith({
    String? id,
    String? code,
    String? description,
    String? discountType,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscountAmount,
    DateTime? startsAt,
    DateTime? expiresAt,
    int? usageLimit,
    int? usageCount,
    int? perUserLimit,
    List<String>? applicableCategories,
    List<String>? applicableProducts,
    List<String>? excludedProducts,
    List<String>? applicableUsers,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxDiscountAmount: maxDiscountAmount ?? this.maxDiscountAmount,
      startsAt: startsAt ?? this.startsAt,
      expiresAt: expiresAt ?? this.expiresAt,
      usageLimit: usageLimit ?? this.usageLimit,
      usageCount: usageCount ?? this.usageCount,
      perUserLimit: perUserLimit ?? this.perUserLimit,
      applicableCategories: applicableCategories ?? this.applicableCategories,
      applicableProducts: applicableProducts ?? this.applicableProducts,
      excludedProducts: excludedProducts ?? this.excludedProducts,
      applicableUsers: applicableUsers ?? this.applicableUsers,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPercentage => discountType == 'percentage';
  bool get isFixedAmount => discountType == 'fixed_amount';

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isNotStarted {
    if (startsAt == null) return false;
    return DateTime.now().isBefore(startsAt!);
  }

  bool get isValid => isActive && !isExpired && !isNotStarted;

  bool get hasUsageLimit => usageLimit != null && usageCount >= usageLimit!;

  double calculateDiscount(double orderAmount) {
    if (!isValid) return 0;
    if (minOrderAmount != null && orderAmount < minOrderAmount!) return 0;

    double discount;
    if (isPercentage) {
      discount = orderAmount * (discountValue / 100);
    } else {
      discount = discountValue;
    }

    if (maxDiscountAmount != null && discount > maxDiscountAmount!) {
      discount = maxDiscountAmount!;
    }

    return discount;
  }

  String get discountDisplay {
    if (isPercentage) {
      return '${discountValue.toStringAsFixed(0)}%';
    } else {
      return '${discountValue.toStringAsFixed(0)} ر.ي';
    }
  }

  String get formattedCode => code.toUpperCase();
}

/// أنواع الخصم
class DiscountType {
  static const String percentage = 'percentage';
  static const String fixedAmount = 'fixed_amount';

  static const List<String> all = [percentage, fixedAmount];
}

/// استخدام الكوبون
class CouponUsage {
  final String id;
  final String couponId;
  final String userId;
  final String? orderId;
  final double discountAmount;
  final DateTime usedAt;

  CouponUsage({
    required this.id,
    required this.couponId,
    required this.userId,
    this.orderId,
    required this.discountAmount,
    required this.usedAt,
  });

  factory CouponUsage.fromJson(Map<String, dynamic> json) {
    return CouponUsage(
      id: json['id'] as String,
      couponId: json['coupon_id'] as String,
      userId: json['user_id'] as String,
      orderId: json['order_id'] as String?,
      discountAmount: (json['discount_amount'] as num).toDouble(),
      usedAt: DateTime.parse(json['used_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coupon_id': couponId,
      'user_id': userId,
      'order_id': orderId,
      'discount_amount': discountAmount,
      'used_at': usedAt.toIso8601String(),
    };
  }
}
