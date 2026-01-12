import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/modules/transactions/controllers/transactions_controller.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/recurring_transaction.dart'; // import for enum

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lazily put controller if not already present
    // Note: If reusing controller, ensure state is reset.
    // For now, Get.put creates new or finds existing.
    final controller = Get.put(TransactionsController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5C842), Color(0xFFF7B500)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Transaction',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Transaction Type Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton('Expense', true, controller),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeButton('Income', false, controller),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Area
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Amount Section
                        _buildAmountSection(controller),
                        const SizedBox(height: 32),

                        // Description
                        _buildDescriptionSection(controller),
                        const SizedBox(height: 24),

                        // Account
                        _buildAccountSection(controller),
                        const SizedBox(height: 24),

                        // Category
                        _buildCategorySection(controller),
                        const SizedBox(height: 24),

                        // Date
                        _buildDateSection(controller),
                        const SizedBox(height: 24),

                        // Recurring Option
                        _buildRecurringSection(controller),
                        const SizedBox(height: 24),

                        // Save Button
                        _buildSaveButton(controller),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(
    String label,
    bool isExpense,
    TransactionsController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.toggleType(isExpense),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: controller.isExpense.value == isExpense
              ? Colors.white.withOpacity(0.9)
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: controller.isExpense.value == isExpense
                ? const Color(0xFFF7B500)
                : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection(TransactionsController controller) {
    return Column(
      children: [
        const Text(
          '\$',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFFF7B500),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: Color(0xFF333333),
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '0.00',
            hintStyle: TextStyle(color: Color(0xFFCCCCCC)),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: controller.updateAmount,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(TransactionsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'What did you spend on?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF5F5F5), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF5F5F5), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFF7B500), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (value) => controller.descriptionText.value = value,
        ),
      ],
    );
  }

  Widget _buildAccountSection(TransactionsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.accounts.isEmpty) {
            return GestureDetector(
              onTap: () => Get.toNamed('/add-account'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('No accounts found. Tap to add one.'),
              ),
            );
          }
          return DropdownButtonFormField<Account>(
            initialValue: controller.selectedAccount.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: controller.accounts.map((account) {
              return DropdownMenuItem(
                value: account,
                child: Text(account.name),
              );
            }).toList(),
            onChanged: (value) => controller.selectedAccount.value = value,
          );
        }),
      ],
    );
  }

  Widget _buildCategorySection(TransactionsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final categories = controller.categories
              .where(
                (c) =>
                    c.type ==
                    (controller.isExpense.value
                        ? CategoryType.expense
                        : CategoryType.income),
              )
              .toList();

          if (categories.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No categories available needed.'),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryItem(category, controller);
            },
          );
        }),
      ],
    );
  }

  Widget _buildCategoryItem(
    Category category,
    TransactionsController controller,
  ) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.selectedCategory.value = category,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: controller.selectedCategory.value?.id == category.id
                  ? const Color(0xFFF7B500)
                  : const Color(0xFFF5F5F5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: controller.selectedCategory.value?.id == category.id
                ? const Color(0xFFF7B500).withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconData(
                  category.iconCodePoint ?? Icons.category.codePoint,
                  fontFamily: 'MaterialIcons',
                ),
                size: 24,
                color: category.colorHex != null
                    ? Color(int.parse(category.colorHex!))
                    : Colors.grey,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(TransactionsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: Get.context!,
              initialDate: controller.selectedDate.value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              controller.selectedDate.value = date;
            }
          },
          child: Obx(
            () => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF5F5F5), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.selectedDate.value.year}-${controller.selectedDate.value.month.toString().padLeft(2, '0')}-${controller.selectedDate.value.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurringSection(TransactionsController controller) {
    return Obx(
      () => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Repeat Transaction',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              Switch(
                value: controller.isRecurring.value,
                onChanged: controller.toggleRecurring,
                activeThumbColor: const Color(0xFFF7B500),
              ),
            ],
          ),
          if (controller.isRecurring.value)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: DropdownButtonFormField<RecurringInterval>(
                initialValue: controller.selectedInterval.value,
                decoration: InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: RecurringInterval.values.map((interval) {
                  return DropdownMenuItem(
                    value: interval,
                    child: Text(interval.name.capitalizeFirst!),
                  );
                }).toList(),
                onChanged: controller.updateInterval,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(TransactionsController controller) {
    return GestureDetector(
      onTap: () => controller.addTransaction(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF7B500),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          'Save Transaction',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
