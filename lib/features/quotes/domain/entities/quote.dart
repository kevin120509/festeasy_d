import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  final String id;
  final String requestId;
  final String providerId;
  final String serviceId;
  final double proposedPrice;
  final Map<String, dynamic> breakdown;
  final String notes;
  final DateTime validUntil;
  final String status;

  const Quote({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.serviceId,
    required this.proposedPrice,
    required this.breakdown,
    required this.notes,
    required this.validUntil,
    required this.status,
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
      ];
}