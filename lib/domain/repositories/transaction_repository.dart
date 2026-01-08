import '../entities/transaction_entity.dart';

class TransactionResponse {
  final int page;
  final int totalPages;
  final List<TransactionEntity> data;

  TransactionResponse({
    required this.page,
    required this.totalPages,
    required this.data,
  });
}

abstract class TransactionRepository {
  Future<TransactionResponse> getTransactions({
    required int page,
    String? type,
    String? status,
  });
}
