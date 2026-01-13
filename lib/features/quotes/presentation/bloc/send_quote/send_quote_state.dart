import 'package:equatable/equatable.dart';

enum SendQuoteStatus { initial, loading, success, failure }

class SendQuoteState extends Equatable {
  const SendQuoteState({
    this.status = SendQuoteStatus.initial,
    this.errorMessage,
  });

  final SendQuoteStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];
}
