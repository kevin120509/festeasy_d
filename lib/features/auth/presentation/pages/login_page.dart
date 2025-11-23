import 'package:festeasy/app/router/auth_service.dart';
import 'package:festeasy/features/auth/domain/usecases/login_usecase.dart';
import 'package:festeasy/features/auth/presentation/bloc/login_cubit.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginCubit(context.read<LoginUseCase>()),
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          // Set auth state first
          context.read<AuthService>().login();

          // Navigate based on user role
          if (state.user != null) {
            if (state.user!.role == 'provider') {
              context.go('/provider/dashboard');
            } else {
              context.go('/client/party-type');
            }
          } else {
            // Fallback if user is null
            context.go('/client/party-type');
          }
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Error: Revisa tus credenciales')),
            );
        }
      },
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _Header(),
                const SizedBox(height: 48),
                _EmailInput(),
                const SizedBox(height: 16),
                _PasswordInput(),
                const SizedBox(height: 16),
                const _ForgotPasswordButton(),
                const SizedBox(height: 20),
                _LoginButton(),
                const SizedBox(height: 24),
                const _RegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Private Widgets for Login Page ---

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFFEF2F2),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text('🎈', style: TextStyle(fontSize: 40)),
        ),
        const SizedBox(height: 16),
        const Text(
          'FESTEASY',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFFEF4444),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tu fiesta, fácil y a un clic',
          style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email, color: Color(0xFF9CA3AF)),
            hintText: 'Correo electrónico',
            fillColor: const Color(0xFFF9FAFB),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF9CA3AF)),
            hintText: 'Contraseña',
            fillColor: const Color(0xFFF9FAFB),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        );
      },
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: Color(0xFFEF4444),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == LoginStatus.submissionInProgress
            ? const CircularProgressIndicator()
            : PrimaryButton(
                key: const Key('loginForm_continue_raisedButton'),
                title: 'Iniciar Sesión',
                onPress: () =>
                    context.read<LoginCubit>().logInWithCredentials(),
              );
      },
    );
  }
}

class _RegisterLink extends StatelessWidget {
  const _RegisterLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿No tienes cuenta?',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () => context.go('/client/register'),
          child: const Text(
            'Regístrate',
            style: TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
