part of 'register_cubit.dart';

enum RegisterStatus {
  pure,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

extension RegisterStatusX on RegisterStatus {
  bool get isSubmissionInProgress =>
      this == RegisterStatus.submissionInProgress;
  bool get isSubmissionSuccess => this == RegisterStatus.submissionSuccess;
  bool get isSubmissionFailure => this == RegisterStatus.submissionFailure;
}

class RegisterState extends Equatable {
  const RegisterState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.role = 'client',
    this.businessName = '',
    this.status = RegisterStatus.pure,
    this.user,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String businessName;
  final RegisterStatus status;
  final User? user;

  @override
  List<Object?> get props =>
      [name, email, phone, password, role, businessName, status, user];

  RegisterState copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? role,
    String? businessName,
    RegisterStatus? status,
    User? user,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
      businessName: businessName ?? this.businessName,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
