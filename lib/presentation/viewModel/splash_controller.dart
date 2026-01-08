import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    // Simulate app startup tasks
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to Transactions screen
    Get.offAllNamed('/transactions');
  }
}
