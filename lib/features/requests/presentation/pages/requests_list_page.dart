import 'package:festeasy/features/requests/domain/entities/request.dart';
import 'package:festeasy/features/requests/domain/usecases/get_provider_new_requests_usecase.dart';
import 'package:festeasy/features/requests/domain/usecases/get_requests_usecase.dart';
import 'package:festeasy/features/requests/presentation/bloc/requests_cubit.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/auth_service.dart';

class RequestsListPage extends StatelessWidget {
  const RequestsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser;
    if (user == null) {
      return const Center(child: Text('Error: Usuario no identificado'));
    }

    return BlocProvider(
      create: (context) => RequestsCubit(
        context.read<GetRequestsUseCase>(),
        context.read<GetProviderNewRequestsUseCase>(),
      )..loadProviderNewRequests(user.id),
      child: const RequestsListView(),
    );
  }
}

class RequestsListView extends StatelessWidget {
  const RequestsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const SimpleHeader(title: 'Solicitudes Nuevas'),
      body: const RequestsListBody(),
    );
  }
}

class RequestsListBody extends StatelessWidget {
  const RequestsListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsCubit, RequestsState>(
      builder: (context, state) {
        if (state.status == RequestsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == RequestsStatus.failure) {
          return const Center(child: Text('Error al cargar solicitudes'));
        } else if (state.status == RequestsStatus.success) {
          if (state.requests.isEmpty) {
            return const Center(child: Text('No hay solicitudes nuevas'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.requests.length,
            itemBuilder: (context, index) {
              final request = state.requests[index];
              return _RequestListItem(request: request);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _RequestListItem extends StatelessWidget {
  const _RequestListItem({required this.request});

  final Request request;

  String _getCategoryName(String id) {
    if (id.endsWith('0001')) return 'Catering';
    if (id.endsWith('0002')) return 'Música';
    if (id.endsWith('0003')) return 'Fotografía';
    if (id.endsWith('0004')) return 'Decoración';
    if (id.endsWith('0005')) return 'Lugar';
    if (id.endsWith('0006')) return 'Transporte';
    return 'Servicio'; // Default readable text instead of UUID
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: CustomBadge(
                      text: _getCategoryName(request.categoryId),
                      color: const Color(0xFFEF4444),
                      bg: const Color(0xFFFEF2F2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Hace 2h',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                request.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                request.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    request.eventDate?.toIso8601String().split('T').first ??
                        'Fecha no disponible',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.pin_drop,
                    size: 14,
                    color: Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.location ?? 'Ubicación no disponible',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 120,
                  child: PrimaryButton(
                    title: 'Revisar',
                    onPress: () => context.push(
                      '/provider/dashboard/requests/${request.id}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
