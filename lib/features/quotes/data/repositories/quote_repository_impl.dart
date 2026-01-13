import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/quote.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_remote_datasource.dart';
import '../models/quote_model.dart';

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
      final quoteModel = QuoteModel(
        id: quote.id,
        requestId: quote.requestId,
        providerId: quote.providerId,
        serviceId: quote.serviceId,
        proposedPrice: quote.proposedPrice,
        breakdown: quote.breakdown,
        notes: quote.notes,
        validUntil: quote.validUntil,
        status: quote.status,
        createdAt: quote.createdAt,
      );
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
        'aceptada',
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
        'rechazada',
      );
      return Right(quote);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuote(String quoteId) async {
    try {
      await _remoteDataSource.deleteQuote(quoteId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Quote>> updateQuote(Quote quote) async {
    try {
      final quoteModel = QuoteModel(
        id: quote.id,
        requestId: quote.requestId,
        providerId: quote.providerId,
        serviceId: quote.serviceId,
        proposedPrice: quote.proposedPrice,
        breakdown: quote.breakdown,
        notes: quote.notes,
        validUntil: quote.validUntil,
        status: quote.status,
        createdAt: quote.createdAt,
      );
      final updatedQuote = await _remoteDataSource.updateQuote(quoteModel);
      return Right(updatedQuote);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}