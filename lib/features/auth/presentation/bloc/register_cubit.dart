import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/register_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerUseCase) : super(const RegisterState());

  final RegisterUseCase _registerUseCase;

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: RegisterStatus.pure));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: RegisterStatus.pure));
  }

  void phoneChanged(String value) {
    emit(state.copyWith(phone: value, status: RegisterStatus.pure));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: RegisterStatus.pure));
  }

  void roleChanged(String value) {
    emit(state.copyWith(role: value, status: RegisterStatus.pure));
  }

  void businessNameChanged(String value) {
    emit(state.copyWith(businessName: value, status: RegisterStatus.pure));
  }

  Future<void> registerWithCredentials() async {
    if (state.status == RegisterStatus.submissionInProgress) return;
    emit(state.copyWith(status: RegisterStatus.submissionInProgress));

    final result = await _registerUseCase(
      RegisterParams(
        name: state.name,
        email: state.email,
        password: state.password,
        role: state.role,
        phone: state.phone,
        businessName: state.businessName,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: RegisterStatus.submissionFailure)),
      (user) => emit(
        state.copyWith(
          status: RegisterStatus.submissionSuccess,
          user: user,
        ),
      ),
    );
  }
}