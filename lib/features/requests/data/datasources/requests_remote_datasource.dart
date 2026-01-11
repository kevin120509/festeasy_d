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

      return RequestModel.fromJson(response as Map<String, dynamic>);
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
