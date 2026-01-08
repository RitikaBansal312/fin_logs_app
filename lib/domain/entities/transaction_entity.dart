class TransactionEntity {
  final String id;
  final double amount;
  final String type;
  final String status;
  final DateTime date;

  TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.date,
  });
}
