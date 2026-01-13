class PackageItem {
  final String id;
  final String packageId;
  final String name;
  final int quantity;
  final String? unit;
  final String? note;
  final DateTime createdAt;

  PackageItem({
    required this.id,
    required this.packageId,
    required this.name,
    required this.quantity,
    this.unit,
    this.note,
    required this.createdAt,
  });

  factory PackageItem.fromJson(Map<String, dynamic> json) {
    return PackageItem(
      id: json['id'] as String,
      packageId: json['paquete_id'] as String,
      name: json['nombre_item'] as String,
      quantity: json['cantidad'] as int,
      unit: json['unidad'] as String?,
      note: json['nota'] as String?,
      createdAt: DateTime.parse(json['creado_en'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paquete_id': packageId,
      'nombre_item': name,
      'cantidad': quantity,
      'unidad': unit,
      'nota': note,
      'creado_en': createdAt.toIso8601String(),
    };
  }
}
