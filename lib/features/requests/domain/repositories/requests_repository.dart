import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/request.dart';

abstract class RequestsRepository {
  Future<Either<Failure, List<Request>>> getRequests({String? userId});
  Future<Either<Failure, List<Request>>> getProviderNewRequests({
    required String providerUserId,
  });
  Future<Either<Failure, Request>> getRequestById(String id);
  Future<Either<Failure, Request>> createRequest(Request request);
}
