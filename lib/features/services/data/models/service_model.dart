import '../../domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.providerId,
    required super.categoryId,
    required super.name,
    required super.description,
    required super.basePrice,
    required super.active,
    required super.portfolioImages,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      providerId: json['provider_id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      basePrice: (json['base_price'] as num).toDouble(),
      active: json['active'] as bool,
      portfolioImages: List<String>.from(json['portfolio_images'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'base_price': basePrice,
      'active': active,
      'portfolio_images': portfolioImages,
    };
  }
}
