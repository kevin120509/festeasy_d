import 'package:festeasy/features/quotes/domain/entities/quote.dart';
import 'package:festeasy/features/quotes/presentation/bloc/provider_quotes/provider_quotes_cubit.dart';
import 'package:festeasy/features/requests/presentation/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditQuotePage extends StatefulWidget {
  const EditQuotePage({required this.quote, super.key});

  final Quote quote;

  @override
  State<EditQuotePage> createState() => _EditQuotePageState();
}

class _EditQuotePageState extends State<EditQuotePage> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.quote.proposedPrice.toString());
    _descriptionController = TextEditingController(text: widget.quote.notes);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave() {
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

    // Create updated quote object (immutable copy logic)
    final updatedQuote = Quote(
      id: widget.quote.id,
      requestId: widget.quote.requestId,
      providerId: widget.quote.providerId,
      serviceId: widget.quote.serviceId,
      proposedPrice: price,
      breakdown: widget.quote.breakdown,
      notes: description,
      status: widget.quote.status, // Keep existing status
      createdAt: widget.quote.createdAt,
      validUntil: widget.quote.validUntil,
    );

    // Call update on the provided Cubit
    context.read<ProviderQuotesCubit>().updateQuote(updatedQuote);
    Navigator.pop(context); // Return to detail page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const SimpleHeader(title: 'Editar Cotización'),
      body: SingleChildScrollView(
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 32),
        child: PrimaryButton(
          title: 'Guardar Cambios',
          onPress: _onSave,
        ),
      ),
    );
  }
}