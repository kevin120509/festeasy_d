import 'package:bloc/bloc.dart';
import 'package:festeasy/features/quotes/domain/entities/quote.dart';
import 'package:festeasy/features/quotes/domain/usecases/create_quote.dart';
import 'send_quote_state.dart';

class SendQuoteCubit extends Cubit<SendQuoteState> {
  SendQuoteCubit(this._createQuoteUseCase) : super(const SendQuoteState());

  final CreateQuote _createQuoteUseCase;

  Future<void> sendQuote(Quote quote) async {
    emit(const SendQuoteState(status: SendQuoteStatus.loading));
    final result = await _createQuoteUseCase(quote);
    result.fold(
      (failure) => emit(SendQuoteState(
        status: SendQuoteStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(const SendQuoteState(status: SendQuoteStatus.success)),
    );
  }
}
