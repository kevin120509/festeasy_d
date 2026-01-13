import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/request_model.dart';

/// Remote data source for requests using Supabase
abstract class RequestsRemoteDataSource {
  /// Get all requests (optionally filtered by user or status)
  Future<List<RequestModel>> getRequests({
    String? userId,
    String? status,
    String? categoryId,
  });

  /// Get requests for providers excluding those already quoted by the provider
  Future<List<RequestModel>> getProviderNewRequests({
    required String providerUserId,
  });

  /// Get a single request by ID
  Future<RequestModel> getRequestById(String id);

  /// Create a new request
  Future<RequestModel> createRequest(RequestModel request);

  /// Update an existing request
  Future<RequestModel> updateRequest(RequestModel request);

  /// Delete a request
  Future<void> deleteRequest(String id);
}

class RequestsRemoteDataSourceImpl implements RequestsRemoteDataSource {
  final SupabaseClient supabaseClient;

  RequestsRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<RequestModel>> getRequests({
    String? userId,
    String? status,
    String? categoryId,
  }) async {
    try {
      var query = supabaseClient.from('solicitudes').select('''
        *,
        eventos (
          id,
          titulo,
          tipo_evento_id,
          fecha_evento,
          hora_evento,
          nombre_lugar,
          direccion,
          numero_invitados,
          presupuesto_total,
          estado
        )
      ''');

      if (userId != null) {
        query = query.eq('cliente_usuario_id', userId);
      }
      if (status != null) {
        query = query.eq('estado', status);
      }
      if (categoryId != null) {
        query = query.eq('categoria_servicio_id', categoryId);
      }

      final response = await query.order('creado_en', ascending: false);

      return (response as List)
          .map((json) => RequestModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch requests: $e');
    }
  }

  @override
  Future<List<RequestModel>> getProviderNewRequests({
    required String providerUserId,
  }) async {
    try {
      print('🔍 DEBUG getProviderNewRequests: providerUserId = $providerUserId');
      
      // 0) Get provider's main service category
      final providerProfile = await supabaseClient
          .from('perfil_proveedor')
          .select('categoria_principal_id')
          .eq('usuario_id', providerUserId)
          .maybeSingle();

      print('🔍 DEBUG: providerProfile = $providerProfile');

      final providerCategoryId =
          (providerProfile as Map<String, dynamic>?)?['categoria_principal_id']
              as String?;

      print('🔍 DEBUG: providerCategoryId = $providerCategoryId');

      // If the provider has no category configured, it should not receive requests
      if (providerCategoryId == null || providerCategoryId.isEmpty) {
        print('⚠️ DEBUG: Proveedor sin categoría, retornando lista vacía');
        return [];
      }

      // 1) Fetch ids of requests already quoted by this provider
      final quoted = await supabaseClient
          .from('cotizaciones')
          .select('solicitud_id')
          .eq('proveedor_usuario_id', providerUserId);

      final quotedIds = <String>{
        for (final row in (quoted as List))
          if ((row as Map<String, dynamic>)['solicitud_id'] != null)
            (row['solicitud_id'] as String),
      };

      print('🔍 DEBUG: quotedIds = $quotedIds');

      // 2) Fetch requests
      final all = await getRequests(
        status: 'abierta',
        categoryId: providerCategoryId,
      );

      print('🔍 DEBUG: Solicitudes encontradas para categoría $providerCategoryId: ${all.length}');
      for (final r in all) {
        print('   - ${r.id}: ${r.title} (categoryId: ${r.categoryId})');
      }

      // 3) Filter out already quoted
      final filtered = all.where((r) => !quotedIds.contains(r.id)).toList();
      print('🔍 DEBUG: Solicitudes después de filtrar cotizadas: ${filtered.length}');
      
      return filtered;
    } catch (e) {
      throw Exception('Failed to fetch provider new requests: $e');
    }
  }

  @override
  Future<RequestModel> getRequestById(String id) async {
    try {
      final response = await supabaseClient
          .from('solicitudes')
          .select('*, eventos(*)')
          .eq('id', id)
          .single();

      return RequestModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch request: $e');
    }
  }

  @override
  Future<RequestModel> createRequest(RequestModel request) async {
    try {
      final response = await supabaseClient
          .from('solicitudes')
          .insert(request.toJson())
          .select()
          .single();

      return RequestModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  @override
  Future<RequestModel> updateRequest(RequestModel request) async {
    try {
      final response = await supabaseClient
          .from('solicitudes')
          .update(request.toJson())
          .eq('id', request.id)
          .select()
          .single();

      return RequestModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update request: $e');
    }
  }

  @override
  Future<void> deleteRequest(String id) async {
    try {
      await supabaseClient.from('solicitudes').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }
}
