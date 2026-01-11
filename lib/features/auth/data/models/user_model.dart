import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.roleDetail,
    super.phone,
    super.avatarUrl,
    super.businessName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['full_name'] as String,
      role: json['role'] as String,
      roleDetail: json['role_detail'] as String? ?? 'normal',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      businessName: json['business_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': name,
      'role': role,
      'role_detail': roleDetail,
      'phone': phone,
      'avatar_url': avatarUrl,
      'business_name': businessName,
    };
  }
}