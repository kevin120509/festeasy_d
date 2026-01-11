import 'package:festeasy/features/requests/domain/entities/request.dart';
import 'package:festeasy/features/requests/domain/usecases/get_requests_usecase.dart';
import 'package:festeasy/features/requests/presentation/bloc/requests_cubit.dart';
import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ClientRequestsPage extends StatelessWidget {
  const ClientRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final user = Supabase.instance.client.auth.currentUser;
        return RequestsCubit(context.read<GetRequestsUseCase>())
          ..loadClientRequests(user?.id ?? '');
      },
      child: const ClientRequestsView(),
    );
  }
}

class ClientRequestsView extends StatefulWidget {
  const ClientRequestsView({super.key});

  @override
  State<ClientRequestsView> createState() => _ClientRequestsViewState();
}

class _ClientRequestsViewState extends State<ClientRequestsView> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mis Solicitudes',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          if (state.status == RequestsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == RequestsStatus.failure) {
            return const Center(child: Text('Error al cargar solicitudes'));
          } else if (state.status == RequestsStatus.success) {
            if (state.requests.isEmpty) {
              return const Center(child: Text('No tienes solicitudes aún'));
            }

            return Column(
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
                            color: _selectedFilter == filter
                                ? Colors.white
                                : Colors.black,
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
                    itemCount: state.requests.length,
                    itemBuilder: (context, index) {
                      return _RequestCard(request: state.requests[index]);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
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

  final Request request;

  @override
  Widget build(BuildContext context) {
    final bool isActive = request.status == 'abierta';
    final dateFormat = DateFormat('dd MMM yyyy');

    String getStatusText(String status) {
      switch (status) {
        case 'abierta':
          return 'Abierta';
        case 'enviada':
          return 'Enviada';
        case 'cotizada':
          return 'Cotizada';
        case 'contratada':
          return 'Contratada';
        case 'cancelada':
          return 'Cancelada';
        case 'expirada':
          return 'Expirada';
        default:
          return status;
      }
    }

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
            request.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          if (request.eventDate != null) ...[
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(request.eventDate!),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                if (request.location != null) ...[
                  const SizedBox(width: 16),
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.location!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
          Text(
            request.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
                    'Estado: ${getStatusText(request.status)}',
                    style: TextStyle(
                      color: isActive ? const Color(0xFF22C55E) : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '0 propuestas recibidas',
                  ), // TODO: Implementar conteo de cotizaciones
                ],
              ),
              SizedBox(
                width: 120,
                child: ClientButton(
                  text: 'Revisar',
                  onPressed: () =>
                      context.push('/client/request-detail/${request.id}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
