import 'package:festeasy/data/mock_data.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequestDetailPage extends StatelessWidget {
  const RequestDetailPage({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    // In a real app, you'd fetch this from a Cubit/Bloc state or repository
    final request = MockData.mockRequests.firstWhere(
      (req) => req.id.toString() == requestId,
      orElse: () => MockData.mockRequests.first, // Fallback
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const SimpleHeader(title: 'Detalle de Solicitud'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CustomCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.description, size: 24, color: Color(0xFFEF4444)),
                    SizedBox(width: 8),
                    Text(
                      'DESCRIPCIÓN DEL CLIENTE',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  request.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(request.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                const Divider(height: 40),
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Fecha del evento',
                  text: request.date,
                ),
                _InfoRow(
                  icon: Icons.access_time,
                  label: 'Horario',
                  text: request.time,
                ),
                _InfoRow(
                  icon: Icons.pin_drop,
                  label: request.location,
                  text: request.address,
                ),
                _InfoRow(
                  icon: Icons.people,
                  label: 'Aforo estimado',
                  text: '${request.guests} Invitados',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _FooterButtons(requestId: requestId),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.text,
  });

  final IconData icon;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF6B7280), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterButtons extends StatelessWidget {
  const _FooterButtons({required this.requestId});
  final String requestId;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              title: 'Rechazar',
              outline: true,
              onPress: () => context.pop(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PrimaryButton(
              title: 'Cotizar',
              onPress: () => context.push('/requests/$requestId/send-quote'),
            ),
          ),
        ],
      ),
    );
  }
}
