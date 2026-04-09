/// نموذج طريقة دفع المستخدم
class UserPaymentMethod {
  final String id;
  final String userId;
  final String type; // card, bank, wallet
  final String? cardNumber;
  final String? cardHolderName;
  final String? expiryDate;
  final String? cvv;
  final String? bankName;
  final String? accountNumber;
  final String? iban;
  final String? swiftCode;
  final String? walletProvider;
  final String? walletNumber;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserPaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.cvv,
    this.bankName,
    this.accountNumber,
    this.iban,
    this.swiftCode,
    this.walletProvider,
    this.walletNumber,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserPaymentMethod.fromJson(Map<String, dynamic> json) {
    return UserPaymentMethod(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      cardNumber: json['card_number'] as String?,
      cardHolderName: json['card_holder_name'] as String?,
      expiryDate: json['expiry_date'] as String?,
      cvv: json['cvv'] as String?,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      iban: json['iban'] as String?,
      swiftCode: json['swift_code'] as String?,
      walletProvider: json['wallet_provider'] as String?,
      walletNumber: json['wallet_number'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'card_number': cardNumber,
      'card_holder_name': cardHolderName,
      'expiry_date': expiryDate,
      'cvv': cvv,
      'bank_name': bankName,
      'account_number': accountNumber,
      'iban': iban,
      'swift_code': swiftCode,
      'wallet_provider': walletProvider,
      'wallet_number': walletNumber,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserPaymentMethod copyWith({
    String? id,
    String? userId,
    String? type,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cvv,
    String? bankName,
    String? accountNumber,
    String? iban,
    String? swiftCode,
    String? walletProvider,
    String? walletNumber,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserPaymentMethod(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      iban: iban ?? this.iban,
      swiftCode: swiftCode ?? this.swiftCode,
      walletProvider: walletProvider ?? this.walletProvider,
      walletNumber: walletNumber ?? this.walletNumber,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get displayName {
    switch (type) {
      case 'card':
        return 'بطاقة ${getCardType()} ${maskCardNumber()}';
      case 'bank':
        return 'حساب بنكي - $bankName';
      case 'wallet':
        return 'محفظة $walletProvider';
      default:
        return 'طريقة دفع';
    }
  }

  String getCardType() {
    if (cardNumber == null) return '';
    final number = cardNumber!.replaceAll(' ', '');
    if (number.startsWith('4')) return 'Visa';
    if (number.startsWith('5')) return 'Mastercard';
    if (number.startsWith('3')) return 'American Express';
    if (number.startsWith('6')) return 'Discover';
    return '';
  }

  String maskCardNumber() {
    if (cardNumber == null || cardNumber!.length < 4) return '';
    final last4 = cardNumber!.substring(cardNumber!.length - 4);
    return '**** $last4';
  }

  bool get isCard => type == 'card';
  bool get isBank => type == 'bank';
  bool get isWallet => type == 'wallet';
}
