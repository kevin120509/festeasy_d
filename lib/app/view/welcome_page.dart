import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.celebration_rounded,
                    color: Color(0xFFEF4444),
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'FESTEASY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFEF4444),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tu evento perfecto, sin estrés.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
              ),
              const Spacer(),
              // Action Buttons
              ClientButton(
                text: 'Soy Cliente',
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 15),
              ClientButton(
                text: 'Soy Proveedor',
                isOutline: true,
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}