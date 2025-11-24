import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:festeasy/client/create_request/domain/usecases/create_request_usecase.dart';
import 'package:festeasy/features/auth/domain/entities/service_category.dart';
import 'package:festeasy/features/auth/domain/usecases/get_service_categories_usecase.dart';
import 'package:flutter/material.dart';

part 'service_request_state.dart';

class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  final CreateRequestUseCase _createRequestUseCase;
  final GetServiceCategoriesUseCase _getServiceCategoriesUseCase;

  ServiceRequestCubit(
    this._createRequestUseCase,
    this._getServiceCategoriesUseCase,
  ) : super(const ServiceRequestState());

  void titleChanged(String value) {
    emit(state.copyWith(title: value, status: ServiceRequestStatus.pure));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value, status: ServiceRequestStatus.pure));
  }

  void dateChanged(DateTime value) {
    emit(state.copyWith(eventDate: value, status: ServiceRequestStatus.pure));
  }

  void timeChanged(TimeOfDay value) {
    emit(state.copyWith(eventTime: value, status: ServiceRequestStatus.pure));
  }

  void locationChanged(String value) {
    emit(state.copyWith(location: value, status: ServiceRequestStatus.pure));
  }

  void guestCountChanged(int value) {
    emit(state.copyWith(guestCount: value, status: ServiceRequestStatus.pure));
  }

  void categoryIdChanged(String value) {
    emit(state.copyWith(categoryId: value, status: ServiceRequestStatus.pure));
  }

  Future<List<ServiceCategory>> getServiceCategories() async {
    final result = await _getServiceCategoriesUseCase();
    return result.fold(
      (failure) => [],
      (categories) => categories,
    );
  }

  Future<void> submitRequest(String clientId, String formattedTime) async {
    if (state.status.isSubmissionInProgress) return;
    emit(state.copyWith(status: ServiceRequestStatus.submissionInProgress));

    final result = await _createRequestUseCase(
      CreateRequestParams(
        title: state.title,
        description: state.description,
        categoryId: state.categoryId!,
        eventDate: state.eventDate!,
        eventTime: formattedTime,
        location: state.location,
        guestCount: state.guestCount!,
        clientId: clientId,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: ServiceRequestStatus.submissionFailure)),
      (success) =>
          emit(state.copyWith(status: ServiceRequestStatus.submissionSuccess)),
    );
  }
}
