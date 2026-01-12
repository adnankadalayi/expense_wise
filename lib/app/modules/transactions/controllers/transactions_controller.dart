import 'package:expense_wise/app/data/models/recurring_transaction.dart';
import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class TransactionsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  var amountText = '0.00'.obs;
  var descriptionText = ''.obs;
  var isExpense = true.obs;
  var selectedAccount = Rxn<Account>();
  var selectedCategory = Rxn<Category>();
  var selectedDate = DateTime.now().obs;

  // Recurring Options
  var isRecurring = false.obs;
  var selectedInterval = RecurringInterval.monthly.obs;

  var accounts = <Account>[].obs;
  var categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAccounts();
    loadCategories();
  }

  void loadAccounts() async {
    final allAccounts = await _storageService.db.accounts.where().findAll();
    accounts.assignAll(allAccounts);
    if (accounts.isNotEmpty) {
      selectedAccount.value = accounts.first;
    }
  }

  void loadCategories() async {
    final allCategories = await _storageService.db.categorys.where().findAll();
    categories.assignAll(allCategories);
  }

  void updateAmount(String value) {
    amountText.value = value;
  }

  void toggleType(bool expense) {
    isExpense.value = expense;
    selectedCategory.value = null; // Reset category when toggling type
  }

  void toggleRecurring(bool value) {
    isRecurring.value = value;
  }

  void updateInterval(RecurringInterval? interval) {
    if (interval != null) {
      selectedInterval.value = interval;
    }
  }

  void addTransaction() async {
    final amount = double.tryParse(amountText.value) ?? 0.0;
    if (amount <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedAccount.value == null) {
      Get.snackbar(
        'Error',
        'Please select an account',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedCategory.value == null) {
      Get.snackbar(
        'Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Save Recurring Transaction
    if (isRecurring.value) {
      final recurring = RecurringTransaction()
        ..amount = amount
        ..note = descriptionText.value
        ..type = isExpense.value
            ? TransactionType.expense
            : TransactionType.income
        ..interval = selectedInterval.value
        // If creating today, the first run depends on logic.
        // Usually immediate? Let's say it starts TODAY.
        // If the logic only checks nextRunDate < now, making it today means it runs immediately on next app start or refresh.
        // But user also wants the current transaction recorded NOW.
        // So we will do BOTH: Record the transaction NOW, and set next recurring date to [Interval] from now.
        ..nextRunDate = _getNextDate(selectedDate.value, selectedInterval.value)
        ..isActive = true;

      recurring.account.value = selectedAccount.value;
      recurring.category.value = selectedCategory.value;

      await _storageService.db.writeTxn(() async {
        await _storageService.db.recurringTransactions.put(recurring);
        await recurring.account.save();
        await recurring.category.save();
      });
    }

    // Save Immediate Transaction (Always save the one they just entered)
    final transaction = Transaction()
      ..amount = amount
      ..date = selectedDate.value
      ..note = descriptionText.value
      ..type = isExpense.value
          ? TransactionType.expense
          : TransactionType.income;

    transaction.category.value = selectedCategory.value;
    transaction.account.value = selectedAccount.value;

    await _storageService.db.writeTxn(() async {
      await _storageService.db.transactions.put(transaction);
      await transaction.category.save(); // Save link
      await transaction.account.save(); // Save link

      // Update Account Balance
      final account = selectedAccount.value!;
      if (isExpense.value) {
        account.balance -= amount;
      } else {
        account.balance += amount;
      }
      await _storageService.db.accounts.put(account);
    });

    Get.back();
    Get.snackbar(
      'Success',
      'Transaction added',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Trigger generic update if needed?
    // Usually controllers on other pages will reload via onReady or listening to DB,
    // but here we might need to manually trigger if they don't listen.
    // For now assuming pages reload on focus or init.
  }

  DateTime _getNextDate(DateTime current, RecurringInterval interval) {
    switch (interval) {
      case RecurringInterval.daily:
        return current.add(const Duration(days: 1));
      case RecurringInterval.weekly:
        return current.add(const Duration(days: 7));
      case RecurringInterval.monthly:
        return DateTime(current.year, current.month + 1, current.day);
      case RecurringInterval.yearly:
        return DateTime(current.year + 1, current.month, current.day);
    }
  }
}
