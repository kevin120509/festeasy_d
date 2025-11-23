import 'package:equatable/equatable.dart';

/// Quote entity represents a price proposal from a provider for a request
class Quote extends Equatable {
  final String id;
  final String requestId; // FK to requests
  final String providerId; // FK to profiles
  final String? serviceId; // FK to services (optional)
  final double proposedPrice;
  final Map<String, dynamic>? breakdown; // Price breakdown (JSONB)
  final String? notes; // Provider's observations
  final DateTime? validUntil; // Expiration date
  final String status; // 'pending', 'accepted', 'rejected', 'expired'
  final DateTime createdAt;
  final DateTime updatedAt;

  const Quote({
    required this.id,
    required this.requestId,
    required this.providerId,
    this.serviceId,
    required this.proposedPrice,
    this.breakdown,
    this.notes,
    this.validUntil,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    requestId,
    providerId,
    serviceId,
    proposedPrice,
    breakdown,
    notes,
    validUntil,
    status,
    createdAt,
    updatedAt,
  ];

  /// Helper to check if quote is still valid
  bool get isValid {
    if (status != 'pending') return false;
    if (validUntil == null) return true;
    return DateTime.now().isBefore(validUntil!);
  }

  /// Helper to check if quote is accepted
  bool get isAccepted => status == 'accepted';

  /// Helper to check if quote is pending
  bool get isPending => status == 'pending';
}
