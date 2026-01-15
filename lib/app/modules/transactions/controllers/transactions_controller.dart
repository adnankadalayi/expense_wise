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

  var amountText = '0'.obs;
  var descriptionText = ''.obs;
  var isExpense = true.obs;
  var isTransfer = false.obs;
  var selectedAccount = Rxn<Account>();
  var selectedTransferAccount = Rxn<Account>();
  var selectedCategory = Rxn<Category>();
  var selectedSubCategory = Rxn<String>();
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

  void onKeypadTap(String value) {
    if (value == '.') {
      if (amountText.value.contains('.')) return;
      amountText.value += value;
    } else {
      if (amountText.value == '0') {
        amountText.value = value;
      } else {
        amountText.value += value;
      }
    }
  }

  void onBackspace() {
    if (amountText.value.length > 1) {
      amountText.value = amountText.value.substring(
        0,
        amountText.value.length - 1,
      );
    } else {
      amountText.value = '0';
    }
  }

  void toggleType(TransactionType type) {
    if (type == TransactionType.expense) {
      isExpense.value = true;
      isTransfer.value = false;
    } else if (type == TransactionType.income) {
      isExpense.value = false;
      isTransfer.value = false;
    } else {
      isExpense.value = false; // Doesn't matter for transfer, but set to false
      isTransfer.value = true;
    }

    // Reset selection
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    // selectedTransferAccount.value = null; // Keep if user selected one previously? Maybe reset.
    if (!isTransfer.value) {
      selectedTransferAccount.value = null;
    }
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

    if (isTransfer.value) {
      if (selectedTransferAccount.value == null) {
        Get.snackbar(
          'Error',
          'Please select a destination account',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }
      if (selectedAccount.value!.id == selectedTransferAccount.value!.id) {
        Get.snackbar(
          'Error',
          'Source and destination accounts cannot be the same',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }
    } else {
      // For Expense/Income, require category
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
    // Save Logic
    final transaction = Transaction()
      ..amount = amount
      ..date = selectedDate.value
      ..note = descriptionText.value
      ..type = isTransfer.value
          ? TransactionType.transfer
          : (isExpense.value
                ? TransactionType.expense
                : TransactionType.income);

    transaction.account.value = selectedAccount.value;

    if (isTransfer.value) {
      transaction.transferAccount.value = selectedTransferAccount.value;
    } else {
      transaction.category.value = selectedCategory.value;
      transaction.subCategory = selectedSubCategory.value;
    }

    await _storageService.db.writeTxn(() async {
      await _storageService.db.transactions.put(transaction);
      await transaction.account.save();
      if (isTransfer.value) {
        await transaction.transferAccount.save();
      } else {
        await transaction.category.save();
      }

      // Update Balances
      final account = selectedAccount.value!;

      if (isTransfer.value) {
        // Deduct from source
        account.balance -= amount;
        await _storageService.db.accounts.put(account);

        // Add to destination
        final destAccount = selectedTransferAccount.value!;
        destAccount.balance += amount;
        await _storageService.db.accounts.put(destAccount);
      } else {
        // Normal Expense/Income
        if (isExpense.value) {
          account.balance -= amount;
        } else {
          account.balance += amount;
        }
        await _storageService.db.accounts.put(account);
      }
    });

    Get.back();
    // Assuming Home controller reloads on focus or we can trigger it:
    // This is handled by loadData calls in HomeController usually.
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
