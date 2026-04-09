import 'package:flutter/foundation.dart';

/// نموذج محفظة واي باي (YPay Wallet)
/// محفظة رقمية يمنية للمدفوعات الإلكترونية
@immutable
class YPayWallet {
  final String id;
  final String userId;
  final String phoneNumber;
  final double balance;
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

  const YPayWallet({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.balance,
    this.currency = 'YER',
    this.isVerified = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.accountName,
    this.email,
    this.dailyLimit = 500000.0,
    this.monthlyLimit = 5000000.0,
    this.loyaltyPoints = 0,
  });

  /// إنشاء نسخة من النموذج مع تعديلات
  YPayWallet copyWith({
    String? id,
    String? userId,
    String? phoneNumber,
    double? balance,
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
  }) {
    return YPayWallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      balance: balance ?? this.balance,
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
    );
  }

  /// تحويل من JSON
  factory YPayWallet.fromJson(Map<String, dynamic> json) {
    return YPayWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'YER',
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      accountName: json['account_name'] as String?,
      email: json['email'] as String?,
      dailyLimit: (json['daily_limit'] as num?)?.toDouble() ?? 500000.0,
      monthlyLimit: (json['monthly_limit'] as num?)?.toDouble() ?? 5000000.0,
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'balance': balance,
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
    };
  }

  /// الحصول على الرصيد المنسق
  String get formattedBalance {
    return '${balance.toStringAsFixed(2)} $currency';
  }

  /// التحقق من وجود رصيد كافٍ
  bool hasSufficientBalance(double amount) {
    return balance >= amount;
  }

  /// تحويل النقاط إلى رصيد
  double get pointsValue {
    return loyaltyPoints * 10.0; // كل نقطة = 10 ريال
  }

  @override
  String toString() {
    return 'YPayWallet(id: $id, phone: $phoneNumber, balance: $balance $currency, points: $loyaltyPoints)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YPayWallet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
