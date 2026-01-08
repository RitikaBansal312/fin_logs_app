class TransactionApi {
  final List<Map<String, dynamic>> _allTransactions = List.generate(200, (
    index,
  ) {
    return {
      "id": "txn_${index + 1}",
      "amount": 500 + index * 15,
      "type": index % 2 == 0 ? "credit" : "debit",
      "status": ["success", "failed", "pending"][index % 3],
      "date": DateTime.now()
          .subtract(Duration(minutes: index * 10))
          .toIso8601String(),
    };
  });

  Future<Map<String, dynamic>> fetchTransactions({
    required int page,
    String? type,
    String? status,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    List<Map<String, dynamic>> filtered = _allTransactions;

    if (type != null) {
      filtered = filtered.where((e) => e['type'] == type).toList();
    }

    if (status != null) {
      filtered = filtered.where((e) => e['status'] == status).toList();
    }

    const int pageSize = 10;
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    final paginated = start < filtered.length
        ? filtered.sublist(start, end.clamp(0, filtered.length))
        : [];

    return {
      "page": page,
      "totalPages": (filtered.length / pageSize).ceil(),
      "data": paginated,
    };
  }
}
