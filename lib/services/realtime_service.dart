import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final List<Function(Map<String, dynamic>)> _messageListeners = [];
  final List<Function(Map<String, dynamic>)> _notificationListeners = [];

  void init() {
    // الاستماع للرسائل الجديدة
    _supabase
        .channel('messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            for (var listener in _messageListeners) {
              listener(payload.newRecord);
            }
          },
        )
        .subscribe();

    // الاستماع للإشعارات الجديدة
    _supabase
        .channel('notifications')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          callback: (payload) {
            for (var listener in _notificationListeners) {
              listener(payload.newRecord);
            }
          },
        )
        .subscribe();
  }

  void addMessageListener(Function(Map<String, dynamic>) listener) {
    _messageListeners.add(listener);
  }

  void addNotificationListener(Function(Map<String, dynamic>) listener) {
    _notificationListeners.add(listener);
  }

  Future<void> sendMessage(String conversationId, String message) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': userId,
      'message': message,
    });
  }

  Future<void> sendNotification(String userId, String title, String body) async {
    await _supabase.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'body': body,
    });
  }
}
