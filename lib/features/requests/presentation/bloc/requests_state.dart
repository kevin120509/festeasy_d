part of 'requests_cubit.dart';

enum RequestsStatus { initial, loading, success, failure }

class RequestsState extends Equatable {
  const RequestsState({
    this.status = RequestsStatus.initial,
    this.requests = const [],
  });

  final RequestsStatus status;
  final List<Request> requests;

  RequestsState copyWith({
    RequestsStatus? status,
    List<Request>? requests,
  }) {
    return RequestsState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
    );
  }

  @override
  List<Object> get props => [status, requests];
}
