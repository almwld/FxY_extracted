import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// عميل Supabase
class SupabaseClient {
  static final SupabaseClient _instance = SupabaseClient._internal();
  factory SupabaseClient() => _instance;
  SupabaseClient._internal();

  SupabaseClient? _client;

  /// تهيئة Supabase
  Future<void> initialize() async {
    await dotenv.load();
    
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
      debug: false,
    );
  }

  /// الحصول على عميل Supabase
  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// الحصول على عميل Supabase مباشرة
  static SupabaseClient get instance => Supabase.instance.client;

  /// الحصول على المستخدم الحالي
  static User? get currentUser => Supabase.instance.client.auth.currentUser;

  /// التحقق مما إذا كان المستخدم مسجل الدخول
  static bool get isAuthenticated => currentUser != null;

  /// الحصول على معرف المستخدم الحالي
  static String? get currentUserId => currentUser?.id;

  /// الاستماع لتغييرات حالة المصادقة
  static Stream<AuthState> get authStateChanges => 
      Supabase.instance.client.auth.onAuthStateChange;

  /// تسجيل الخروج
  static Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
