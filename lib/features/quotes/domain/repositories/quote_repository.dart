import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quote.dart';

/// Repository interface for quotes
abstract class QuoteRepository {
  /// Get all quotes for a specific request
  Future<Either<Failure, List<Quote>>> getQuotesForRequest(String requestId);

  /// Get quotes sent by a provider
  Future<Either<Failure, List<Quote>>> getQuotesByProvider(String providerId);

  /// Get a single quote by ID
  Future<Either<Failure, Quote>> getQuoteById(String id);

  /// Create a new quote (provider)
  Future<Either<Failure, Quote>> createQuote(Quote quote);

  /// Accept a quote (client)
  Future<Either<Failure, Quote>> acceptQuote(String quoteId);

  /// Reject a quote (client)
  Future<Either<Failure, Quote>> rejectQuote(String quoteId);
}
