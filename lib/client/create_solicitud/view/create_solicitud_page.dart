import 'package:festeasy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:festeasy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:festeasy/features/auth/domain/entities/service_category.dart';
import 'package:festeasy/features/auth/domain/usecases/get_service_categories_usecase.dart';
import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateSolicitudPage extends StatefulWidget {
  const CreateSolicitudPage({super.key, required this.eventId});

  final String eventId;

  @override
  State<CreateSolicitudPage> createState() => _CreateSolicitudPageState();
}

class _CreateSolicitudPageState extends State<CreateSolicitudPage> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _especificacionesController = TextEditingController();
  final _presupuestoController = TextEditingController();

  List<ServiceCategory> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final repository = AuthRepositoryImpl(
        AuthRemoteDataSourceImpl(
          supabaseClient: Supabase.instance.client,
        ),
      );
      final useCase = GetServiceCategoriesUseCase(repository);
      final result = await useCase();

      result.fold(
        (failure) {
          // Usar categorías de respaldo
          setState(() {
            _categories = [
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
          });
        },
        (categories) {
          setState(() {
            _categories = categories.isNotEmpty
                ? categories
                : [
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
          });
        },
      );
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _submitSolicitud() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos requeridos'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      final solicitudData = <String, dynamic>{
        'cliente_usuario_id': user.id,
        'evento_id': widget.eventId,
        'categoria_servicio_id': _selectedCategory!,
        'titulo':
            'Solicitud de ${_categories.firstWhere((c) => c.id == _selectedCategory).name}',
        'descripcion': _descripcionController.text,
        'estado': 'abierta',
      };

      // Agregar campos opcionales si tienen valor
      if (_especificacionesController.text.isNotEmpty) {
        solicitudData['especificaciones'] = <String, dynamic>{
          'detalles': _especificacionesController.text,
        };
      }

      if (_presupuestoController.text.isNotEmpty) {
        final presupuesto = double.tryParse(_presupuestoController.text);
        if (presupuesto != null) {
          solicitudData['presupuesto_estimado'] = presupuesto;
        }
      }

      await Supabase.instance.client.from('solicitudes').insert(solicitudData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud creada exitosamente')),
        );
        context.go('/client/requests');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear solicitud: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _especificacionesController.dispose();
    _presupuestoController.dispose();
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
        title: const Text(
          'Crear Solicitud',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categoría de Servicio',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
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
                },
                decoration: InputDecoration(
                  hintText: 'Selecciona una categoría',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'La categoría es requerida';
                  }
                  return null;
                },
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
                controller: _descripcionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe lo que necesitas para tu evento...',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es requerida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Especificaciones (Opcional)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _especificacionesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Detalles adicionales, preferencias, etc.',
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
                'Presupuesto Estimado (Opcional)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _presupuestoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ej: 5000',
                  prefixText: '\$ ',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ClientButton(
                      text: 'Crear Solicitud',
                      onPressed: _submitSolicitud,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
