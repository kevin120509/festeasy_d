import 'package:bloc/bloc.dart';
import 'package:festeasy/features/profile/domain/entities/provider_profile.dart';
import 'package:festeasy/features/profile/domain/usecases/get_provider_profile_usecase.dart';
import 'package:festeasy/features/profile/domain/usecases/update_provider_profile_usecase.dart';
import 'provider_profile_state.dart';

class ProviderProfileCubit extends Cubit<ProviderProfileState> {
  final GetProviderProfileUseCase _getProfile;
  final UpdateProviderProfileUseCase _updateProfile;

  ProviderProfileCubit(this._getProfile, this._updateProfile)
      : super(const ProviderProfileState());

  Future<void> loadProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getProfile(userId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (profile) => emit(state.copyWith(
        status: ProfileStatus.success,
        profile: profile,
      )),
    );
  }

  Future<void> updateProfile(ProviderProfile profile) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _updateProfile(profile);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: failure.message,
      )),
      (updatedProfile) => emit(state.copyWith(
        status: ProfileStatus.success,
        profile: updatedProfile,
      )),
    );
  }
}
