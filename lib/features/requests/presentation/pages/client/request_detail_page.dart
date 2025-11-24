import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientRequestDetailPage extends StatelessWidget {
  const ClientRequestDetailPage({super.key, required this.requestId});
  final String requestId;

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final requestDetails = {
      'category': 'Fotografía de Eventos',
      'description':
          'Necesito un fotógrafo profesional para un evento corporativo de 4 horas. Cubrir la ceremonia de premiación y el cóctel posterior. Se requieren 200 fotos editadas en alta resolución.',
      'location': 'Hotel Gran Plaza, Ciudad de México',
      'date': '18 de Noviembre, 2025',
      'guests': '100',
    };
    final proposals = [
      {
        'id': '1',
        'provider': 'FotoPro Eventos',
        'rating': 4.9,
        'price': 1800.0,
      },
      {
        'id': '2',
        'provider': 'Captura Momentos SA',
        'rating': 4.7,
        'price': 1500.0,
      },
      {
        'id': '3',
        'provider': 'Lente Mágico Estudio',
        'rating': 5.0,
        'price': 2000.0,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          requestDetails['category']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Request Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DETALLES DE TU SOLICITUD',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    requestDetails['description']!,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const Divider(height: 32),
                  _InfoRow(
                    icon: Icons.pin_drop,
                    text: requestDetails['location']!,
                  ),
                  _InfoRow(
                    icon: Icons.calendar_today,
                    text: requestDetails['date']!,
                  ),
                  _InfoRow(
                    icon: Icons.people,
                    text: '${requestDetails['guests']} invitados',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Propuestas Recibidas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Proposals List
            ListView.separated(
              itemCount: proposals.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _ProposalCard(proposal: proposals[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFEF4444)),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({required this.proposal});
  final Map<String, dynamic> proposal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proposal['provider'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${proposal['rating']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(' (124 reviews)'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${(proposal['price'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 150,
                  child: ClientButton(
                    text: 'Ver Propuesta',
                    onPressed: () => context.push(
                      '/client/proposal-detail/${proposal['id']}',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
