/// نموذج المحادثة
class ChatConversation {
  final String id;
  final String? title;
  final String type; // direct, group, support
  final List<ChatParticipant> participants;
  final String? lastMessageId;
  final String? lastMessageContent;
  final String? lastMessageType;
  final DateTime? lastMessageAt;
  final String? lastMessageSenderId;
  final int unreadCount;
  final bool isArchived;
  final bool isMuted;
  final DateTime? mutedUntil;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatConversation({
    required this.id,
    this.title,
    this.type = 'direct',
    required this.participants,
    this.lastMessageId,
    this.lastMessageContent,
    this.lastMessageType,
    this.lastMessageAt,
    this.lastMessageSenderId,
    this.unreadCount = 0,
    this.isArchived = false,
    this.isMuted = false,
    this.mutedUntil,
    this.imageUrl,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] as String,
      title: json['title'] as String?,
      type: json['type'] as String? ?? 'direct',
      participants: (json['participants'] as List<dynamic>)
          .map((e) => ChatParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessageId: json['last_message_id'] as String?,
      lastMessageContent: json['last_message_content'] as String?,
      lastMessageType: json['last_message_type'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessageSenderId: json['last_message_sender_id'] as String?,
      unreadCount: json['unread_count'] as int? ?? 0,
      isArchived: json['is_archived'] as bool? ?? false,
      isMuted: json['is_muted'] as bool? ?? false,
      mutedUntil: json['muted_until'] != null
          ? DateTime.parse(json['muted_until'] as String)
          : null,
      imageUrl: json['image_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'participants': participants.map((e) => e.toJson()).toList(),
      'last_message_id': lastMessageId,
      'last_message_content': lastMessageContent,
      'last_message_type': lastMessageType,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message_sender_id': lastMessageSenderId,
      'unread_count': unreadCount,
      'is_archived': isArchived,
      'is_muted': isMuted,
      'muted_until': mutedUntil?.toIso8601String(),
      'image_url': imageUrl,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ChatConversation copyWith({
    String? id,
    String? title,
    String? type,
    List<ChatParticipant>? participants,
    String? lastMessageId,
    String? lastMessageContent,
    String? lastMessageType,
    DateTime? lastMessageAt,
    String? lastMessageSenderId,
    int? unreadCount,
    bool? isArchived,
    bool? isMuted,
    DateTime? mutedUntil,
    String? imageUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      isArchived: isArchived ?? this.isArchived,
      isMuted: isMuted ?? this.isMuted,
      mutedUntil: mutedUntil ?? this.mutedUntil,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isDirect => type == 'direct';
  bool get isGroup => type == 'group';
  bool get isSupport => type == 'support';
  bool get hasUnread => unreadCount > 0;
  bool get isCurrentlyMuted {
    if (!isMuted) return false;
    if (mutedUntil == null) return true;
    return DateTime.now().isBefore(mutedUntil!);
  }

  String get displayTitle {
    if (title != null && title!.isNotEmpty) return title!;
    if (isDirect && participants.isNotEmpty) {
      return participants.first.userName ?? 'مستخدم';
    }
    return 'محادثة';
  }

  String? get displayImage {
    if (imageUrl != null) return imageUrl;
    if (isDirect && participants.isNotEmpty) {
      return participants.first.avatarUrl;
    }
    return null;
  }

  ChatParticipant? getOtherParticipant(String currentUserId) {
    try {
      return participants.firstWhere((p) => p.userId != currentUserId);
    } catch (e) {
      return null;
    }
  }
}

/// أنواع المحادثات
class ConversationType {
  static const String direct = 'direct';
  static const String group = 'group';
  static const String support = 'support';

  static const List<String> all = [direct, group, support];
}
