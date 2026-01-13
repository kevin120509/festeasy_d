import '../../domain/entities/quote.dart';

class QuoteModel extends Quote {
  const QuoteModel({
    required super.id,
    required super.requestId,
    required super.providerId,
    required super.serviceId,
    required super.proposedPrice,
    required super.breakdown,
    super.notes,
    super.validUntil,
    required super.status,
    required super.createdAt,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      requestId: json['solicitud_id'] as String,
      providerId: json['proveedor_usuario_id'] as String,
      serviceId: json['paquete_id'] as String? ?? '', // Handle nullable package
      proposedPrice: (json['precio_propuesto'] as num).toDouble(),
      breakdown: json['desglose'] as Map<String, dynamic>? ?? {},
      notes: json['notas'] as String?,
      validUntil: json['valida_hasta'] != null ? DateTime.parse(json['valida_hasta'] as String) : null,
      status: json['estado'] as String,
      createdAt: json['creado_en'] != null ? DateTime.parse(json['creado_en'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'solicitud_id': requestId,
      'proveedor_usuario_id': providerId,
      'paquete_id': serviceId.isNotEmpty ? serviceId : null,
      'precio_propuesto': proposedPrice,
      'desglose': breakdown,
      'notas': notes,
      if (validUntil != null) 'valida_hasta': validUntil!.toIso8601String().split('T')[0],
      'estado': status,
      'creado_en': createdAt.toIso8601String(),
    };
  }
}