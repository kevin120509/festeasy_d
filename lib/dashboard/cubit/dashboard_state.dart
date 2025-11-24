part of 'dashboard_cubit.dart';

enum DashboardStatus {
  initial,
  loading,
  success,
  failure,
}

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.newRequestsCount = 0,
    this.ongoingRequestsCount = 0,
    this.errorMessage,
  });

  final DashboardStatus status;
  final int newRequestsCount;
  final int ongoingRequestsCount;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        newRequestsCount,
        ongoingRequestsCount,
        errorMessage,
      ];

  DashboardState copyWith({
    DashboardStatus? status,
    int? newRequestsCount,
    int? ongoingRequestsCount,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      newRequestsCount: newRequestsCount ?? this.newRequestsCount,
      ongoingRequestsCount: ongoingRequestsCount ?? this.ongoingRequestsCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
