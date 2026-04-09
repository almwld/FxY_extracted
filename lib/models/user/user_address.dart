/// نموذج عنوان المستخدم
class UserAddress {
  final String id;
  final String userId;
  final String title; // المنزل، العمل، آخر...
  final String fullName;
  final String phone;
  final String country;
  final String city;
  final String? state;
  final String street;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? landmark;
  final String postalCode;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAddress({
    required this.id,
    required this.userId,
    required this.title,
    required this.fullName,
    required this.phone,
    this.country = 'اليمن',
    required this.city,
    this.state,
    required this.street,
    this.building,
    this.floor,
    this.apartment,
    this.landmark,
    required this.postalCode,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      country: json['country'] as String? ?? 'اليمن',
      city: json['city'] as String,
      state: json['state'] as String?,
      street: json['street'] as String,
      building: json['building'] as String?,
      floor: json['floor'] as String?,
      apartment: json['apartment'] as String?,
      landmark: json['landmark'] as String?,
      postalCode: json['postal_code'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'full_name': fullName,
      'phone': phone,
      'country': country,
      'city': city,
      'state': state,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'landmark': landmark,
      'postal_code': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserAddress copyWith({
    String? id,
    String? userId,
    String? title,
    String? fullName,
    String? phone,
    String? country,
    String? city,
    String? state,
    String? street,
    String? building,
    String? floor,
    String? apartment,
    String? landmark,
    String? postalCode,
    double? latitude,
    double? longitude,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserAddress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      city: city ?? this.city,
      state: state ?? this.state,
      street: street ?? this.street,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      landmark: landmark ?? this.landmark,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullAddress {
    final parts = <String>[
      street,
      if (building != null) 'مبنى $building',
      if (floor != null) 'الدور $floor',
      if (apartment != null) 'شقة $apartment',
      if (landmark != null) '($landmark)',
      city,
      country,
    ];
    return parts.join(', ');
  }

  String get shortAddress => '$street، $city';
}
