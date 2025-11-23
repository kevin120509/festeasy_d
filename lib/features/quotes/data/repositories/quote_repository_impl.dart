import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/quote.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_remote_datasource.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource _remoteDataSource;

  QuoteRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Quote>>> getQuotesForRequest(
    String requestId,
  ) async {
    try {
      final quotes = await _remoteDataSource.getQuotesForRequest(requestId);
      return Right(quotes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Quote>>> getQuotesByProvider(
    String providerId,
  ) async {
    try {
      final quotes = await _remoteDataSource.getQuotesByProvider(providerId);
      return Right(quotes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> getQuoteById(String id) async {
    try {
      final quote = await _remoteDataSource.getQuoteById(id);
      return Right(quote);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> createQuote(Quote quote) async {
    try {
      final quoteModel = quote as dynamic;
      final createdQuote = await _remoteDataSource.createQuote(quoteModel);
      return Right(createdQuote);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> acceptQuote(String quoteId) async {
    try {
      final quote = await _remoteDataSource.updateQuoteStatus(
        quoteId,
        'accepted',
      );
      return Right(quote);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> rejectQuote(String quoteId) async {
    try {
      final quote = await _remoteDataSource.updateQuoteStatus(
        quoteId,
        'rejected',
      );
      return Right(quote);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
