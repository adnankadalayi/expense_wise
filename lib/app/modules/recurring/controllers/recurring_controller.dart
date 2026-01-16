import 'package:expense_wise/app/data/models/recurring_transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class RecurringController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final recurringTransactions = <RecurringTransaction>[].obs;
  final activeOnly = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecurringTransactions();
  }

  Future<void> loadRecurringTransactions() async {
    final db = _storageService.db;
    final baseQuery = db.recurringTransactions.where();

    final transactions = activeOnly.value
        ? await baseQuery
              .filter()
              .isActiveEqualTo(true)
              .sortByNextRunDate()
              .findAll()
        : await baseQuery.sortByNextRunDate().findAll();

    // Load category and account links
    for (var transaction in transactions) {
      await transaction.category.load();
      await transaction.account.load();
    }

    recurringTransactions.value = transactions;
  }

  Future<void> toggleFilter() async {
    activeOnly.value = !activeOnly.value;
    await loadRecurringTransactions();
  }

  Future<void> toggleActive(RecurringTransaction transaction) async {
    final db = _storageService.db;

    await db.writeTxn(() async {
      transaction.isActive = !transaction.isActive;
      await db.recurringTransactions.put(transaction);
    });

    await loadRecurringTransactions();
  }

  Future<void> deleteRecurring(int id) async {
    final db = _storageService.db;

    await db.writeTxn(() async {
      await db.recurringTransactions.delete(id);
    });

    await loadRecurringTransactions();
    Get.back();
  }

  String getFrequencyText(RecurringInterval interval) {
    switch (interval) {
      case RecurringInterval.daily:
        return 'Daily';
      case RecurringInterval.weekly:
        return 'Weekly';
      case RecurringInterval.monthly:
        return 'Monthly';
      case RecurringInterval.yearly:
        return 'Yearly';
    }
  }

  String getNextRunText(DateTime nextRun) {
    final now = DateTime.now();
    final difference = nextRun.difference(now);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return 'In ${difference.inDays} days';
    } else {
      return 'On ${nextRun.day}/${nextRun.month}/${nextRun.year}';
    }
  }
}
