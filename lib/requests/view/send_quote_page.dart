import 'package:festeasy/requests/widgets/simple_header.dart';
import 'package:festeasy/shared/widgets/global_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SendQuotePage extends StatefulWidget {
  const SendQuotePage({required this.requestId, super.key});
  final String requestId;

  @override
  State<SendQuotePage> createState() => _SendQuotePageState();
}

class _SendQuotePageState extends State<SendQuotePage> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Map<String, bool> _services = {
    'Montaje incluido': false,
    'Desmontaje incluido': false,
    'Transporte': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const SimpleHeader(title: 'Enviar Cotización'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Monto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                prefixText: r'$ ',
                prefixStyle: const TextStyle(fontSize: 18, color: Color(0xFF9CA3AF)),
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
            const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            const SizedBox(height: 20),
            const Text('Servicios incluidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ..._services.keys.map((service) {
              return _CheckboxRow(
                title: service,
                value: _services[service]!,
                onChanged: (bool? value) {
                  setState(() {
                    _services[service] = value ?? false;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 32),
        child: PrimaryButton(
          title: 'Enviar cotización',
          onPress: () {
            // In a real app, you'd process the form data
            context.go('/success');
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

class _CheckboxRow extends StatelessWidget {
  const _CheckboxRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFFEF4444),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
