import 'package:festeasy/shared/widgets/client_components.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({super.key});

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  String _selectedPaymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Confirmar Reservación',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del Servicio',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Proveedor', 'Eventos Mágicos'),
                  _buildSummaryRow(
                    'Servicio',
                    'Decoración y Catering para Boda',
                  ),
                  const Divider(height: 32),
                  _buildSummaryRow('Monto Total', '\$2,500.00', isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Método de Pago',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _PaymentMethodSelector(
              icon: Icons.credit_card,
              title: 'Tarjeta de Crédito/Débito',
              isSelected: _selectedPaymentMethod == 'card',
              onTap: () => setState(() => _selectedPaymentMethod = 'card'),
            ),
            const SizedBox(height: 12),
            _PaymentMethodSelector(
              icon: Icons.account_balance,
              title: 'Transferencia Bancaria',
              isSelected: _selectedPaymentMethod == 'transfer',
              onTap: () => setState(() => _selectedPaymentMethod = 'transfer'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: ClientButton(
          text: 'Confirmar y Pagar',
          onPressed: () => context.go('/client/success'),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: isTotal ? const Color(0xFFEF4444) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  const _PaymentMethodSelector({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFEF4444) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFEF4444)),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFFEF4444)),
          ],
        ),
      ),
    );
  }
}
