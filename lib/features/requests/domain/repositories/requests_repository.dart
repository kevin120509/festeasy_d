import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/request.dart';

abstract class RequestsRepository {
  Future<Either<Failure, List<Request>>> getRequests();
  Future<Either<Failure, Request>> getRequestById(int id);
}
