import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

/// Use case to create a quote (for providers)
class CreateQuote {
  final QuoteRepository repository;

  CreateQuote(this.repository);

  Future<Either<Failure, Quote>> call(Quote quote) {
    return repository.createQuote(quote);
  }
}
