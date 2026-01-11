import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.clientUserId,
    required super.title,
    required super.eventTypeId,
    required super.eventDate,
    super.eventTime,
    super.locationName,
    super.address,
    super.guestCount,
    super.totalBudget,
    required super.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      clientUserId: json['cliente_usuario_id'] as String,
      title: json['titulo'] as String,
      eventTypeId: json['tipo_evento_id'] as String,
      eventDate: DateTime.parse(json['fecha_evento'] as String),
      eventTime: json['hora_evento'] as String?,
      locationName: json['nombre_lugar'] as String?,
      address: json['direccion'] as String?,
      guestCount: json['numero_invitados'] as int?,
      totalBudget: (json['presupuesto_total'] as num?)?.toDouble() ?? 0.0,
      status: json['estado'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente_usuario_id': clientUserId,
      'titulo': title,
      'tipo_evento_id': eventTypeId,
      'fecha_evento': eventDate.toIso8601String().split('T')[0],
      'hora_evento': eventTime,
      'nombre_lugar': locationName,
      'direccion': address,
      'numero_invitados': guestCount,
      'presupuesto_total': totalBudget,
      'estado': status,
    };
  }
}