import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quote.dart';
import '../../domain/usecases/get_quotes_for_request.dart';

/// Page to display quotes received for a specific request (for clients)
class QuotesListPage extends StatefulWidget {
  final String requestId;
  final String requestTitle;

  const QuotesListPage({
    super.key,
    required this.requestId,
    required this.requestTitle,
  });

  @override
  State<QuotesListPage> createState() => _QuotesListPageState();
}

class _QuotesListPageState extends State<QuotesListPage> {
  List<Quote>? _quotes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final getQuotes = context.read<GetQuotesForRequest>();
    final result = await getQuotes(widget.requestId);

    result.fold(
      (failure) {
        setState(() {
          _error = failure.message;
          _isLoading = false;
        });
      },
      (quotes) {
        setState(() {
          _quotes = quotes;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotizaciones'),
        backgroundColor: const Color(0xFFEF4444),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $_error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadQuotes,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            )
          : _quotes == null || _quotes!.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay cotizaciones aún',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Los proveedores enviarán sus propuestas pronto',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadQuotes,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _quotes!.length,
                itemBuilder: (context, index) {
                  final quote = _quotes![index];
                  return _QuoteCard(quote: quote, onRefresh: _loadQuotes);
                },
              ),
            ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onRefresh;

  const _QuoteCard({
    required this.quote,
    required this.onRefresh,
  });

  Color _getStatusColor() {
    switch (quote.status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'expired':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _getStatusLabel() {
    switch (quote.status) {
      case 'accepted':
        return 'Aceptada';
      case 'rejected':
        return 'Rechazada';
      case 'expired':
        return 'Expirada';
      default:
        return 'Pendiente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusLabel(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  '\$${quote.proposedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Notes
            if (quote.notes != null && quote.notes!.isNotEmpty) ...[
              Text(
                quote.notes!,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
            ],
            // Valid until
            if (quote.validUntil != null) ...[
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Válida hasta: ${quote.validUntil!.day}/${quote.validUntil!.month}/${quote.validUntil!.year}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            // Action buttons (only if pending)
            if (quote.isPending) ...[
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: Implement reject
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rechazar cotización')),
                      );
                    },
                    child: const Text('Rechazar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement accept
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Aceptar cotización')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
