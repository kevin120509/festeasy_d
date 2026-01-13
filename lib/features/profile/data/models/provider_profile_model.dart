import 'package:festeasy/features/profile/domain/entities/provider_profile.dart';

class ProviderProfileModel extends ProviderProfile {
  const ProviderProfileModel({
    required super.id,
    required super.userId,
    required super.businessName,
    super.description,
    super.phone,
    super.avatarUrl,
    super.locationKey,
    super.mainCategoryId,
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    return ProviderProfileModel(
      id: json['id'] as String,
      userId: json['usuario_id'] as String,
      businessName: json['nombre_negocio'] as String,
      description: json['descripcion'] as String?,
      phone: json['telefono'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      locationKey: json['clave_lugar'] as String?,
      mainCategoryId: json['categoria_principal_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': userId,
      'nombre_negocio': businessName,
      'descripcion': description,
      'telefono': phone,
      'avatar_url': avatarUrl,
      'clave_lugar': locationKey,
      'categoria_principal_id': mainCategoryId,
    };
  }
}
