/// نموذج الإعلان
class AdModel {
  final String id;
  final String userId;
  final String? userName;
  final String title;
  final String description;
  final double price;
  final String? compareAtPrice;
  final String currency;
  final String categoryId;
  final String? subcategoryId;
  final List<String> images;
  final String? thumbnail;
  final String condition; // new, used, refurbished
  final String location;
  final double? latitude;
  final double? longitude;
  final String contactPhone;
  final String? contactEmail;
  final bool isNegotiable;
  final String status; // active, pending, sold, expired, rejected
  final int viewCount;
  final int favoriteCount;
  final DateTime? expiresAt;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdModel({
    required this.id,
    required this.userId,
    this.userName,
    required this.title,
    required this.description,
    required this.price,
    this.compareAtPrice,
    this.currency = 'YER',
    required this.categoryId,
    this.subcategoryId,
    required this.images,
    this.thumbnail,
    this.condition = 'used',
    required this.location,
    this.latitude,
    this.longitude,
    required this.contactPhone,
    this.contactEmail,
    this.isNegotiable = false,
    this.status = 'pending',
    this.viewCount = 0,
    this.favoriteCount = 0,
    this.expiresAt,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      compareAtPrice: json['compare_at_price'] as String?,
      currency: json['currency'] as String? ?? 'YER',
      categoryId: json['category_id'] as String,
      subcategoryId: json['subcategory_id'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      thumbnail: json['thumbnail'] as String?,
      condition: json['condition'] as String? ?? 'used',
      location: json['location'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      contactPhone: json['contact_phone'] as String,
      contactEmail: json['contact_email'] as String?,
      isNegotiable: json['is_negotiable'] as bool? ?? false,
      status: json['status'] as String? ?? 'pending',
      viewCount: json['view_count'] as int? ?? 0,
      favoriteCount: json['favorite_count'] as int? ?? 0,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'title': title,
      'description': description,
      'price': price,
      'compare_at_price': compareAtPrice,
      'currency': currency,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'images': images,
      'thumbnail': thumbnail,
      'condition': condition,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'is_negotiable': isNegotiable,
      'status': status,
      'view_count': viewCount,
      'favorite_count': favoriteCount,
      'expires_at': expiresAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AdModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? title,
    String? description,
    double? price,
    String? compareAtPrice,
    String? currency,
    String? categoryId,
    String? subcategoryId,
    List<String>? images,
    String? thumbnail,
    String? condition,
    String? location,
    double? latitude,
    double? longitude,
    String? contactPhone,
    String? contactEmail,
    bool? isNegotiable,
    String? status,
    int? viewCount,
    int? favoriteCount,
    DateTime? expiresAt,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      currency: currency ?? this.currency,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      images: images ?? this.images,
      thumbnail: thumbnail ?? this.thumbnail,
      condition: condition ?? this.condition,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      status: status ?? this.status,
      viewCount: viewCount ?? this.viewCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      expiresAt: expiresAt ?? this.expiresAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  bool get isSold => status == 'sold';
  bool get isExpired => status == 'expired';
  bool get isRejected => status == 'rejected';

  bool get isExpiredDate {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  String get conditionDisplay {
    final conditionMap = {
      'new': 'جديد',
      'used': 'مستعمل',
      'refurbished': 'مجدد',
    };
    return conditionMap[condition] ?? condition;
  }

  String get statusDisplay {
    final statusMap = {
      'active': 'نشط',
      'pending': 'قيد المراجعة',
      'sold': 'تم البيع',
      'expired': 'منتهي',
      'rejected': 'مرفوض',
    };
    return statusMap[status] ?? status;
  }

  String? get mainImage => images.isNotEmpty ? images.first : thumbnail;
}

/// حالات الإعلان
class AdStatus {
  static const String active = 'active';
  static const String pending = 'pending';
  static const String sold = 'sold';
  static const String expired = 'expired';
  static const String rejected = 'rejected';

  static const List<String> all = [active, pending, sold, expired, rejected];
}

/// حالة المنتج
class AdCondition {
  static const String newItem = 'new';
  static const String used = 'used';
  static const String refurbished = 'refurbished';

  static const List<String> all = [newItem, used, refurbished];
}
