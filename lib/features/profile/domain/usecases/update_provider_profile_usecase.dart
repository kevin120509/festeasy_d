import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/core/usecases/usecase.dart';
import 'package:festeasy/features/profile/domain/entities/provider_profile.dart';
import 'package:festeasy/features/profile/domain/repositories/profile_repository.dart';

class UpdateProviderProfileUseCase implements UseCase<ProviderProfile, ProviderProfile> {
  final ProfileRepository repository;

  UpdateProviderProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProviderProfile>> call(ProviderProfile params) async {
    return await repository.updateProviderProfile(params);
  }
}
