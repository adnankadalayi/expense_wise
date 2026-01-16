import 'package:expense_wise/app/data/models/budget.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/services/budget_tracking_service.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class BudgetsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final BudgetTrackingService _budgetTrackingService =
      Get.find<BudgetTrackingService>();

  final budgets = <Budget>[].obs;
  final categories = <Category>[].obs;
  final budgetSpending =
      <int, Map<String, dynamic>>{}.obs; // Map<BudgetID, SpendingData>

  // Form selections
  final selectedCategory = Rxn<Category>();
  final amountText = ''.obs;
  final selectedPeriod = BudgetPeriod.monthly.obs;
  final notificationThreshold = 80.0.obs;
  final isNotificationEnabled = true.obs;

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
    final allBudgets = await _storageService.db.budgets
        .filter()
        .isActiveEqualTo(true)
        .findAll();

    // Calculate spending for each budget using the tracking service
    final spendingMap = <int, Map<String, dynamic>>{};
    for (var budget in allBudgets) {
      await budget.category.load();
      if (budget.category.value != null) {
        final spendingData = await _budgetTrackingService.getBudgetSpending(
          budget,
        );
        spendingMap[budget.id] = spendingData;
      }
    }

    budgetSpending.assignAll(spendingMap);
    budgets.assignAll(allBudgets);

    // Check budgets for notifications
    await _budgetTrackingService.checkBudgets();
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

    final budget = Budget()
      ..amount = amount
      ..period = selectedPeriod.value
      ..notificationThreshold = notificationThreshold.value
      ..isNotificationEnabled = isNotificationEnabled.value
      ..isActive = true;

    budget.category.value = selectedCategory.value;

    await _storageService.db.writeTxn(() async {
      await _storageService.db.budgets.put(budget);
      await budget.category.save();
    });

    // Reset form
    amountText.value = '';
    selectedCategory.value = null;
    notificationThreshold.value = 80.0;
    isNotificationEnabled.value = true;
    selectedPeriod.value = BudgetPeriod.monthly;

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
