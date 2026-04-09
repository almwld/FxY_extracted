import 'package:supabase_flutter/supabase_flutter.dart';
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<AuthResponse> signUp(String email, String password, String name) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
  }
  Future<Session?> signIn(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(email: email, password: password);
    return response.session;
  }
  Future<void> signOut() async => await _supabase.auth.signOut();
  User? get currentUser => _supabase.auth.currentUser;
  bool get isLoggedIn => currentUser != null;
}
