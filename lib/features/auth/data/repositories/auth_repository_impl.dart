import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/service_category.dart';
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
    String? businessName,
  }) async {
    try {
      return Right(
        await _remoteDataSource.register(
          name: name,
          email: email,
          password: password,
          role: role,
          phone: phone,
          businessName: businessName,
        ),
      );
    } on EmailConfirmationRequiredException catch (e) {
      return Left(EmailConfirmationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceCategory>>> getServiceCategories() async {
    try {
      return Right(await _remoteDataSource.getServiceCategories());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createRequest(params) async {
    try {
      return Right(await _remoteDataSource.createRequest(params));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getProviderDashboardData(
    String providerId,
  ) async {
    try {
      return Right(
        await _remoteDataSource.getProviderDashboardData(providerId),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
