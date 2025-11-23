part of 'login_cubit.dart';

enum LoginStatus {
  pure,
  submissionInProgress,
  submissionSuccess,
  submissionFailure,
}

extension LoginStatusX on LoginStatus {
  bool get isSubmissionInProgress => this == LoginStatus.submissionInProgress;
  bool get isSubmissionSuccess => this == LoginStatus.submissionSuccess;
  bool get isSubmissionFailure => this == LoginStatus.submissionFailure;
}

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.pure,
    this.user,
  });

  final String email;
  final String password;
  final LoginStatus status;
  final User? user;

  @override
  List<Object?> get props => [email, password, status, user];

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    User? user,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
