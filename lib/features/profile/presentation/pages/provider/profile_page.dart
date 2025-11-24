import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => context.pop(),
        ),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProfileHeader(),
            const SizedBox(height: 32),
            const _SectionLabel('GESTIÓN'),
            const SizedBox(height: 8),
            CustomCard(
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.dashboard_outlined,
                    text: 'Mi Negocio',
                    color: const Color(0xFFEF4444),
                    onTap: () {
                      // TODO(future): Navigate to My Business Page
                    },
                  ),
                  const Divider(
                    height: 1,
                    indent: 56,
                    color: Color(0xFFF3F4F6),
                  ),
                  _MenuItem(
                    icon: Icons.article_outlined,
                    text: 'Mis Servicios',
                    color: const Color(0xFFEF4444),
                    onTap: () => context.push('/services'),
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
                    icon: Icons.settings_outlined,
                    text: 'Configuración',
                    color: const Color(0xFF6B7280),
                    onTap: () => context.push('/settings'),
                  ),
                  const Divider(
                    height: 1,
                    indent: 56,
                    color: Color(0xFFF3F4F6),
                  ),
                  _MenuItem(
                    icon: Icons.logout,
                    text: 'Cerrar Sesión',
                    color: const Color(0xFFEF4444),
                    onTap: () {
                      // TODO(auth): Implement logout logic
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

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
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFFEF3C7),
              child: Text(
                'FF',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD97706),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'FestaFusion Catering',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Color(0xFFD97706), size: 16),
              SizedBox(width: 4),
              Text(
                '4.8 (124 reviews)',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFD97706),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.push('/profile/edit'),
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
