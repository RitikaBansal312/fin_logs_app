import '../repositories/transaction_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<TransactionResponse> call({
    required int page,
    String? type,
    String? status,
  }) {
    return repository.getTransactions(page: page, type: type, status: status);
  }
}
