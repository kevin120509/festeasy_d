import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

/// Use case to reject a quote (for clients)
class RejectQuote {
  final QuoteRepository repository;

  RejectQuote(this.repository);

  Future<Either<Failure, Quote>> call(String quoteId) {
    return repository.rejectQuote(quoteId);
  }
}
