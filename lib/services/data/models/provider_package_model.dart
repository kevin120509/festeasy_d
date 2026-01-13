class ProviderPackage {
  final String id;
  final String providerUserId;
  final String categoryId;
  final String name;
  final String? description;
  final double basePrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProviderPackage({
    required this.id,
    required this.providerUserId,
    required this.categoryId,
    required this.name,
    this.description,
    required this.basePrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProviderPackage.fromJson(Map<String, dynamic> json) {
    return ProviderPackage(
      id: json['id'] as String,
      providerUserId: json['proveedor_usuario_id'] as String,
      categoryId: json['categoria_servicio_id'] as String,
      name: json['nombre'] as String,
      description: json['descripcion'] as String?,
      basePrice: (json['precio_base'] as num).toDouble(),
      status: json['estado'] as String,
      createdAt: DateTime.parse(json['creado_en'] as String),
      updatedAt: DateTime.parse(json['actualizado_en'] as String),
    );
  }

  Map<String, dynamic> toJson({bool forInsert = false}) {
    final map = <String, dynamic>{
      'proveedor_usuario_id': providerUserId,
      'nombre': name,
      'descripcion': description,
      'precio_base': basePrice,
      'estado': status,
      'creado_en': createdAt.toIso8601String(),
      'actualizado_en': updatedAt.toIso8601String(),
    };
    if (categoryId.isNotEmpty) {
      map['categoria_servicio_id'] = categoryId;
    }
    if (!forInsert) {
      map['id'] = id;
    } else if (id.isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }
}
