import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quote_model.dart';

/// Remote data source for quotes using Supabase
abstract class QuoteRemoteDataSource {
  /// Get all quotes for a specific request
  Future<List<QuoteModel>> getQuotesForRequest(String requestId);

  /// Get quotes created by a provider
  Future<List<QuoteModel>> getQuotesByProvider(String providerId);

  /// Get a single quote by ID
  Future<QuoteModel> getQuoteById(String id);

  /// Create a new quote
  Future<QuoteModel> createQuote(QuoteModel quote);

  /// Update quote status (accept/reject)
  Future<QuoteModel> updateQuoteStatus(String quoteId, String status);

  /// Delete a quote by ID
  Future<void> deleteQuote(String quoteId);

  /// Update an existing quote
  Future<QuoteModel> updateQuote(QuoteModel quote);
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final SupabaseClient supabaseClient;

  QuoteRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<QuoteModel>> getQuotesForRequest(String requestId) async {
    try {
      final response = await supabaseClient
          .from('cotizaciones')
          .select()
          .eq('solicitud_id', requestId)
          .order('creado_en', ascending: false);

      return (response as List)
          .map((json) => QuoteModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch quotes for request: $e');
    }
  }

  @override
  Future<List<QuoteModel>> getQuotesByProvider(String providerId) async {
    try {
      final response = await supabaseClient
          .from('cotizaciones')
          .select()
          .eq('proveedor_usuario_id', providerId)
          .order('creado_en', ascending: false);

      return (response as List)
          .map((json) => QuoteModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch provider quotes: $e');
    }
  }

  @override
  Future<QuoteModel> getQuoteById(String id) async {
    try {
      final response = await supabaseClient
          .from('cotizaciones')
          .select()
          .eq('id', id)
          .single();

      return QuoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch quote: $e');
    }
  }

  @override
  Future<QuoteModel> createQuote(QuoteModel quote) async {
    try {
      final response = await supabaseClient
          .from('cotizaciones')
          .insert(quote.toJson())
          .select()
          .single();

      return QuoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create quote: $e');
    }
  }

  @override
  Future<QuoteModel> updateQuoteStatus(String quoteId, String status) async {
    try {
      final response = await supabaseClient
          .from('cotizaciones')
          .update({
            'estado': status,
            'actualizado_en': DateTime.now().toIso8601String(),
          })
          .eq('id', quoteId)
          .select()
          .single();

      return QuoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update quote status: $e');
    }
  }

  @override
  Future<void> deleteQuote(String quoteId) async {
    try {
      await supabaseClient.from('cotizaciones').delete().eq('id', quoteId);
    } catch (e) {
      throw Exception('Failed to delete quote: $e');
    }
  }

  @override
  Future<QuoteModel> updateQuote(QuoteModel quote) async {
    try {
      final response = await supabaseClient
          .from('cotizaciones')
          .update({
            'precio_propuesto': quote.proposedPrice,
            'notas': quote.notes,
            'valida_hasta': quote.validUntil?.toIso8601String().split('T')[0],
            'actualizado_en': DateTime.now().toIso8601String(),
          })
          .eq('id', quote.id)
          .select()
          .single();

      return QuoteModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update quote: $e');
    }
  }
}