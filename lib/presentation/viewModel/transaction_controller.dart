import 'package:fin_logs_app/domain/usecase/transaction_usecase.dart';
import 'package:get/get.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionController extends GetxController {
  final GetTransactionsUseCase useCase;

  TransactionController(this.useCase);

  final transactions = <TransactionEntity>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasError = false.obs;
  final hasMore = true.obs;

  int _page = 1;
  int _totalPages = 1;
  bool _isPaginating = false;

  String? selectedType;
  String? selectedStatus;

  @override
  void onInit() {
    fetchInitial();
    super.onInit();
  }

  void fetchInitial() {
    _page = 1;
    hasMore.value = true;
    _isPaginating = false; // 🔴 IMPORTANT
    transactions.clear();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    if (_isPaginating || !hasMore.value) return;

    _isPaginating = true;
    _page == 1 ? isLoading.value = true : isLoadingMore.value = true;
    hasError.value = false;

    try {
      final result = await useCase(
        page: _page,
        type: selectedType,
        status: selectedStatus,
      );

      // 🔒 SAFETY: prevent duplicate append
      if (result.page != _page) return;

      _totalPages = result.totalPages;
      transactions.addAll(result.data);

      _page++;

      if (_page > _totalPages) {
        hasMore.value = false;
      }
    } catch (_) {
      hasError.value = true;
    } finally {
      _isPaginating = false;
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void applyFilter({String? type, String? status}) {
    selectedType = type;
    selectedStatus = status;
    fetchInitial(); // reset page + reload
  }
}
