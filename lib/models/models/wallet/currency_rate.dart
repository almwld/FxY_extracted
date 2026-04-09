import 'package:flutter/foundation.dart';

/// نموذج سعر صرف العملة (Currency Rate)
/// يمثل سعر صرف العملة في التطبيق
@immutable
class CurrencyRate {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final double? previousRate;
  final DateTime updatedAt;
  final String? source;
  final bool isActive;
  final double? buyRate;
  final double? sellRate;
  final double? spread;

  const CurrencyRate({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    this.previousRate,
    required this.updatedAt,
    this.source,
    this.isActive = true,
    this.buyRate,
    this.sellRate,
    this.spread,
  });

  /// إنشاء نسخة من النموذج مع تعديلات
  CurrencyRate copyWith({
    String? id,
    String? fromCurrency,
    String? toCurrency,
    double? rate,
    double? previousRate,
    DateTime? updatedAt,
    String? source,
    bool? isActive,
    double? buyRate,
    double? sellRate,
    double? spread,
  }) {
    return CurrencyRate(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
      previousRate: previousRate ?? this.previousRate,
      updatedAt: updatedAt ?? this.updatedAt,
      source: source ?? this.source,
      isActive: isActive ?? this.isActive,
      buyRate: buyRate ?? this.buyRate,
      sellRate: sellRate ?? this.sellRate,
      spread: spread ?? this.spread,
    );
  }

  /// تحويل من JSON
  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      id: json['id'] as String,
      fromCurrency: json['from_currency'] as String,
      toCurrency: json['to_currency'] as String,
      rate: (json['rate'] as num).toDouble(),
      previousRate: (json['previous_rate'] as num?)?.toDouble(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      source: json['source'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      buyRate: (json['buy_rate'] as num?)?.toDouble(),
      sellRate: (json['sell_rate'] as num?)?.toDouble(),
      spread: (json['spread'] as num?)?.toDouble(),
    );
  }

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'rate': rate,
      'previous_rate': previousRate,
      'updated_at': updatedAt.toIso8601String(),
      'source': source,
      'is_active': isActive,
      'buy_rate': buyRate,
      'sell_rate': sellRate,
      'spread': spread,
    };
  }

  /// الحصول على زوج العملات
  String get currencyPair {
    return '$fromCurrency/$toCurrency';
  }

  /// حساب نسبة التغيير
  double? get changePercentage {
    if (previousRate == null || previousRate == 0) return null;
    return ((rate - previousRate!) / previousRate!) * 100;
  }

  /// التحقق مما إذا كان السعر قد ارتفع
  bool get isIncreased {
    if (previousRate == null) return false;
    return rate > previousRate!;
  }

  /// التحقق مما إذا كان السعر قد انخفض
  bool get isDecreased {
    if (previousRate == null) return false;
    return rate < previousRate!;
  }

  /// تحويل مبلغ من عملة إلى أخرى
  double convert(double amount) {
    return amount * rate;
  }

  /// تحويل مبلغ من عملة إلى أخرى (عكسي)
  double convertInverse(double amount) {
    if (rate == 0) return 0;
    return amount / rate;
  }

  /// الحصول على سعر الشراء
  double get effectiveBuyRate {
    return buyRate ?? rate;
  }

  /// الحصول على سعر البيع
  double get effectiveSellRate {
    return sellRate ?? rate;
  }

  /// الحصول على فارق السعر
  double get effectiveSpread {
    if (spread != null) return spread!;
    if (buyRate != null && sellRate != null) {
      return sellRate! - buyRate!;
    }
    return 0;
  }

  @override
  String toString() {
    return 'CurrencyRate($currencyPair: $rate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CurrencyRate && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// نموذج تحويل العملات
class CurrencyConversion {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double convertedAmount;
  final double rate;
  final double? fee;
  final DateTime timestamp;

  const CurrencyConversion({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.convertedAmount,
    required this.rate,
    this.fee,
    required this.timestamp,
  });

  /// الحصول على المبلغ الأصلي المنسق
  String get formattedAmount {
    return '${amount.toStringAsFixed(2)} $fromCurrency';
  }

  /// الحصول على المبلغ المحول المنسق
  String get formattedConvertedAmount {
    return '${convertedAmount.toStringAsFixed(2)} $toCurrency';
  }

  /// الحصول على الرسوم المنسقة
  String? get formattedFee {
    if (fee == null) return null;
    return '${fee!.toStringAsFixed(2)} $fromCurrency';
  }

  /// الحصول على المبلغ الإجمالي مع الرسوم
  double get totalAmount {
    return amount + (fee ?? 0);
  }

  /// الحصول على المبلغ الإجمالي المنسق
  String get formattedTotalAmount {
    return '${totalAmount.toStringAsFixed(2)} $fromCurrency';
  }
}
