import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/request.dart';
import '../../domain/usecases/get_request_by_id_usecase.dart';

part 'request_detail_state.dart';

class RequestDetailCubit extends Cubit<RequestDetailState> {
  RequestDetailCubit(this._getRequestByIdUseCase)
    : super(const RequestDetailState());

  final GetRequestByIdUseCase _getRequestByIdUseCase;

  Future<void> loadRequest(String id) async {
    emit(state.copyWith(status: RequestDetailStatus.loading));
    final result = await _getRequestByIdUseCase(GetRequestByIdParams(id: id));
    result.fold(
      (failure) => emit(state.copyWith(status: RequestDetailStatus.failure)),
      (request) => emit(
        state.copyWith(
          status: RequestDetailStatus.success,
          request: request,
        ),
      ),
    );
  }
}
