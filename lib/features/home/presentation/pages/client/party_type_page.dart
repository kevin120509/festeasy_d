import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartyType {
  const PartyType({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
  final String id;
  final String name;
  final String imageUrl;
}

final _partyTypes = [
  const PartyType(
    id: '550e8400-e29b-41d4-a716-446655440011', // Boda
    name: 'Boda',
    imageUrl: 'https://picsum.photos/id/237/400/300',
  ),
  const PartyType(
    id: '550e8400-e29b-41d4-a716-446655440012', // XV Años
    name: 'XV Años',
    imageUrl: 'https://picsum.photos/id/160/400/300',
  ),
  const PartyType(
    id: '550e8400-e29b-41d4-a716-446655440013', // Cumpleaños
    name: 'Cumpleaños',
    imageUrl: 'https://picsum.photos/id/214/400/300',
  ),
  const PartyType(
    id: '550e8400-e29b-41d4-a716-446655440016', // Corporativo
    name: 'Corporativo',
    imageUrl: 'https://picsum.photos/id/350/400/300',
  ),
];

class PartyTypePage extends StatefulWidget {
  const PartyTypePage({super.key});

  @override
  State<PartyTypePage> createState() => _PartyTypePageState();
}

class _PartyTypePageState extends State<PartyTypePage> {
  Future<void> _saveSelectedPartyType(String partyTypeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_party_type_id', partyTypeId);
    await prefs.setString(
      'selected_party_type_name',
      _partyTypes.firstWhere((type) => type.id == partyTypeId).name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '¿Qué vas a celebrar?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.9,
        ),
        itemCount: _partyTypes.length,
        itemBuilder: (context, index) {
          final party = _partyTypes[index];
          return _PartyTypeCard(
            party: party,
            onPartySelected: _saveSelectedPartyType,
          );
        },
      ),
    );
  }
}

class _PartyTypeCard extends StatelessWidget {
  const _PartyTypeCard({required this.party, required this.onPartySelected});
  final PartyType party;
  final Function(String) onPartySelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await onPartySelected(party.id);
        if (context.mounted) {
          context.go('/client/home');
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              party.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey,
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
            // Black overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Text(
                party.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
