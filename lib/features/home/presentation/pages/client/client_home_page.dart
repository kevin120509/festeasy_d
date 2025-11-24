import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _Category {
  const _Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.iconColor,
  });
  final int id;
  final String name;
  final IconData icon;
  final Color color;
  final Color iconColor;
}

final _categories = [
  const _Category(
    id: 1,
    name: 'Música',
    icon: Icons.music_note,
    color: Color(0xFFFEF3C7),
    iconColor: Color(0xFFD97706),
  ),
  const _Category(
    id: 2,
    name: 'Catering',
    icon: Icons.restaurant_menu,
    color: Color(0xFFDCFCE7),
    iconColor: Color(0xFF16A34A),
  ),
  const _Category(
    id: 3,
    name: 'Foto/Video',
    icon: Icons.camera_alt,
    color: Color(0xFFDBEAFE),
    iconColor: Color(0xFF2563EB),
  ),
  const _Category(
    id: 4,
    name: 'Decoración',
    icon: Icons.palette,
    color: Color(0xFFFCE7F3),
    iconColor: Color(0xFFDB2777),
  ),
  const _Category(
    id: 5,
    name: 'Lugares',
    icon: Icons.pin_drop,
    color: Color(0xFFE0E7FF),
    iconColor: Color(0xFF4F46E5),
  ),
  const _Category(
    id: 6,
    name: 'Otro',
    icon: Icons.add_circle,
    color: Color(0xFFF3F4F6),
    iconColor: Color(0xFF4B5563),
  ),
];

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on index
    switch (index) {
      case 0:
        context.go('/client/home');
        break;
      case 1:
        context.go('/client/requests');
        break;
      // case 2: context.go('/client/profile'); break; // Add profile page if exists
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hola, Kevin 👋',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          '¡Planea tu fiesta perfecta!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: const Color(0xFFF3F4F6),
                      child: IconButton(
                        onPressed: () => context.push(
                          '/client/profile',
                        ), // Navigate to client profile
                        icon: const Icon(
                          Icons.person,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Categories Grid
                const Text(
                  'Categorías',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _categories.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return ServiceCard(
                      name: cat.name,
                      icon: cat.icon,
                      color: cat.color,
                      iconColor: cat.iconColor,
                      onTap: () {
                        context.go(
                          '/client/create-request',
                        ); // Navigate to service request form
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
