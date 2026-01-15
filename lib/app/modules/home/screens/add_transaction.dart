import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/modules/transactions/controllers/transactions_controller.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/transaction.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          // User profile or other actions if needed
        ],
      ),
      body: Column(
        children: [
          // Content Area (Scrollable to prevent overflow)
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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

                    // Options Row 1
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Obx(
                        () => Wrap(
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
                              icon: Icons.edit,
                              onTap: () => _showNoteDialog(context, controller),
                            ),
                            if (!controller.isTransfer.value)
                              _buildOptionChip(
                                context,
                                controller,
                                label:
                                    controller.selectedCategory.value?.name ??
                                    'Category',
                                icon: Icons.category,
                                onTap: () =>
                                    _showCategorySheet(context, controller),
                              ),
                            if (controller.selectedCategory.value != null &&
                                controller
                                        .selectedCategory
                                        .value!
                                        .subCategories !=
                                    null &&
                                controller
                                    .selectedCategory
                                    .value!
                                    .subCategories!
                                    .isNotEmpty &&
                                !controller.isTransfer.value)
                              _buildOptionChip(
                                context,
                                controller,
                                label:
                                    controller.selectedSubCategory.value ??
                                    'Subcategory',
                                icon: Icons.subdirectory_arrow_right,
                                onTap: () =>
                                    _showSubCategorySheet(context, controller),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Options Row 2
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildOptionChip(
                            context,
                            controller,
                            label: controller.isTransfer.value
                                ? 'From Account'
                                : 'Account',
                            icon: Icons.account_balance_wallet,
                            onTap: () =>
                                _showAccountSheet(context, controller, false),
                          ),
                          if (controller.isTransfer.value) ...[
                            const SizedBox(width: 12),
                            _buildOptionChip(
                              context,
                              controller,
                              label: 'To Account',
                              icon: Icons.arrow_forward_ios,
                              onTap: () =>
                                  _showAccountSheet(context, controller, true),
                            ),
                          ],
                          const SizedBox(width: 12),
                          _buildOptionChip(
                            context,
                            controller,
                            label: 'Date',
                            icon: Icons.calendar_today,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: controller.selectedDate.value,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (date != null)
                                controller.selectedDate.value = date;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Type Toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8,
                      ),
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
                                      color:
                                          controller.isExpense.value &&
                                              !controller.isTransfer.value
                                          ? Colors.redAccent
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      'Expense',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            controller.isExpense.value &&
                                                !controller.isTransfer.value
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
                                      color:
                                          !controller.isExpense.value &&
                                              !controller.isTransfer.value
                                          ? Colors.green
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      'Income',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            !controller.isExpense.value &&
                                                !controller.isTransfer.value
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
                                    TransactionType.transfer,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: controller.isTransfer.value
                                          ? Colors.blueAccent
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      'Transfer',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: controller.isTransfer.value
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

                    // Proceed Button
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // Proceed Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.addTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BAF2), // Paytm Cyan
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Proceed',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Keypad (Fixed at bottom)
          Container(
            color: const Color(0xFFF9F9F9),
            padding: const EdgeInsets.only(bottom: 30, top: 10),
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

  Widget _buildOptionChip(
    BuildContext context,
    TransactionsController controller, {
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

  Widget _buildKeypadRow(TransactionsController controller, List<String> keys) {
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

  Widget _buildKeypadButton(TransactionsController controller, String key) {
    return GestureDetector(
      onTap: () {
        if (key == 'backspace') {
          controller.onBackspace();
        } else {
          controller.onKeypadTap(key);
        }
      },
      child: Container(
        width: 80, // Approximate width
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
                Icons.backspace_outlined,
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
    TransactionsController controller,
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
    TransactionsController controller,
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
                          (controller.isExpense.value
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
                                fontFamily: 'MaterialIcons',
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
    TransactionsController controller,
    bool isDestination,
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isDestination ? "Select Destination Account" : "Select Account",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.accounts.length,
                  itemBuilder: (context, index) {
                    final acc = controller.accounts[index];
                    return ListTile(
                      leading: const Icon(Icons.account_balance_wallet),
                      title: Text(acc.name),
                      onTap: () {
                        if (isDestination) {
                          controller.selectedTransferAccount.value = acc;
                        } else {
                          controller.selectedAccount.value = acc;
                        }
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

  void _showSubCategorySheet(
    BuildContext context,
    TransactionsController controller,
  ) {
    if (controller.selectedCategory.value == null ||
        controller.selectedCategory.value!.subCategories == null)
      return;

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
                "Select Subcategory",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:
                    controller.selectedCategory.value!.subCategories!.length,
                itemBuilder: (context, index) {
                  final subCat =
                      controller.selectedCategory.value!.subCategories![index];
                  return ListTile(
                    title: Text(subCat),
                    onTap: () {
                      controller.selectedSubCategory.value = subCat;
                      Get.back();
                    },
                    trailing: controller.selectedSubCategory.value == subCat
                        ? const Icon(Icons.check, color: Color(0xFF00BAF2))
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
