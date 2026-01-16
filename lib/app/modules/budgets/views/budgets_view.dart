import 'package:expense_wise/app/modules/budgets/controllers/budgets_controller.dart';
import 'package:expense_wise/app/modules/budgets/views/add_budget_view.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetsHeader extends StatelessWidget {
  const BudgetsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    Get.put(BudgetsController());

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Budgets',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => const AddBudgetView());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                CupertinoIcons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetsBody extends StatelessWidget {
  const BudgetsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BudgetsController());

    return Container(
      child: Obx(() {
        if (controller.budgets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.creditcard,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No budgets set',
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const AddBudgetView()),
                  child: const Text('Set your first budget'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          // padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          padding: const EdgeInsets.all(24),
          itemCount: controller.budgets.length,
          itemBuilder: (context, index) {
            final budget = controller.budgets[index];
            final spendingData = controller.budgetSpending[budget.id];
            final spent = spendingData?['spending'] ?? 0.0;
            final isExceeded = spendingData?['isExceeded'] ?? false;
            final isInWarning = spendingData?['isInWarning'] ?? false;
            final category = budget.category.value;

            // Safe access
            final catName = category?.name ?? 'Unknown';
            final catColor = category?.colorHex != null
                ? Color(int.parse(category!.colorHex!))
                : Colors.blue;
            final catIcon = category?.iconCodePoint != null
                ? IconData(
                    category!.iconCodePoint!,
                    fontFamily: 'CupertinoIcons',
                    fontPackage: 'cupertino_icons',
                  )
                : CupertinoIcons.square_grid_2x2;

            final progress = (spent / budget.amount).clamp(0.0, 1.0);
            final remaining = budget.amount - spent;

            return Card(
              elevation: 4,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isExceeded
                    ? const BorderSide(color: Colors.red, width: 2)
                    : isInWarning
                    ? BorderSide(color: Colors.orange.shade400, width: 2)
                    : BorderSide.none,
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: catColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(catIcon, color: catColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    catName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (isExceeded) ...[
                                    const SizedBox(width: 8),
                                    const Icon(
                                      CupertinoIcons
                                          .exclamationmark_triangle_fill,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                  ] else if (isInWarning) ...[
                                    const SizedBox(width: 8),
                                    Icon(
                                      CupertinoIcons
                                          .exclamationmark_circle_fill,
                                      color: Colors.orange.shade400,
                                      size: 16,
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                isExceeded
                                    ? 'Over budget by ${Get.find<StorageService>().currencySymbol.value}${(spent - budget.amount).toStringAsFixed(0)}'
                                    : '${Get.find<StorageService>().currencySymbol.value}${remaining.toStringAsFixed(0)} left',
                                style: TextStyle(
                                  color: isExceeded
                                      ? Colors.red
                                      : isInWarning
                                      ? Colors.orange.shade700
                                      : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: isExceeded || isInWarning
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.delete,
                            size: 20,
                            color: Colors.grey,
                          ),
                          onPressed: () => controller.deleteBudget(budget),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${Get.find<StorageService>().currencySymbol.value}${spent.toStringAsFixed(0)} spent',
                              style: TextStyle(
                                color: isExceeded
                                    ? Colors.red
                                    : isInWarning
                                    ? Colors.orange.shade700
                                    : catColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${Get.find<StorageService>().currencySymbol.value}${budget.amount.toStringAsFixed(0)}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation(
                              isExceeded
                                  ? Colors.red
                                  : isInWarning
                                  ? Colors.orange.shade400
                                  : catColor,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
