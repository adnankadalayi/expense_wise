import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class StatisticsController extends GetxController
    with GetTickerProviderStateMixin {
  final StorageService _storageService = Get.find<StorageService>();

  // Date Navigation
  var selectedDate = DateTime.now().obs;

  // Real Data Observables
  var totalSpent = 0.0.obs;
  var totalIncome = 0.0.obs;
  var netSavings = 0.0.obs;

  // Chart Data
  var incomeSpots = <FlSpot>[].obs;
  var expenseSpots = <FlSpot>[].obs;
  var maxY = 100.0.obs; // To scale chart (default non-zero)

  // Averages
  var avgDay = 0.0.obs;
  var avgWeek = 0.0.obs;
  var avgMonth = 0.0.obs;

  // Averages for Income
  var avgDayIncome = 0.0.obs;
  var avgWeekIncome = 0.0.obs;
  var avgMonthIncome = 0.0.obs;

  late AnimationController headerAnimationController;
  late AnimationController contentAnimationController;

  late Animation<Offset> headerSlideAnimation;
  late Animation<double> headerFadeAnimation;
  late Animation<Offset> contentSlideAnimation;
  late Animation<double> contentFadeAnimation;

  @override
  void onInit() {
    super.onInit();
    setupAnimations();
    startAnimations();
    loadData();

    // Listen to changes in date
    ever(selectedDate, (_) => loadData());
  }

  void nextMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + 1,
    );
  }

  void previousMonth() {
    selectedDate.value = DateTime(
      selectedDate.value.year,
      selectedDate.value.month - 1,
    );
  }

  void loadData() async {
    final now = selectedDate.value;
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final transactions = await _storageService.db.transactions
        .filter()
        .dateBetween(start, end)
        .findAll();

    double expenseSum = 0;
    double incomeSum = 0;

    // Daily Aggregation
    final Map<int, double> dailyExpense = {};
    final Map<int, double> dailyIncome = {};

    int daysInMonth = end.day;
    for (int i = 1; i <= daysInMonth; i++) {
      dailyExpense[i] = 0.0;
      dailyIncome[i] = 0.0;
    }

    for (var tx in transactions) {
      if (tx.type == TransactionType.expense) {
        expenseSum += tx.amount;
        dailyExpense[tx.date.day] =
            (dailyExpense[tx.date.day] ?? 0) + tx.amount;
      } else if (tx.type == TransactionType.income) {
        incomeSum += tx.amount;
        dailyIncome[tx.date.day] = (dailyIncome[tx.date.day] ?? 0) + tx.amount;
      }
    }

    totalSpent.value = expenseSum;
    totalIncome.value = incomeSum;
    // netSavings.value = incomeSum - expenseSum; // Removed as per instruction

    // Prepare Chart Spots
    final List<FlSpot> eSpots = [];
    final List<FlSpot> iSpots = [];
    double currentMaxY = 0;

    dailyExpense.forEach((day, amount) {
      eSpots.add(FlSpot(day.toDouble(), amount));
      if (amount > currentMaxY) currentMaxY = amount;
    });
    dailyIncome.forEach((day, amount) {
      iSpots.add(FlSpot(day.toDouble(), amount));
      if (amount > currentMaxY) currentMaxY = amount;
    });

    // Sort sorted by key/day above, but good to be safe
    eSpots.sort((a, b) => a.x.compareTo(b.x));
    iSpots.sort((a, b) => a.x.compareTo(b.x));

    expenseSpots.assignAll(eSpots);
    incomeSpots.assignAll(iSpots);

    // Ensure maxY is at least somewhat reasonable to avoid flat line issues or 0 division
    if (currentMaxY == 0) currentMaxY = 100;
    maxY.value = currentMaxY * 1.2;

    // Calculate Averages
    int divisorDay = daysInMonth;
    // If viewing current month, use days passed so far
    if (now.year == DateTime.now().year && now.month == DateTime.now().month) {
      divisorDay = DateTime.now().day;
      if (divisorDay == 0) divisorDay = 1;
    }

    avgDay.value = expenseSum / divisorDay;
    avgWeek.value = avgDay.value * 7;
    avgMonth.value = expenseSum;

    avgDayIncome.value = incomeSum / divisorDay;
    avgWeekIncome.value = avgDayIncome.value * 7;
    avgMonthIncome.value = incomeSum;
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
  }

  void startAnimations() {
    headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      contentAnimationController.forward();
    });
  }

  @override
  void onClose() {
    headerAnimationController.dispose();
    contentAnimationController.dispose();
    super.onClose();
  }
}
