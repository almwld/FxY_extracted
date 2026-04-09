/// نموذج الحساب البنكي
class WalletBankAccount {
  final String id;
  final String userId;
  final String walletId;
  final String bankName;
  final String? bankCode;
  final String accountHolderName;
  final String accountNumber;
  final String? iban;
  final String? swiftCode;
  final String? branchName;
  final String? branchCode;
  final String currency;
  final bool isDefault;
  final bool isVerified;
  final DateTime? verifiedAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletBankAccount({
    required this.id,
    required this.userId,
    required this.walletId,
    required this.bankName,
    this.bankCode,
    required this.accountHolderName,
    required this.accountNumber,
    this.iban,
    this.swiftCode,
    this.branchName,
    this.branchCode,
    this.currency = 'YER',
    this.isDefault = false,
    this.isVerified = false,
    this.verifiedAt,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletBankAccount.fromJson(Map<String, dynamic> json) {
    return WalletBankAccount(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      walletId: json['wallet_id'] as String,
      bankName: json['bank_name'] as String,
      bankCode: json['bank_code'] as String?,
      accountHolderName: json['account_holder_name'] as String,
      accountNumber: json['account_number'] as String,
      iban: json['iban'] as String?,
      swiftCode: json['swift_code'] as String?,
      branchName: json['branch_name'] as String?,
      branchCode: json['branch_code'] as String?,
      currency: json['currency'] as String? ?? 'YER',
      isDefault: json['is_default'] as bool? ?? false,
      isVerified: json['is_verified'] as bool? ?? false,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'wallet_id': walletId,
      'bank_name': bankName,
      'bank_code': bankCode,
      'account_holder_name': accountHolderName,
      'account_number': accountNumber,
      'iban': iban,
      'swift_code': swiftCode,
      'branch_name': branchName,
      'branch_code': branchCode,
      'currency': currency,
      'is_default': isDefault,
      'is_verified': isVerified,
      'verified_at': verifiedAt?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  WalletBankAccount copyWith({
    String? id,
    String? userId,
    String? walletId,
    String? bankName,
    String? bankCode,
    String? accountHolderName,
    String? accountNumber,
    String? iban,
    String? swiftCode,
    String? branchName,
    String? branchCode,
    String? currency,
    bool? isDefault,
    bool? isVerified,
    DateTime? verifiedAt,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletBankAccount(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      walletId: walletId ?? this.walletId,
      bankName: bankName ?? this.bankName,
      bankCode: bankCode ?? this.bankCode,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      iban: iban ?? this.iban,
      swiftCode: swiftCode ?? this.swiftCode,
      branchName: branchName ?? this.branchName,
      branchCode: branchCode ?? this.branchCode,
      currency: currency ?? this.currency,
      isDefault: isDefault ?? this.isDefault,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get maskedAccountNumber {
    if (accountNumber.length < 4) return accountNumber;
    final last4 = accountNumber.substring(accountNumber.length - 4);
    return '****$last4';
  }

  String get displayName => '$bankName - $maskedAccountNumber';
}

/// البنوك المتاحة في اليمن
class YemenBanks {
  static const List<Map<String, String>> banks = [
    {'code': 'CBOY', 'name': 'البنك المركزي اليمني'},
    {'code': 'YBR', 'name': 'بنك اليمن الدولي'},
    {'code': 'SABA', 'name': 'بنك صاب'},
    {'code': 'ARAB', 'name': 'البنك العربي'},
    {'code': 'CAIRO', 'name': 'بنك القاهرة'},
    {'code': 'KUWAIT', 'name': 'بنك الكويت الوطني'},
    {'code': 'RAFIDAIN', 'name': 'بنك الرافدين'},
    {'code': 'TADHAMON', 'name': 'بنك التضامن الإسلامي'},
    {'code': 'SHAMIL', 'name': 'بنك الشامل'},
    {'code': 'YEMEN_KUWAIT', 'name': 'البنك اليمني الكويتي'},
    {'code': 'ABU_DHABI', 'name': 'بنك أبوظبي الوطني'},
    {'code': 'AL_AHLI', 'name': 'البنك الأهلي اليمني'},
    {'code': 'AL_AMAL', 'name': 'بنك الأمل'},
    {'code': 'AL_IMAN', 'name': 'بنك الإيمان'},
    {'code': 'AL_KURUMI', 'name': 'بنك الكريمي'},
    {'code': 'AL_MUTAHID', 'name': 'بنك المتحد'},
    {'code': 'AL_SALAM', 'name': 'بنك السلام'},
    {'code': 'AL_WATANI', 'name': 'البنك الوطني'},
    {'code': 'AL_YEMENIA', 'name': 'بنك اليمنية'},
    {'code': 'AL_QUTAYBI', 'name': 'بنك القطيبي'},
  ];

  static String getBankName(String code) {
    return banks.firstWhere(
      (bank) => bank['code'] == code,
      orElse: () => {'name': code},
    )['name']!;
  }

  static String? getBankCode(String name) {
    return banks.firstWhere(
      (bank) => bank['name'] == name,
      orElse: () => {'code': ''},
    )['code'];
  }
}
