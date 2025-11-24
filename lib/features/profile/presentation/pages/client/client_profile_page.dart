import 'package:festeasy/app/router/auth_service.dart';
import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFFF3F4F6),
                child: Icon(Icons.person, size: 80, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Nombre del Cliente', // Replace with actual user name
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'cliente@email.com', // Replace with actual user email
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ClientButton(
                  text: 'Cerrar Sesión',
                  onPressed: () {
                    // Call logout method from AuthService
                    context.read<AuthService>().logout();
                    // Navigate back to the login page
                    context.go('/login');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
