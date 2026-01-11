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
  bool get isSubmissionSuccess =>
      this == ServiceRequestStatus.submissionSuccess;
  bool get isSubmissionFailure =>
      this == ServiceRequestStatus.submissionFailure;
}

class ServiceRequestState extends Equatable {
  const ServiceRequestState({
    this.title = '',
    this.description = '',
    this.eventDate,
    this.eventTime,
    this.location = '',
    this.address = '',
    this.guestCount,
    this.status = ServiceRequestStatus.pure,
    this.categoryId,
    this.eventTypeId,
    this.createdEventId,
    this.errorMessage,
  });

  final String title;
  final String description;
  final DateTime? eventDate;
  final TimeOfDay? eventTime;
  final String location;
  final String address;
  final int? guestCount;
  final ServiceRequestStatus status;
  final String? categoryId;
  final String? eventTypeId;
  final String? createdEventId;
  final String? errorMessage;

  @override
  List<Object?> get props => [
    title,
    description,
    eventDate,
    eventTime,
    location,
    address,
    guestCount,
    status,
    categoryId,
    eventTypeId,
    createdEventId,
    errorMessage,
  ];

  ServiceRequestState copyWith({
    String? title,
    String? description,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String? location,
    String? address,
    int? guestCount,
    ServiceRequestStatus? status,
    String? categoryId,
    String? eventTypeId,
    String? createdEventId,
    String? errorMessage,
  }) {
    return ServiceRequestState(
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      location: location ?? this.location,
      address: address ?? this.address,
      guestCount: guestCount ?? this.guestCount,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      createdEventId: createdEventId ?? this.createdEventId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
