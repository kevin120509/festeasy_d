import 'dart:math';

import 'package:festeasy/features/quotes/domain/entities/quote.dart';
import 'package:festeasy/features/quotes/domain/usecases/create_quote.dart';
import 'package:festeasy/features/quotes/presentation/bloc/send_quote/send_quote_cubit.dart';
import 'package:festeasy/features/quotes/presentation/bloc/send_quote/send_quote_state.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SendQuotePage extends StatelessWidget {
  const SendQuotePage({required this.requestId, super.key});
  final String requestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendQuoteCubit(
        context.read<CreateQuote>(),
      ),
      child: _SendQuoteView(requestId: requestId),
    );
  }
}

class _SendQuoteView extends StatefulWidget {
  const _SendQuoteView({required this.requestId});
  final String requestId;

  @override
  State<_SendQuoteView> createState() => _SendQuoteViewState();
}

class _SendQuoteViewState extends State<_SendQuoteView> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _generateUuid() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40;
    values[8] = (values[8] & 0x3f) | 0x80;
    final uuid =
        values.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
    return '${uuid.substring(0, 8)}-${uuid.substring(8, 12)}-${uuid.substring(12, 16)}-${uuid.substring(16, 20)}-${uuid.substring(20)}';
  }

  void _onSend() {
    final amountText = _amountController.text.trim();
    final description = _descriptionController.text.trim();

    if (amountText.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final price = double.tryParse(amountText);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido')),
      );
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Usuario no identificado')),
      );
      return;
    }

    final quote = Quote(
      id: _generateUuid(),
      requestId: widget.requestId,
      providerId: user.id,
      serviceId: '', // Opcional según lógica
      proposedPrice: price,
      breakdown: const {}, // Vacío por ahora
      notes: description,
      status: 'pendiente',
      createdAt: DateTime.now(),
      validUntil: DateTime.now().add(const Duration(days: 15)),
    );

    context.read<SendQuoteCubit>().sendQuote(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const SimpleHeader(title: 'Enviar Cotización'),
      body: BlocListener<SendQuoteCubit, SendQuoteState>(
        listener: (context, state) {
          if (state.status == SendQuoteStatus.success) {
            // Ir al panel principal (donde se verán las cotizaciones)
            // Usamos go para limpiar el stack y forzar recarga si la página principal lo gestiona
            context.go('/provider/dashboard'); 
            ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Cotización enviada exitosamente')),
            );
          } else if (state.status == SendQuoteStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.errorMessage}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  prefixText: r'$ ',
                  prefixStyle: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF9CA3AF),
                  ),
                  hintText: '0.00',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Descripción / Notas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Explica brevemente qué incluye tu cotización...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 32),
        child: BlocBuilder<SendQuoteCubit, SendQuoteState>(
          builder: (context, state) {
            if (state.status == SendQuoteStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return PrimaryButton(
              title: 'Enviar cotización',
              onPress: _onSend,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
