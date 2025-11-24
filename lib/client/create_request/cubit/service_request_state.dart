part of 'service_request_cubit.dart';

enum ServiceRequestStatus {
  pure,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

extension ServiceRequestStatusX on ServiceRequestStatus {
  bool get isSubmissionInProgress =>
      this == ServiceRequestStatus.submissionInProgress;
  bool get isSubmissionSuccess => this == ServiceRequestStatus.submissionSuccess;
  bool get isSubmissionFailure => this == ServiceRequestStatus.submissionFailure;
}

class ServiceRequestState extends Equatable {
  const ServiceRequestState({
    this.title = '',
    this.description = '',
    this.eventDate,
    this.eventTime,
    this.location = '',
    this.guestCount,
    this.status = ServiceRequestStatus.pure,
    this.categoryId,
  });

  final String title;
  final String description;
  final DateTime? eventDate;
  final TimeOfDay? eventTime;
  final String location;
  final int? guestCount;
  final ServiceRequestStatus status;
  final String? categoryId;

  @override
  List<Object?> get props => [
        title,
        description,
        eventDate,
        eventTime,
        location,
        guestCount,
        status,
        categoryId,
      ];

  ServiceRequestState copyWith({
    String? title,
    String? description,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String? location,
    int? guestCount,
    ServiceRequestStatus? status,
    String? categoryId,
  }) {
    return ServiceRequestState(
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      location: location ?? this.location,
      guestCount: guestCount ?? this.guestCount,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
