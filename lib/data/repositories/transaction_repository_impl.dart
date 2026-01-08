import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';
import '../sources/transaction_api.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionApi api;

  TransactionRepositoryImpl(this.api);

  @override
  Future<TransactionResponse> getTransactions({
    required int page,
    String? type,
    String? status,
  }) async {
    final response = await api.fetchTransactions(
      page: page,
      type: type,
      status: status,
    );

    final data = (response['data'] as List)
        .map((e) => TransactionModel.fromJson(e).toEntity())
        .toList();

    return TransactionResponse(
      page: response['page'],
      totalPages: response['totalPages'],
      data: data,
    );
  }
}
