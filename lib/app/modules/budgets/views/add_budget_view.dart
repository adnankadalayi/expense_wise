import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/modules/budgets/controllers/budgets_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBudgetView extends StatelessWidget {
  const AddBudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    final controller = Get.find<BudgetsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Budget', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'For which category?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final expenseCategories = controller.categories
                  .where((c) => c.type == CategoryType.expense)
                  .toList();

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: expenseCategories.map((category) {
                  return Obx(() {
                    final isSelected =
                        controller.selectedCategory.value?.id == category.id;
                    return GestureDetector(
                      onTap: () => controller.selectedCategory.value = category,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF7B500)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (category.iconCodePoint != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  IconData(
                                    category.iconCodePoint!,
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  size: 18,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            Text(
                              category.name,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                }).toList(),
              );
            }),
            const SizedBox(height: 32),
            const Text(
              'What is the limit?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                prefixText: '\$ ',
                prefixStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                hintText: '0',
                hintStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) => controller.amountText.value = val,
            ),
            const SizedBox(height: 16),
            const Text(
              'This budget will repeat monthly.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.addBudget,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7B500),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Set Budget',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
