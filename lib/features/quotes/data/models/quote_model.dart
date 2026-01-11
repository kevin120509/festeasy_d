import '../../domain/entities/quote.dart';

class QuoteModel extends Quote {
  const QuoteModel({
    required super.id,
    required super.requestId,
    required super.providerId,
    required super.serviceId,
    required super.proposedPrice,
    required super.breakdown,
    required super.notes,
    required super.validUntil,
    required super.status,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      providerId: json['provider_id'] as String,
      serviceId: json['service_id'] as String,
      proposedPrice: (json['proposed_price'] as num).toDouble(),
      breakdown: json['breakdown'] as Map<String, dynamic>,
      notes: json['notes'] as String,
      validUntil: DateTime.parse(json['valid_until'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'provider_id': providerId,
      'service_id': serviceId,
      'proposed_price': proposedPrice,
      'breakdown': breakdown,
      'notes': notes,
      'valid_until': validUntil.toIso8601String().split('T')[0],
      'status': status,
    };
  }
}