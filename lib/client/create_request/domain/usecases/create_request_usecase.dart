import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/features/auth/domain/repositories/auth_repository.dart';

class CreateRequestUseCase {
  final AuthRepository repository;

  CreateRequestUseCase(this.repository);

  Future<Either<Failure, String>> call(CreateRequestParams params) async {
    // Creates an event and returns its ID
    return await repository.createRequest(params);
  }
}

class CreateRequestParams extends Equatable {
  final String title;
  final String description;
  final String categoryId;
  final String eventTypeId; // Requerido para la tabla eventos
  final DateTime eventDate;
  final String eventTime;
  final String location;
  final String? address; // Opcional pero recomendado
  final int guestCount;
  final String clientId;

  const CreateRequestParams({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.eventTypeId,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    this.address,
    required this.guestCount,
    required this.clientId,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    categoryId,
    eventTypeId,
    eventDate,
    eventTime,
    location,
    address,
    guestCount,
    clientId,
  ];
}
