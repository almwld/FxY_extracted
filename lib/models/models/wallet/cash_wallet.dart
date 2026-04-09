import 'package:flutter/foundation.dart';

/// نموذج محفظة كاش (Cash Wallet)
/// يمثل محفظة النقدية في التطبيق
@immutable
class CashWallet {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? walletName;
  final String? description;

  const CashWallet({
    required this.id,
    required this.userId,
    required this.balance,
    this.currency = 'YER',
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.walletName,
    this.description,
  });

  /// إنشاء نسخة من النموذج مع تعديلات
  CashWallet copyWith({
    String? id,
    String? userId,
    double? balance,
    String? currency,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? walletName,
    String? description,
  }) {
    return CashWallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      walletName: walletName ?? this.walletName,
      description: description ?? this.description,
    );
  }

  /// تحويل من JSON
  factory CashWallet.fromJson(Map<String, dynamic> json) {
    return CashWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'YER',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      walletName: json['wallet_name'] as String?,
      description: json['description'] as String?,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'currency': currency,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'wallet_name': walletName,
      'description': description,
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
    return 'CashWallet(id: $id, balance: $balance $currency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CashWallet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
