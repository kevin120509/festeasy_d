import 'package:festeasy/data/mock_data.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final event = MockData.mockEvents.first; // Get the mock event

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const SimpleHeader(title: 'Calendario'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CalendarHeader(),
            const SizedBox(height: 16),
            _CalendarGrid(
              eventDay: 15,
              event: event,
            ), // Mocking event on day 15
            const SizedBox(height: 24),
            _EventList(event: event),
          ],
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Octubre 2024',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.eventDay, required this.event});
  final int eventDay;
  final Event event;
  @override
  Widget build(BuildContext context) {
    final daysOfWeek = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemCount: 31 + 7, // 7 for headers + 31 days
      itemBuilder: (context, index) {
        if (index < 7) {
          // Day headers
          return Center(
            child: Text(
              daysOfWeek[index],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          );
        }
        final day = index - 6;
        final isEventDay = day == eventDay;

        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isEventDay ? const Color(0xFFEF4444) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                color: isEventDay ? Colors.white : Colors.black87,
                fontWeight: isEventDay ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EventList extends StatelessWidget {
  const _EventList({required this.event});
  final Event event;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eventos del mes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: InkWell(
            onTap: () => context.push('/calendar/${event.id}'),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${event.date} - ${event.time}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
