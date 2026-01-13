import 'package:dartz/dartz.dart';
import 'package:festeasy/core/errors/failures.dart';
import 'package:festeasy/core/usecases/usecase.dart';
import 'package:festeasy/features/quotes/domain/repositories/quote_repository.dart';

class DeleteQuoteUseCase implements UseCase<void, String> {
  final QuoteRepository repository;

  DeleteQuoteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String quoteId) async {
    return await repository.deleteQuote(quoteId);
  }
}
