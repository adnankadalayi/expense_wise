import 'package:expense_wise/app/data/models/recurring_transaction.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/modules/recurring/controllers/recurring_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecurringTransactionsView extends GetView<RecurringController> {
  const RecurringTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF002E6E), Color(0xFF00BAF2)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            CupertinoIcons.back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Recurring Transactions',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Obx(
                          () => FilterChip(
                            label: Text(
                              controller.activeOnly.value
                                  ? 'Active Only'
                                  : 'All',
                            ),
                            selected: controller.activeOnly.value,
                            onSelected: (_) => controller.toggleFilter(),
                            backgroundColor: Colors.white.withOpacity(0.2),
                            selectedColor: Colors.white.withOpacity(0.3),
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            checkmarkColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Body
          Expanded(
            child: Obx(() {
              if (controller.recurringTransactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.repeat,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No recurring transactions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add recurring bills, subscriptions, or income',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: controller.recurringTransactions.length,
                itemBuilder: (context, index) {
                  final recurring = controller.recurringTransactions[index];
                  return _buildRecurringCard(recurring);
                },
              );
            }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/add-recurring'),
        backgroundColor: const Color(0xFF00BAF2),
        icon: const Icon(CupertinoIcons.add, color: Colors.white),
        label: const Text(
          'Add Recurring',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildRecurringCard(RecurringTransaction recurring) {
    final category = recurring.category.value;
    final account = recurring.account.value;
    final isExpense = recurring.type == TransactionType.expense;

    return GestureDetector(
      onTap: () => Get.toNamed('/add-recurring', arguments: recurring),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: recurring.isActive
                ? Colors.grey.shade200
                : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Category Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category?.colorHex != null
                        ? Color(int.parse(category!.colorHex!)).withOpacity(0.2)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      IconData(
                        category?.iconCodePoint ??
                            CupertinoIcons.square_grid_2x2_fill.codePoint,
                        fontFamily: 'CupertinoIcons',
                        fontPackage: 'cupertino_icons',
                      ),
                      size: 24,
                      color: category?.colorHex != null
                          ? Color(int.parse(category!.colorHex!))
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              recurring.note?.isNotEmpty == true
                                  ? recurring.note!
                                  : (category?.name ?? 'Unknown'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: recurring.isActive
                                    ? const Color(0xFF333333)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          if (!recurring.isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Inactive',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.repeat,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            controller.getFrequencyText(recurring.interval),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            CupertinoIcons.calendar,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            controller.getNextRunText(recurring.nextRunDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      if (account != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.creditcard,
                              size: 12,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              account.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Amount
                Text(
                  '${isExpense ? '-' : '+'}${account?.currency ?? '\$'}${recurring.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isExpense
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF22C55E),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.toggleActive(recurring),
                    icon: Icon(
                      recurring.isActive
                          ? CupertinoIcons.pause_circle
                          : CupertinoIcons.play_circle,
                      size: 16,
                    ),
                    label: Text(recurring.isActive ? 'Pause' : 'Resume'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00BAF2),
                      side: const BorderSide(color: Color(0xFF00BAF2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteDialog(recurring),
                    icon: const Icon(CupertinoIcons.delete, size: 16),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(RecurringTransaction recurring) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Recurring Transaction'),
        content: const Text(
          'Are you sure you want to delete this recurring transaction? This will not delete already created transactions.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.deleteRecurring(recurring.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }
}
