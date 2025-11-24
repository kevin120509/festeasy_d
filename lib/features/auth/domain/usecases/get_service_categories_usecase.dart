import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/features/auth/domain/entities/service_category.dart';
import 'package:festeasy/features/auth/domain/repositories/auth_repository.dart';

class GetServiceCategoriesUseCase {
  final AuthRepository repository;

  GetServiceCategoriesUseCase(this.repository);

  Future<Either<Failure, List<ServiceCategory>>> call() async {
    return await repository.getServiceCategories();
  }
}
