import 'package:festeasy/data/mock_data.dart';
import 'package:festeasy/requests/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';

class ConfirmedEventPage extends StatelessWidget {
  const ConfirmedEventPage({required this.eventId, super.key});
  final String eventId;

  @override
  Widget build(BuildContext context) {
    // In a real app, fetch the event by ID from a repository
    final event = MockData.mockEvents.first;

    return Scaffold(
      appBar: const SimpleHeader(title: 'Detalle del Evento'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(event.status.toUpperCase()),
              backgroundColor: const Color(0xFFDCFCE7),
              labelStyle: const TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold),
              side: BorderSide.none,
            ),
            const SizedBox(height: 24),
            _InfoCard(event: event),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 32),
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                title: 'Llamar al Cliente',
                icon: Icons.phone,
                outline: true,
                onPress: () { /* TODO: Implement launchUrl('tel:${event.clientPhone}') */ },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                title: 'Abrir Chat',
                icon: Icons.chat_bubble,
                onPress: () { /* TODO: Implement context.push('/messages/...') */ },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(icon: Icons.person, title: 'Cliente', subtitle: event.clientName),
            _InfoRow(icon: Icons.construction, title: 'Servicios', subtitle: event.service),
            _InfoRow(icon: Icons.calendar_today, title: 'Fecha y Hora', subtitle: '${event.date}, ${event.time}'),
            _InfoRow(icon: Icons.pin_drop, title: 'Ubicación', subtitle: event.location, hasBorder: false),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.hasBorder = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: hasBorder ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B7280)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}
