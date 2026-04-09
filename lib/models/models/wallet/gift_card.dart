import 'package:flutter/foundation.dart';

/// نموذج بطاقة الهدايا (Gift Card)
/// يمثل بطاقة هدايا في التطبيق
@immutable
class GiftCard {
  final String id;
  final String code;
  final double amount;
  final String currency;
  final bool isRedeemed;
  final String? redeemedBy;
  final DateTime? redeemedAt;
  final DateTime expiryDate;
  final DateTime createdAt;
  final String? senderId;
  final String? recipientId;
  final String? message;
  final String? designUrl;
  final bool isActive;

  const GiftCard({
    required this.id,
    required this.code,
    required this.amount,
    this.currency = 'YER',
    this.isRedeemed = false,
    this.redeemedBy,
    this.redeemedAt,
    required this.expiryDate,
    required this.createdAt,
    this.senderId,
    this.recipientId,
    this.message,
    this.designUrl,
    this.isActive = true,
  });

  /// إنشاء نسخة من النموذج مع تعديلات
  GiftCard copyWith({
    String? id,
    String? code,
    double? amount,
    String? currency,
    bool? isRedeemed,
    String? redeemedBy,
    DateTime? redeemedAt,
    DateTime? expiryDate,
    DateTime? createdAt,
    String? senderId,
    String? recipientId,
    String? message,
    String? designUrl,
    bool? isActive,
  }) {
    return GiftCard(
      id: id ?? this.id,
      code: code ?? this.code,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      isRedeemed: isRedeemed ?? this.isRedeemed,
      redeemedBy: redeemedBy ?? this.redeemedBy,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      message: message ?? this.message,
      designUrl: designUrl ?? this.designUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  /// تحويل من JSON
  factory GiftCard.fromJson(Map<String, dynamic> json) {
    return GiftCard(
      id: json['id'] as String,
      code: json['code'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'YER',
      isRedeemed: json['is_redeemed'] as bool? ?? false,
      redeemedBy: json['redeemed_by'] as String?,
      redeemedAt: json['redeemed_at'] != null
          ? DateTime.parse(json['redeemed_at'] as String)
          : null,
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      senderId: json['sender_id'] as String?,
      recipientId: json['recipient_id'] as String?,
      message: json['message'] as String?,
      designUrl: json['design_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'amount': amount,
      'currency': currency,
      'is_redeemed': isRedeemed,
      'redeemed_by': redeemedBy,
      'redeemed_at': redeemedAt?.toIso8601String(),
      'expiry_date': expiryDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'sender_id': senderId,
      'recipient_id': recipientId,
      'message': message,
      'design_url': designUrl,
      'is_active': isActive,
    };
  }

  /// الحصول على المبلغ المنسق
  String get formattedAmount {
    return '${amount.toStringAsFixed(2)} $currency';
  }

  /// التحقق مما إذا كانت البطاقة منتهية الصلاحية
  bool get isExpired {
    return DateTime.now().isAfter(expiryDate);
  }

  /// التحقق مما إذا كانت البطاقة صالحة للاستخدام
  bool get isValid {
    return isActive && !isExpired && !isRedeemed;
  }

  /// الحصول على الأيام المتبقية للصلاحية
  int get daysUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(expiryDate)) return 0;
    return expiryDate.difference(now).inDays;
  }

  /// إخفاء جزء من الكود
  String get maskedCode {
    if (code.length <= 8) return code;
    return '${code.substring(0, 4)}****${code.substring(code.length - 4)}';
  }

  @override
  String toString() {
    return 'GiftCard(id: $id, code: $maskedCode, amount: $amount $currency, valid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GiftCard && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
