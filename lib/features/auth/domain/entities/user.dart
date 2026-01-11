import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role;
  final String roleDetail;
  final String? phone;
  final String? avatarUrl;
  final String? businessName;
  final String? description;
  final String? categoryId;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.roleDetail = 'normal',
    this.phone,
    this.avatarUrl,
    this.businessName,
    this.description,
    this.categoryId,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    role,
    roleDetail,
    phone,
    avatarUrl,
    businessName,
    description,
    categoryId,
  ];
}
