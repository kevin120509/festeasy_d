import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/request.dart';
import '../../domain/usecases/get_provider_new_requests_usecase.dart';
import '../../domain/usecases/get_requests_usecase.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit(this._getRequestsUseCase, this._getProviderNewRequestsUseCase)
    : super(const RequestsState());

  final GetRequestsUseCase _getRequestsUseCase;
  final GetProviderNewRequestsUseCase _getProviderNewRequestsUseCase;

  Future<void> loadRequests() async {
    emit(state.copyWith(status: RequestsStatus.loading));
    final result = await _getRequestsUseCase.callWithoutParams();
    result.fold(
      (failure) => emit(state.copyWith(status: RequestsStatus.failure)),
      (requests) => emit(
        state.copyWith(
          status: RequestsStatus.success,
          requests: requests,
        ),
      ),
    );
  }

  Future<void> loadProviderNewRequests(String providerUserId) async {
    emit(state.copyWith(status: RequestsStatus.loading));
    final result = await _getProviderNewRequestsUseCase(providerUserId);
    result.fold(
      (failure) => emit(state.copyWith(status: RequestsStatus.failure)),
      (requests) => emit(
        state.copyWith(
          status: RequestsStatus.success,
          requests: requests,
        ),
      ),
    );
  }

  Future<void> loadClientRequests(String userId) async {
    emit(state.copyWith(status: RequestsStatus.loading));
    final result = await _getRequestsUseCase(GetRequestsParams(userId: userId));
    result.fold(
      (failure) => emit(state.copyWith(status: RequestsStatus.failure)),
      (requests) => emit(
        state.copyWith(
          status: RequestsStatus.success,
          requests: requests,
        ),
      ),
    );
  }
}
