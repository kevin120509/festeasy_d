import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

/// Use case to accept a quote (for clients)
class AcceptQuote {
  final QuoteRepository repository;

  AcceptQuote(this.repository);

  Future<Either<Failure, Quote>> call(String quoteId) {
    return repository.acceptQuote(quoteId);
  }
}
