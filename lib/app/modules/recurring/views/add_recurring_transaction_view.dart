import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/recurring_transaction.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/modules/recurring/controllers/add_recurring_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddRecurringTransactionView extends StatelessWidget {
  const AddRecurringTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddRecurringController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.editingTransaction == null
              ? 'Add Recurring'
              : 'Edit Recurring',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Amount Display
                  Obx(
                    () => Text(
                      '\$${controller.amountText.value}',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildOptionChip(
                          context,
                          controller,
                          label: controller.descriptionText.value.isNotEmpty
                              ? 'Note Added'
                              : 'Add Note',
                          icon: CupertinoIcons.pencil,
                          onTap: () => _showNoteDialog(context, controller),
                        ),
                        Obx(
                          () => _buildOptionChip(
                            context,
                            controller,
                            label:
                                controller.selectedCategory.value?.name ??
                                'Category',
                            icon: CupertinoIcons.tag,
                            onTap: () =>
                                _showCategorySheet(context, controller),
                          ),
                        ),
                        Obx(
                          () => _buildOptionChip(
                            context,
                            controller,
                            label:
                                controller.selectedAccount.value?.name ??
                                'Account',
                            icon: CupertinoIcons.creditcard,
                            onTap: () => _showAccountSheet(context, controller),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Frequency Selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Frequency',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: RecurringInterval.values.map((interval) {
                              final isSelected =
                                  controller.selectedInterval.value == interval;
                              return GestureDetector(
                                onTap: () => controller.selectedInterval.value =
                                    interval,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF00BAF2)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF00BAF2)
                                          : Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _getIntervalText(interval),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Next Run Date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Next Run Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: controller.nextRunDate.value,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              controller.nextRunDate.value = date;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.calendar,
                                  color: Color(0xFF00BAF2),
                                ),
                                const SizedBox(width: 12),
                                Obx(
                                  () => Text(
                                    DateFormat(
                                      'MMM d, yyyy',
                                    ).format(controller.nextRunDate.value),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Type Toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.toggleType(
                                  TransactionType.expense,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.isExpense
                                        ? Colors.redAccent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    'Expense',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: controller.isExpense
                                          ? Colors.white
                                          : Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => controller.toggleType(
                                  TransactionType.income,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !controller.isExpense
                                        ? Colors.green
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    'Income',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: !controller.isExpense
                                          ? Colors.white
                                          : Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveRecurring,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BAF2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  controller.editingTransaction == null ? 'Create' : 'Update',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Keypad
          Container(
            color: const Color(0xFFF9F9F9),
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Column(
              children: [
                _buildKeypadRow(controller, ['1', '2', '3']),
                _buildKeypadRow(controller, ['4', '5', '6']),
                _buildKeypadRow(controller, ['7', '8', '9']),
                _buildKeypadRow(controller, ['.', '0', 'backspace']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIntervalText(RecurringInterval interval) {
    switch (interval) {
      case RecurringInterval.daily:
        return 'Daily';
      case RecurringInterval.weekly:
        return 'Weekly';
      case RecurringInterval.monthly:
        return 'Monthly';
      case RecurringInterval.yearly:
        return 'Yearly';
    }
  }

  Widget _buildOptionChip(
    BuildContext context,
    AddRecurringController controller, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(AddRecurringController controller, List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) {
          return _buildKeypadButton(controller, key);
        }).toList(),
      ),
    );
  }

  Widget _buildKeypadButton(AddRecurringController controller, String key) {
    return GestureDetector(
      onTap: () {
        if (key == 'backspace') {
          controller.onBackspace();
        } else {
          controller.onKeypadTap(key);
        }
      },
      child: Container(
        width: 80,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: key == 'backspace'
            ? const Icon(
                CupertinoIcons.delete_left,
                size: 24,
                color: Colors.black,
              )
            : Text(
                key,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }

  void _showNoteDialog(
    BuildContext context,
    AddRecurringController controller,
  ) {
    final textController = TextEditingController(
      text: controller.descriptionText.value,
    );
    Get.defaultDialog(
      title: "Add Note",
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(hintText: "Enter description"),
        autofocus: true,
      ),
      textConfirm: "Save",
      textCancel: "Cancel",
      onConfirm: () {
        controller.descriptionText.value = textController.text;
        Get.back();
      },
    );
  }

  void _showCategorySheet(
    BuildContext context,
    AddRecurringController controller,
  ) {
    Get.bottomSheet(
      Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Obx(() {
                final categories = controller.categories
                    .where(
                      (c) =>
                          c.type ==
                          (controller.isExpense
                              ? CategoryType.expense
                              : CategoryType.income),
                    )
                    .toList();
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return GestureDetector(
                      onTap: () {
                        controller.selectedCategory.value = cat;
                        Get.back();
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: cat.colorHex != null
                                ? Color(
                                    int.parse(cat.colorHex!),
                                  ).withOpacity(0.2)
                                : Colors.grey[200],
                            child: Icon(
                              IconData(
                                cat.iconCodePoint!,
                                fontFamily: 'CupertinoIcons',
                                fontPackage: 'cupertino_icons',
                              ),
                              color: cat.colorHex != null
                                  ? Color(int.parse(cat.colorHex!))
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cat.name,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountSheet(
    BuildContext context,
    AddRecurringController controller,
  ) {
    Get.bottomSheet(
      Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.accounts.length,
                  itemBuilder: (context, index) {
                    final acc = controller.accounts[index];
                    return ListTile(
                      leading: const Icon(CupertinoIcons.creditcard),
                      title: Text(acc.name),
                      onTap: () {
                        controller.selectedAccount.value = acc;
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
