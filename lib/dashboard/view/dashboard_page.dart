import 'package:festeasy/dashboard/cubit/dashboard_cubit.dart';
import 'package:festeasy/dashboard/domain/usecases/get_provider_dashboard_data_usecase.dart';
import 'package:festeasy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:festeasy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        GetProviderDashboardDataUseCase(
          AuthRepositoryImpl(
            AuthRemoteDataSourceImpl(
              supabaseClient: Supabase.instance.client,
            ),
          ),
        ),
      ),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      context.read<DashboardCubit>().getDashboardData(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Panel del Proveedor',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF1F2937),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Bienvenido, FestFusion',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Color(0xFF4B5563), size: 28),
                  onPressed: () {},
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == DashboardStatus.failure) {
            return Center(child: Text(state.errorMessage ?? 'An error occurred'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Solicitudes nuevas',
                        value: state.newRequestsCount.toString(),
                        color: const Color(0xFFEF4444),
                        hasBorder: true,
                        onTap: () => context.go('/provider/dashboard/requests'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'En espera',
                        value: state.ongoingRequestsCount.toString(),
                        color: const Color(0xFFF97316),
                        onTap: () =>
                            context.go('/provider/dashboard/ongoing-requests'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Online Status Toggle
                CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isOnline
                                    ? const Color(0xFF22C55E)
                                    : const Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _isOnline ? 'En línea' : 'Desconectado',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151)),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isOnline,
                          onChanged: (value) =>
                              setState(() => _isOnline = value),
                          activeColor: const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Shortcuts
                const Text(
                  'Atajos rápidos',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937)),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  title: 'Ver solicitudes nuevas',
                  icon: Icons.description_outlined,
                  onPress: () => context.go('/provider/dashboard/requests'),
                ),
                const SizedBox(height: 12),
                CustomCard(
                  child: Column(
                    children: [
                      _MenuItem(
                        icon: Icons.calendar_today_outlined,
                        text: 'Calendario',
                        onTap: () =>
                            context.go('/provider/dashboard/calendar'),
                      ),
                      _MenuItem(
                        icon: Icons.chat_bubble_outline,
                        text: 'Mensajes / Chats',
                        onTap: () =>
                            context.go('/provider/dashboard/messages'),
                      ),
                      _MenuItem(
                        icon: Icons.person_outline,
                        text: 'Perfil / Mi negocio',
                        onTap: () =>
                            context.go('/provider/dashboard/profile'),
                        hasBorder: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Private Widgets for Dashboard
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    this.hasBorder = false,
    this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final bool hasBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        border:
            hasBorder ? Border(left: BorderSide(color: color, width: 4)) : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem(
      {required this.icon,
      required this.text,
      this.onTap,
      this.hasBorder = true});

  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: hasBorder
              ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6B7280), size: 20),
            const SizedBox(width: 12),
            Expanded(
                child: Text(text,
                    style: const TextStyle(
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w500,
                        fontSize: 15))),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
          ],
        ),
      ),
    );
  }
}