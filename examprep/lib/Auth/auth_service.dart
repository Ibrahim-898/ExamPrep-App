// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthService {
//   final SupabaseClient _supabase = Supabase.instance.client;

//   // sign in

//   Future<AuthResponse> signInWithEmailPassword(
//       String email, String password) async {
//     return await _supabase.auth.signInWithPassword(
//       email: email,
//       password: password,
//     );
//   }

//   // sign up
//   Future<AuthResponse> signUpWithEmailPassword(
//       String email, String password) async {
//     return await _supabase.auth.signUp(
//       email: email,
//       password: password,
//     );
//   }

//   //sign out
//   Future<void> signOut() async {
//     await _supabase.auth.signOut();
//   }
// }

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email, password, and profile data
  Future<AuthResponse> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String mobile,
    required String dept,
    required int year,
  }) async {
    // 1. Create user account
    final authResponse = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    // 2. If sign-up successful, create profile record
    if (authResponse.user != null) {
      await _supabase.from('profiles').upsert({
        'id': authResponse.user!.id,
        'email': email,
        'name': name,
        'mobile': mobile,
        'dept': dept,
        'year': year,
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    return authResponse;
  }

  // Get current user's profile data
  Future<Map<String, dynamic>?> getProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  // Update profile information
  Future<void> updateProfile({
    required String name,
    required String mobile,
    required String dept,
    required int year,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    await _supabase.from('profiles').upsert({
      'id': userId,
      'name': name,
      'mobile': mobile,
      'dept': dept,
      'year': year,
    });
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return _supabase.auth.currentUser?.email;
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Get auth stream
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }
}
