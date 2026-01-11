import 'package:festeasy/features/requests/data/datasources/requests_remote_datasource.dart';
import 'package:festeasy/features/requests/data/repositories/requests_repository_impl.dart';
import 'package:festeasy/features/requests/domain/usecases/get_request_by_id_usecase.dart';
import 'package:festeasy/features/requests/presentation/bloc/request_detail_cubit.dart';
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
      child: const ClientRequestDetailView(),
    );
  }
}

class ClientRequestDetailView extends StatelessWidget {
  const ClientRequestDetailView({super.key});

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
                  // Placeholder for proposals
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No hay propuestas todavía.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
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
