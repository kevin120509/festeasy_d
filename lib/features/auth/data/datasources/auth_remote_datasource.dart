import 'package:festeasy/core/errors/exceptions.dart';
import 'package:festeasy/features/auth/domain/entities/service_category.dart'
    as domain;
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
    String? businessName,
  });

  /// Get current authenticated user
  Future<domain.User?> getCurrentUser();

  /// Sign out
  Future<void> logout();

  /// Get service categories
  Future<List<domain.ServiceCategory>> getServiceCategories();

  /// Create a new service request
  Future<void> createRequest(dynamic params);

  /// Get provider dashboard data
  Future<Map<String, int>> getProviderDashboardData(String providerId);
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
        phone: profileData['phone'] as String?,
        avatarUrl: profileData['avatar_url'] as String?,
        businessName: profileData['business_name'] as String?,
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
    String? businessName,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'role': role,
          'phone': phone,
          'business_name': businessName,
        },
      );

      if (response.user == null) {
        throw EmailConfirmationRequiredException();
      }

      // Return user directly from input data to avoid race condition with profile trigger
      return domain.User(
        id: response.user!.id,
        email: response.user!.email!,
        name: name,
        role: role,
        phone: phone,
        businessName: businessName,
      );
    } catch (e) {
      if (e is EmailConfirmationRequiredException) {
        rethrow;
      }
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
        phone: profileData['phone'] as String?,
        avatarUrl: profileData['avatar_url'] as String?,
        businessName: profileData['business_name'] as String?,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<List<domain.ServiceCategory>> getServiceCategories() async {
    try {
      final response = await supabaseClient.from('service_categories').select();
      return (response as List)
          .map(
            (e) => domain.ServiceCategory(
              id: e['id'] as String,
              name: e['name'] as String,
              description: e['description'] as String?,
              icon: e['icon'] as String?,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get service categories: $e');
    }
  }

  @override
  Future<void> createRequest(params) async {
    try {
      await supabaseClient.from('requests').insert({
        'title': params.title,
        'description': params.description,
        'category_id': params.categoryId,
        'event_date': params.eventDate.toIso8601String(),
        'event_time': params.eventTime,
        'location': params.location,
        'guest_count': params.guestCount,
        'client_id': params.clientId,
      });
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  @override
  Future<Map<String, int>> getProviderDashboardData(String providerId) async {
    try {
      final newRequests = await supabaseClient
          .from('requests')
          .select('id')
          .eq('status', 'open');

      final ongoingRequests = await supabaseClient
          .from('quotes')
          .select('id')
          .eq('provider_id', providerId)
          .eq('status', 'pending');

      return {
        'newRequestsCount': (newRequests as List).length,
        'ongoingRequestsCount': (ongoingRequests as List).length,
      };
    } catch (e) {
      throw Exception('Failed to get dashboard data: $e');
    }
  }
}
