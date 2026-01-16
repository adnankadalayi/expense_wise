import 'package:expense_wise/app/data/models/budget.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/notification_service.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:isar_community/isar.dart';
import 'package:get/get.dart';

class BudgetTrackingService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  // Track which budgets have already been notified to avoid spam
  final Set<int> _notifiedBudgets = {};

  /// Check all budgets and trigger notifications if thresholds are reached
  Future<void> checkBudgets() async {
    final db = _storageService.db;

    // Get all active budgets
    final budgets = await db.budgets.filter().isActiveEqualTo(true).findAll();

    for (var budget in budgets) {
      await budget.category.load();
      if (budget.category.value == null) continue;

      // Calculate current spending for this budget
      final spending = await _calculateCurrentSpending(budget);

      // Check if notification should be triggered
      if (budget.shouldNotify(spending) &&
          !_notifiedBudgets.contains(budget.id)) {
        // Send notification
        await _notificationService.showBudgetNotification(
          budgetId: budget.id,
          categoryName: budget.category.value!.name,
          spentAmount: spending,
          budgetLimit: budget.amount,
          percentage: budget.getProgressPercentage(spending),
        );

        // Mark as notified
        _notifiedBudgets.add(budget.id);
      } else if (budget.isExceeded(spending) &&
          !_notifiedBudgets.contains(budget.id + 100000)) {
        // Send exceeded notification (different ID to allow both notifications)
        await _notificationService.showBudgetNotification(
          budgetId: budget.id + 100000,
          categoryName: budget.category.value!.name,
          spentAmount: spending,
          budgetLimit: budget.amount,
          percentage: budget.getProgressPercentage(spending),
        );

        // Mark as notified
        _notifiedBudgets.add(budget.id + 100000);
      }

      // Reset notification flag if spending drops below threshold
      if (!budget.isInWarning(spending)) {
        _notifiedBudgets.remove(budget.id);
        _notifiedBudgets.remove(budget.id + 100000);
      }
    }
  }

  /// Calculate current spending for a budget based on its period
  Future<double> _calculateCurrentSpending(Budget budget) async {
    final db = _storageService.db;
    final now = DateTime.now();

    // Determine date range based on budget period
    DateTime startDate;
    DateTime endDate = now;

    switch (budget.period) {
      case BudgetPeriod.weekly:
        // Start of current week (Monday)
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case BudgetPeriod.monthly:
        // Start of current month
        startDate = DateTime(now.year, now.month, 1);
        break;
      case BudgetPeriod.yearly:
        // Start of current year
        startDate = DateTime(now.year, 1, 1);
        break;
    }

    // Get all expense transactions for this category in the period
    final transactions = await db.transactions
        .filter()
        .category((q) => q.idEqualTo(budget.category.value!.id))
        .typeEqualTo(TransactionType.expense)
        .dateBetween(startDate, endDate)
        .findAll();

    // Sum up the spending
    double total = 0;
    for (var tx in transactions) {
      total += tx.amount;
    }

    return total;
  }

  /// Get spending data for a specific budget
  Future<Map<String, dynamic>> getBudgetSpending(Budget budget) async {
    final spending = await _calculateCurrentSpending(budget);
    final percentage = budget.getProgressPercentage(spending);
    final remaining = budget.amount - spending;

    return {
      'spending': spending,
      'percentage': percentage,
      'remaining': remaining,
      'isExceeded': budget.isExceeded(spending),
      'isInWarning': budget.isInWarning(spending),
    };
  }

  /// Reset notification flags (call this at the start of a new period)
  void resetNotifications() {
    _notifiedBudgets.clear();
  }
}
