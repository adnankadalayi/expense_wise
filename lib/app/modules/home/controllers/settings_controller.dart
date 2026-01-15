import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:expense_wise/app/services/pdf_service.dart';
import 'package:isar_community/isar.dart';
import 'package:expense_wise/app/data/models/settings.dart';
import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/transaction.dart';

class SettingsController extends GetxController
    with SingleGetTickerProviderMixin {
  var dailyReminders = true.obs;
  var darkMode = false.obs;
  var cloudBackup = true.obs;
  var currencyCode = 'USD'.obs;
  var currencySymbol = '\$'.obs;

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

    slideUpAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
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
    _loadSettings();
  }

  final _storage = Get.find<StorageService>();

  Future<void> _loadSettings() async {
    final settings = await _storage.db.settings.where().findFirst();
    if (settings != null) {
      dailyReminders.value = settings.dailyReminders;
      darkMode.value = settings.darkMode;
      cloudBackup.value = settings.cloudBackup;
      currencyCode.value = settings.currencyCode;
      currencySymbol.value = settings.currencySymbol;

      Get.changeThemeMode(settings.darkMode ? ThemeMode.dark : ThemeMode.light);
    }
  }

  Future<void> _updateSettings() async {
    final settings = await _storage.db.settings.where().findFirst();
    if (settings != null) {
      settings.dailyReminders = dailyReminders.value;
      settings.darkMode = darkMode.value;
      settings.cloudBackup = cloudBackup.value;
      settings.currencyCode = currencyCode.value;
      settings.currencySymbol = currencySymbol.value;

      // Update global state
      _storage.currencyCode.value = currencyCode.value;
      _storage.currencySymbol.value = currencySymbol.value;

      await _storage.db.writeTxn(() async {
        await _storage.db.settings.put(settings);
      });
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void toggleDailyReminders() {
    dailyReminders.toggle();
    _updateSettings();
  }

  void toggleDarkMode() {
    darkMode.toggle();
    Get.changeThemeMode(darkMode.value ? ThemeMode.dark : ThemeMode.light);
    _updateSettings();
  }

  void toggleCloudBackup() {
    cloudBackup.toggle();
    _updateSettings();
  }

  void changeCurrency(String code, String symbol) {
    currencyCode.value = code;
    currencySymbol.value = symbol;
    _updateSettings();
  }

  void exportPdf() async {
    try {
      final storage = Get.find<StorageService>();
      final pdfService = PdfService();

      final accounts = await storage.db.accounts.where().findAll();
      final transactions = await storage.db.transactions
          .where()
          .sortByDateDesc()
          .findAll();

      await pdfService.generateAndShareReport(accounts, transactions);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
