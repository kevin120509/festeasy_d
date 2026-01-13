import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:festeasy/features/profile/data/models/provider_profile_model.dart';
import 'package:festeasy/features/profile/domain/entities/provider_profile.dart';
import 'package:festeasy/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProviderProfile>> getProviderProfile(String userId) async {
    try {
      final result = await remoteDataSource.getProviderProfile(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProviderProfile>> updateProviderProfile(ProviderProfile profile) async {
    try {
      final profileModel = ProviderProfileModel(
        id: profile.id,
        userId: profile.userId,
        businessName: profile.businessName,
        description: profile.description,
        phone: profile.phone,
        avatarUrl: profile.avatarUrl,
        locationKey: profile.locationKey,
        mainCategoryId: profile.mainCategoryId,
      );
      final result = await remoteDataSource.updateProviderProfile(profileModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
