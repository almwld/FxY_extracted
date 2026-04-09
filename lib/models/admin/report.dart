/// نموذج البلاغ
class Report {
  final String id;
  final String reporterId;
  final String? reporterName;
  final String reportedType; // user, product, ad, review, message
  final String reportedId;
  final String? reportedUserId;
  final String reason;
  final String? description;
  final List<String>? evidenceUrls;
  final String status; // pending, investigating, resolved, dismissed
  final String? resolution;
  final String? resolvedBy;
  final DateTime? resolvedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Report({
    required this.id,
    required this.reporterId,
    this.reporterName,
    required this.reportedType,
    required this.reportedId,
    this.reportedUserId,
    required this.reason,
    this.description,
    this.evidenceUrls,
    this.status = 'pending',
    this.resolution,
    this.resolvedBy,
    this.resolvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      reporterId: json['reporter_id'] as String,
      reporterName: json['reporter_name'] as String?,
      reportedType: json['reported_type'] as String,
      reportedId: json['reported_id'] as String,
      reportedUserId: json['reported_user_id'] as String?,
      reason: json['reason'] as String,
      description: json['description'] as String?,
      evidenceUrls: (json['evidence_urls'] as List<dynamic>?)?.cast<String>(),
      status: json['status'] as String? ?? 'pending',
      resolution: json['resolution'] as String?,
      resolvedBy: json['resolved_by'] as String?,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporter_id': reporterId,
      'reporter_name': reporterName,
      'reported_type': reportedType,
      'reported_id': reportedId,
      'reported_user_id': reportedUserId,
      'reason': reason,
      'description': description,
      'evidence_urls': evidenceUrls,
      'status': status,
      'resolution': resolution,
      'resolved_by': resolvedBy,
      'resolved_at': resolvedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Report copyWith({
    String? id,
    String? reporterId,
    String? reporterName,
    String? reportedType,
    String? reportedId,
    String? reportedUserId,
    String? reason,
    String? description,
    List<String>? evidenceUrls,
    String? status,
    String? resolution,
    String? resolvedBy,
    DateTime? resolvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Report(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      reporterName: reporterName ?? this.reporterName,
      reportedType: reportedType ?? this.reportedType,
      reportedId: reportedId ?? this.reportedId,
      reportedUserId: reportedUserId ?? this.reportedUserId,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      evidenceUrls: evidenceUrls ?? this.evidenceUrls,
      status: status ?? this.status,
      resolution: resolution ?? this.resolution,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isInvestigating => status == 'investigating';
  bool get isResolved => status == 'resolved';
  bool get isDismissed => status == 'dismissed';

  String get statusDisplay {
    final statusMap = {
      'pending': 'قيد الانتظار',
      'investigating': 'قيد التحقيق',
      'resolved': 'تم الحل',
      'dismissed': 'مرفوض',
    };
    return statusMap[status] ?? status;
  }

  String get reportedTypeDisplay {
    final typeMap = {
      'user': 'مستخدم',
      'product': 'منتج',
      'ad': 'إعلان',
      'review': 'تقييم',
      'message': 'رسالة',
    };
    return typeMap[reportedType] ?? reportedType;
  }

  String get reasonDisplay {
    final reasonMap = {
      'spam': 'رسائل مزعجة',
      'fake': 'محتوى مزيف',
      'inappropriate': 'محتوى غير لائق',
      'scam': 'احتيال',
      'harassment': 'تحرش',
      'violence': 'عنف',
      'illegal': 'محتوى غير قانوني',
      'other': 'أخرى',
    };
    return reasonMap[reason] ?? reason;
  }
}

/// أنواع البلاغات
class ReportType {
  static const String user = 'user';
  static const String product = 'product';
  static const String ad = 'ad';
  static const String review = 'review';
  static const String message = 'message';

  static const List<String> all = [user, product, ad, review, message];
}

/// أسباب البلاغات
class ReportReason {
  static const String spam = 'spam';
  static const String fake = 'fake';
  static const String inappropriate = 'inappropriate';
  static const String scam = 'scam';
  static const String harassment = 'harassment';
  static const String violence = 'violence';
  static const String illegal = 'illegal';
  static const String other = 'other';

  static const List<String> all = [spam, fake, inappropriate, scam, harassment, violence, illegal, other];

  static const Map<String, String> displayNames = {
    spam: 'رسائل مزعجة',
    fake: 'محتوى مزيف',
    inappropriate: 'محتوى غير لائق',
    scam: 'احتيال',
    harassmment: 'تحرش',
    violence: 'عنف',
    illegal: 'محتوى غير قانوني',
    other: 'أخرى',
  };
}

/// حالات البلاغ
class ReportStatus {
  static const String pending = 'pending';
  static const String investigating = 'investigating';
  static const String resolved = 'resolved';
  static const String dismissed = 'dismissed';

  static const List<String> all = [pending, investigating, resolved, dismissed];
}
