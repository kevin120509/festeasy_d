import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClientRequestsPage extends StatefulWidget {
  const ClientRequestsPage({super.key});

  @override
  State<ClientRequestsPage> createState() => _ClientRequestsPageState();
}

class _ClientRequestsPageState extends State<ClientRequestsPage> {
  String _selectedFilter = 'Todos';
  final _filters = ['Todos', 'Bodas', 'XV Años', 'Infantiles'];
  int _selectedIndex = 1; // Set to 1 because this is the "Mis Solicitudes" page

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on index
    switch (index) {
      case 0:
        context.go('/client/home'); // Navigate to Home
        break;
      case 1:
        // Stay on current page (Mis Solicitudes)
        break;
      // case 2: context.go('/client/profile'); break; // Add profile page if exists
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final requests = [
      {
        'id': '1',
        'category': 'Boda',
        'services': ['Catering', 'Decoración', 'Música'],
        'status': 'Activa',
        'proposals': 3,
      },
      {
        'id': '2',
        'category': 'XV Años',
        'services': ['Fotografía', 'Música'],
        'status': 'Finalizada',
        'proposals': 1,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mis Solicitudes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Filter Pills
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                      }
                    },
                    backgroundColor: const Color(0xFFF3F4F6),
                    selectedColor: const Color(0xFFEF4444),
                    labelStyle: TextStyle(
                      color: _selectedFilter == filter ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide.none,
                  ),
                );
              },
            ),
          ),
          // Request List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return _RequestCard(request: requests[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long), // Icon for requests/agenda
            label: 'Mis Solicitudes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFEF4444), // Red color
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final Map<String, dynamic> request;

  @override
  Widget build(BuildContext context) {
    final bool isActive = request['status'] == 'Activa';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request['category'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          if ((request['services'] as List<String>).isNotEmpty)
            Text(
              (request['services'] as List<String>).first,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estado: ${request['status']}',
                    style: TextStyle(
                      color: isActive ? const Color(0xFF22C55E) : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${request['proposals']} propuestas recibidas'),
                ],
              ),
              SizedBox(
                width: 120,
                child: ClientButton(
                  text: 'Revisar',
                  onPressed: () => context.push('/client/request-detail/${request['id']}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}