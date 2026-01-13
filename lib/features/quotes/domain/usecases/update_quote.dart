import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

/// Use case to update a quote (for providers)
class UpdateQuote {
  final QuoteRepository repository;

  UpdateQuote(this.repository);

  Future<Either<Failure, Quote>> call(Quote quote) {
    return repository.updateQuote(quote);
  }
}
