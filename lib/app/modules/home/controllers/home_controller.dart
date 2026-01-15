import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  final StorageService _storageService = Get.find<StorageService>();

  var balance = 0.0.obs;
  var weeklyChange = 0.0.obs;
  final transactions = <Transaction>[].obs;
  final homeAccounts = <Account>[].obs;

  var selectedNavIndex = 0.obs;

  // Top offsets for the white card based on tab index
  final Map<int, double> cardTopOffsets = {
    0: 240.0, // Home: Below Balance Card
    1: 100.0, // Stats: Below Title/Dropdown
    2: 100.0, // Budgets: Below Title
    3: 220.0, // Settings: Below Profile
  };

  double get currentCardTop => cardTopOffsets[selectedNavIndex.value] ?? 280.0;

  late AnimationController animationController;
  late Animation<double> fadeInLeftAnimation;
  late Animation<Offset> slideUpAnimation;
  late Animation<double> fadeInRightAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    fadeInLeftAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    slideUpAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
          ),
        );

    fadeInRightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    animationController.forward();
    loadData();

    // Listen to changes in DB? Or just reload on events?
    // For now, reload when revisiting or triggered
  }

  Future<void> loadData() async {
    // Load Accounts
    final accounts = await _storageService.db.accounts.where().findAll();

    // Calculate Total Balance (filter excludeFromTotal)
    double total = 0;
    for (var acc in accounts) {
      if (!acc.excludeFromTotal) {
        total += acc.balance;
      }
    }
    balance.value = total;

    // Filter Accounts for Home Screen
    final homeList = accounts.where((a) => a.showOnHome).take(4).toList();
    homeAccounts.assignAll(homeList);

    // Load Transactions
    final txs = await _storageService.db.transactions
        .where()
        .sortByDateDesc()
        .limit(10)
        .findAll();

    // Ensure links are loaded
    for (var tx in txs) {
      await tx.category.load();
    }
    transactions.assignAll(txs);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void updateNavIndex(int index) {
    selectedNavIndex.value = index;
    if (index == 0) loadData(); // Reload home data
    update();
  }

  void addExpense() {
    Get.toNamed('/add-transaction'); // Use named route
  }

  void addIncome() {
    Get.toNamed('/add-transaction');
  }
}
