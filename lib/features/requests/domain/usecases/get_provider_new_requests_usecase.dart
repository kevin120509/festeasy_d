import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/request.dart';
import '../repositories/requests_repository.dart';

class GetProviderNewRequestsUseCase {
  final RequestsRepository repository;

  GetProviderNewRequestsUseCase(this.repository);

  Future<Either<Failure, List<Request>>> call(String providerUserId) {
    return repository.getProviderNewRequests(providerUserId: providerUserId);
  }
}
