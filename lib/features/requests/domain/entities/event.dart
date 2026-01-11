import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String clientUserId; // cliente_usuario_id
  final String title; // titulo
  final String eventTypeId; // tipo_evento_id
  final DateTime eventDate; // fecha_evento
  final String? eventTime; // hora_evento (nullable)
  final String? locationName; // nombre_lugar (nullable)
  final String? address; // direccion (nullable)
  final int? guestCount; // numero_invitados (nullable)
  final double totalBudget; // presupuesto_total
  final String status; // estado

  const Event({
    required this.id,
    required this.clientUserId,
    required this.title,
    required this.eventTypeId,
    required this.eventDate,
    this.eventTime,
    this.locationName,
    this.address,
    this.guestCount,
    this.totalBudget = 0.0,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        clientUserId,
        title,
        eventTypeId,
        eventDate,
        eventTime,
        locationName,
        address,
        guestCount,
        totalBudget,
        status,
      ];
}