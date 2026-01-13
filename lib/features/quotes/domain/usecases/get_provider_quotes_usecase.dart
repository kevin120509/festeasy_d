import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/core/usecases/usecase.dart';
import 'package:festeasy/features/quotes/domain/entities/quote.dart';
import 'package:festeasy/features/quotes/domain/repositories/quote_repository.dart';

class GetProviderQuotesUseCase implements UseCase<List<Quote>, String> {
  final QuoteRepository repository;

  GetProviderQuotesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Quote>>> call(String providerId) async {
    return await repository.getQuotesByProvider(providerId);
  }
}
