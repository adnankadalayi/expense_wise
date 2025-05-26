import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController
    with SingleGetTickerProviderMixin {
  var dailyReminders = true.obs;
  var darkMode = false.obs;
  var cloudBackup = true.obs;

  late AnimationController animationController;
  late Animation<double> fadeInLeftAnimation;
  late Animation<Offset> slideUpAnimation;
  late Animation<double> fadeInRightAnimation;
  late Animation<double> fadeInAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Fixed intervals to avoid overlapping issues
    fadeInLeftAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );

    slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
      ),
    );

    fadeInRightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void toggleDailyReminders() => dailyReminders.toggle();
  void toggleDarkMode() => darkMode.toggle();
  void toggleCloudBackup() => cloudBackup.toggle();
}
