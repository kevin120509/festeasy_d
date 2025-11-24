import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:festeasy/dashboard/domain/usecases/get_provider_dashboard_data_usecase.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetProviderDashboardDataUseCase _getProviderDashboardDataUseCase;

  DashboardCubit(this._getProviderDashboardDataUseCase)
      : super(const DashboardState());

  Future<void> getDashboardData(String providerId) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    final result = await _getProviderDashboardDataUseCase(providerId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: DashboardStatus.success,
        newRequestsCount: data['newRequestsCount'],
        ongoingRequestsCount: data['ongoingRequestsCount'],
      )),
    );
  }
}
