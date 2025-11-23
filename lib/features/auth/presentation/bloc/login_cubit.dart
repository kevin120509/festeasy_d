import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUseCase) : super(const LoginState());

  final LoginUseCase _loginUseCase;

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: LoginStatus.pure));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: LoginStatus.pure));
  }

  Future<void> logInWithCredentials() async {
    if (state.status == LoginStatus.submissionInProgress) return;
    emit(state.copyWith(status: LoginStatus.submissionInProgress));

    final result = await _loginUseCase(
      LoginParams(
        email: state.email,
        password: state.password,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(status: LoginStatus.submissionFailure)),
      (user) => emit(
        state.copyWith(
          status: LoginStatus.submissionSuccess,
          user: user,
        ),
      ),
    );
  }
}
