import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/core/usecases/usecase.dart';
import 'package:festeasy/features/quotes/domain/entities/quote.dart';
import 'package:festeasy/features/quotes/domain/repositories/quote_repository.dart';

class UpdateQuoteUseCase implements UseCase<Quote, Quote> {
  final QuoteRepository repository;

  UpdateQuoteUseCase(this.repository);

  @override
  Future<Either<Failure, Quote>> call(Quote quote) async {
    return await repository.updateQuote(quote);
  }
}
