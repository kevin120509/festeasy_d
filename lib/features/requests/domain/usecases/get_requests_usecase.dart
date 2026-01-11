import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/request.dart';
import '../repositories/requests_repository.dart';

class GetRequestsUseCase implements UseCase<List<Request>, GetRequestsParams> {
  final RequestsRepository repository;

  GetRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(GetRequestsParams params) async {
    return await repository.getRequests(userId: params.userId);
  }

  // Convenience method for backwards compatibility
  Future<Either<Failure, List<Request>>> callWithoutParams() async {
    return await repository.getRequests();
  }
}

class GetRequestsParams extends Equatable {
  final String? userId;

  const GetRequestsParams({this.userId});

  @override
  List<Object?> get props => [userId];
}
