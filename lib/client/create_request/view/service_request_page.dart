import 'package:festeasy/client/create_request/cubit/service_request_cubit.dart';
import 'package:festeasy/client/create_request/domain/usecases/create_request_usecase.dart';
import 'package:festeasy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:festeasy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:festeasy/features/auth/domain/entities/service_category.dart';
import 'package:festeasy/features/auth/domain/usecases/get_service_categories_usecase.dart';
import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceRequestPage extends StatelessWidget {
  const ServiceRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceRequestCubit(
        CreateRequestUseCase(
          AuthRepositoryImpl(
            AuthRemoteDataSourceImpl(
              supabaseClient: Supabase.instance.client,
            ),
          ),
        ),
        GetServiceCategoriesUseCase(
          AuthRepositoryImpl(
            AuthRemoteDataSourceImpl(
              supabaseClient: Supabase.instance.client,
            ),
          ),
        ),
      ),
      child: const ServiceRequestView(),
    );
  }
}

class ServiceRequestView extends StatefulWidget {
  const ServiceRequestView({super.key});

  @override
  State<ServiceRequestView> createState() => _ServiceRequestViewState();
}

class _ServiceRequestViewState extends State<ServiceRequestView> {
  String? _savedEventTypeId;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _addressController = TextEditingController();
  final _guestCountController = TextEditingController();

  List<ServiceCategory> _categories = [];
  String? _selectedCategory;
  List<ServiceCategory> _eventTypes = [];
  String? _selectedEventType;
  TimeOfDay? _selectedTime;

  Future<void> _loadSavedEventType() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEventTypeId = prefs.getString('selected_party_type_id');
    if (savedEventTypeId != null) {
      // Verificar que el tipo de evento existe en la lista
      final existsInList = _eventTypes.any(
        (type) => type.id == savedEventTypeId,
      );
      if (existsInList) {
        setState(() {
          _selectedEventType = savedEventTypeId;
        });
        // Notificar al cubit sobre la selección guardada
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ServiceRequestCubit>().eventTypeIdChanged(
            savedEventTypeId,
          );
        });
      } else {
        print(
          'Warning: Saved event type ID $savedEventTypeId not found in available types',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedEventType();
    _fetchCategories();
    _titleController.addListener(() {
      context.read<ServiceRequestCubit>().titleChanged(_titleController.text);
    });
    _descriptionController.addListener(() {
      context.read<ServiceRequestCubit>().descriptionChanged(
        _descriptionController.text,
      );
    });
    _locationController.addListener(() {
      context.read<ServiceRequestCubit>().locationChanged(
        _locationController.text,
      );
    });
    _addressController.addListener(() {
      context.read<ServiceRequestCubit>().addressChanged(
        _addressController.text,
      );
    });
    _guestCountController.addListener(() {
      context.read<ServiceRequestCubit>().guestCountChanged(
        int.tryParse(_guestCountController.text) ?? 0,
      );
    });
  }

  Future<void> _fetchCategories() async {
    final categories = await context
        .read<ServiceRequestCubit>()
        .getServiceCategories();

    // Si no hay categorías de la base de datos, usar categorías de respaldo con UUIDs
    final fallbackCategories = [
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440001',
        name: 'Catering',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440002',
        name: 'Música',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440003',
        name: 'Fotografía',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440004',
        name: 'Decoración',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440005',
        name: 'Lugar',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440006',
        name: 'Transporte',
      ),
    ];

    // Categorías de eventos hardcodeadas por ahora
    final eventTypeFallbacks = [
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440011',
        name: 'Boda',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440012',
        name: 'XV Años',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440013',
        name: 'Cumpleaños',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440014',
        name: 'Bautizo',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440015',
        name: 'Graduación',
      ),
      const ServiceCategory(
        id: '550e8400-e29b-41d4-a716-446655440016',
        name: 'Corporativo',
      ),
    ];

    setState(() {
      _categories = categories.isNotEmpty ? categories : fallbackCategories;
      _eventTypes =
          eventTypeFallbacks; // Usar categorías hardcodeadas por ahora
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
      context.read<ServiceRequestCubit>().dateChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
        _selectedTime = picked;
      });
      context.read<ServiceRequestCubit>().timeChanged(picked);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _guestCountController.dispose();
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
          onPressed: () => context.go('/client/home'),
        ),
        title: const Text(
          'Describe tu evento',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: BlocListener<ServiceRequestCubit, ServiceRequestState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess &&
              state.createdEventId != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Evento creado exitosamente')),
              );
            // Navegar a la pantalla de solicitud con el eventId
            context.go('/client/create-solicitud/${state.createdEventId}');
          } else if (state.status.isSubmissionFailure) {
            String errorMessage = state.errorMessage ?? 'Error al crear evento';

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  duration: const Duration(seconds: 5),
                ),
              );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Ej: Boda de 200 personas',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Descripción',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      'Ej: Necesito un servicio de fotografía profesional para una boda de 6 horas, con entrega de 300 fotos editadas y un álbum digital.',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                  context.read<ServiceRequestCubit>().categoryIdChanged(value!);
                },
                decoration: InputDecoration(
                  labelText: 'Categoría de Servicio',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedEventType,
                items: _eventTypes
                    .map(
                      (eventType) => DropdownMenuItem(
                        value: eventType.id,
                        child: Text(eventType.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEventType = value;
                  });
                  context.read<ServiceRequestCubit>().eventTypeIdChanged(
                    value!,
                  );
                },
                decoration: InputDecoration(
                  labelText: 'Tipo de Evento',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: InputGroup(
                          label: 'Fecha',
                          icon: Icons.calendar_today,
                          controller: _dateController,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: AbsorbPointer(
                        child: InputGroup(
                          label: 'Hora',
                          icon: Icons.access_time,
                          controller: _timeController,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              InputGroup(
                label: 'Ubicación',
                icon: Icons.location_on,
                controller: _locationController,
              ),
              const SizedBox(height: 24),
              InputGroup(
                label: 'Dirección',
                icon: Icons.map,
                controller: _addressController,
              ),
              const SizedBox(height: 24),
              InputGroup(
                label: 'Invitados',
                icon: Icons.people,
                keyboardType: TextInputType.number,
                controller: _guestCountController,
              ),
              const SizedBox(height: 40),
              BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
                builder: (context, state) {
                  return state.status.isSubmissionInProgress
                      ? const Center(child: CircularProgressIndicator())
                      : ClientButton(
                          text: 'Enviar Solicitud',
                          onPressed: () {
                            final user =
                                Supabase.instance.client.auth.currentUser;
                            if (user != null &&
                                _selectedTime != null &&
                                _selectedEventType != null) {
                              context.read<ServiceRequestCubit>().submitRequest(
                                user.id,
                              );
                            }
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
