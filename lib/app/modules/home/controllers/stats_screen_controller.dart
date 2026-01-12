import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class StatisticsController extends GetxController
    with GetTickerProviderStateMixin {
  final StorageService _storageService = Get.find<StorageService>();

  var selectedPeriod = 'This Month'.obs;

  // Real Data Observables
  var totalSpent = 0.0.obs;
  var totalIncome = 0.0.obs;
  var netSavings = 0.0.obs;
  var categoryData = <Map<String, dynamic>>[].obs;

  late AnimationController headerAnimationController;
  late AnimationController contentAnimationController;
  late AnimationController overviewAnimationController;
  late AnimationController chartAnimationController;
  late AnimationController categoriesAnimationController;

  late Animation<Offset> headerSlideAnimation;
  late Animation<double> headerFadeAnimation;
  late Animation<Offset> contentSlideAnimation;
  late Animation<double> contentFadeAnimation;
  late Animation<Offset> overviewSlideAnimation;
  late Animation<double> overviewFadeAnimation;
  late Animation<Offset> chartSlideAnimation;
  late Animation<double> chartFadeAnimation;
  late Animation<Offset> categoriesSlideAnimation;
  late Animation<double> categoriesFadeAnimation;

  final List<String> periods = ['This Month', 'Last Month', 'This Year'];

  @override
  void onInit() {
    super.onInit();
    setupAnimations();
    startAnimations();
    loadData();

    // Listen to changes in period
    ever(selectedPeriod, (_) => loadData());
  }

  void loadData() async {
    final now = DateTime.now();
    DateTime start;
    DateTime end;

    if (selectedPeriod.value == 'This Month') {
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    } else if (selectedPeriod.value == 'Last Month') {
      start = DateTime(now.year, now.month - 1, 1);
      end = DateTime(now.year, now.month, 0, 23, 59, 59);
    } else {
      // This Year
      start = DateTime(now.year, 1, 1);
      end = DateTime(now.year, 12, 31, 23, 59, 59);
    }

    final transactions = await _storageService.db.transactions
        .filter()
        .dateBetween(start, end)
        .findAll();

    // Calculate Overview
    double expense = 0;
    double income = 0;

    // Calculate Category Breakdown
    final catMap = <String, double>{};
    final catColorMap = <String, Color>{};

    for (var tx in transactions) {
      if (tx.type == TransactionType.expense) {
        expense += tx.amount;

        await tx.category.load();
        final catName = tx.category.value?.name ?? 'Other';
        catMap[catName] = (catMap[catName] ?? 0) + tx.amount;

        if (!catColorMap.containsKey(catName)) {
          final hex = tx.category.value?.colorHex;
          catColorMap[catName] = hex != null
              ? Color(int.parse(hex))
              : Colors.grey;
        }
      } else if (tx.type == TransactionType.income) {
        income += tx.amount;
      }
    }

    totalSpent.value = expense;
    totalIncome.value = income;
    netSavings.value = income - expense;

    // Prepare Category Data List
    final totalExp = expense > 0 ? expense : 1.0; // avoid div by zero
    final List<Map<String, dynamic>> newData = [];

    catMap.forEach((name, amount) {
      final percentage = (amount / totalExp * 100);
      newData.add({
        'name': name,
        'percentage': '${percentage.toStringAsFixed(0)}% of spending',
        'amount': '\$${amount.toStringAsFixed(0)}',
        'color': catColorMap[name] ?? Colors.grey,
        'rawPercentage': percentage, // for sorting or chart angles
      });
    });

    // Sort by amount descending
    newData.sort(
      (a, b) => (b['rawPercentage'] as double).compareTo(
        a['rawPercentage'] as double,
      ),
    );

    categoryData.assignAll(newData);
  }

  void setupAnimations() {
    headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    overviewAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    categoriesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    headerSlideAnimation =
        Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: headerAnimationController,
            curve: Curves.easeOut,
          ),
        );

    headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(headerAnimationController);

    contentSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: contentAnimationController,
            curve: Curves.easeOut,
          ),
        );

    contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(contentAnimationController);

    overviewSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: overviewAnimationController,
            curve: Curves.easeOut,
          ),
        );

    overviewFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(overviewAnimationController);

    chartSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: chartAnimationController,
            curve: Curves.easeOut,
          ),
        );

    chartFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(chartAnimationController);

    categoriesSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: categoriesAnimationController,
            curve: Curves.easeOut,
          ),
        );

    categoriesFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(categoriesAnimationController);
  }

  void startAnimations() {
    headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      contentAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      overviewAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      chartAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      categoriesAnimationController.forward();
    });
  }

  void selectPeriod(String period) {
    selectedPeriod.value = period;
  }

  @override
  void onClose() {
    headerAnimationController.dispose();
    contentAnimationController.dispose();
    overviewAnimationController.dispose();
    chartAnimationController.dispose();
    categoriesAnimationController.dispose();
    super.onClose();
  }
}
