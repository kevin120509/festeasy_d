import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReservationConfirmedPage extends StatelessWidget {
  const ReservationConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF22C55E), // Green for success
                size: 80,
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Reservación Confirmada!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu evento ha sido agendado. El proveedor se pondrá en contacto contigo pronto.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              Container(
                 padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(20),
                ),
                 child: Column(
                   children: [
                     const Text('Boda en Playa del Carmen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                     const SizedBox(height: 8),
                     const Text('20 de Diciembre, 2024', style: TextStyle(color: Colors.grey)),
                      const Divider(height: 32),
                      ClientButton(text: 'Contactar al Proveedor', isOutline: true, onPressed: (){}),
                      const SizedBox(height: 12),
                      ClientButton(text: 'Ver comprobante', isOutline: true, onPressed: (){}),
                   ],
                 ),
              ),
               const Spacer(),
              ClientButton(text: 'Volver al Inicio', onPressed: ()=> context.go('/client/home')),

            ],
          ),
        ),
      ),
    );
  }
}
