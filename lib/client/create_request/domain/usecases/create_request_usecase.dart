import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/features/auth/domain/repositories/auth_repository.dart';

class CreateRequestUseCase {
  final AuthRepository repository;

  CreateRequestUseCase(this.repository);

  Future<Either<Failure, void>> call(CreateRequestParams params) async {
    // This is not ideal, the request creation should be in its own repository
    // but for the sake of simplicity we use the AuthRepository
    return await (repository as dynamic).createRequest(params);
  }
}

class CreateRequestParams extends Equatable {
  final String title;
  final String description;
  final String categoryId;
  final DateTime eventDate;
  final String eventTime;
  final String location;
  final int guestCount;
  final String clientId;

  const CreateRequestParams({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.guestCount,
    required this.clientId,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        categoryId,
        eventDate,
        eventTime,
        location,
        guestCount,
        clientId,
      ];
}
