import '../../domain/entities/transaction_entity.dart';

class TransactionModel {
  final String id;
  final double amount;
  final String type;
  final String status;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }

  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    amount: amount,
    type: type,
    status: status,
    date: date,
  );
}
