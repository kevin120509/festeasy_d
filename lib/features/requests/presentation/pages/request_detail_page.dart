import 'package:festeasy/features/requests/domain/repositories/requests_repository.dart';
import 'package:festeasy/features/requests/domain/usecases/get_request_by_id_usecase.dart';
import 'package:festeasy/features/requests/presentation/bloc/request_detail_cubit.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RequestDetailPage extends StatelessWidget {
  const RequestDetailPage({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestDetailCubit(
        GetRequestByIdUseCase(context.read<RequestsRepository>()),
      )..loadRequest(requestId),
      child: const RequestDetailView(),
    );
  }
}

class RequestDetailView extends StatelessWidget {
  const RequestDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const SimpleHeader(title: 'Detalle de Solicitud'),
      body: BlocBuilder<RequestDetailCubit, RequestDetailState>(
        builder: (context, state) {
          if (state.status == RequestDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == RequestDetailStatus.failure) {
            return const Center(child: Text('Error al cargar la solicitud'));
          } else if (state.status == RequestDetailStatus.success &&
              state.request != null) {
            final request = state.request!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 24,
                            color: Color(0xFFEF4444),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'DESCRIPCIÓN DEL CLIENTE',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        request.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        request.description,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const Divider(height: 40),
                      _InfoRow(
                        icon: Icons.calendar_today,
                        label: 'Fecha del evento',
                        text:
                            request.eventDate
                                ?.toIso8601String()
                                .split('T')
                                .first ??
                            'Fecha no disponible',
                      ),
                      _InfoRow(
                        icon: Icons.access_time,
                        label: 'Horario',
                        text: request.eventTime ?? 'Horario no especificado',
                      ),
                      _InfoRow(
                        icon: Icons.pin_drop,
                        label: request.location ?? 'Ubicación',
                        text: request.address ?? 'Dirección no disponible',
                      ),
                      _InfoRow(
                        icon: Icons.people,
                        label: 'Aforo estimado',
                        text: '${request.guestCount ?? 0} Invitados',
                      ),
                      if (request.budgetEstimate != null)
                        _InfoRow(
                          icon: Icons.attach_money,
                          label: 'Presupuesto estimado',
                          text: '\$${request.budgetEstimate}',
                        ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: BlocBuilder<RequestDetailCubit, RequestDetailState>(
        builder: (context, state) {
          if (state.status == RequestDetailStatus.success &&
              state.request != null) {
            return _FooterButtons(requestId: state.request!.id);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.text,
  });

  final IconData icon;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF6B7280), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterButtons extends StatelessWidget {
  const _FooterButtons({required this.requestId});
  final String requestId;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              title: 'Rechazar',
              outline: true,
              onPress: () => context.pop(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PrimaryButton(
              title: 'Cotizar',
              onPress: () => context.push(
                '/provider/dashboard/requests/$requestId/send-quote',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
