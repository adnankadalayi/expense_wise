import 'package:get/get.dart';
import 'dart:async';
import 'package:expense_wise/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Auto-redirect after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Get.offNamed(Routes.HOME);
    });
  }

  void navigateToHome() {
    Get.offNamed(Routes.HOME);
  }
}
