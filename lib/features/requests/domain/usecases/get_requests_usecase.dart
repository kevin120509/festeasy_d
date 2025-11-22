import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/request.dart';
import '../repositories/requests_repository.dart';

class GetRequestsUseCase implements UseCase<List<Request>, NoParams> {
  final RequestsRepository repository;

  GetRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(NoParams params) async {
    return await repository.getRequests();
  }
}
