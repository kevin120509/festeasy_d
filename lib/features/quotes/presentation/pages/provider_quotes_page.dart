import 'package:festeasy/app/router/auth_service.dart';
import 'package:festeasy/features/quotes/domain/repositories/quote_repository.dart';
import 'package:festeasy/features/quotes/domain/usecases/delete_quote_usecase.dart';
import 'package:festeasy/features/quotes/domain/usecases/get_provider_quotes_usecase.dart';
import 'package:festeasy/features/quotes/domain/usecases/update_quote_usecase.dart';
import 'package:festeasy/features/quotes/presentation/bloc/provider_quotes/provider_quotes_cubit.dart';
import 'package:festeasy/features/quotes/presentation/bloc/provider_quotes/provider_quotes_state.dart';
import 'package:festeasy/features/quotes/presentation/pages/provider_quote_detail_page.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderQuotesPage extends StatelessWidget {
  const ProviderQuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser;
    // Si no hay usuario logueado o providerId, manejamos el error visualmente
    if (user == null) {
      return const Center(child: Text('Error: Usuario no identificado'));
    }

    return BlocProvider(
      create: (context) => ProviderQuotesCubit(
        GetProviderQuotesUseCase(context.read<QuoteRepository>()),
        context.read<DeleteQuoteUseCase>(),
        context.read<UpdateQuoteUseCase>(),
      )..loadQuotes(user.id),
      child: const _ProviderQuotesView(),
    );
  }
}

class _ProviderQuotesView extends StatelessWidget {
  const _ProviderQuotesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text(
          'Mis Cotizaciones',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ProviderQuotesCubit, ProviderQuotesState>(
        builder: (context, state) {
          if (state.status == ProviderQuotesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ProviderQuotesStatus.failure) {
            return Center(
              child: Text('Error: ${state.errorMessage ?? "Desconocido"}'),
            );
          } else if (state.status == ProviderQuotesStatus.success) {
            if (state.quotes.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.request_quote_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('Aún no has enviado cotizaciones'),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () {
                final userId = Supabase.instance.client.auth.currentUser?.id;
                if (userId != null) {
                  return context.read<ProviderQuotesCubit>().loadQuotes(userId);
                }
                return Future.value();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.quotes.length,
                itemBuilder: (context, index) {
                  final quote = state.quotes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () {
                        final userId =
                            Supabase.instance.client.auth.currentUser?.id;
                        if (userId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<ProviderQuotesCubit>(),
                                child: ProviderQuoteDetailPage(
                                  quote: quote,
                                  providerId: userId,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: CustomCard(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            'Cotización #${quote.id.substring(0, 8)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text('Monto: \$${quote.proposedPrice}'),
                              const SizedBox(height: 4),
                              Text(
                                'Enviada: ${DateFormat.yMMMd('es').format(quote.createdAt)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: CustomBadge(
                            text: quote.status.toUpperCase(),
                            color: _getStatusColor(quote.status),
                            bg: _getStatusColor(quote.status).withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aceptada':
        return Colors.green;
      case 'rechazada':
        return Colors.red;
      case 'pendiente':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
