/// نموذج طلب البائع
class SellerRequest {
  final String id;
  final String userId;
  final String? userName;
  final String? userEmail;
  final String businessName;
  final String? businessDescription;
  final String businessType;
  final String? businessRegistrationNumber;
  final String? taxNumber;
  final String contactPhone;
  final String? contactEmail;
  final String? website;
  final String? logoUrl;
  final String? idFrontUrl;
  final String? idBackUrl;
  final String? businessLicenseUrl;
  final String status; // pending, approved, rejected
  final String? adminNotes;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  SellerRequest({
    required this.id,
    required this.userId,
    this.userName,
    this.userEmail,
    required this.businessName,
    this.businessDescription,
    required this.businessType,
    this.businessRegistrationNumber,
    this.taxNumber,
    required this.contactPhone,
    this.contactEmail,
    this.website,
    this.logoUrl,
    this.idFrontUrl,
    this.idBackUrl,
    this.businessLicenseUrl,
    this.status = 'pending',
    this.adminNotes,
    this.reviewedBy,
    this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SellerRequest.fromJson(Map<String, dynamic> json) {
    return SellerRequest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      businessName: json['business_name'] as String,
      businessDescription: json['business_description'] as String?,
      businessType: json['business_type'] as String,
      businessRegistrationNumber: json['business_registration_number'] as String?,
      taxNumber: json['tax_number'] as String?,
      contactPhone: json['contact_phone'] as String,
      contactEmail: json['contact_email'] as String?,
      website: json['website'] as String?,
      logoUrl: json['logo_url'] as String?,
      idFrontUrl: json['id_front_url'] as String?,
      idBackUrl: json['id_back_url'] as String?,
      businessLicenseUrl: json['business_license_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      adminNotes: json['admin_notes'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'business_name': businessName,
      'business_description': businessDescription,
      'business_type': businessType,
      'business_registration_number': businessRegistrationNumber,
      'tax_number': taxNumber,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'website': website,
      'logo_url': logoUrl,
      'id_front_url': idFrontUrl,
      'id_back_url': idBackUrl,
      'business_license_url': businessLicenseUrl,
      'status': status,
      'admin_notes': adminNotes,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  SellerRequest copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? businessName,
    String? businessDescription,
    String? businessType,
    String? businessRegistrationNumber,
    String? taxNumber,
    String? contactPhone,
    String? contactEmail,
    String? website,
    String? logoUrl,
    String? idFrontUrl,
    String? idBackUrl,
    String? businessLicenseUrl,
    String? status,
    String? adminNotes,
    String? reviewedBy,
    DateTime? reviewedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SellerRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      businessType: businessType ?? this.businessType,
      businessRegistrationNumber: businessRegistrationNumber ?? this.businessRegistrationNumber,
      taxNumber: taxNumber ?? this.taxNumber,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      website: website ?? this.website,
      logoUrl: logoUrl ?? this.logoUrl,
      idFrontUrl: idFrontUrl ?? this.idFrontUrl,
      idBackUrl: idBackUrl ?? this.idBackUrl,
      businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
      status: status ?? this.status,
      adminNotes: adminNotes ?? this.adminNotes,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  String get statusDisplay {
    final statusMap = {
      'pending': 'قيد المراجعة',
      'approved': 'تمت الموافقة',
      'rejected': 'مرفوض',
    };
    return statusMap[status] ?? status;
  }

  String get businessTypeDisplay {
    final typeMap = {
      'individual': 'فردي',
      'company': 'شركة',
      'partnership': 'شراكة',
      'nonprofit': 'غير ربحي',
    };
    return typeMap[businessType] ?? businessType;
  }

  bool get hasAllDocuments {
    return idFrontUrl != null && 
           idBackUrl != null && 
           businessLicenseUrl != null;
  }
}

/// أنواع الأعمال
class BusinessType {
  static const String individual = 'individual';
  static const String company = 'company';
  static const String partnership = 'partnership';
  static const String nonprofit = 'nonprofit';

  static const List<String> all = [individual, company, partnership, nonprofit];

  static const Map<String, String> displayNames = {
    individual: 'فردي',
    company: 'شركة',
    partnership: 'شراكة',
    nonprofit: 'غير ربحي',
  };
}

/// حالات طلب البائع
class SellerRequestStatus {
  static const String pending = 'pending';
  static const String approved = 'approved';
  static const String rejected = 'rejected';

  static const List<String> all = [pending, approved, rejected];
}
