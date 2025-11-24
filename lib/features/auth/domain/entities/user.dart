import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? phone;
  final String? avatarUrl;
  final String? businessName;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phone,
    this.avatarUrl,
    this.businessName,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    role,
    phone,
    avatarUrl,
    businessName,
  ];
}
