import 'package:flutter/foundation.dart';

/// نموذج محفظة تل واي (TelY Wallet)
/// محفظة رقمية يمنية للمدفوعات الإلكترونية
@immutable
class TelYWallet {
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
  final String? operatorName;

  const TelYWallet({
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
    this.operatorName,
  });

  /// إنشاء نسخة من النموذج مع تعديلات
  TelYWallet copyWith({
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
    String? operatorName,
  }) {
    return TelYWallet(
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
      operatorName: operatorName ?? this.operatorName,
    );
  }

  /// تحويل من JSON
  factory TelYWallet.fromJson(Map<String, dynamic> json) {
    return TelYWallet(
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
      operatorName: json['operator_name'] as String?,
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
      'operator_name': operatorName,
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

  @override
  String toString() {
    return 'TelYWallet(id: $id, phone: $phoneNumber, balance: $balance $currency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TelYWallet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
