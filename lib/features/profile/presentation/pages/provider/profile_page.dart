import 'package:festeasy/app/router/auth_service.dart';
import 'package:festeasy/features/profile/domain/entities/provider_profile.dart';
import 'package:festeasy/features/profile/domain/usecases/get_provider_profile_usecase.dart';
import 'package:festeasy/features/profile/domain/usecases/update_provider_profile_usecase.dart';
import 'package:festeasy/features/profile/presentation/bloc/provider_profile_cubit.dart';
import 'package:festeasy/features/profile/presentation/bloc/provider_profile_state.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return const Center(child: Text('Usuario no autenticado'));
    }

    return BlocProvider(
      create: (context) => ProviderProfileCubit(
        context.read<GetProviderProfileUseCase>(),
        context.read<UpdateProviderProfileUseCase>(),
      )..loadProfile(user.id),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final user = Supabase.instance.client.auth.currentUser;
              if (user != null) {
                context.read<ProviderProfileCubit>().loadProfile(user.id);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ProviderProfileCubit, ProviderProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ProfileStatus.failure) {
            return Center(
              child: Text('Error: ${state.errorMessage ?? "Desconocido"}'),
            );
          } else if (state.status == ProfileStatus.success &&
              state.profile != null) {
            final profile = state.profile!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileHeader(profile: profile),
                  const SizedBox(height: 32),
                  const _SectionLabel('INFORMACIÓN DEL NEGOCIO'),
                  const SizedBox(height: 8),
                  CustomCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoItem(
                            icon: Icons.store,
                            label: 'Nombre',
                            value: profile.businessName,
                          ),
                          const Divider(),
                          _InfoItem(
                            icon: Icons.phone,
                            label: 'Teléfono',
                            value: profile.phone ?? 'No registrado',
                          ),
                          const Divider(),
                          _InfoItem(
                            icon: Icons.description,
                            label: 'Descripción',
                            value: profile.description ?? 'Sin descripción',
                          ),
                          const Divider(),
                          _InfoItem(
                            icon: Icons.location_on,
                            label: 'Ubicación (Clave)',
                            value: profile.locationKey ?? 'No registrada',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('GESTIÓN'),
                  const SizedBox(height: 8),
                  CustomCard(
                    child: Column(
                      children: [
                        _MenuItem(
                          icon: Icons.article_outlined,
                          text: 'Mis Servicios',
                          color: const Color(0xFFEF4444),
                          onTap: () => context.push('/provider/dashboard/services'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('CUENTA'),
                  const SizedBox(height: 8),
                  CustomCard(
                    child: Column(
                      children: [
                  _MenuItem(
                    icon: Icons.logout,
                    text: 'Cerrar Sesión',
                    color: const Color(0xFFEF4444),
                    onTap: () async {
                      // 1. Sign out from Supabase
                      await Supabase.instance.client.auth.signOut();

                      // 2. Update local AuthService state to trigger Router redirect
                      if (context.mounted) {
                        provider.Provider.of<AuthService>(context, listen: false)
                            .logout();
                        // 3. Fallback explicit navigation
                        context.go('/');
                      }
                    },
                  ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No hay información de perfil'));
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final ProviderProfile profile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFFFEF3C7),
              backgroundImage: profile.avatarUrl != null
                  ? NetworkImage(profile.avatarUrl!)
                  : null,
              child: profile.avatarUrl == null
                  ? Text(
                      profile.businessName.substring(0, 2).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD97706),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.businessName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.push(
              '/provider/dashboard/profile/edit',
              extra: profile, // Pass the profile object
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Editar Información',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.text,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}