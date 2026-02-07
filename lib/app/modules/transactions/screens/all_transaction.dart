import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/modules/transactions/controllers/all_transaction_controller.dart';
import 'package:expense_wise/app/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:expense_wise/app/modules/transactions/views/add_transaction_bottom_sheet.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllTransactionController());

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search, color: Colors.white),
            onPressed: controller.toggleSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs (Optional/If design requires)
          // For now, simple list
          Expanded(
            child: Obx(() {
              if (controller.groupedTransactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.doc_text,
                        size: 64,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
                itemCount: controller.groupedTransactions.length,
                itemBuilder: (context, groupIndex) {
                  final group = controller.groupedTransactions[groupIndex];
                  final transactions =
                      group['transactions'] as List<Transaction>;
                  final dayLabel = group['dayLabel'] as String;
                  final dayTotal = group['total'] as double;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Day Header
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dayLabel,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white54,
                              ),
                            ),
                            Text(
                              '${dayTotal >= 0 ? '+' : ''}${dayTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Transactions List
                      ...transactions.map((transaction) {
                        final category = transaction.category.value;
                        final isExpense =
                            transaction.type == TransactionType.expense;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.darkSurface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: category?.colorHex != null
                                      ? Color(
                                          int.parse(category!.colorHex!),
                                        ).withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Icon(
                                    IconData(
                                      category?.iconCodePoint ??
                                          CupertinoIcons
                                              .square_grid_2x2_fill
                                              .codePoint,
                                      fontFamily:
                                          'CupertinoIcons', // Assuming Cupertino icons standard
                                      fontPackage: 'cupertino_icons',
                                    ),
                                    size: 20,
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat(
                                        'h:mm a',
                                      ).format(transaction.date),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${isExpense ? '-' : '+'}${transaction.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isExpense
                                      ? AppTheme.expenseColor
                                      : AppTheme.incomeColor,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            const AddTransactionBottomSheet(),
            isScrollControlled: true,
            ignoreSafeArea: false,
          );
        },
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
