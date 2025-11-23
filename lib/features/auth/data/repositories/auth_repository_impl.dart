import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      return Right(await _remoteDataSource.login(email, password));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
  }) async {
    try {
      return Right(
        await _remoteDataSource.register(
          name: name,
          email: email,
          password: password,
          role: role,
          phone: phone,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}