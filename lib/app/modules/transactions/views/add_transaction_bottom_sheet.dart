import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/modules/transactions/controllers/transactions_controller.dart';
import 'package:expense_wise/app/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionBottomSheet extends StatelessWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is fresh or reset
    final controller = Get.put(TransactionsController());
    // Use onReady or similar to reset if needed, but for now assuming new instance or reset logic called before

    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // 85% height
      decoration: const BoxDecoration(
        color: AppTheme.darkBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Tabs (Income / Expense / Transfer)
          _buildTypeSelector(controller),

          const SizedBox(height: 20),

          // Date & Time
          _buildDateSelector(context, controller),

          const SizedBox(height: 20),

          // Account Selector
          _buildAccountSelector(controller),

          const SizedBox(height: 10),

          Expanded(
            child: Column(
              children: [
                // Amount Display
                Obx(
                  () => Text(
                    '₹ ${controller.amountText.value.isEmpty ? '0' : controller.amountText.value}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: controller.isExpense.value
                          ? AppTheme.expenseColor
                          : (controller.isTransfer.value
                                ? AppTheme.transferColor
                                : AppTheme.incomeColor),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Note
                GestureDetector(
                  onTap: () => _showNoteDialog(context, controller),
                  child: Obx(
                    () => Text(
                      controller.descriptionText.value.isEmpty
                          ? 'Add note'
                          : controller.descriptionText.value,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Categories (visible only for Income/Expense)
                Obx(
                  () => Visibility(
                    visible: !controller.isTransfer.value,
                    child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.categories
                            .where(
                              (c) =>
                                  c.type ==
                                  (controller.isExpense.value
                                      ? CategoryType.expense
                                      : CategoryType.income),
                            )
                            .length,
                        itemBuilder: (context, index) {
                          final category = controller.categories
                              .where(
                                (c) =>
                                    c.type ==
                                    (controller.isExpense.value
                                        ? CategoryType.expense
                                        : CategoryType.income),
                              )
                              .toList()[index];
                          final isSelected =
                              controller.selectedCategory.value?.id ==
                              category.id;

                          final catColor = category.colorHex != null
                              ? Color(int.parse(category.colorHex!))
                              : Colors.grey;

                          return GestureDetector(
                            onTap: () =>
                                controller.selectedCategory.value = category,
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? catColor
                                    : AppTheme.darkSurface,
                                borderRadius: BorderRadius.circular(20),
                                border: isSelected
                                    ? Border.all(
                                        color: catColor.withOpacity(0.5),
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  if (category.iconCodePoint != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: Icon(
                                        IconData(
                                          category.iconCodePoint!,
                                          fontFamily: 'CupertinoIcons',
                                          fontPackage: 'cupertino_icons',
                                        ),
                                        size: 16,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white70,
                                      ),
                                    ),
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white70,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                          14, // Reduced font size for compact look
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Keypad
                _buildKeypad(controller),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(TransactionsController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Obx(() {
        return Row(
          children: [
            _buildTab(
              'Income',
              !controller.isExpense.value && !controller.isTransfer.value,
              () => controller.toggleType(TransactionType.income),
            ),
            _buildTab(
              'Expense',
              controller.isExpense.value && !controller.isTransfer.value,
              () => controller.toggleType(TransactionType.expense),
            ),
            _buildTab(
              'Transfer',
              controller.isTransfer.value,
              () => controller.toggleType(TransactionType.transfer),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTab(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.darkBackground
                : Colors.transparent, // Inverted feel for tab selection
            borderRadius: BorderRadius.circular(20),
            // Optional: box shadow for active tab
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    TransactionsController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => controller.selectedDate.value = controller
                .selectedDate
                .value
                .subtract(const Duration(days: 1)),
            icon: const Icon(CupertinoIcons.chevron_left, color: Colors.white),
          ),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) =>
                    Theme(data: ThemeData.dark(), child: child!),
              );
              if (date != null) controller.selectedDate.value = date;
            },
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.calendar,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    DateFormat(
                      'MMM dd, yyyy', // e.g. Jan 16, 2026
                    ).format(controller.selectedDate.value),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(CupertinoIcons.clock, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                DateFormat('HH:mm').format(DateTime.now()),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => controller.selectedDate.value = controller
                .selectedDate
                .value
                .add(const Duration(days: 1)),
            icon: const Icon(CupertinoIcons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSelector(TransactionsController controller) {
    return SizedBox(
      height: 60,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: controller.accounts.length,
          itemBuilder: (context, index) {
            final account = controller.accounts[index];
            final isSelected =
                controller.selectedAccount.value?.id == account.id;

            // Simple coloring logic
            Color baseColor;
            if (account.name.toLowerCase().contains('bank')) {
              baseColor = const Color(0xFF5E92F3);
            } else if (account.name.toLowerCase().contains('cash')) {
              baseColor = const Color(0xFF4CAF50); // Green
            } else {
              baseColor = const Color(0xFFFF9800); // Orange/Yellow
            }

            return GestureDetector(
              onTap: () => controller.selectedAccount.value = account,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? baseColor : AppTheme.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      // Placeholder icons based on name
                      account.name.toLowerCase().contains('bank')
                          ? CupertinoIcons.building_2_fill
                          : account.name.toLowerCase().contains('cash')
                          ? CupertinoIcons.money_dollar_circle_fill
                          : CupertinoIcons.creditcard_fill,
                      color: isSelected ? Colors.white : baseColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '₹${account.balance.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKeypad(TransactionsController controller) {
    return Container(
      color: AppTheme.darkSurface, // Or distinct background
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Column(
        children: [
          _buildKeypadRow(controller, ['÷', '7', '8', '9']),
          _buildKeypadRow(controller, ['×', '4', '5', '6']),
          _buildKeypadRow(controller, ['-', '1', '2', '3']),
          _buildLastRow(controller),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(TransactionsController controller, List<String> keys) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) => _buildKey(controller, key)).toList(),
      ),
    );
  }

  Widget _buildLastRow(TransactionsController controller) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildKey(controller, '+'),
          _buildKey(controller, '0'),
          _buildKey(controller, '.'),
          // Done Button
          Expanded(
            child: GestureDetector(
              onTap: controller.addTransaction,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor, // Check mark background
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  CupertinoIcons.checkmark_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(TransactionsController controller, String key) {
    final isOperator = ['+', '-', '×', '÷'].contains(key);

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onKeypadTap(key),
        child: Container(
          color: Colors.transparent, // Hit test
          alignment: Alignment.center,
          child: Text(
            key,
            style: TextStyle(
              fontSize: 24,
              color: isOperator ? AppTheme.secondaryColor : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showNoteDialog(
    BuildContext context,
    TransactionsController controller,
  ) {
    final textController = TextEditingController(
      text: controller.descriptionText.value,
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Text('Add Note', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter note...',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              controller.descriptionText.value = textController.text;
              Get.back();
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
