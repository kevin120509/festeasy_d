import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/request.dart';
import '../../domain/repositories/requests_repository.dart';
import '../datasources/requests_remote_datasource.dart';
import '../models/request_model.dart';

class RequestsRepositoryImpl implements RequestsRepository {
  final RequestsRemoteDataSource _remoteDataSource;

  RequestsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Request>>> getRequests({String? userId}) async {
    try {
      final requests = await _remoteDataSource.getRequests(userId: userId);
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
      final requestModel = RequestModel(
        id: request.id,
        clientId: request.clientId,
        eventId: request.eventId,
        categoryId: request.categoryId,
        title: request.title,
        description: request.description,
        specifications: request.specifications,
        budgetEstimate: request.budgetEstimate,
        status: request.status,
        expiresAt: request.expiresAt,
        createdAt: request.createdAt,
        updatedAt: request.updatedAt,
      );

      final createdRequestModel = await _remoteDataSource.createRequest(
        requestModel,
      );
      return Right(createdRequestModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
