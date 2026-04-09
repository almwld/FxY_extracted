/// نموذج المستخدم
class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String? fullName;
  final String? avatarUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? gender;
  final String userType; // customer, seller, admin
  final bool isVerified;
  final bool isIdentityVerified;
  final DateTime? identityVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final bool isActive;
  final bool isBlocked;
  final String? blockReason;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.id,
    required this.email,
    this.phone,
    this.fullName,
    this.avatarUrl,
    this.bio,
    this.dateOfBirth,
    this.gender,
    this.userType = 'customer',
    this.isVerified = false,
    this.isIdentityVerified = false,
    this.identityVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.isActive = true,
    this.isBlocked = false,
    this.blockReason,
    this.metadata,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] as String?,
      userType: json['user_type'] as String? ?? 'customer',
      isVerified: json['is_verified'] as bool? ?? false,
      isIdentityVerified: json['is_identity_verified'] as bool? ?? false,
      identityVerifiedAt: json['identity_verified_at'] != null
          ? DateTime.parse(json['identity_verified_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      isBlocked: json['is_blocked'] as bool? ?? false,
      blockReason: json['block_reason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'user_type': userType,
      'is_verified': isVerified,
      'is_identity_verified': isIdentityVerified,
      'identity_verified_at': identityVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'is_active': isActive,
      'is_blocked': isBlocked,
      'block_reason': blockReason,
      'metadata': metadata,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? phone,
    String? fullName,
    String? avatarUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? userType,
    bool? isVerified,
    bool? isIdentityVerified,
    DateTime? identityVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    bool? isActive,
    bool? isBlocked,
    String? blockReason,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      userType: userType ?? this.userType,
      isVerified: isVerified ?? this.isVerified,
      isIdentityVerified: isIdentityVerified ?? this.isIdentityVerified,
      identityVerifiedAt: identityVerifiedAt ?? this.identityVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      blockReason: blockReason ?? this.blockReason,
      metadata: metadata ?? this.metadata,
    );
  }

  String get displayName => fullName ?? email.split('@').first;
  String get initials => displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  bool get isSeller => userType == 'seller';
  bool get isAdmin => userType == 'admin';
  bool get isCustomer => userType == 'customer';
}
