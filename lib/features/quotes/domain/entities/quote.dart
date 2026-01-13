import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String id;
  final String requestId;
  final String providerId;
  final String serviceId;
  final double proposedPrice;
  final Map<String, dynamic> breakdown;
  final String? notes;
  final DateTime? validUntil;
  final String status;
  final DateTime createdAt;

  const Quote({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.serviceId,
    required this.proposedPrice,
    required this.breakdown,
    this.notes,
    this.validUntil,
    required this.status,
    required this.createdAt,
  });

  /// Returns true if the quote is pending
  bool get isPending {
    final normalized = status.trim().toLowerCase();
    return normalized == 'pendiente' || normalized == 'pending';
  }

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
      ];
}