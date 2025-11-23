import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String role;
  final String phone;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
  });
}

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      role: params.role,
      phone: params.phone,
    );
  }
}