import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/features/auth/domain/repositories/auth_repository.dart';

class GetProviderDashboardDataUseCase {
  final AuthRepository repository;

  GetProviderDashboardDataUseCase(this.repository);

  Future<Either<Failure, Map<String, int>>> call(String providerId) async {
    // This is not ideal, the dashboard data should be in its own repository
    // but for the sake of simplicity we use the AuthRepository
    final result = await (repository as dynamic).getProviderDashboardData(providerId);
    return result as Either<Failure, Map<String, int>>;
  }
}
