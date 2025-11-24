import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/service_category.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
    String? businessName,
  });
  Future<Either<Failure, List<ServiceCategory>>> getServiceCategories();
  Future<Either<Failure, void>> createRequest(dynamic params);
  Future<Either<Failure, Map<String, int>>> getProviderDashboardData(
    String providerId,
  );
}
