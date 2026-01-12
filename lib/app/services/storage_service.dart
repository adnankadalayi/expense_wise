import 'package:expense_wise/app/data/models/recurring_transaction.dart';
import 'package:expense_wise/app/data/models/settings.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/budget.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:flutter/material.dart';

class StorageService extends GetxService {
  late Isar db;
  late Settings settings;

  Future<StorageService> init() async {
    final dir = await getApplicationDocumentsDirectory();
    db = await Isar.open([
      AccountSchema,
      BudgetSchema,
      CategorySchema,
      TransactionSchema,
      RecurringTransactionSchema,
      SettingsSchema,
    ], directory: dir.path);
    await _seedDefaultCategories();
    await _ensureSettings();
    await _processRecurringTransactions();
    return this;
  }

  Future<void> _processRecurringTransactions() async {
    final now = DateTime.now();

    final dueTransactions = await db.recurringTransactions
        .filter()
        .isActiveEqualTo(true)
        .and()
        .nextRunDateLessThan(now)
        .findAll();

    if (dueTransactions.isEmpty) return;

    await db.writeTxn(() async {
      for (var recurring in dueTransactions) {
        // Create the real transaction
        final transaction = Transaction()
          ..amount = recurring.amount
          ..date = recurring.nextRunDate
          ..note = recurring.note ?? 'Recurring Transaction'
          ..type = recurring.type;

        // Inherit links
        transaction.category.value = recurring.category.value;
        transaction.account.value = recurring.account.value;

        await db.transactions.put(transaction);
        await transaction.category.save();
        await transaction.account.save();

        // Update Account Balance
        final account = recurring.account.value;
        if (account != null) {
          if (recurring.type == TransactionType.income) {
            account.balance += recurring.amount;
          } else {
            account.balance -= recurring.amount;
          }
          await db.accounts.put(account);
        }

        // Update Next Run Date
        DateTime nextDate = recurring.nextRunDate;
        switch (recurring.interval) {
          case RecurringInterval.daily:
            nextDate = nextDate.add(const Duration(days: 1));
            break;
          case RecurringInterval.weekly:
            nextDate = nextDate.add(const Duration(days: 7));
            break;
          case RecurringInterval.monthly:
            nextDate = DateTime(
              nextDate.year,
              nextDate.month + 1,
              nextDate.day,
            );
            break;
          case RecurringInterval.yearly:
            nextDate = DateTime(
              nextDate.year + 1,
              nextDate.month,
              nextDate.day,
            );
            break;
        }

        recurring.nextRunDate = nextDate;
        // Loop: if nextDate is STILL in the past (missed multiple cycles),
        // we might want to catch up or just process one.
        // For simplicity, we process one per app launch or standard loop separately.
        // But here, let's just save the new upcoming date.

        await db.recurringTransactions.put(recurring);
      }
    });
  }

  Future<void> _seedDefaultCategories() async {
    final count = await db.categorys.count();
    if (count == 0) {
      final defaultCategories = [
        Category()
          ..name = 'Food'
          ..iconCodePoint = Icons.fastfood.codePoint
          ..colorHex =
              '0xFFFF5722' // Deep Orange
          ..type = CategoryType.expense,
        Category()
          ..name = 'Transport'
          ..iconCodePoint = Icons.directions_bus.codePoint
          ..colorHex =
              '0xFF2196F3' // Blue
          ..type = CategoryType.expense,
        Category()
          ..name = 'Shopping'
          ..iconCodePoint = Icons.shopping_bag.codePoint
          ..colorHex =
              '0xFFE91E63' // Pink
          ..type = CategoryType.expense,
        Category()
          ..name = 'Entertainment'
          ..iconCodePoint = Icons.movie.codePoint
          ..colorHex =
              '0xFF9C27B0' // Purple
          ..type = CategoryType.expense,
        Category()
          ..name = 'Health'
          ..iconCodePoint = Icons.local_hospital.codePoint
          ..colorHex =
              '0xFFF44336' // Red
          ..type = CategoryType.expense,
        Category()
          ..name = 'Salary'
          ..iconCodePoint = Icons.attach_money.codePoint
          ..colorHex =
              '0xFF4CAF50' // Green
          ..type = CategoryType.income,
        Category()
          ..name = 'Gift'
          ..iconCodePoint = Icons.card_giftcard.codePoint
          ..colorHex =
              '0xFFFFC107' // Amber
          ..type = CategoryType.income,
      ];

      await db.writeTxn(() async {
        await db.categorys.putAll(defaultCategories);
      });
    }
  }

  Future<void> _ensureSettings() async {
    final count = await db.settings.count();
    if (count == 0) {
      final newSettings = Settings();
      await db.writeTxn(() async {
        await db.settings.put(newSettings);
      });
      settings = newSettings;
    } else {
      settings = (await db.settings.where().findFirst())!;
    }
  }
}
