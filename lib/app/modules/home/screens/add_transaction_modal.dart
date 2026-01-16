import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/modules/transactions/controllers/transactions_controller.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:intl/intl.dart';

class AddTransactionModal extends StatelessWidget {
  const AddTransactionModal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionsController());

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Transaction Type Selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          controller.toggleType(TransactionType.income),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              !controller.isExpense.value &&
                                  !controller.isTransfer.value
                              ? const Color(0xFF3A3A3A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Income',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                !controller.isExpense.value &&
                                    !controller.isTransfer.value
                                ? Colors.white
                                : Colors.white60,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          controller.toggleType(TransactionType.expense),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              controller.isExpense.value &&
                                  !controller.isTransfer.value
                              ? const Color(0xFF3A3A3A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Expense',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                controller.isExpense.value &&
                                    !controller.isTransfer.value
                                ? Colors.white
                                : Colors.white60,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          controller.toggleType(TransactionType.transfer),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.isTransfer.value
                              ? const Color(0xFF3A3A3A)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Transfer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: controller.isTransfer.value
                                ? Colors.white
                                : Colors.white60,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Date and Time Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.chevron_left,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    controller.selectedDate.value = controller
                        .selectedDate
                        .value
                        .subtract(const Duration(days: 1));
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedDate.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(data: ThemeData.dark(), child: child!);
                      },
                    );
                    if (date != null) {
                      controller.selectedDate.value = date;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.calendar,
                          color: Colors.white70,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Obx(
                          () => Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(controller.selectedDate.value),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.clock,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('HH:mm').format(DateTime.now()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.chevron_right,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    controller.selectedDate.value = controller
                        .selectedDate
                        .value
                        .add(const Duration(days: 1));
                  },
                ),
              ],
            ),
          ),

          // Account Selection Chips
          SizedBox(
            height: 70,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.accounts.length,
                itemBuilder: (context, index) {
                  final account = controller.accounts[index];
                  final isSelected =
                      controller.selectedAccount.value?.id == account.id;

                  Color chipColor;
                  IconData chipIcon;

                  // Assign colors and icons based on account name
                  if (account.name.toLowerCase().contains('cash')) {
                    chipColor = const Color(0xFF10B981);
                    chipIcon = CupertinoIcons.money_dollar;
                  } else if (account.name.toLowerCase().contains('bank')) {
                    chipColor = const Color(0xFF3B82F6);
                    chipIcon = CupertinoIcons.building_2_fill;
                  } else if (account.name.toLowerCase().contains('saving')) {
                    chipColor = const Color(0xFFF59E0B);
                    chipIcon = CupertinoIcons.archivebox_fill;
                  } else {
                    chipColor = const Color(0xFF8B5CF6);
                    chipIcon = CupertinoIcons.creditcard_fill;
                  }

                  return GestureDetector(
                    onTap: () => controller.selectedAccount.value = account,
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? chipColor : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : chipColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              chipIcon,
                              color: isSelected ? Colors.white : chipColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                account.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '\$${account.balance.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white60,
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
          ),

          const SizedBox(height: 16),

          // Amount Display
          Obx(
            () => Text(
              '₹ ${controller.amountText.value.isEmpty ? '0' : controller.amountText.value}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEF4444),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Add Note Button
          Obx(
            () => TextButton(
              onPressed: () => _showNoteDialog(context, controller),
              child: Text(
                controller.descriptionText.value.isEmpty
                    ? 'Add note'
                    : 'Note: ${controller.descriptionText.value}',
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Category Pills
          if (!controller.isTransfer.value)
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

              return SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected =
                        controller.selectedCategory.value?.id == category.id;

                    Color categoryColor = category.colorHex != null
                        ? Color(int.parse(category.colorHex!))
                        : const Color(0xFF6B7280);

                    return GestureDetector(
                      onTap: () {
                        controller.selectedCategory.value = category;
                        Get.back();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? categoryColor
                              : categoryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              category.iconCodePoint != null
                                  ? IconData(
                                      category.iconCodePoint!,
                                      fontFamily: 'CupertinoIcons',
                                      fontPackage: 'cupertino_icons',
                                    )
                                  : CupertinoIcons.tag,
                              color: isSelected ? Colors.white : categoryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category.name,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : categoryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

          const Spacer(),

          // Keypad
          Container(
            color: const Color(0xFF252525),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                _buildKeypadRow(controller, ['÷', '7', '8', '9']),
                _buildKeypadRow(controller, ['×', '4', '5', '6']),
                _buildKeypadRow(controller, ['-', '1', '2', '3']),
                _buildKeypadRow(controller, ['+', '0', '.', 'backspace']),
              ],
            ),
          ),

          // Bottom Action Bar
          Container(
            color: const Color(0xFF252525),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.addTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BAF2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.check_mark,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(TransactionsController controller, List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) {
          return _buildKeypadButton(controller, key);
        }).toList(),
      ),
    );
  }

  Widget _buildKeypadButton(TransactionsController controller, String key) {
    bool isOperator = ['÷', '×', '-', '+'].contains(key);

    return GestureDetector(
      onTap: () {
        if (key == 'backspace') {
          controller.onBackspace();
        } else if (isOperator) {
          // Handle operators if needed
          return;
        } else {
          controller.onKeypadTap(key);
        }
      },
      child: Container(
        width: 70,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: key == 'backspace'
            ? const Icon(
                CupertinoIcons.delete_left,
                size: 22,
                color: Colors.white70,
              )
            : Text(
                key,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isOperator ? const Color(0xFF00BAF2) : Colors.white,
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
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Add Note', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter description',
            hintStyle: TextStyle(color: Colors.white60),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00BAF2)),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.descriptionText.value = textController.text;
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFF00BAF2)),
            ),
          ),
        ],
      ),
    );
  }
}
