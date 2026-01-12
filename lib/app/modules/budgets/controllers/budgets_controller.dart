import 'package:expense_wise/app/data/models/budget.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class BudgetsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  final budgets = <Budget>[].obs;
  final categories = <Category>[].obs;
  final budgetProgress = <int, double>{}.obs; // Map<BudgetID, SpentAmount>

  // Form selections
  final selectedCategory = Rxn<Category>();
  final amountText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBudgets();
    loadCategories();
  }

  void loadCategories() async {
    final allCategories = await _storageService.db.categorys.where().findAll();
    categories.assignAll(allCategories);
  }

  void loadBudgets() async {
    final allBudgets = await _storageService.db.budgets.where().findAll();

    // Calculate spent for each budget
    final progressMap = <int, double>{};
    for (var budget in allBudgets) {
      await budget.category.load();
      if (budget.category.value != null) {
        final categoryId = budget.category.value!.id;

        // Query transactions for this category
        final transactions = await _storageService.db.transactions
            .filter()
            .category((q) => q.idEqualTo(categoryId))
            .typeEqualTo(TransactionType.expense)
            .findAll();

        // TODO: Filter by period (month/week)
        // For now, assume all time or current month
        final now = DateTime.now();
        final currentMonthTxs = transactions
            .where((t) => t.date.year == now.year && t.date.month == now.month)
            .toList();

        double spent = 0;
        for (var tx in currentMonthTxs) {
          spent += tx
              .amount; // expenses are usually positive in this context or abs()
        }
        progressMap[budget.id] = spent;
      }
    }

    budgetProgress.assignAll(progressMap);
    budgets.assignAll(allBudgets);
  }

  Future<void> addBudget() async {
    final amount = double.tryParse(amountText.value);
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Invalid amount');
      return;
    }
    if (selectedCategory.value == null) {
      Get.snackbar('Error', 'Select a category');
      return;
    }

    // Check if budget exists for this category? (Optional)

    final budget = Budget()
      ..amount = amount
      ..period = BudgetPeriod.monthly; // Default

    budget.category.value = selectedCategory.value;

    await _storageService.db.writeTxn(() async {
      await _storageService.db.budgets.put(budget);
      await budget.category.save();
    });

    loadBudgets();
    Get.back(); // Close bottom sheet or screen
    Get.snackbar('Success', 'Budget set successfully');
  }

  Future<void> deleteBudget(Budget budget) async {
    await _storageService.db.writeTxn(() async {
      await _storageService.db.budgets.delete(budget.id);
    });
    loadBudgets();
  }
}
