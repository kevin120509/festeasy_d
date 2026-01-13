import 'package:festeasy/features/requests/data/datasources/requests_remote_datasource.dart';
import 'package:festeasy/features/requests/data/repositories/requests_repository_impl.dart';
import 'package:festeasy/features/requests/domain/usecases/get_request_by_id_usecase.dart';
import 'package:festeasy/features/requests/presentation/bloc/request_detail_cubit.dart';
import 'package:festeasy/features/quotes/domain/entities/quote.dart';
import 'package:festeasy/features/quotes/domain/usecases/accept_quote.dart';
import 'package:festeasy/features/quotes/domain/usecases/get_quotes_for_request.dart';
import 'package:festeasy/features/quotes/domain/usecases/reject_quote.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ClientRequestDetailPage extends StatelessWidget {
  const ClientRequestDetailPage({super.key, required this.requestId});
  final String requestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestDetailCubit(
        GetRequestByIdUseCase(
          RequestsRepositoryImpl(
            RequestsRemoteDataSourceImpl(
              supabaseClient: Supabase.instance.client,
            ),
          ),
        ),
      )..loadRequest(requestId),
      child: ClientRequestDetailView(requestId: requestId),
    );
  }
}

class ClientRequestDetailView extends StatefulWidget {
  const ClientRequestDetailView({super.key, required this.requestId});

  final String requestId;

  @override
  State<ClientRequestDetailView> createState() =>
      _ClientRequestDetailViewState();
}

class _ClientRequestDetailViewState extends State<ClientRequestDetailView> {
  List<Quote>? _quotes;
  bool _isLoadingQuotes = true;
  String? _quotesError;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    setState(() {
      _isLoadingQuotes = true;
      _quotesError = null;
    });

    final getQuotes = context.read<GetQuotesForRequest>();
    final result = await getQuotes(widget.requestId);

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _quotesError = failure.message;
          _isLoadingQuotes = false;
        });
      },
      (quotes) {
        setState(() {
          _quotes = quotes;
          _isLoadingQuotes = false;
        });
      },
    );
  }

  Future<void> _acceptQuote(String quoteId) async {
    final acceptQuote = context.read<AcceptQuote>();
    final result = await acceptQuote(quoteId);
    if (!mounted) return;
    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${failure.message}')),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cotización aceptada')),
        );
        _loadQuotes();
      },
    );
  }

  Future<void> _rejectQuote(String quoteId) async {
    final rejectQuote = context.read<RejectQuote>();
    final result = await rejectQuote(quoteId);
    if (!mounted) return;
    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${failure.message}')),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cotización rechazada')),
        );
        _loadQuotes();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: BlocBuilder<RequestDetailCubit, RequestDetailState>(
          builder: (context, state) {
            return Text(
              state.request?.title ?? 'Detalle de Solicitud',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<RequestDetailCubit, RequestDetailState>(
        builder: (context, state) {
          if (state.status == RequestDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == RequestDetailStatus.failure) {
            return const Center(child: Text('Error al cargar la solicitud'));
          } else if (state.status == RequestDetailStatus.success &&
              state.request != null) {
            final request = state.request!;
            final dateFormat = DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Information Card
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
                          'INFORMACIÓN DEL EVENTO',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          request.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 32),
                        if (request.eventDate != null)
                          _InfoRow(
                            icon: Icons.calendar_today,
                            text: dateFormat.format(request.eventDate!),
                            subtext:
                                request.eventTime ?? 'Hora no especificada',
                          ),
                        if (request.location != null &&
                            request.location!.isNotEmpty)
                          _InfoRow(
                            icon: Icons.place,
                            text: request.location!,
                            subtext:
                                request.address ?? 'Dirección no especificada',
                          ),
                        if (request.guestCount != null)
                          _InfoRow(
                            icon: Icons.people,
                            text: '${request.guestCount} invitados',
                          ),
                        if (request.totalBudget != null &&
                            request.totalBudget! > 0)
                          _InfoRow(
                            icon: Icons.attach_money,
                            text:
                                '\$${request.totalBudget!.toStringAsFixed(2)}',
                            subtext: 'Presupuesto Total del Evento',
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'DETALLES DE LA SOLICITUD',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            _StatusBadge(status: request.status),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Descripción:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          request.description,
                          style: const TextStyle(fontSize: 16, height: 1.5),
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
                  if (_isLoadingQuotes)
                    const Center(child: CircularProgressIndicator())
                  else if (_quotesError != null)
                    Center(
                      child: Column(
                        children: [
                          Text('Error: $_quotesError'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _loadQuotes,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    )
                  else if (_quotes == null || _quotes!.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No hay propuestas todavía.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _quotes!.length,
                      itemBuilder: (context, index) {
                        final quote = _quotes![index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _statusLabel(quote.status),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _statusColor(quote.status),
                                      ),
                                    ),
                                    Text(
                                      '\$${quote.proposedPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (quote.notes != null &&
                                    quote.notes!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    quote.notes!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                                if (quote.isPending) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => _rejectQuote(quote.id),
                                        child: const Text('Rechazar'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () => _acceptQuote(quote.id),
                                        child: const Text('Aceptar'),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aceptada':
      case 'accepted':
        return Colors.green;
      case 'rechazada':
      case 'rejected':
        return Colors.red;
      case 'pendiente':
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'aceptada':
      case 'accepted':
        return 'Aceptada';
      case 'rechazada':
      case 'rejected':
        return 'Rechazada';
      case 'pendiente':
      case 'pending':
      default:
        return 'Pendiente';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case 'abierta':
        color = Colors.orange;
        text = 'Pendiente';
        break;
      case 'enviada':
        color = Colors.blue;
        text = 'Enviada';
        break;
      case 'cotizada':
        color = Colors.orange;
        text = 'Cotizada';
        break;
      case 'contratada':
        color = Colors.purple;
        text = 'Contratada';
        break;
      case 'cancelada':
        color = Colors.red;
        text = 'Cancelada';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text, this.subtext});
  final IconData icon;
  final String text;
  final String? subtext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFEF4444), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtext != null && subtext!.isNotEmpty)
                  Text(
                    subtext!,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
