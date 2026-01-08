import 'package:fin_logs_app/presentation/view/splash_screen.dart';
import 'package:fin_logs_app/presentation/view/transaction_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const splash = '/';
  static const transactions = '/transactions';

  static final routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: transactions, page: () => const TransactionPage()),
  ];
}
