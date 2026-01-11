import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String id;
  final String providerId;
  final String categoryId;
  final String name;
  final String description;
  final double basePrice;
  final bool active;
  final List<String> portfolioImages;

  const Service({
    required this.id,
    required this.providerId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.active,
    required this.portfolioImages,
  });

  @override
  List<Object?> get props => [
        id,
        providerId,
        categoryId,
        name,
        description,
        basePrice,
        active,
        portfolioImages,
      ];
}
