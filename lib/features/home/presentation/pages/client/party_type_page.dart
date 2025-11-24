import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    id: '1',
    name: 'Boda',
    imageUrl: 'https://picsum.photos/id/237/400/300',
  ),
  const PartyType(
    id: '2',
    name: 'XV Años',
    imageUrl: 'https://picsum.photos/id/160/400/300',
  ),
  const PartyType(
    id: '3',
    name: 'Infantil',
    imageUrl: 'https://picsum.photos/id/214/400/300',
  ),
  const PartyType(
    id: '4',
    name: 'Corporativo',
    imageUrl: 'https://picsum.photos/id/350/400/300',
  ),
];

class PartyTypePage extends StatelessWidget {
  const PartyTypePage({super.key});

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
          return _PartyTypeCard(party: party);
        },
      ),
    );
  }
}

class _PartyTypeCard extends StatelessWidget {
  const _PartyTypeCard({required this.party});
  final PartyType party;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/client/home'),
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
