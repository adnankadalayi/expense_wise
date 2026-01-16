import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final focusedDay = DateTime.now().obs;
  final selectedDay = Rxn<DateTime>();
  final calendarFormat = CalendarFormat.month.obs;

  final monthTransactions = <Transaction>[].obs;
  final dayTransactions = <Transaction>[].obs;
  final dailySummaries = <DateTime, DayData>{}.obs;

  final monthIncome = 0.0.obs;
  final monthExpense = 0.0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedDay.value = focusedDay.value;
    loadMonthData(focusedDay.value);
  }

  Future<void> loadMonthData(DateTime month) async {
    isLoading.value = true;
    try {
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final db = _storageService.db;
      final transactions = await db.transactions
          .filter()
          .dateBetween(firstDay, lastDay)
          .findAll();

      // Load category links
      for (var tx in transactions) {
        await tx.category.load();
      }

      monthTransactions.value = transactions;
      _calculateDailySummaries();
      _calculateMonthTotals();

      if (selectedDay.value != null) {
        loadDayTransactions(selectedDay.value!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load calendar data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateDailySummaries() {
    final summaries = <DateTime, DayData>{};

    for (var tx in monthTransactions) {
      final dateKey = DateTime(tx.date.year, tx.date.month, tx.date.day);

      if (!summaries.containsKey(dateKey)) {
        summaries[dateKey] = DayData(
          date: dateKey,
          income: 0,
          expense: 0,
          transactionCount: 0,
        );
      }

      final current = summaries[dateKey]!;
      if (tx.type == TransactionType.income) {
        summaries[dateKey] = DayData(
          date: dateKey,
          income: current.income + tx.amount,
          expense: current.expense,
          transactionCount: current.transactionCount + 1,
        );
      } else if (tx.type == TransactionType.expense) {
        summaries[dateKey] = DayData(
          date: dateKey,
          income: current.income,
          expense: current.expense + tx.amount,
          transactionCount: current.transactionCount + 1,
        );
      }
    }

    dailySummaries.value = summaries;
  }

  void _calculateMonthTotals() {
    double income = 0;
    double expense = 0;

    for (var tx in monthTransactions) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        expense += tx.amount;
      }
    }

    monthIncome.value = income;
    monthExpense.value = expense;
  }

  void loadDayTransactions(DateTime day) {
    final dayKey = DateTime(day.year, day.month, day.day);
    dayTransactions.value = monthTransactions.where((tx) {
      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      return txDate == dayKey;
    }).toList();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
    loadDayTransactions(selectedDay);
  }

  void onPageChanged(DateTime focusedDay) {
    this.focusedDay.value = focusedDay;
    loadMonthData(focusedDay);
  }

  void goToToday() {
    final today = DateTime.now();
    focusedDay.value = today;
    selectedDay.value = today;
    loadMonthData(today);
    loadDayTransactions(today);
  }

  List<Transaction> getEventsForDay(DateTime day) {
    final dayKey = DateTime(day.year, day.month, day.day);
    return monthTransactions.where((tx) {
      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      return txDate == dayKey;
    }).toList();
  }

  DayData? getDayData(DateTime day) {
    final dayKey = DateTime(day.year, day.month, day.day);
    return dailySummaries[dayKey];
  }
}

class DayData {
  final DateTime date;
  final double income;
  final double expense;
  final int transactionCount;

  DayData({
    required this.date,
    required this.income,
    required this.expense,
    required this.transactionCount,
  });

  double get net => income - expense;
  bool get hasIncome => income > 0;
  bool get hasExpense => expense > 0;
  bool get hasTransactions => transactionCount > 0;
}
