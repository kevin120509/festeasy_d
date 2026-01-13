import 'package:equatable/equatable.dart';
import 'package:festeasy/features/profile/domain/entities/provider_profile.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProviderProfileState extends Equatable {
  final ProfileStatus status;
  final ProviderProfile? profile;
  final String? errorMessage;

  const ProviderProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  ProviderProfileState copyWith({
    ProfileStatus? status,
    ProviderProfile? profile,
    String? errorMessage,
  }) {
    return ProviderProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
