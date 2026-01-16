import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/modules/transactions/controllers/all_transaction_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllTransactionController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF002E6E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'All Transactions',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.groupedTransactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.doc_text,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No transactions yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: controller.groupedTransactions.length,
          itemBuilder: (context, groupIndex) {
            final group = controller.groupedTransactions[groupIndex];
            final transactions = group['transactions'] as List<Transaction>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    group['month'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                // Transactions
                ...transactions.map((transaction) {
                  final category = transaction.category.value;
                  final isExpense = transaction.type == TransactionType.expense;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: category?.colorHex != null
                                ? Color(
                                    int.parse(category!.colorHex!),
                                  ).withValues(alpha: 0.2)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              IconData(
                                category?.iconCodePoint ??
                                    CupertinoIcons
                                        .square_grid_2x2_fill
                                        .codePoint,
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.note?.isNotEmpty == true
                                    ? transaction.note!
                                    : (category?.name ?? 'Unknown'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat(
                                  'MMM d, yyyy - h:mm a',
                                ).format(transaction.date),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${isExpense ? '-' : '+'}${transaction.account.value?.currency ?? '\$'}${transaction.amount.toStringAsFixed(2)}',
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
                  );
                }),
              ],
            );
          },
        );
      }),
    );
  }
}
