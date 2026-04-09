/// نموذج بطاقة المحفظة
class WalletCard {
  final String id;
  final String userId;
  final String walletId;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final String? cardType;
  final bool isVirtual;
  final bool isDefault;
  final bool isActive;
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletCard({
    required this.id,
    required this.userId,
    required this.walletId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    this.cardType,
    this.isVirtual = false,
    this.isDefault = false,
    this.isActive = true,
    this.issuedAt,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletCard.fromJson(Map<String, dynamic> json) {
    return WalletCard(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      walletId: json['wallet_id'] as String,
      cardNumber: json['card_number'] as String,
      cardHolderName: json['card_holder_name'] as String,
      expiryDate: json['expiry_date'] as String,
      cvv: json['cvv'] as String,
      cardType: json['card_type'] as String?,
      isVirtual: json['is_virtual'] as bool? ?? false,
      isDefault: json['is_default'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      issuedAt: json['issued_at'] != null
          ? DateTime.parse(json['issued_at'] as String)
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'wallet_id': walletId,
      'card_number': cardNumber,
      'card_holder_name': cardHolderName,
      'expiry_date': expiryDate,
      'cvv': cvv,
      'card_type': cardType,
      'is_virtual': isVirtual,
      'is_default': isDefault,
      'is_active': isActive,
      'issued_at': issuedAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  WalletCard copyWith({
    String? id,
    String? userId,
    String? walletId,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cvv,
    String? cardType,
    bool? isVirtual,
    bool? isDefault,
    bool? isActive,
    DateTime? issuedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletCard(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      walletId: walletId ?? this.walletId,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      cardType: cardType ?? this.cardType,
      isVirtual: isVirtual ?? this.isVirtual,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get maskedNumber {
    if (cardNumber.length < 4) return cardNumber;
    final last4 = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $last4';
  }

  String get formattedNumber {
    final buffer = StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(cardNumber[i]);
    }
    return buffer.toString();
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  String get detectedType {
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5')) return 'Mastercard';
    if (cardNumber.startsWith('3')) return 'American Express';
    if (cardNumber.startsWith('6')) return 'Discover';
    return 'Unknown';
  }
}
