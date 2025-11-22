import 'package:festeasy/data/mock_data.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';

// Helper record to hold style properties for the status.
typedef StatusStyle = ({Color bg, Color text, IconData icon});

class OngoingRequestsPage extends StatelessWidget {
  const OngoingRequestsPage({super.key});

  StatusStyle _getStatusStyle(String status) {
    switch (status) {
      case 'accepted':
        return (
          bg: const Color(0xFFDCFCE7),
          text: const Color(0xFF16A34A),
          icon: Icons.check_circle
        );
      case 'sent':
        return (
          bg: const Color(0xFFDBEAFE),
          text: const Color(0xFF2563EB),
          icon: Icons.send
        );
      case 'waiting':
        return (
          bg: const Color(0xFFFFEDD5),
          text: const Color(0xFFEA580C),
          icon: Icons.hourglass_top
        );
      default:
        return (
          bg: const Color(0xFFF3F4F6),
          text: const Color(0xFF4B5563),
          icon: Icons.history
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const SimpleHeader(title: 'Solicitudes en Curso'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.mockOngoing.length,
        itemBuilder: (context, index) {
          final item = MockData.mockOngoing[index];
          final statusStyle = _getStatusStyle(item.status);
          return _OngoingRequestCard(item: item, style: statusStyle);
        },
      ),
    );
  }
}

class _OngoingRequestCard extends StatelessWidget {
  const _OngoingRequestCard({required this.item, required this.style});

  final OngoingRequest item;
  final StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: style.bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(style.icon, color: style.text, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          item.statusLabel,
                          style: TextStyle(
                            color: style.text,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Color(0xFF6B7280)),
                  const SizedBox(width: 8),
                  Text(
                    item.date,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  title: 'Ver detalles',
                  outline: true,
                  onPress: () {
                    // TODO: Navigate to the detail of the ongoing request
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
