import 'package:festeasy/features/auth/domain/usecases/register_usecase.dart';
import 'package:festeasy/features/auth/presentation/bloc/register_cubit.dart';
import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClientRegisterPage extends StatelessWidget {
  const ClientRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(context.read<RegisterUseCase>()),
      child: const ClientRegisterView(),
    );
  }
}

class ClientRegisterView extends StatefulWidget {
  const ClientRegisterView({super.key});

  @override
  State<ClientRegisterView> createState() => _ClientRegisterViewState();
}

class _ClientRegisterViewState extends State<ClientRegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _businessNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      context.read<RegisterCubit>().nameChanged(_nameController.text);
    });
    _emailController.addListener(() {
      context.read<RegisterCubit>().emailChanged(_emailController.text);
    });
    _phoneController.addListener(() {
      context.read<RegisterCubit>().phoneChanged(_phoneController.text);
    });
    _passwordController.addListener(() {
      context.read<RegisterCubit>().passwordChanged(_passwordController.text);
    });
    _businessNameController.addListener(() {
      context.read<RegisterCubit>().businessNameChanged(
        _businessNameController.text,
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            if (state.role == 'provider') {
              context.go('/provider/dashboard');
            } else {
              context.go('/client/party-type');
            }
          } else if (state.status.isSubmissionSuccessEmailConfirmationNeeded) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'Registration successful! Please check your email to confirm your account.',
                  ),
                ),
              );
            context.go('/login');
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Registration Failed')),
              );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Crea tu Cuenta',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Es rápido y fácil',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                BlocBuilder<RegisterCubit, RegisterState>(
                  buildWhen: (previous, current) =>
                      previous.role != current.role,
                  builder: (context, state) {
                    return Column(
                      children: [
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment<String>(
                              value: 'client',
                              label: Text('Cliente'),
                              icon: Icon(Icons.person),
                            ),
                            ButtonSegment<String>(
                              value: 'provider',
                              label: Text('Proveedor'),
                              icon: Icon(Icons.store),
                            ),
                          ],
                          selected: {state.role},
                          onSelectionChanged: (Set<String> newSelection) {
                            context.read<RegisterCubit>().roleChanged(
                              newSelection.first,
                            );
                          },
                        ),
                        if (state.role == 'provider') ...[
                          const SizedBox(height: 24),
                          InputGroup(
                            label: 'Nombre del Negocio',
                            icon: Icons.store_outlined,
                            controller: _businessNameController,
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                InputGroup(
                  label: 'Nombre Completo',
                  icon: Icons.person_outline,
                  controller: _nameController,
                ),
                const SizedBox(height: 24),
                InputGroup(
                  label: 'Correo Electrónico',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 24),
                InputGroup(
                  label: 'Número de Teléfono',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                const SizedBox(height: 24),
                InputGroup(
                  label: 'Contraseña',
                  icon: Icons.lock_outlined,
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 40),
                BlocBuilder<RegisterCubit, RegisterState>(
                  builder: (context, state) {
                    return state.status.isSubmissionInProgress
                        ? const Center(child: CircularProgressIndicator())
                        : ClientButton(
                            text: 'Registrarme',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<RegisterCubit>()
                                    .registerWithCredentials();
                              }
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
