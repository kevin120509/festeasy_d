import 'package:equatable/equatable.dart';

class Request extends Equatable {
  final String id;
  final String clientId;
  final String eventId;
  final String categoryId;
  final String title;
  final String description;
  final Map<String, dynamic>? specifications;
  final double? budgetEstimate;
  final String status;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Event information
  final DateTime? eventDate;
  final String? eventTime;
  final String? location;
  final int? guestCount;

  final String? eventTypeId;
  final String? address;
  final double? totalBudget;
  final String? eventStatus;

  const Request({
    required this.id,
    required this.clientId,
    required this.eventId,
    required this.categoryId,
    required this.title,
    required this.description,
    this.specifications,
    this.budgetEstimate,
    required this.status,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
    this.eventDate,
    this.eventTime,
    this.location,
    this.guestCount,
    this.eventTypeId,
    this.address,
    this.totalBudget,
    this.eventStatus,
  });

  @override
  List<Object?> get props => [
    id,
    clientId,
    eventId,
    categoryId,
    title,
    description,
    specifications,
    budgetEstimate,
    status,
    expiresAt,
    createdAt,
    updatedAt,
    eventDate,
    eventTime,
    location,
    guestCount,
    eventTypeId,
    address,
    totalBudget,
    eventStatus,
  ];
}
