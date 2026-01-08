import 'package:fin_logs_app/data/repositories/transaction_repository_impl.dart';
import 'package:fin_logs_app/domain/usecase/transaction_usecase.dart';
import 'package:fin_logs_app/presentation/viewModel/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/sources/transaction_api.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late final TransactionController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller = Get.put(
      TransactionController(
        GetTransactionsUseCase(TransactionRepositoryImpl(TransactionApi())),
      ),
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      controller.fetchTransactions();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: ElevatedButton(
              onPressed: controller.fetchInitial,
              child: const Text('Retry'),
            ),
          );
        }

        if (controller.transactions.isEmpty) {
          return const Center(child: Text('No Transactions Found'));
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount:
              controller.transactions.length +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.transactions.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final txn = controller.transactions[index];
            return TransactionCard(txn: txn);
          },
        );
      }),
    );
  }

  /// ================= Filter UI =================
  void _showFilterSheet() {
    String? tempType = controller.selectedType;
    String? tempStatus = controller.selectedStatus;

    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== Header =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Transactions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: Get.back,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ===== Transaction Type =====
              const Text(
                'Transaction Type',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: tempType,
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: 'All',
                  prefixIcon: const Icon(Icons.swap_vert),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: 'credit', child: Text('Credit')),
                  DropdownMenuItem(value: 'debit', child: Text('Debit')),
                ],
                onChanged: (v) => tempType = v,
              ),

              const SizedBox(height: 16),

              /// ===== Status =====
              const Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: tempStatus,
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: 'All',
                  prefixIcon: const Icon(Icons.info_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: 'success', child: Text('Success')),
                  DropdownMenuItem(value: 'failed', child: Text('Failed')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                ],
                onChanged: (v) => tempStatus = v,
              ),

              const SizedBox(height: 24),

              /// ===== Actions =====
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        tempType = null;
                        tempStatus = null;
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Get.back();
                        controller.applyFilter(
                          type: tempType,
                          status: tempStatus,
                        );
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

/// ================= TRANSACTION CARD =================

class TransactionCard extends StatelessWidget {
  final TransactionEntity txn;

  const TransactionCard({super.key, required this.txn});

  Color get statusColor {
    switch (txn.status) {
      case 'success':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              txn.type == 'credit' ? Icons.arrow_downward : Icons.arrow_upward,
              color: txn.type == 'credit' ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.id,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    txn.date.toLocal().toString().split('.')[0],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${txn.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  txn.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
