import 'package:equatable/equatable.dart';
import 'package:festeasy/features/quotes/domain/entities/quote.dart';

enum ProviderQuotesStatus { initial, loading, success, failure }

class ProviderQuotesState extends Equatable {
  const ProviderQuotesState({
    this.status = ProviderQuotesStatus.initial,
    this.quotes = const [],
    this.errorMessage,
  });

  final ProviderQuotesStatus status;
  final List<Quote> quotes;
  final String? errorMessage;

  ProviderQuotesState copyWith({
    ProviderQuotesStatus? status,
    List<Quote>? quotes,
    String? errorMessage,
  }) {
    return ProviderQuotesState(
      status: status ?? this.status,
      quotes: quotes ?? this.quotes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, quotes, errorMessage];
}
