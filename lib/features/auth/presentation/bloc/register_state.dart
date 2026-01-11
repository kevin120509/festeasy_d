part of 'register_cubit.dart';

enum RegisterStatus {
  pure,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
  submissionSuccessEmailConfirmationNeeded,
  submissionFailureUserAlreadyRegistered,
}

extension RegisterStatusX on RegisterStatus {
  bool get isSubmissionInProgress =>
      this == RegisterStatus.submissionInProgress;
  bool get isSubmissionSuccess => this == RegisterStatus.submissionSuccess;
  bool get isSubmissionFailure => this == RegisterStatus.submissionFailure;
  bool get isSubmissionSuccessEmailConfirmationNeeded =>
      this == RegisterStatus.submissionSuccessEmailConfirmationNeeded;
  bool get isSubmissionFailureUserAlreadyRegistered =>
      this == RegisterStatus.submissionFailureUserAlreadyRegistered;
}

class RegisterState extends Equatable {
  const RegisterState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.role = 'client',
    this.businessName = '',
    this.description = '',
    this.categoryId = '',
    this.status = RegisterStatus.pure,
    this.user,
    this.errorMessage,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String businessName;
  final String description;
  final String categoryId;
  final RegisterStatus status;
  final User? user;
  final String? errorMessage;

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    password,
    role,
    businessName,
    description,
    categoryId,
    status,
    user,
    errorMessage,
  ];

  RegisterState copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? role,
    String? businessName,
    String? description,
    String? categoryId,
    RegisterStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
      businessName: businessName ?? this.businessName,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
