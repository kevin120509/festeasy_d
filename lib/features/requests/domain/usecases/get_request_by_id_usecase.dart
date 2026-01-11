import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/request.dart';
import '../repositories/requests_repository.dart';

class GetRequestByIdUseCase implements UseCase<Request, GetRequestByIdParams> {
  final RequestsRepository repository;

  GetRequestByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Request>> call(GetRequestByIdParams params) async {
    return await repository.getRequestById(params.id);
  }
}

class GetRequestByIdParams extends Equatable {
  final String id;

  const GetRequestByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
