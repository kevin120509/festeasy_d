import 'package:festeasy/core/errors/exceptions.dart';
import 'package:festeasy/features/auth/domain/entities/service_category.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/entities/user.dart';

/// Remote data source for authentication using Supabase
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<User> login(String email, String password);

  /// Register a new user
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
    String? businessName,
    String? description,
    String? categoryId,
  });

  /// Get current authenticated user
  Future<User?> getCurrentUser();

  /// Sign out
  Future<void> logout();

  /// Get service categories
  Future<List<ServiceCategory>> getServiceCategories();

  /// Create a new event and return its ID
  Future<String> createRequest(dynamic params);

  /// Get provider dashboard data
  Future<Map<String, int>> getProviderDashboardData(String providerId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabase.SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed: No user returned');
      }

      final userId = response.user!.id;
      final userMetadata = response.user!.userMetadata;
      print('🔍 DEBUG: userId = $userId');
      print('🔍 DEBUG: userMetadata = $userMetadata');

      // Intentar buscar perfil de cliente
      final clientProfile = await supabaseClient
          .from('perfil_cliente')
          .select()
          .eq('usuario_id', userId)
          .maybeSingle();

      print('🔍 DEBUG: clientProfile = $clientProfile');

      if (clientProfile != null) {
        print('✅ DEBUG: Encontró perfil de CLIENTE');
        return User(
          id: userId,
          email: response.user!.email!,
          name: clientProfile['nombre_completo'] as String,
          role: 'client',
          roleDetail: 'normal',
          phone: clientProfile['telefono'] as String?,
          avatarUrl: clientProfile['avatar_url'] as String?,
        );
      }

      // Si no es cliente, buscar perfil de proveedor
      final providerProfile = await supabaseClient
          .from('perfil_proveedor')
          .select()
          .eq('usuario_id', userId)
          .maybeSingle();

      print('🔍 DEBUG: providerProfile = $providerProfile');

      if (providerProfile != null) {
        print('✅ DEBUG: Encontró perfil de PROVEEDOR');
        return User(
          id: userId,
          email: response.user!.email!,
          name: providerProfile['nombre_negocio'] as String,
          role: 'provider',
          roleDetail: 'normal',
          phone: providerProfile['telefono'] as String?,
          avatarUrl: providerProfile['avatar_url'] as String?,
          businessName: providerProfile['nombre_negocio'] as String?,
          description: providerProfile['descripcion'] as String?,
          categoryId: providerProfile['categoria_principal_id'] as String?,
        );
      }

      // No se encontró perfil - intentar crear desde metadatos del usuario
      print('⚠️ DEBUG: No encontró ningún perfil, intentando crear desde metadatos...');
      
      final fullName = userMetadata?['full_name'] as String? ?? 'Usuario';
      final role = userMetadata?['role'] as String? ?? 'client';
      
      print('📝 DEBUG: fullName desde metadatos = $fullName');
      print('📝 DEBUG: role desde metadatos = $role');

      // Crear registros en tablas auxiliares
      try {
        await supabaseClient.from('profiles').upsert({
          'id': userId,
          'full_name': fullName,
          'updated_at': DateTime.now().toIso8601String(),
        });
        print('✅ DEBUG: Registro en profiles creado');
      } catch (e) {
        print('⚠️ DEBUG: Error creando registro en profiles: $e');
      }

      try {
        await supabaseClient.from('users').upsert({
          'id': userId,
          'correo_electronico': email,
          'contrasena': 'managed_by_supabase_auth',
          'rol': role,
          'correo_verificado_en': DateTime.now().toIso8601String(),
          'ultimo_acceso_en': DateTime.now().toIso8601String(),
          'estado': 'active',
        });
        print('✅ DEBUG: Registro en users creado');
      } catch (e) {
        print('⚠️ DEBUG: Error creando registro en users: $e');
      }

      // Crear el perfil que falta
      if (role == 'client') {
        try {
          await supabaseClient.from('perfil_cliente').upsert({
            'id': userId,
            'usuario_id': userId,
            'nombre_completo': fullName,
          });
          print('✅ DEBUG: Perfil de cliente creado exitosamente');
        } catch (e) {
          print('⚠️ DEBUG: Error creando perfil de cliente: $e');
        }
        
        return User(
          id: userId,
          email: response.user!.email!,
          name: fullName,
          role: 'client',
          roleDetail: 'normal',
        );
      } else {
        try {
          await supabaseClient.from('perfil_proveedor').upsert({
            'id': userId,
            'usuario_id': userId,
            'nombre_negocio': fullName,
          });
          print('✅ DEBUG: Perfil de proveedor creado exitosamente');
        } catch (e) {
          print('⚠️ DEBUG: Error creando perfil de proveedor: $e');
        }
        
        return User(
          id: userId,
          email: response.user!.email!,
          name: fullName,
          role: 'provider',
          roleDetail: 'normal',
          businessName: fullName,
        );
      }
    } catch (e) {
      print('❌ DEBUG: Error en login: $e');
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
    String? businessName,
    String? description,
    String? categoryId,
  }) async {
    try {
      print('📝 DEBUG: Iniciando registro...');
      print('📝 DEBUG: role = $role');
      print('📝 DEBUG: name = $name');
      print('📝 DEBUG: businessName = $businessName');

      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name,
          'role': role,
          'phone': phone,
          'businessName': businessName,
          'categoryId': categoryId,
        },
      );

      print('✅ DEBUG: Supabase Auth signUp exitoso');
      print('📝 DEBUG: response.user = ${response.user}');
      print('📝 DEBUG: response.session = ${response.session}');

      // Verificar si el usuario fue creado (puede existir sin sesión si requiere confirmación)
      if (response.user == null) {
        print(
          '❌ DEBUG: response.user es null, el registro falló completamente',
        );
        throw Exception('Registration failed: No user returned');
      }

      final userId = response.user!.id;
      final needsEmailConfirmation = response.session == null;
      print('📝 DEBUG: userId = $userId');
      print('📝 DEBUG: needsEmailConfirmation = $needsEmailConfirmation');

      // 1. Insertar en tabla 'profiles' (requerida por Supabase auth)
      try {
        print('📝 DEBUG: Insertando en profiles...');
        await supabaseClient.from('profiles').upsert({
          'id': userId,
          'full_name': name,
          'updated_at': DateTime.now().toIso8601String(),
        });
        print('✅ DEBUG: Inserción en profiles exitosa');
      } catch (e) {
        print('⚠️ DEBUG: Error insertando en profiles (puede ser RLS): $e');
        // Continuar aunque falle - puede ser un problema de RLS sin sesión
      }

      // 2. Insertar en tabla pública 'users'
      try {
        print('📝 DEBUG: Insertando en users...');
        await supabaseClient.from('users').upsert({
          'id': userId,
          'correo_electronico': email,
          'contrasena': 'managed_by_supabase_auth',
          'rol': role,
          'correo_verificado_en': DateTime.now().toIso8601String(),
          'ultimo_acceso_en': DateTime.now().toIso8601String(),
          'estado': 'active',
        });
        print('✅ DEBUG: Inserción en users exitosa');
      } catch (e) {
        print('⚠️ DEBUG: Error insertando en users (puede ser RLS): $e');
        // Continuar aunque falle - puede ser un problema de RLS sin sesión
      }

      // 3. Insertar en perfil específico
      if (role == 'client') {
        try {
          print('📝 DEBUG: Insertando en perfil_cliente...');
          final clientData = {
            'id': userId,
            'usuario_id': userId,
            'nombre_completo': name,
            'telefono': phone.isEmpty ? null : phone,
          };
          print('📝 DEBUG: clientData = $clientData');

          await supabaseClient.from('perfil_cliente').upsert(clientData);
          print('✅ DEBUG: Inserción en perfil_cliente exitosa');
        } catch (e) {
          print('⚠️ DEBUG: Error insertando en perfil_cliente (puede ser RLS): $e');
          // Continuar aunque falle - puede ser un problema de RLS sin sesión
        }
      } else {
        try {
          print('📝 DEBUG: Insertando en perfil_proveedor...');
          final providerData = {
            'id': userId,
            'usuario_id': userId,
            'nombre_negocio': businessName ?? name,
            'descripcion': description?.isEmpty ?? true ? null : description,
            'telefono': phone.isEmpty ? null : phone,
            'categoria_principal_id': categoryId?.isEmpty ?? true
                ? null
                : categoryId,
          };
          print('📝 DEBUG: providerData = $providerData');

          await supabaseClient.from('perfil_proveedor').upsert(providerData);
          print('✅ DEBUG: Inserción en perfil_proveedor exitosa');
        } catch (e) {
          print('⚠️ DEBUG: Error insertando en perfil_proveedor (puede ser RLS): $e');
          // Continuar aunque falle - puede ser un problema de RLS sin sesión
        }
      }

      print('✅ DEBUG: Registro completado exitosamente');
      
      // Si se requiere confirmación de email, lanzar excepción DESPUÉS de guardar los perfiles
      if (needsEmailConfirmation) {
        print('📧 DEBUG: Se requiere confirmación de email');
        throw EmailConfirmationRequiredException();
      }
      
      return User(
        id: userId,
        email: response.user!.email!,
        name: name,
        role: role,
        roleDetail: 'normal',
        phone: phone,
        businessName: businessName,
        description: description,
        categoryId: categoryId,
      );
    } catch (e) {
      print('❌ DEBUG: Error general en registro: $e');
      if (e is EmailConfirmationRequiredException) {
        rethrow;
      } else if (e is supabase.AuthApiException &&
          e.statusCode == '422' &&
          e.message.contains('User already registered')) {
        throw UserAlreadyRegisteredException();
      }
      throw Exception('Registration error: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return null;

      final userId = user.id;

      final clientProfile = await supabaseClient
          .from('perfil_cliente')
          .select()
          .eq('usuario_id', userId)
          .maybeSingle();

      if (clientProfile != null) {
        return User(
          id: userId,
          email: user.email!,
          name: clientProfile['nombre_completo'] as String,
          role: 'client',
          roleDetail: 'normal',
          phone: clientProfile['telefono'] as String?,
          avatarUrl: clientProfile['avatar_url'] as String?,
        );
      }

      final providerProfile = await supabaseClient
          .from('perfil_proveedor')
          .select()
          .eq('usuario_id', userId)
          .maybeSingle();

      if (providerProfile != null) {
        return User(
          id: userId,
          email: user.email!,
          name: providerProfile['nombre_negocio'] as String,
          role: 'provider',
          roleDetail: 'normal',
          phone: providerProfile['telefono'] as String?,
          avatarUrl: providerProfile['avatar_url'] as String?,
          businessName: providerProfile['nombre_negocio'] as String?,
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<List<ServiceCategory>> getServiceCategories() async {
    try {
      final response = await supabaseClient
          .from('categorias_servicio')
          .select();
      return (response as List)
          .map(
            (e) => ServiceCategory(
              id: e['id'] as String,
              name: e['nombre'] as String,
              description: e['descripcion'] as String?,
              icon: e['icono'] as String?,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get service categories: $e');
    }
  }

  @override
  Future<String> createRequest(params) async {
    try {
      print('=== CREANDO EVENTO ===');
      print('Cliente ID: ${params.clientId}');
      print('Título: ${params.title}');
      print('Tipo de evento ID: ${params.eventTypeId}');
      print('Fecha: ${params.eventDate}');
      print('Hora: ${params.eventTime}');
      print('Ubicación: ${params.location}');
      print('Dirección: ${params.address}');
      print('Invitados: ${params.guestCount}');

      // Crear solo el evento
      final eventData = <String, dynamic>{
        'cliente_usuario_id': params.clientId,
        'titulo': params.title,
        'tipo_evento_id': params.eventTypeId,
        'fecha_evento': params.eventDate.toIso8601String().split('T')[0],
        'estado': 'planning',
      };

      // Solo agregar campos opcionales si tienen valores
      final eventTimeStr = params.eventTime?.toString() ?? '';
      if (eventTimeStr.isNotEmpty) {
        eventData['hora_evento'] = params.eventTime;
      }
      final locationStr = params.location?.toString() ?? '';
      if (locationStr.isNotEmpty) {
        eventData['nombre_lugar'] = params.location;
      }
      final addressStr = params.address?.toString() ?? '';
      if (addressStr.isNotEmpty) {
        eventData['direccion'] = params.address;
      }
      final guestCount = params.guestCount as int?;
      if (guestCount != null && guestCount > 0) {
        eventData['numero_invitados'] = guestCount;
      }

      print('Datos del evento a insertar: $eventData');

      final eventResponse = await supabaseClient
          .from('eventos')
          .insert(eventData)
          .select()
          .single();

      final eventId = eventResponse['id'] as String;
      print('Evento creado con ID: $eventId');
      print('=== EVENTO CREADO EXITOSAMENTE ===');

      return eventId;
    } catch (e) {
      print('=== ERROR DETALLADO ===');
      print('Error completo: $e');
      print('Tipo de error: ${e.runtimeType}');

      // Proporcionar mensaje de error más específico
      String errorMessage;
      if (e.toString().contains('permission denied') ||
          e.toString().contains('policy')) {
        errorMessage =
            'Error de permisos: Verifica las políticas RLS en Supabase. Usuario: ${params.clientId}';
      } else if (e.toString().contains('foreign key') ||
          e.toString().contains('violates foreign key constraint')) {
        errorMessage =
            'Error: El tipo de evento no existe. EventType: ${params.eventTypeId}';
      } else if (e.toString().contains('violates not-null constraint')) {
        final match = RegExp(r'column "([^"]+)"').firstMatch(e.toString());
        final field = match?.group(1) ?? 'desconocido';
        errorMessage = 'Error: El campo "$field" es requerido pero está vacío.';
      } else if (e.toString().contains('invalid input syntax for type uuid')) {
        errorMessage = 'Error: Formato UUID inválido';
      } else if (e.toString().contains('duplicate key value')) {
        errorMessage = 'Error: Ya existe un evento similar.';
      } else if (e.toString().contains('invalid input syntax for type time')) {
        errorMessage = 'Error: Formato de hora inválido: ${params.eventTime}';
      } else {
        errorMessage = 'Error al crear evento: ${e.toString()}';
      }

      print('Mensaje de error final: $errorMessage');
      throw Exception(errorMessage);
    }
  }

  @override
  Future<Map<String, int>> getProviderDashboardData(String providerId) async {
    try {
      final providerProfile = await supabaseClient
        .from('perfil_proveedor')
        .select('categoria_principal_id')
        .eq('usuario_id', providerId)
        .maybeSingle();

      final providerCategoryId =
        (providerProfile as Map<String, dynamic>?)?['categoria_principal_id']
          as String?;

      final newRequests = await supabaseClient
          .from('solicitudes')
          .select('id')
        .eq('estado', 'abierta')
        .eq('categoria_servicio_id', providerCategoryId ?? '');

      final ongoingRequests = await supabaseClient
          .from('cotizaciones')
          .select('id')
          .eq('proveedor_usuario_id', providerId)
          .eq('estado', 'pendiente');

      return {
        'newRequestsCount': (newRequests as List).length,
        'ongoingRequestsCount': (ongoingRequests as List).length,
      };
    } catch (e) {
      throw Exception('Failed to get dashboard data: $e');
    }
  }
}
