/// نموذج إعدادات المستخدم
class UserSettings {
  final String userId;
  final String language;
  final String theme;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool marketingEmails;
  final bool biometricEnabled;
  final bool locationEnabled;
  final String? defaultPaymentMethod;
  final String? defaultAddressId;
  final String currency;
  final Map<String, dynamic>? notificationPreferences;
  final Map<String, dynamic>? privacySettings;
  final DateTime updatedAt;

  UserSettings({
    required this.userId,
    this.language = 'ar',
    this.theme = 'system',
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.marketingEmails = false,
    this.biometricEnabled = false,
    this.locationEnabled = true,
    this.defaultPaymentMethod,
    this.defaultAddressId,
    this.currency = 'YER',
    this.notificationPreferences,
    this.privacySettings,
    required this.updatedAt,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'] as String,
      language: json['language'] as String? ?? 'ar',
      theme: json['theme'] as String? ?? 'system',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      smsNotifications: json['sms_notifications'] as bool? ?? false,
      marketingEmails: json['marketing_emails'] as bool? ?? false,
      biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      locationEnabled: json['location_enabled'] as bool? ?? true,
      defaultPaymentMethod: json['default_payment_method'] as String?,
      defaultAddressId: json['default_address_id'] as String?,
      currency: json['currency'] as String? ?? 'YER',
      notificationPreferences: json['notification_preferences'] as Map<String, dynamic>?,
      privacySettings: json['privacy_settings'] as Map<String, dynamic>?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'language': language,
      'theme': theme,
      'notifications_enabled': notificationsEnabled,
      'email_notifications': emailNotifications,
      'push_notifications': pushNotifications,
      'sms_notifications': smsNotifications,
      'marketing_emails': marketingEmails,
      'biometric_enabled': biometricEnabled,
      'location_enabled': locationEnabled,
      'default_payment_method': defaultPaymentMethod,
      'default_address_id': defaultAddressId,
      'currency': currency,
      'notification_preferences': notificationPreferences,
      'privacy_settings': privacySettings,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserSettings copyWith({
    String? userId,
    String? language,
    String? theme,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    bool? marketingEmails,
    bool? biometricEnabled,
    bool? locationEnabled,
    String? defaultPaymentMethod,
    String? defaultAddressId,
    String? currency,
    Map<String, dynamic>? notificationPreferences,
    Map<String, dynamic>? privacySettings,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      marketingEmails: marketingEmails ?? this.marketingEmails,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
      currency: currency ?? this.currency,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      privacySettings: privacySettings ?? this.privacySettings,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isArabic => language == 'ar';
  bool get isEnglish => language == 'en';
  bool get isLightTheme => theme == 'light';
  bool get isDarkTheme => theme == 'dark';
  bool get isSystemTheme => theme == 'system';
}
