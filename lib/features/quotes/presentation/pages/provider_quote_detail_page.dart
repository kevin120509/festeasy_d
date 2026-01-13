import 'package:festeasy/features/quotes/presentation/pages/edit_quote_page.dart';
import 'package:festeasy/features/quotes/domain/entities/quote.dart';
import 'package:festeasy/features/quotes/presentation/bloc/provider_quotes/provider_quotes_cubit.dart';
import 'package:festeasy/features/requests/domain/repositories/requests_repository.dart';
import 'package:festeasy/features/requests/domain/usecases/get_request_by_id_usecase.dart';
import 'package:festeasy/features/requests/presentation/bloc/request_detail_cubit.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProviderQuoteDetailPage extends StatelessWidget {
  const ProviderQuoteDetailPage({
    required this.quote,
    required this.providerId,
    super.key,
  });

  final Quote quote;
  final String providerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestDetailCubit(
        GetRequestByIdUseCase(context.read<RequestsRepository>()),
      )..loadRequest(quote.requestId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        appBar: const SimpleHeader(title: 'Detalle de Cotización'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de la Cotización
              const Text(
                'TU PROPUESTA',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailItem(
                        label: 'Precio Propuesto',
                        value: '\$${quote.proposedPrice}',
                        isCurrency: true,
                      ),
                      const Divider(height: 24),
                      _DetailItem(
                        label: 'Fecha de Envío',
                        value: DateFormat.yMMMd('es').format(quote.createdAt),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Notas / Descripción',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quote.notes ?? 'Sin notas adicionales',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Sección de la Solicitud del Cliente
              const Text(
                'DATOS DE LA SOLICITUD',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              
              BlocBuilder<RequestDetailCubit, RequestDetailState>(
                builder: (context, state) {
                  if (state.status == RequestDetailStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == RequestDetailStatus.failure) {
                    return const CustomCard(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No se pudo cargar la información del evento'),
                      ),
                    );
                  } else if (state.status == RequestDetailStatus.success &&
                      state.request != null) {
                    final req = state.request!;
                    return CustomCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              req.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(req.description),
                            const Divider(height: 24),
                            _InfoRow(
                              icon: Icons.calendar_today,
                              text: req.eventDate != null
                                  ? DateFormat.yMMMd('es').format(req.eventDate!)
                                  : 'Fecha no definida',
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.access_time,
                              text: req.eventTime ?? 'Hora no definida',
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.location_on,
                              text: req.location ?? 'Ubicación no definida',
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.people,
                              text: '${req.guestCount ?? 0} Invitados',
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      title: 'Eliminar',
                      outline: true, // Make delete outlined/secondary
                      onPress: () => _confirmDelete(context),
                    ),
                  ),
                  if (quote.isPending) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: PrimaryButton(
                        title: 'Editar',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<ProviderQuotesCubit>(),
                                child: EditQuotePage(quote: quote),
                              ),
                            ),
                          ).then((_) {
                            // Refresh logic handled by Cubit, but if we need to refresh THIS page's state (if it was Stateful), we'd do it here.
                            // Since this page is Stateless and receives 'quote' in constructor, it won't auto-update visually unless we re-fetch or pop back.
                            // Better UX: Pop back to list after edit, or convert this page to BlocBuilder listening to specific quote updates.
                            // For simplicity: Pop back to list if edited.
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Cotización'),
        content: const Text(
            '¿Estás seguro de que deseas eliminar esta cotización? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              // Call delete on the provided Cubit
              context
                  .read<ProviderQuotesCubit>()
                  .deleteQuote(quote.id, providerId);
              context.pop(); // Go back to list
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.label,
    required this.value,
    this.isCurrency = false,
  });

  final String label;
  final String value;
  final bool isCurrency;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isCurrency ? const Color(0xFFEF4444) : Colors.black,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
