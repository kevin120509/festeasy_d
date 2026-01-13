import 'package:equatable/equatable.dart';

class ProviderProfile extends Equatable {
  final String id;
  final String userId;
  final String businessName;
  final String? description;
  final String? phone;
  final String? avatarUrl;
  final String? locationKey; // clave_lugar
  final String? mainCategoryId;

  const ProviderProfile({
    required this.id,
    required this.userId,
    required this.businessName,
    this.description,
    this.phone,
    this.avatarUrl,
    this.locationKey,
    this.mainCategoryId,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        businessName,
        description,
        phone,
        avatarUrl,
        locationKey,
        mainCategoryId,
      ];
}
