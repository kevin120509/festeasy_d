import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

/// Use case to get quotes for a specific request
class GetQuotesForRequest {
  final QuoteRepository repository;

  GetQuotesForRequest(this.repository);

  Future<Either<Failure, List<Quote>>> call(String requestId) {
    return repository.getQuotesForRequest(requestId);
  }
}
