import '../../domain/entities/quote.dart';

/// Quote data model for Supabase integration
class QuoteModel extends Quote {
  const QuoteModel({
    required super.id,
    required super.requestId,
    required super.providerId,
    super.serviceId,
    required super.proposedPrice,
    super.breakdown,
    super.notes,
    super.validUntil,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create QuoteModel from Supabase JSON
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      providerId: json['provider_id'] as String,
      serviceId: json['service_id'] as String?,
      proposedPrice: (json['proposed_price'] as num).toDouble(),
      breakdown: json['breakdown'] as Map<String, dynamic>?,
      notes: json['notes'] as String?,
      validUntil: json['valid_until'] != null
          ? DateTime.parse(json['valid_until'] as String)
          : null,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'provider_id': providerId,
      'service_id': serviceId,
      'proposed_price': proposedPrice,
      'breakdown': breakdown,
      'notes': notes,
      'valid_until': validUntil?.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  QuoteModel copyWith({
    String? id,
    String? requestId,
    String? providerId,
    String? serviceId,
    double? proposedPrice,
    Map<String, dynamic>? breakdown,
    String? notes,
    DateTime? validUntil,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      providerId: providerId ?? this.providerId,
      serviceId: serviceId ?? this.serviceId,
      proposedPrice: proposedPrice ?? this.proposedPrice,
      breakdown: breakdown ?? this.breakdown,
      notes: notes ?? this.notes,
      validUntil: validUntil ?? this.validUntil,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
