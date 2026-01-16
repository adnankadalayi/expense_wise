import 'package:expense_wise/app/data/models/recurring_transaction.dart';
import 'package:expense_wise/app/data/models/settings.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/budget.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:flutter/cupertino.dart';

class StorageService extends GetxService {
  late Isar db;
  late Settings settings;
  final currencyCode = 'USD'.obs;
  final currencySymbol = '\$'.obs;

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
    await _fixExistingCategoryIcons();
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
          ..iconCodePoint = CupertinoIcons.cart_fill.codePoint
          ..colorHex =
              '0xFFFF5722' // Deep Orange
          ..type = CategoryType.expense,
        Category()
          ..name = 'Transport'
          ..iconCodePoint = CupertinoIcons.car_detailed.codePoint
          ..colorHex =
              '0xFF2196F3' // Blue
          ..type = CategoryType.expense,
        Category()
          ..name = 'Shopping'
          ..iconCodePoint = CupertinoIcons.bag_fill.codePoint
          ..colorHex =
              '0xFFE91E63' // Pink
          ..type = CategoryType.expense,
        Category()
          ..name = 'Entertainment'
          ..iconCodePoint = CupertinoIcons.film.codePoint
          ..colorHex =
              '0xFF9C27B0' // Purple
          ..type = CategoryType.expense,
        Category()
          ..name = 'Health'
          ..iconCodePoint = CupertinoIcons.heart_fill.codePoint
          ..colorHex =
              '0xFFF44336' // Red
          ..type = CategoryType.expense,
        Category()
          ..name = 'Salary'
          ..iconCodePoint = CupertinoIcons.money_dollar.codePoint
          ..colorHex =
              '0xFF4CAF50' // Green
          ..type = CategoryType.income,
        Category()
          ..name = 'Gift'
          ..iconCodePoint = CupertinoIcons.gift_fill.codePoint
          ..colorHex =
              '0xFFFFC107' // Amber
          ..type = CategoryType.income,
      ];

      await db.writeTxn(() async {
        await db.categorys.putAll(defaultCategories);
      });
    }
  }

  Future<void> _fixExistingCategoryIcons() async {
    // defaults map: Name -> desired Cupertino Icon CodePoint
    final updates = {
      'Food': CupertinoIcons.cart_fill.codePoint,
      'Transport': CupertinoIcons.car_detailed.codePoint,
      'Shopping': CupertinoIcons.bag_fill.codePoint,
      'Entertainment': CupertinoIcons.film.codePoint,
      'Health': CupertinoIcons.heart_fill.codePoint,
      'Salary': CupertinoIcons.money_dollar.codePoint,
      'Gift': CupertinoIcons.gift_fill.codePoint,
    };

    final categoriesToUpdate = await db.categorys
        .filter()
        .anyOf(updates.keys, (q, name) => q.nameEqualTo(name))
        .findAll();

    if (categoriesToUpdate.isEmpty) return;

    await db.writeTxn(() async {
      for (var cat in categoriesToUpdate) {
        if (updates.containsKey(cat.name)) {
          // Only update if it's different to avoid unnecessary writes
          // (though writeTxn is already open)
          final newCodePoint = updates[cat.name]!;
          if (cat.iconCodePoint != newCodePoint) {
            cat.iconCodePoint = newCodePoint;
            await db.categorys.put(cat);
          }
        }
      }
    });
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
    currencyCode.value = settings.currencyCode;
    currencySymbol.value = settings.currencySymbol;
  }

  Future<void> saveSetting(String key, String value) async {
    await db.writeTxn(() async {
      switch (key) {
        case 'fire_current_age':
          settings.fireCurrentAge = int.tryParse(value);
          break;
        case 'fire_target_age':
          settings.fireTargetAge = int.tryParse(value);
          break;
        case 'fire_return_rate':
          settings.fireReturnRate = double.tryParse(value);
          break;
        case 'fire_withdrawal_rate':
          settings.fireWithdrawalRate = double.tryParse(value);
          break;
      }
      await db.settings.put(settings);
    });
  }

  Future<String?> getSetting(String key) async {
    switch (key) {
      case 'fire_current_age':
        return settings.fireCurrentAge?.toString();
      case 'fire_target_age':
        return settings.fireTargetAge?.toString();
      case 'fire_return_rate':
        return settings.fireReturnRate?.toString();
      case 'fire_withdrawal_rate':
        return settings.fireWithdrawalRate?.toString();
      default:
        return null;
    }
  }
}
