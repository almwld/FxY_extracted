/// نموذج رسالة المحادثة
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String type; // text, image, product, order
  final String content;
  final String? mediaUrl;
  final Map<String, dynamic>? metadata;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    this.type = 'text',
    required this.content,
    this.mediaUrl,
    this.metadata,
    this.isRead = false,
    this.readAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String?,
      senderAvatar: json['sender_avatar'] as String?,
      type: json['type'] as String? ?? 'text',
      content: json['content'] as String,
      mediaUrl: json['media_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'type': type,
      'content': content,
      'media_url': mediaUrl,
      'metadata': metadata,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? type,
    String? content,
    String? mediaUrl,
    Map<String, dynamic>? metadata,
    bool? isRead,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      type: type ?? this.type,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  bool get isText => type == 'text';
  bool get isImage => type == 'image';
  bool get isProduct => type == 'product';
  bool get isOrder => type == 'order';
  bool get isDeleted => deletedAt != null;
  bool get isEdited => updatedAt != null && updatedAt != createdAt;

  String get typeDisplay {
    final typeMap = {
      'text': 'نص',
      'image': 'صورة',
      'product': 'منتج',
      'order': 'طلب',
    };
    return typeMap[type] ?? type;
  }
}

/// أنواع الرسائل
class MessageType {
  static const String text = 'text';
  static const String image = 'image';
  static const String product = 'product';
  static const String order = 'order';
  static const String location = 'location';
  static const String voice = 'voice';
  static const String file = 'file';

  static const List<String> all = [text, image, product, order, location, voice, file];
}
