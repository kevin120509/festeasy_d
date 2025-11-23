import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/request.dart';
import '../../domain/repositories/requests_repository.dart';
import '../datasources/requests_remote_datasource.dart';

class RequestsRepositoryImpl implements RequestsRepository {
  final RequestsRemoteDataSource _remoteDataSource;

  RequestsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Request>>> getRequests() async {
    try {
      final requests = await _remoteDataSource.getRequests();
      return Right(List<Request>.from(requests));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Request>> getRequestById(String id) async {
    try {
      final requestModel = await _remoteDataSource.getRequestById(id);
      return Right(requestModel as Request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Request>> createRequest(Request request) async {
    try {
      // Cast Request to dynamic to avoid type issues
      final createdRequestModel = await _remoteDataSource.createRequest(
        request as dynamic,
      );
      return Right(createdRequestModel as Request);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
