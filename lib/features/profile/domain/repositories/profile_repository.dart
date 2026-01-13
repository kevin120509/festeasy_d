import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/features/profile/domain/entities/provider_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProviderProfile>> getProviderProfile(String userId);
  Future<Either<Failure, ProviderProfile>> updateProviderProfile(ProviderProfile profile);
}
