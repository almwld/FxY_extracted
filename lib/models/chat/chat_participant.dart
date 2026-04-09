/// نموذج مشارك في المحادثة
class ChatParticipant {
  final String id;
  final String conversationId;
  final String userId;
  final String? userName;
  final String? avatarUrl;
  final String role; // admin, member
  final bool isActive;
  final DateTime? lastReadAt;
  final DateTime joinedAt;
  final DateTime? leftAt;

  ChatParticipant({
    required this.id,
    required this.conversationId,
    required this.userId,
    this.userName,
    this.avatarUrl,
    this.role = 'member',
    this.isActive = true,
    this.lastReadAt,
    required this.joinedAt,
    this.leftAt,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'member',
      isActive: json['is_active'] as bool? ?? true,
      lastReadAt: json['last_read_at'] != null
          ? DateTime.parse(json['last_read_at'] as String)
          : null,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      leftAt: json['left_at'] != null
          ? DateTime.parse(json['left_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'user_id': userId,
      'user_name': userName,
      'avatar_url': avatarUrl,
      'role': role,
      'is_active': isActive,
      'last_read_at': lastReadAt?.toIso8601String(),
      'joined_at': joinedAt.toIso8601String(),
      'left_at': leftAt?.toIso8601String(),
    };
  }

  ChatParticipant copyWith({
    String? id,
    String? conversationId,
    String? userId,
    String? userName,
    String? avatarUrl,
    String? role,
    bool? isActive,
    DateTime? lastReadAt,
    DateTime? joinedAt,
    DateTime? leftAt,
  }) {
    return ChatParticipant(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isMember => role == 'member';
  bool get hasLeft => leftAt != null;
  bool get isOnline => isActive && !hasLeft;

  String get displayName => userName ?? 'مستخدم';
  String get initials => displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
}

/// أدوار المشاركين
class ParticipantRole {
  static const String admin = 'admin';
  static const String member = 'member';
  static const String moderator = 'moderator';

  static const List<String> all = [admin, member, moderator];
}
