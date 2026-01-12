import 'package:expense_wise/app/modules/budgets/controllers/budgets_controller.dart';
import 'package:expense_wise/app/modules/budgets/views/add_budget_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BudgetsView extends StatelessWidget {
  const BudgetsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BudgetsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Budgets', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Get.to(() => const AddBudgetView());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.budgets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
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
          padding: const EdgeInsets.all(16),
          itemCount: controller.budgets.length,
          itemBuilder: (context, index) {
            final budget = controller.budgets[index];
            final spent = controller.budgetProgress[budget.id] ?? 0.0;
            final category = budget.category.value;

            // Safe access
            final catName = category?.name ?? 'Unknown';
            final catColor = category?.colorHex != null
                ? Color(int.parse(category!.colorHex!))
                : Colors.blue;
            final catIcon = category?.iconCodePoint != null
                ? IconData(
                    category!.iconCodePoint!,
                    fontFamily: 'MaterialIcons',
                  )
                : Icons.category;

            final progress = (spent / budget.amount).clamp(0.0, 1.0);
            final remaining = budget.amount - spent;
            final isOverBudget = spent > budget.amount;

            return Card(
              elevation: 4,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
                              Text(
                                catName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                isOverBudget
                                    ? 'Over budget by \$${(spent - budget.amount).toStringAsFixed(0)}'
                                    : '\$${remaining.toStringAsFixed(0)} left',
                                style: TextStyle(
                                  color: isOverBudget
                                      ? Colors.red
                                      : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
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
                              '\$${spent.toStringAsFixed(0)} spent',
                              style: TextStyle(
                                color: catColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\$${budget.amount.toStringAsFixed(0)}',
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
                              isOverBudget ? Colors.red : catColor,
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
