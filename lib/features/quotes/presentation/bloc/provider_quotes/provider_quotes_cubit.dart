import 'package:bloc/bloc.dart';
import 'package:festeasy/features/quotes/domain/entities/quote.dart';
import 'package:festeasy/features/quotes/domain/usecases/delete_quote_usecase.dart';
import 'package:festeasy/features/quotes/domain/usecases/get_provider_quotes_usecase.dart';
import 'package:festeasy/features/quotes/domain/usecases/update_quote_usecase.dart';
import 'provider_quotes_state.dart';

class ProviderQuotesCubit extends Cubit<ProviderQuotesState> {
  ProviderQuotesCubit(
    this._getProviderQuotesUseCase,
    this._deleteQuoteUseCase,
    this._updateQuoteUseCase,
  ) : super(const ProviderQuotesState());

  final GetProviderQuotesUseCase _getProviderQuotesUseCase;
  final DeleteQuoteUseCase _deleteQuoteUseCase;
  final UpdateQuoteUseCase _updateQuoteUseCase;

  Future<void> loadQuotes(String providerId) async {
    emit(state.copyWith(status: ProviderQuotesStatus.loading));
    final result = await _getProviderQuotesUseCase(providerId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderQuotesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (quotes) => emit(
        state.copyWith(
          status: ProviderQuotesStatus.success,
          quotes: quotes,
        ),
      ),
    );
  }

  Future<void> updateQuote(Quote quote) async {
    emit(state.copyWith(status: ProviderQuotesStatus.loading));
    final result = await _updateQuoteUseCase(quote);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderQuotesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Reload list after update
        loadQuotes(quote.providerId);
      },
    );
  }

  Future<void> deleteQuote(String quoteId, String providerId) async {
    emit(state.copyWith(status: ProviderQuotesStatus.loading));
    final result = await _deleteQuoteUseCase(quoteId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProviderQuotesStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Reload list after deletion
        loadQuotes(providerId);
      },
    );
  }
}
