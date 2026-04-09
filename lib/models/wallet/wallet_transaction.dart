/// نموذج معاملة المحفظة
class WalletTransaction {
  final String id;
  final String walletId;
  final String userId;
  final String type; // deposit, withdraw, transfer, payment, refund
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String currency;
  final String status; // pending, completed, failed, cancelled
  final String? description;
  final String? referenceId;
  final String? referenceType;
  final String? recipientId;
  final String? recipientName;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? completedAt;

  WalletTransaction({
    required this.id,
    required this.walletId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    this.currency = 'YER',
    this.status = 'pending',
    this.description,
    this.referenceId,
    this.referenceType,
    this.recipientId,
    this.recipientName,
    this.metadata,
    required this.createdAt,
    this.completedAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] as String,
      walletId: json['wallet_id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      balanceBefore: (json['balance_before'] as num).toDouble(),
      balanceAfter: (json['balance_after'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'YER',
      status: json['status'] as String? ?? 'pending',
      description: json['description'] as String?,
      referenceId: json['reference_id'] as String?,
      referenceType: json['reference_type'] as String?,
      recipientId: json['recipient_id'] as String?,
      recipientName: json['recipient_name'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'user_id': userId,
      'type': type,
      'amount': amount,
      'balance_before': balanceBefore,
      'balance_after': balanceAfter,
      'currency': currency,
      'status': status,
      'description': description,
      'reference_id': referenceId,
      'reference_type': referenceType,
      'recipient_id': recipientId,
      'recipient_name': recipientName,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  WalletTransaction copyWith({
    String? id,
    String? walletId,
    String? userId,
    String? type,
    double? amount,
    double? balanceBefore,
    double? balanceAfter,
    String? currency,
    String? status,
    String? description,
    String? referenceId,
    String? referenceType,
    String? recipientId,
    String? recipientName,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return WalletTransaction(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      balanceBefore: balanceBefore ?? this.balanceBefore,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      description: description ?? this.description,
      referenceId: referenceId ?? this.referenceId,
      referenceType: referenceType ?? this.referenceType,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isDeposit => type == 'deposit';
  bool get isWithdraw => type == 'withdraw';
  bool get isTransfer => type == 'transfer';
  bool get isPayment => type == 'payment';
  bool get isRefund => type == 'refund';

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isCancelled => status == 'cancelled';

  bool get isIncoming => isDeposit || isRefund || (isTransfer && amount > 0);
  bool get isOutgoing => isWithdraw || isPayment || (isTransfer && amount < 0);

  String get typeDisplay {
    final typeMap = {
      'deposit': 'إيداع',
      'withdraw': 'سحب',
      'transfer': 'تحويل',
      'payment': 'دفع',
      'refund': 'استرداد',
      'fee': 'رسوم',
      'bonus': 'مكافأة',
    };
    return typeMap[type] ?? type;
  }

  String get statusDisplay {
    final statusMap = {
      'pending': 'قيد الانتظار',
      'completed': 'مكتمل',
      'failed': 'فاشل',
      'cancelled': 'ملغي',
      'processing': 'قيد المعالجة',
    };
    return statusMap[status] ?? status;
  }

  String get formattedAmount {
    final prefix = isIncoming ? '+' : '-';
    return '$prefix${amount.abs().toStringAsFixed(2)} $currency';
  }
}

/// أنواع المعاملات
class TransactionTypes {
  static const String deposit = 'deposit';
  static const String withdraw = 'withdraw';
  static const String transfer = 'transfer';
  static const String payment = 'payment';
  static const String refund = 'refund';
  static const String fee = 'fee';
  static const String bonus = 'bonus';

  static const List<String> all = [
    deposit,
    withdraw,
    transfer,
    payment,
    refund,
    fee,
    bonus,
  ];
}

/// حالات المعاملات
class TransactionStatuses {
  static const String pending = 'pending';
  static const String processing = 'processing';
  static const String completed = 'completed';
  static const String failed = 'failed';
  static const String cancelled = 'cancelled';

  static const List<String> all = [
    pending,
    processing,
    completed,
    failed,
    cancelled,
  ];
}
