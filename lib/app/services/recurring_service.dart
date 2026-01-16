import 'package:expense_wise/app/data/models/recurring_transaction.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:isar_community/isar.dart';
import 'package:get/get.dart';

class RecurringService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();

  /// Process all due recurring transactions
  /// This should be called on app startup and periodically
  Future<void> processRecurringTransactions() async {
    final db = _storageService.db;

    // Get all active recurring transactions that are due
    final now = DateTime.now();
    final dueTransactions = await db.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .nextRunDateLessThan(now)
        .findAll();

    for (var recurring in dueTransactions) {
      await _generateTransaction(recurring);
      await _updateNextRunDate(recurring);
    }
  }

  /// Generate a transaction from a recurring template
  Future<void> _generateTransaction(RecurringTransaction recurring) async {
    final db = _storageService.db;

    // Load linked data
    await recurring.category.load();
    await recurring.account.load();

    await db.writeTxn(() async {
      final transaction = Transaction()
        ..amount = recurring.amount
        ..note = recurring.note
        ..type = recurring.type
        ..date = recurring.nextRunDate;

      await db.transactions.put(transaction);

      // Link category and account
      transaction.category.value = recurring.category.value;
      transaction.account.value = recurring.account.value;
      await transaction.category.save();
      await transaction.account.save();

      // Update account balance
      if (recurring.account.value != null) {
        final account = recurring.account.value!;
        if (recurring.type == TransactionType.expense) {
          account.balance -= recurring.amount;
        } else if (recurring.type == TransactionType.income) {
          account.balance += recurring.amount;
        }
        await db.accounts.put(account);
      }
    });
  }

  /// Update the next run date based on the interval
  Future<void> _updateNextRunDate(RecurringTransaction recurring) async {
    final db = _storageService.db;

    DateTime nextDate = recurring.nextRunDate;

    switch (recurring.interval) {
      case RecurringInterval.daily:
        nextDate = nextDate.add(const Duration(days: 1));
        break;
      case RecurringInterval.weekly:
        nextDate = nextDate.add(const Duration(days: 7));
        break;
      case RecurringInterval.monthly:
        nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
        break;
      case RecurringInterval.yearly:
        nextDate = DateTime(nextDate.year + 1, nextDate.month, nextDate.day);
        break;
    }

    await db.writeTxn(() async {
      recurring.nextRunDate = nextDate;
      await db.recurringTransactions.put(recurring);
    });
  }

  /// Get upcoming recurring transactions (next 7 days)
  Future<List<RecurringTransaction>> getUpcomingRecurring() async {
    final db = _storageService.db;
    final now = DateTime.now();
    final weekLater = now.add(const Duration(days: 7));

    final upcoming = await db.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .nextRunDateBetween(now, weekLater)
        .sortByNextRunDate()
        .findAll();

    // Load linked data
    for (var recurring in upcoming) {
      await recurring.category.load();
      await recurring.account.load();
    }

    return upcoming;
  }
}
