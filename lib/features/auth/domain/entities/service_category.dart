import 'package:equatable/equatable.dart';

class ServiceCategory extends Equatable {
  const ServiceCategory({
    required this.id,
    required this.name,
    this.description,
    this.icon,
  });

  final String id;
  final String name;
  final String? description;
  final String? icon;

  @override
  List<Object?> get props => [id, name, description, icon];
}
