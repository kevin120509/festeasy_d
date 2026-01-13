import 'package:festeasy/features/profile/domain/entities/provider_profile.dart';
import 'package:festeasy/features/profile/domain/usecases/get_provider_profile_usecase.dart';
import 'package:festeasy/features/profile/domain/usecases/update_provider_profile_usecase.dart';
import 'package:festeasy/features/profile/presentation/bloc/provider_profile_cubit.dart';
import 'package:festeasy/features/profile/presentation/bloc/provider_profile_state.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the profile passed via GoRouter extra
    final profile = GoRouterState.of(context).extra as ProviderProfile?;

    if (profile == null) {
      return const Scaffold(
        body: Center(child: Text('Error: No se cargó el perfil')),
      );
    }

    return BlocProvider(
      create: (context) => ProviderProfileCubit(
        context.read<GetProviderProfileUseCase>(),
        context.read<UpdateProviderProfileUseCase>(),
      ),
      child: _EditProfileView(profile: profile),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView({required this.profile});

  final ProviderProfile profile;

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _descController;
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.businessName);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _descController = TextEditingController(text: widget.profile.description);
    _locationController = TextEditingController(text: widget.profile.locationKey);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onSave() {
    final updatedProfile = ProviderProfile(
      id: widget.profile.id,
      userId: widget.profile.userId,
      businessName: _nameController.text,
      phone: _phoneController.text,
      description: _descController.text,
      locationKey: _locationController.text,
      avatarUrl: widget.profile.avatarUrl,
      mainCategoryId: widget.profile.mainCategoryId,
    );

    context.read<ProviderProfileCubit>().updateProfile(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleHeader(title: 'Editar Información'),
      body: BlocConsumer<ProviderProfileCubit, ProviderProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Perfil actualizado correctamente')),
            );
            // Navigate back and potentially trigger a refresh on the previous page
            // Since we're just popping, the previous page needs to handle refresh on focus or via a callback if needed.
            // But ProfilePage has a refresh button now.
            context.pop(); 
          } else if (state.status == ProfileStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Nombre del Negocio',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Teléfono',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _locationController,
                  label: 'Ubicación (Clave)',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _descController,
                  label: 'Descripción Corta',
                  maxLines: 3,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 32),
        child: PrimaryButton(
          title: 'Guardar Cambios',
          onPress: _onSave,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
