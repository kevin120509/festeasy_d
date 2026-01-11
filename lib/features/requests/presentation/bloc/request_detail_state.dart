part of 'request_detail_cubit.dart';

enum RequestDetailStatus { initial, loading, success, failure }

class RequestDetailState extends Equatable {
  const RequestDetailState({
    this.status = RequestDetailStatus.initial,
    this.request,
  });

  final RequestDetailStatus status;
  final Request? request;

  RequestDetailState copyWith({
    RequestDetailStatus? status,
    Request? request,
  }) {
    return RequestDetailState(
      status: status ?? this.status,
      request: request ?? this.request,
    );
  }

  @override
  List<Object?> get props => [status, request];
}
