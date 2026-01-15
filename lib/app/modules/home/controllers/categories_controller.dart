import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class CategoriesController extends GetxController
    with GetTickerProviderStateMixin {
  final StorageService _storageService = Get.find<StorageService>();

  // Date Navigation
  var currentDate = DateTime.now().obs;

  // Data Observables
  var totalSpent = 0.0.obs;
  var totalIncome = 0.0.obs;
  var categoryData = <Map<String, dynamic>>[].obs;
  var isExpense = true.obs;

  late AnimationController headerAnimationController;
  late AnimationController chartAnimationController;
  late AnimationController listAnimationController;

  late Animation<Offset> headerSlideAnimation;
  late Animation<double> headerFadeAnimation;
  late Animation<Offset> chartSlideAnimation;
  late Animation<double> chartFadeAnimation;
  late Animation<Offset> listSlideAnimation;
  late Animation<double> listFadeAnimation;

  @override
  void onInit() {
    super.onInit();
    setupAnimations();
    startAnimations();
    loadData();

    // Listen to changes in date or type
    ever(currentDate, (_) => loadData());
    ever(isExpense, (_) => loadData());
  }

  void toggleType() {
    isExpense.value = !isExpense.value;
  }

  void loadData() async {
    final now = currentDate.value;
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final transactions = await _storageService.db.transactions
        .filter()
        .dateBetween(start, end)
        .findAll();

    double expense = 0;
    double income = 0;

    final catMap = <String, double>{};
    final catColorMap = <String, Color>{};

    for (var tx in transactions) {
      if (tx.type == TransactionType.expense) {
        expense += tx.amount;
        if (isExpense.value) {
          await tx.category.load();
          final catName = tx.category.value?.name ?? 'Other';
          catMap[catName] = (catMap[catName] ?? 0) + tx.amount;

          if (!catColorMap.containsKey(catName)) {
            final hex = tx.category.value?.colorHex;
            catColorMap[catName] = hex != null
                ? Color(int.parse(hex))
                : Colors.grey;
          }
        }
      } else if (tx.type == TransactionType.income) {
        income += tx.amount;
        if (!isExpense.value) {
          await tx.category.load();
          final catName = tx.category.value?.name ?? 'Other';
          catMap[catName] = (catMap[catName] ?? 0) + tx.amount;

          if (!catColorMap.containsKey(catName)) {
            final hex = tx.category.value?.colorHex;
            catColorMap[catName] = hex != null
                ? Color(int.parse(hex))
                : Colors.grey;
          }
        }
      }
    }

    totalSpent.value = expense;
    totalIncome.value = income;

    // Prepare Category Data List
    final total = isExpense.value
        ? (expense > 0 ? expense : 1.0)
        : (income > 0 ? income : 1.0);
    final List<Map<String, dynamic>> newData = [];

    catMap.forEach((name, amount) {
      final percentageVal = (amount / total);
      newData.add({
        'name': name,
        'percentageDouble': percentageVal,
        'percentageText': '${(percentageVal * 100).toStringAsFixed(0)}%',
        'amount': '₹${amount.toStringAsFixed(0)}',
        'color': catColorMap[name] ?? Colors.grey,
        'rawPercentage': percentageVal * 100,
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

  void changeMonth(int offset) {
    final current = currentDate.value;
    currentDate.value = DateTime(current.year, current.month + offset, 1);
  }

  void setupAnimations() {
    headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: headerAnimationController,
            curve: Curves.easeOut,
          ),
        );

    headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(headerAnimationController);

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

    listSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: listAnimationController,
            curve: Curves.easeOut,
          ),
        );

    listFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(listAnimationController);
  }

  void startAnimations() {
    headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      chartAnimationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      listAnimationController.forward();
    });
  }

  @override
  void onClose() {
    headerAnimationController.dispose();
    chartAnimationController.dispose();
    listAnimationController.dispose();
    super.onClose();
  }
}
