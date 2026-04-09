/// نموذج المحفظة
class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final bool isActive;
  final double? dailyLimit;
  final double? monthlyLimit;
  final double? maxBalance;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletModel({
    required this.id,
    required this.userId,
    this.balance = 0.0,
    this.currency = 'YER',
    this.isActive = true,
    this.dailyLimit,
    this.monthlyLimit,
    this.maxBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'YER',
      isActive: json['is_active'] as bool? ?? true,
      dailyLimit: json['daily_limit'] != null
          ? (json['daily_limit'] as num).toDouble()
          : null,
      monthlyLimit: json['monthly_limit'] != null
          ? (json['monthly_limit'] as num).toDouble()
          : null,
      maxBalance: json['max_balance'] != null
          ? (json['max_balance'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'balance': balance,
      'currency': currency,
      'is_active': isActive,
      'daily_limit': dailyLimit,
      'monthly_limit': monthlyLimit,
      'max_balance': maxBalance,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  WalletModel copyWith({
    String? id,
    String? userId,
    double? balance,
    String? currency,
    bool? isActive,
    double? dailyLimit,
    double? monthlyLimit,
    double? maxBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      maxBalance: maxBalance ?? this.maxBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasBalance => balance > 0;
  bool get isEmpty => balance <= 0;

  bool canWithdraw(double amount) {
    return balance >= amount;
  }

  bool canDeposit(double amount) {
    if (maxBalance == null) return true;
    return (balance + amount) <= maxBalance!;
  }

  double get availableBalance => balance;
}
