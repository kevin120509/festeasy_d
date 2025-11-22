import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProposalDetailPage extends StatelessWidget {
  const ProposalDetailPage({super.key, required this.proposalId});
  final String proposalId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Eventos Mágicos', style: TextStyle(color: Colors.white)),
              background: Image.network(
                'https://picsum.photos/800/600', // Replaced with a more reliable URL
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.4),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white, size: 50),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Propuesta para tu Boda', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const _RatingSummary(),
                  const Divider(height: 48),
                  const Text('¿Qué incluye?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _IncludedItem(text: 'Decoración estilo bohemio completo'),
                  _IncludedItem(text: 'Menú de mariscos para 50 personas'),
                  _IncludedItem(text: 'Dúo de guitarras en vivo por 3 horas'),
                  _IncludedItem(text: 'Coordinador de evento'),
                  const Divider(height: 48),
                   const Text('Notas Adicionales', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 8),
                   const Text('No se incluyen bebidas alcohólicas. El montaje se realiza 5 horas antes del evento.', style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/client/payment'),
        label: const Text('Elegir este proveedor'),
        icon: const Icon(Icons.check),
        backgroundColor: const Color(0xFFEF4444),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _RatingSummary extends StatelessWidget {
  const _RatingSummary();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 24),
            SizedBox(width: 8),
            Text('4.8', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 4),
            Text('(124 reviews)', style: TextStyle(color: Colors.grey)),
          ],
        ),
        Text(
          '\$2,500.00',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
        )
      ],
    );
  }
}

class _IncludedItem extends StatelessWidget {
  const _IncludedItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF22C55E)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}