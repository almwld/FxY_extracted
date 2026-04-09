/// نموذج المحفظة اليمنية - كاش
class CashWallet {
  final String id;
  final String userId;
  final String provider;
  final String accountNumber;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CashWallet({
    required this.id,
    required this.userId,
    this.provider = 'Cash',
    required this.accountNumber,
    this.balance = 0.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CashWallet.fromJson(Map<String, dynamic> json) {
    return CashWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      provider: json['provider'] as String? ?? 'Cash',
      accountNumber: json['account_number'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider': provider,
      'account_number': accountNumber,
      'balance': balance,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// نموذج محفظة YOU
class YouWallet {
  final String id;
  final String userId;
  final String phoneNumber;
  final double balance;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  YouWallet({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    this.balance = 0.0,
    this.isVerified = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory YouWallet.fromJson(Map<String, dynamic> json) {
    return YouWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'balance': balance,
      'is_verified': isVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// نموذج محفظة YPay
class YpayWallet {
  final String id;
  final String userId;
  final String phoneNumber;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  YpayWallet({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    this.balance = 0.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory YpayWallet.fromJson(Map<String, dynamic> json) {
    return YpayWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'balance': balance,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// نموذج محفظة MyCash
class MycashWallet {
  final String id;
  final String userId;
  final String phoneNumber;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  MycashWallet({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    this.balance = 0.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MycashWallet.fromJson(Map<String, dynamic> json) {
    return MycashWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'balance': balance,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// نموذج محفظة TelY
class TelYWallet {
  final String id;
  final String userId;
  final String phoneNumber;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  TelYWallet({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    this.balance = 0.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TelYWallet.fromJson(Map<String, dynamic> json) {
    return TelYWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'balance': balance,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// نموذج محفظة FlexPay
class FlexPayWallet {
  final String id;
  final String userId;
  final String phoneNumber;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  FlexPayWallet({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    this.balance = 0.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FlexPayWallet.fromJson(Map<String, dynamic> json) {
    return FlexPayWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'balance': balance,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// نموذج محفظة يمن موبايل
class YemenMobileWallet {
  final String id;
  final String userId;
  final String phoneNumber;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  YemenMobileWallet({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    this.balance = 0.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory YemenMobileWallet.fromJson(Map<String, dynamic> json) {
    return YemenMobileWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'balance': balance,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// نموذج محفظة سبأفون
class SabafonWallet {
  final String id;
  final String userId;
  final String phoneNumber;
  final double balance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  SabafonWallet({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    this.balance = 0.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SabafonWallet.fromJson(Map<String, dynamic> json) {
    return SabafonWallet(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      phoneNumber: json['phone_number'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'phone_number': phoneNumber,
      'balance': balance,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// نموذج بطاقة الهدايا
class GiftCard {
  final String id;
  final String code;
  final double amount;
  final double? balance;
  final String currency;
  final DateTime? expiresAt;
  final bool isRedeemed;
  final String? redeemedBy;
  final DateTime? redeemedAt;
  final bool isActive;
  final DateTime createdAt;

  GiftCard({
    required this.id,
    required this.code,
    required this.amount,
    this.balance,
    this.currency = 'YER',
    this.expiresAt,
    this.isRedeemed = false,
    this.redeemedBy,
    this.redeemedAt,
    this.isActive = true,
    required this.createdAt,
  });

  factory GiftCard.fromJson(Map<String, dynamic> json) {
    return GiftCard(
      id: json['id'] as String,
      code: json['code'] as String,
      amount: (json['amount'] as num).toDouble(),
      balance: json['balance'] != null ? (json['balance'] as num).toDouble() : null,
      currency: json['currency'] as String? ?? 'YER',
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      isRedeemed: json['is_redeemed'] as bool? ?? false,
      redeemedBy: json['redeemed_by'] as String?,
      redeemedAt: json['redeemed_at'] != null
          ? DateTime.parse(json['redeemed_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'amount': amount,
      'balance': balance,
      'currency': currency,
      'expires_at': expiresAt?.toIso8601String(),
      'is_redeemed': isRedeemed,
      'redeemed_by': redeemedBy,
      'redeemed_at': redeemedAt?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isValid => isActive && !isExpired && !isRedeemed;

  double get remainingBalance => balance ?? amount;
}

/// نموذج سعر الصرف
class CurrencyRate {
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime updatedAt;

  CurrencyRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.updatedAt,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> json) {
    return CurrencyRate(
      fromCurrency: json['from_currency'] as String,
      toCurrency: json['to_currency'] as String,
      rate: (json['rate'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'rate': rate,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double convert(double amount) {
    return amount * rate;
  }
}

/// مزودي المحافظ اليمنية
class YemeniWalletProviders {
  static const List<Map<String, dynamic>> providers = [
    {
      'id': 'cash',
      'name': 'كاش',
      'logo': 'cash_logo',
      'color': '#4CAF50',
      'phonePattern': r'^7[0-9]{8}$',
    },
    {
      'id': 'you',
      'name': 'YOU',
      'logo': 'you_logo',
      'color': '#2196F3',
      'phonePattern': r'^7[0-9]{8}$',
    },
    {
      'id': 'ypay',
      'name': 'YPay',
      'logo': 'ypay_logo',
      'color': '#9C27B0',
      'phonePattern': r'^7[0-9]{8}$',
    },
    {
      'id': 'mycash',
      'name': 'MyCash',
      'logo': 'mycash_logo',
      'color': '#FF9800',
      'phonePattern': r'^7[0-9]{8}$',
    },
    {
      'id': 'tely',
      'name': 'TelY',
      'logo': 'tely_logo',
      'color': '#F44336',
      'phonePattern': r'^7[0-9]{8}$',
    },
    {
      'id': 'flexpay',
      'name': 'فلكس باي',
      'logo': 'flexpay_logo',
      'color': '#00BCD4',
      'phonePattern': r'^7[0-9]{8}$',
    },
    {
      'id': 'yemenmobile',
      'name': 'يمن موبايل',
      'logo': 'yemenmobile_logo',
      'color': '#3F51B5',
      'phonePattern': r'^7[0-9]{8}$',
    },
    {
      'id': 'sabafon',
      'name': 'سبأفون',
      'logo': 'sabafon_logo',
      'color': '#E91E63',
      'phonePattern': r'^7[0-9]{8}$',
    },
  ];

  static Map<String, dynamic>? getProvider(String id) {
    try {
      return providers.firstWhere((p) => p['id'] == id);
    } catch (e) {
      return null;
    }
  }

  static String getProviderName(String id) {
    return getProvider(id)?['name'] ?? id;
  }

  static String getProviderColor(String id) {
    return getProvider(id)?['color'] ?? '#000000';
  }
}
