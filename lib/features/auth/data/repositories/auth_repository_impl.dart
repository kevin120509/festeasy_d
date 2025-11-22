import 'package:dartz/dartz.dart';
import '../../../../app/router/auth_service.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      if (email.isNotEmpty && password.isNotEmpty) {
        authService.login();
        return const Right(UserModel(id: '1', email: 'test@test.com', name: 'Test User'));
      } else {
        return const Left(ServerFailure('Invalid credentials'));
      }
    } catch (e) {
      return const Left(ServerFailure('Login failed'));
    }
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      authService.login();
      return const Right(UserModel(id: '1', email: 'test@test.com', name: 'Test User'));
    } catch (e) {
      return const Left(ServerFailure('Registration failed'));
    }
  }
}
