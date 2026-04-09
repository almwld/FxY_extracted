import 'package:flutter/foundation.dart';

/// نموذج محفظة فليكس باي (FlexPay Wallet)
/// المحفظة الرقمية الرسمية لتطبيق Flex Yemen
@immutable
class FlexPayWallet {
  final String id;
  final String userId;
  final String phoneNumber;
  final double balance;
  final double frozenBalance;
  final String currency;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? accountName;
  final String? email;
  final double dailyLimit;
  final double monthlyLimit;
  final int loyaltyPoints;
  final String? referralCode;
  final int referralCount;

  const FlexPayWallet({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.balance,
    this.frozenBalance = 0.0,
    this.currency = 'YER',
    this.isVerified = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.accountName,
    this.email,
    this.dailyLimit = 1000000.0,
    this.monthlyLimit = 10000000.0,
    this.loyaltyPoints = 0,
    this.referralCode,
    this.referralCount = 0,
  });

  /// إنشاء نسخة من النموذج مع تعديلات
  FlexPayWallet copyWith({
    String? id,
    String? userId,
    String? phoneNumber,
    double? balance,
    double? frozenBalance,
    String? currency,
    bool? isVerified,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? accountName,
    String? email,
    double? dailyLimit,
    double? monthlyLimit,
    int? loyaltyPoints,
    String? referralCode,
    int? referralCount,
  }) {
    return FlexPayWallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      balance: balance ?? this.balance,
      frozenBalance: frozenBalance ?? this.frozenBalance,
      currency: currency ?? this.currency,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      accountName: accountName ?? this.accountName,
      email: email ?? this.email,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      referralCode: referralCode ?? this.referralCode,
      referralCount: referralCount ?? this.referralCount,
    );
  }

  /// تحويل من JSON
  factory FlexPayWallet.fromJson(Map<String, dynamic> json) {
    return FlexPayWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      balance: (json['balance'] as num).toDouble(),
      frozenBalance: (json['frozen_balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'YER',
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      accountName: json['account_name'] as String?,
      email: json['email'] as String?,
      dailyLimit: (json['daily_limit'] as num?)?.toDouble() ?? 1000000.0,
      monthlyLimit: (json['monthly_limit'] as num?)?.toDouble() ?? 10000000.0,
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
      referralCode: json['referral_code'] as String?,
      referralCount: json['referral_count'] as int? ?? 0,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'balance': balance,
      'frozen_balance': frozenBalance,
      'currency': currency,
      'is_verified': isVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'account_name': accountName,
      'email': email,
      'daily_limit': dailyLimit,
      'monthly_limit': monthlyLimit,
      'loyalty_points': loyaltyPoints,
      'referral_code': referralCode,
      'referral_count': referralCount,
    };
  }

  /// الحصول على الرصيد المنسق
  String get formattedBalance {
    return '${balance.toStringAsFixed(2)} $currency';
  }

  /// الحصول على الرصيد المتاح (الرصيد - الرصيد المجمد)
  double get availableBalance {
    return balance - frozenBalance;
  }

  /// الحصول على الرصيد المتاح المنسق
  String get formattedAvailableBalance {
    return '${availableBalance.toStringAsFixed(2)} $currency';
  }

  /// التحقق من وجود رصيد كافٍ
  bool hasSufficientBalance(double amount) {
    return availableBalance >= amount;
  }

  /// تحويل النقاط إلى رصيد
  double get pointsValue {
    return loyaltyPoints * 10.0; // كل نقطة = 10 ريال
  }

  @override
  String toString() {
    return 'FlexPayWallet(id: $id, phone: $phoneNumber, balance: $balance $currency, points: $loyaltyPoints)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlexPayWallet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
