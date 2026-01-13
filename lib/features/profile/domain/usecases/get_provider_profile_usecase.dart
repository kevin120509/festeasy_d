import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/core/usecases/usecase.dart';
import 'package:festeasy/features/profile/domain/entities/provider_profile.dart';
import 'package:festeasy/features/profile/domain/repositories/profile_repository.dart';

class GetProviderProfileUseCase implements UseCase<ProviderProfile, String> {
  final ProfileRepository repository;

  GetProviderProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProviderProfile>> call(String userId) async {
    return await repository.getProviderProfile(userId);
  }
}
