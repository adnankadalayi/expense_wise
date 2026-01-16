import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/recurring_transaction.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class AddRecurringController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  // Form fields
  final amountText = '0'.obs;
  final descriptionText = ''.obs;
  final selectedCategory = Rxn<Category>();
  final selectedAccount = Rxn<Account>();
  final selectedInterval = RecurringInterval.monthly.obs;
  final selectedType = TransactionType.expense.obs;
  final nextRunDate = DateTime.now().obs;
  final isActive = true.obs;

  // Data
  final categories = <Category>[].obs;
  final accounts = <Account>[].obs;

  // Edit mode
  RecurringTransaction? editingTransaction;

  @override
  void onInit() {
    super.onInit();
    loadData();

    // Check if editing
    if (Get.arguments != null && Get.arguments is RecurringTransaction) {
      editingTransaction = Get.arguments as RecurringTransaction;
      loadEditData();
    }
  }

  Future<void> loadData() async {
    final db = _storageService.db;

    categories.value = await db.categorys.where().findAll();
    accounts.value = await db.accounts.where().findAll();
  }

  void loadEditData() {
    if (editingTransaction == null) return;

    amountText.value = editingTransaction!.amount.toString();
    descriptionText.value = editingTransaction!.note ?? '';
    selectedCategory.value = editingTransaction!.category.value;
    selectedAccount.value = editingTransaction!.account.value;
    selectedInterval.value = editingTransaction!.interval;
    selectedType.value = editingTransaction!.type;
    nextRunDate.value = editingTransaction!.nextRunDate;
    isActive.value = editingTransaction!.isActive;
  }

  void onKeypadTap(String key) {
    if (amountText.value == '0') {
      amountText.value = key;
    } else {
      amountText.value += key;
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

  Future<void> saveRecurring() async {
    // Validation
    if (double.tryParse(amountText.value) == null ||
        double.parse(amountText.value) <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    if (selectedCategory.value == null) {
      Get.snackbar('Error', 'Please select a category');
      return;
    }

    if (selectedAccount.value == null) {
      Get.snackbar('Error', 'Please select an account');
      return;
    }

    final db = _storageService.db;

    await db.writeTxn(() async {
      final recurring = editingTransaction ?? RecurringTransaction();

      recurring.amount = double.parse(amountText.value);
      recurring.note = descriptionText.value.isEmpty
          ? null
          : descriptionText.value;
      recurring.type = selectedType.value;
      recurring.interval = selectedInterval.value;
      recurring.nextRunDate = nextRunDate.value;
      recurring.isActive = isActive.value;

      await db.recurringTransactions.put(recurring);

      // Link category and account
      recurring.category.value = selectedCategory.value;
      recurring.account.value = selectedAccount.value;
      await recurring.category.save();
      await recurring.account.save();
    });

    Get.back();
    Get.snackbar(
      'Success',
      editingTransaction == null
          ? 'Recurring transaction created'
          : 'Recurring transaction updated',
    );
  }

  bool get isExpense => selectedType.value == TransactionType.expense;

  void toggleType(TransactionType type) {
    selectedType.value = type;
    selectedCategory.value = null; // Reset category when type changes
  }
}
