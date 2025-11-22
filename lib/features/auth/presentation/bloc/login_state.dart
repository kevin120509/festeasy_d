part of 'login_cubit.dart';

enum LoginStatus {
  pure,
  submissionInProgress,
  submissionSuccess,
  submissionFailure;

  bool get isSubmissionSuccess => this == LoginStatus.submissionSuccess;
  bool get isSubmissionFailure => this == LoginStatus.submissionFailure;
}

class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.status = LoginStatus.pure,
  });

  final String email;
  final String password;
  final LoginStatus status;

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, password, status];
}
