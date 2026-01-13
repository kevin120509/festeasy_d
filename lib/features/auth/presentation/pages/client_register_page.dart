import 'package:festeasy/features/auth/domain/usecases/register_usecase.dart';
import 'package:festeasy/features/auth/presentation/bloc/register_cubit.dart';
import 'package:festeasy/features/auth/domain/entities/service_category.dart';
import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  List<ServiceCategory> _serviceCategories = [];
  String? _selectedServiceCategoryId;
  bool _loadingServiceCategories = false;

  Future<void> _fetchServiceCategories() async {
    if (_loadingServiceCategories) return;
    setState(() => _loadingServiceCategories = true);
    try {
      final response = await Supabase.instance.client
          .from('categorias_servicio')
          .select('id, nombre, descripcion, icono')
          .eq('activa', true)
          .order('nombre');

      final categories = (response as List)
          .map(
            (e) => ServiceCategory(
              id: (e as Map<String, dynamic>)['id'] as String,
              name: e['nombre'] as String,
              description: e['descripcion'] as String?,
              icon: e['icono'] as String?,
            ),
          )
          .toList();

      if (!mounted) return;
      setState(() => _serviceCategories = categories);
    } catch (_) {
      // fallback (mismos UUIDs que en basededatos.sql)
      if (!mounted) return;
      setState(() {
        _serviceCategories = const [
          ServiceCategory(id: '11111111-1111-1111-1111-111111111111', name: 'Mobiliario'),
          ServiceCategory(id: '550e8400-e29b-41d4-a716-446655440001', name: 'Catering'),
          ServiceCategory(id: '550e8400-e29b-41d4-a716-446655440002', name: 'Música'),
          ServiceCategory(id: '550e8400-e29b-41d4-a716-446655440003', name: 'Fotografía'),
          ServiceCategory(id: '550e8400-e29b-41d4-a716-446655440004', name: 'Decoración'),
          ServiceCategory(id: '550e8400-e29b-41d4-a716-446655440005', name: 'Lugar'),
          ServiceCategory(id: '550e8400-e29b-41d4-a716-446655440006', name: 'Transporte'),
        ];
      });
    } finally {
      if (!mounted) return;
      setState(() => _loadingServiceCategories = false);
    }
  }

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

    // Cargar categorías para el selector de proveedores
    _fetchServiceCategories();
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
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'Registration successful!',
                  ),
                ),
              );
            context.go('/'); // Redirect to welcome screen
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
            context.go('/'); // Redirect to welcome screen
          } else if (state.status.isSubmissionFailureUserAlreadyRegistered) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: const Text(
                    'User already registered. Please login.',
                  ),
                  action: SnackBarAction(
                    label: 'Login',
                    onPressed: () {
                      context.go('/login');
                    },
                  ),
                ),
              );
          } else if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Registration Failed')),
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
                          const SizedBox(height: 24),
                          DropdownButtonFormField<String>(
                            value: _selectedServiceCategoryId,
                            decoration: const InputDecoration(
                              labelText: 'Categoría del servicio *',
                              prefixIcon: Icon(Icons.category_outlined),
                              border: OutlineInputBorder(),
                            ),
                            items: _serviceCategories
                                .map(
                                  (c) => DropdownMenuItem<String>(
                                    value: c.id,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedServiceCategoryId = value);
                              context.read<RegisterCubit>().categoryIdChanged(
                                    value ?? '',
                                  );
                            },
                            validator: (value) {
                              if (state.role != 'provider') return null;
                              if (value == null || value.isEmpty) {
                                return 'Selecciona una categoría';
                              }
                              return null;
                            },
                          ),
                          if (_loadingServiceCategories) ...[
                            const SizedBox(height: 12),
                            const LinearProgressIndicator(),
                          ],
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo electrónico';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Ingresa un correo electrónico válido';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
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
