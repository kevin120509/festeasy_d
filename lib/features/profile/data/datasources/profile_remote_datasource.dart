import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/provider_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProviderProfileModel> getProviderProfile(String userId);
  Future<ProviderProfileModel> updateProviderProfile(ProviderProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<ProviderProfileModel> getProviderProfile(String userId) async {
    try {
      print('🔍 DEBUG getProviderProfile: userId = $userId');
      
      // Primero intentar obtener el perfil existente
      final response = await supabaseClient
          .from('perfil_proveedor')
          .select()
          .eq('usuario_id', userId)
          .maybeSingle();
      
      if (response != null) {
        print('✅ DEBUG: Perfil encontrado');
        return ProviderProfileModel.fromJson(response);
      }
      
      print('⚠️ DEBUG: Perfil no existe, intentando crear...');
      
      // Si no existe el perfil, intentar crearlo automáticamente
      final user = supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }
      
      final userMetadata = user.userMetadata;
      print('🔍 DEBUG: userMetadata = $userMetadata');
      
      // Leer datos de los metadatos del usuario (guardados durante el registro)
      final businessName = userMetadata?['businessName'] as String? ?? 
                           userMetadata?['full_name'] as String? ?? 
                           'Mi Negocio';
      final phone = userMetadata?['phone'] as String?;
      final mainCategoryId = userMetadata?['categoryId'] as String?;
      
      print('🔍 DEBUG: businessName=$businessName, phone=$phone, categoryId=$mainCategoryId');
      
      // 1. Asegurar que el usuario existe en la tabla users
      try {
        final existingUser = await supabaseClient
            .from('users')
            .select('id')
            .eq('id', userId)
            .maybeSingle();
        
        if (existingUser == null) {
          print('📝 DEBUG: Insertando usuario en tabla users...');
          await supabaseClient.from('users').insert({
            'id': userId,
            'correo_electronico': user.email ?? 'unknown@email.com',
            'contrasena': 'managed_by_supabase_auth',
            'rol': 'provider',
            'correo_verificado_en': DateTime.now().toIso8601String(),
            'ultimo_acceso_en': DateTime.now().toIso8601String(),
            'estado': 'active',
          });
          print('✅ DEBUG: Usuario insertado en users');
        }
      } catch (e) {
        print('⚠️ DEBUG: Error con tabla users: $e');
      }
      
      // 2. Crear el perfil del proveedor
      try {
        print('📝 DEBUG: Insertando perfil_proveedor...');
        final insertResult = await supabaseClient.from('perfil_proveedor').insert({
          'usuario_id': userId,
          'nombre_negocio': businessName,
          'telefono': phone,
          'categoria_principal_id': mainCategoryId,
        }).select().single();
        
        print('✅ DEBUG: Perfil creado exitosamente');
        return ProviderProfileModel.fromJson(insertResult);
      } catch (insertError) {
        print('❌ DEBUG: Error insertando perfil: $insertError');
        
        // Si falló el insert, intentar obtener el perfil de nuevo (por si ya existía)
        final retryResponse = await supabaseClient
            .from('perfil_proveedor')
            .select()
            .eq('usuario_id', userId)
            .maybeSingle();
        
        if (retryResponse != null) {
          print('✅ DEBUG: Perfil encontrado en retry');
          return ProviderProfileModel.fromJson(retryResponse);
        }
        
        // Si todavía no existe, crear un perfil básico en memoria para que la UI funcione
        print('⚠️ DEBUG: Retornando perfil temporal');
        return ProviderProfileModel(
          id: userId,
          userId: userId,
          businessName: businessName,
          phone: phone,
          mainCategoryId: mainCategoryId,
        );
      }
    } catch (e) {
      print('❌ DEBUG: Error general: $e');
      throw Exception('Failed to fetch or create provider profile: $e');
    }
  }

  @override
  Future<ProviderProfileModel> updateProviderProfile(ProviderProfileModel profile) async {
    try {
      final response = await supabaseClient
          .from('perfil_proveedor')
          .update(profile.toJson())
          .eq('usuario_id', profile.userId)
          .select()
          .single();
      return ProviderProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update provider profile: $e');
    }
  }
}
