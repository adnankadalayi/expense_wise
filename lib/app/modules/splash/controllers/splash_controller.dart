import 'package:get/get.dart';
import 'dart:async';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Auto-redirect after 4 seconds
    Timer(const Duration(seconds: 4), () {
      Get.offNamed('/main');
    });
  }

  void navigateToHome() {
    Get.offNamed('/main');
  }
}
