import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../data/mock_data.dart' hide Request;
import '../../domain/entities/request.dart';
import '../../domain/repositories/requests_repository.dart';
import '../models/request_model.dart';

class RequestsRepositoryImpl implements RequestsRepository {
  @override
  Future<Either<Failure, List<Request>>> getRequests() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final requests = MockData.mockRequests.map((e) => RequestModel(
        id: e.id,
        category: e.category,
        title: e.title,
        description: e.description,
        date: e.date,
        location: e.location,
        address: e.address,
        time: e.time,
        guests: e.guests,
        status: e.status,
      )).toList();
      return Right(requests);
    } catch (e) {
      return const Left(ServerFailure('Failed to fetch requests'));
    }
  }

  @override
  Future<Either<Failure, Request>> getRequestById(int id) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final request = MockData.mockRequests.firstWhere((element) => element.id == id);
      return Right(RequestModel(
        id: request.id,
        category: request.category,
        title: request.title,
        description: request.description,
        date: request.date,
        location: request.location,
        address: request.address,
        time: request.time,
        guests: request.guests,
        status: request.status,
      ));
    } catch (e) {
      return const Left(ServerFailure('Request not found'));
    }
  }
}
