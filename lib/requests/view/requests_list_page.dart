import 'package:festeasy/data/mock_data.dart';
import 'package:festeasy/requests/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequestsListPage extends StatelessWidget {
  const RequestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const SimpleHeader(title: 'Solicitudes Nuevas'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.mockRequests.length,
        itemBuilder: (context, index) {
          final request = MockData.mockRequests[index];
          return _RequestListItem(request: request);
        },
      ),
    );
  }
}

class _RequestListItem extends StatelessWidget {
  const _RequestListItem({required this.request});

  final Request request;

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
                children: [
                  CustomBadge(
                    text: request.category,
                    color: const Color(0xFFEF4444),
                    bg: const Color(0xFFFEF2F2),
                  ),
                  const Text('Hace 2h', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                request.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                request.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Color(0xFF6B7280)),
                  const SizedBox(width: 4),
                  Text(request.date, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                  const SizedBox(width: 16),
                  const Icon(Icons.pin_drop, size: 14, color: Color(0xFF6B7280)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.location,
                      style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 120,
                  child: PrimaryButton(
                    title: 'Revisar',
                    onPress: () => context.push('/requests/${request.id}'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
