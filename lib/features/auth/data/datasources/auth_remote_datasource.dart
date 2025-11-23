import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart' as domain;

/// Remote data source for authentication using Supabase
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<domain.User> login(String email, String password);

  /// Register a new user
  Future<domain.User> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  });

  /// Get current authenticated user
  Future<domain.User?> getCurrentUser();

  /// Sign out
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<domain.User> login(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed: No user returned');
      }

      // Fetch profile data including role
      final profileData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return domain.User(
        id: response.user!.id,
        email: response.user!.email!,
        name: profileData['full_name'] as String,
        role: profileData['role'] as String,
      );
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<domain.User> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'role': role,
          'phone': phone,
        },
      );

      if (response.user == null) {
        throw Exception('Registration failed: No user returned');
      }

      // Profile is auto-created by trigger, fetch it
      final profileData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return domain.User(
        id: response.user!.id,
        email: response.user!.email!,
        name: profileData['full_name'] as String,
        role: profileData['role'] as String,
      );
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  @override
  Future<domain.User?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user == null) return null;

      // Fetch profile data including role
      final profileData = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return domain.User(
        id: user.id,
        email: user.email!,
        name: profileData['full_name'] as String,
        role: profileData['role'] as String,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }
}