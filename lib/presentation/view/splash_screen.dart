import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewModel/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// App Icon / Logo
            Icon(Icons.account_balance_wallet, size: 72, color: Colors.green),

            const SizedBox(height: 16),

            /// App Name
            const Text(
              'Fin Logs',
              style: TextStyle(
                color: Colors.green,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 32),

            /// Loading Effect
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              strokeWidth: 3,
            ),

            const SizedBox(height: 12),

            const Text(
              'Loading transactions...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
