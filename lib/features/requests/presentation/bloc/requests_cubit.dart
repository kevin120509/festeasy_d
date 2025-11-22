import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/request.dart';
import '../../domain/usecases/get_requests_usecase.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit(this._getRequestsUseCase) : super(const RequestsState());

  final GetRequestsUseCase _getRequestsUseCase;

  Future<void> loadRequests() async {
    emit(state.copyWith(status: RequestsStatus.loading));
    final result = await _getRequestsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: RequestsStatus.failure)),
      (requests) => emit(state.copyWith(
        status: RequestsStatus.success,
        requests: requests,
      )),
    );
  }
}
