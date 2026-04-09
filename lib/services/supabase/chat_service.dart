import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/chat/chat_message.dart';
import '../../models/chat/chat_conversation.dart';
import '../../models/chat/chat_participant.dart';

/// خدمة المحادثات
class ChatService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// ========== المحادثات ==========

  /// إنشاء محادثة جديدة
  Future<ChatConversation> createConversation({
    String? title,
    String type = 'direct',
    required List<String> participantIds,
  }) async {
    // إنشاء المحادثة
    final conversationResponse = await _supabase
        .from('conversations')
        .insert({
          'title': title,
          'type': type,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    final conversationId = conversationResponse['id'] as String;

    // إضافة المشاركين
    for (final userId in participantIds) {
      await _supabase.from('conversation_participants').insert({
        'conversation_id': conversationId,
        'user_id': userId,
        'role': 'member',
        'joined_at': DateTime.now().toIso8601String(),
      });
    }

    return ChatConversation.fromJson(conversationResponse);
  }

  /// الحصول على محادثات المستخدم
  Future<List<ChatConversation>> getUserConversations(String userId) async {
    final response = await _supabase
        .from('conversation_participants')
        .select('conversation_id')
        .eq('user_id', userId)
        .eq('is_active', true);

    final conversationIds = (response as List)
        .map((p) => p['conversation_id'] as String)
        .toList();

    if (conversationIds.isEmpty) return [];

    final conversationsResponse = await _supabase
        .from('conversations')
        .select()
        .inFilter('id', conversationIds)
        .order('updated_at', ascending: false);

    return (conversationsResponse as List)
        .map((json) => ChatConversation.fromJson(json))
        .toList();
  }

  /// الحصول على محادثة بواسطة المعرف
  Future<ChatConversation?> getConversationById(String conversationId) async {
    final response = await _supabase
        .from('conversations')
        .select()
        .eq('id', conversationId)
        .single();

    if (response == null) return null;
    return ChatConversation.fromJson(response);
  }

  /// الحصول على محادثة مباشرة بين مستخدمين
  Future<ChatConversation?> getDirectConversation(
    String userId1,
    String userId2,
  ) async {
    // البحث عن محادثة مباشرة موجودة
    final response = await _supabase.rpc(
      'get_direct_conversation',
      params: {'user1': userId1, 'user2': userId2},
    );

    if (response == null) return null;
    return ChatConversation.fromJson(response);
  }

  /// ========== الرسائل ==========

  /// إرسال رسالة
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    String type = 'text',
    String? mediaUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final message = ChatMessage(
      id: '',
      conversationId: conversationId,
      senderId: senderId,
      type: type,
      content: content,
      mediaUrl: mediaUrl,
      metadata: metadata,
      createdAt: DateTime.now(),
    );

    final response = await _supabase
        .from('messages')
        .insert(message.toJson())
        .select()
        .single();

    // تحديث آخر رسالة في المحادثة
    await _supabase.from('conversations').update({
      'last_message_id': response['id'],
      'last_message_content': content,
      'last_message_type': type,
      'last_message_at': DateTime.now().toIso8601String(),
      'last_message_sender_id': senderId,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', conversationId);

    return ChatMessage.fromJson(response);
  }

  /// الحصول على رسائل المحادثة
  Future<List<ChatMessage>> getMessages(
    String conversationId, {
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _supabase
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false)
        .range((page - 1) * limit, page * limit - 1);

    return (response as List)
        .map((json) => ChatMessage.fromJson(json))
        .toList();
  }

  /// تحديث حالة القراءة
  Future<void> markAsRead(String messageId, String userId) async {
    await _supabase.from('messages').update({
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('id', messageId);

    await _supabase.from('conversation_participants').update({
      'last_read_at': DateTime.now().toIso8601String(),
    }).eq('conversation_id', messageId).eq('user_id', userId);
  }

  /// حذف رسالة
  Future<void> deleteMessage(String messageId) async {
    await _supabase.from('messages').update({
      'deleted_at': DateTime.now().toIso8601String(),
    }).eq('id', messageId);
  }

  /// ========== المشاركين ==========

  /// إضافة مشارك
  Future<void> addParticipant(
    String conversationId,
    String userId, {
    String role = 'member',
  }) async {
    await _supabase.from('conversation_participants').insert({
      'conversation_id': conversationId,
      'user_id': userId,
      'role': role,
      'joined_at': DateTime.now().toIso8601String(),
    });
  }

  /// إزالة مشارك
  Future<void> removeParticipant(String conversationId, String userId) async {
    await _supabase.from('conversation_participants').update({
      'is_active': false,
      'left_at': DateTime.now().toIso8601String(),
    }).eq('conversation_id', conversationId).eq('user_id', userId);
  }

  /// الحصول على مشاركي المحادثة
  Future<List<ChatParticipant>> getParticipants(String conversationId) async {
    final response = await _supabase
        .from('conversation_participants')
        .select()
        .eq('conversation_id', conversationId)
        .eq('is_active', true);

    return (response as List)
        .map((json) => ChatParticipant.fromJson(json))
        .toList();
  }

  /// ========== الاستماع المباشر ==========

  /// الاستماع للرسائل الجديدة
  Stream<List<Map<String, dynamic>>> subscribeToMessages(
    String conversationId,
  ) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: false);
  }

  /// الاستماع لمحادثات المستخدم
  Stream<List<Map<String, dynamic>>> subscribeToConversations(String userId) {
    return _supabase
        .from('conversations')
        .stream(primaryKey: ['id'])
        .order('updated_at', ascending: false);
  }

  /// ========== العد غير المقروء ==========

  /// الحصول على عدد الرسائل غير المقروءة
  Future<int> getUnreadCount(String userId) async {
    final response = await _supabase.rpc(
      'get_unread_messages_count',
      params: {'p_user_id': userId},
    );

    return response as int? ?? 0;
  }

  /// تحديث عدد الرسائل غير المقروءة في المحادثة
  Future<void> updateUnreadCount(
    String conversationId,
    String userId,
  ) async {
    final response = await _supabase
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .neq('sender_id', userId)
        .eq('is_read', false);

    final count = (response as List).length;

    await _supabase.from('conversations').update({
      'unread_count': count,
    }).eq('id', conversationId);
  }
}
