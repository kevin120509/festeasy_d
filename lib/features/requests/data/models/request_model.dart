import '../../domain/entities/request.dart';

class RequestModel extends Request {
  const RequestModel({
    required super.id,
    required super.clientId,
    required super.eventId,
    required super.categoryId,
    required super.title,
    required super.description,
    super.specifications,
    super.budgetEstimate,
    required super.status,
    super.expiresAt,
    required super.createdAt,
    required super.updatedAt,
    super.eventDate,
    super.eventTime,
    super.location,
    super.guestCount,
    super.eventTypeId,
    super.address,
    super.totalBudget,
    super.eventStatus,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      clientId: json['cliente_usuario_id'] as String,
      eventId: json['evento_id'] as String,
      categoryId: json['categoria_servicio_id'] as String,
      title: json['titulo'] as String,
      description: json['descripcion'] as String,
      specifications: json['especificaciones'] as Map<String, dynamic>?,
      budgetEstimate: json['presupuesto_estimado'] != null
          ? (json['presupuesto_estimado'] as num).toDouble()
          : null,
      status: json['estado'] as String,
      expiresAt: json['expira_en'] != null
          ? DateTime.parse(json['expira_en'] as String)
          : null,
      createdAt: DateTime.parse(json['creado_en'] as String),
      updatedAt: DateTime.parse(json['actualizado_en'] as String),
      eventDate: json['eventos']?['fecha_evento'] != null
          ? DateTime.parse(json['eventos']['fecha_evento'] as String)
          : null,
      eventTime: json['eventos']?['hora_evento'] as String?,
      location: json['eventos']?['nombre_lugar'] as String?,
      guestCount: json['eventos']?['numero_invitados'] as int?,
      eventTypeId: json['eventos']?['tipo_evento_id'] as String?,
      address: json['eventos']?['direccion'] as String?,
      totalBudget: json['eventos']?['presupuesto_total'] != null
          ? (json['eventos']['presupuesto_total'] as num).toDouble()
          : null,
      eventStatus: json['eventos']?['estado'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente_usuario_id': clientId,
      'evento_id': eventId,
      'categoria_servicio_id': categoryId,
      'titulo': title,
      'descripcion': description,
      'especificaciones': specifications,
      'presupuesto_estimado': budgetEstimate,
      'estado': status,
      'expira_en': expiresAt?.toIso8601String(),
    };
  }
}
