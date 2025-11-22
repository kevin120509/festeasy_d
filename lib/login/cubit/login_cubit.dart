import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:festeasy/app/router/auth_service.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authService) : super(const LoginState());

  final AuthService _authService;

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.pure));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.pure));
  }

  Future<void> logInWithCredentials() async {
    if (state.status == LoginStatus.submissionInProgress) return;
    emit(state.copyWith(status: LoginStatus.submissionInProgress));

    try {
      await Future<void>.delayed(const Duration(seconds: 1));

      if (state.email.isNotEmpty && state.password.isNotEmpty) {
        // The auth service will be called from the UI layer after a success state.
        emit(state.copyWith(status: LoginStatus.submissionSuccess));
      } else {
        emit(state.copyWith(status: LoginStatus.submissionFailure));
      }
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.submissionFailure));
    }
  }
}