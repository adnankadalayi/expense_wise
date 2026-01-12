import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/modules/transactions/controllers/all_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Main Widget
class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(AllTransactionController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFf5c842), Color(0xFFf7b500)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Header
                  SlideTransition(
                    position: controller.slideAnimation,
                    child: FadeTransition(
                      opacity: controller.fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text(
                                    'All Transactions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.toggleSearch,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Filter Tabs
                  SlideTransition(
                    position: controller.slideAnimation,
                    child: FadeTransition(
                      opacity: controller.fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: controller.filterTabs.map((tab) {
                              return Obx(
                                () => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () =>
                                        controller.setActiveFilter(tab),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            controller.activeFilter.value == tab
                                            ? Colors.white.withOpacity(0.9)
                                            : Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        tab,
                                        style: TextStyle(
                                          color:
                                              controller.activeFilter.value ==
                                                  tab
                                              ? const Color(0xFFf7b500)
                                              : Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Content
                  Expanded(
                    child: SlideTransition(
                      position: controller.slideAnimation,
                      child: FadeTransition(
                        opacity: controller.fadeAnimation,
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
                            child: Obx(() {
                              if (controller.groupedTransactions.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: Text("No transactions found"),
                                  ),
                                );
                              }
                              return Column(
                                children: controller.groupedTransactions.map((
                                  monthData,
                                ) {
                                  return _buildMonthSection(
                                    monthData,
                                    controller,
                                  );
                                }).toList(),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Search Overlay
              Obx(
                () => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: controller.isSearchVisible.value
                      ? Colors.black.withOpacity(0.5)
                      : Colors.transparent,
                  child: controller.isSearchVisible.value
                      ? GestureDetector(
                          onTap: controller.toggleSearch,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(24, 100, 24, 0),
                            child: Material(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      onChanged: controller.updateSearchQuery,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Search transactions...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFf5f5f5),
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFf7b500),
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.all(
                                          16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSection(
    Map<String, dynamic> monthData,
    AllTransactionController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          // Month Header
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFf5f5f5), width: 2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  monthData['month'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  monthData['total'] >= 0
                      ? '+\$${(monthData['total'] as double).toStringAsFixed(2)}'
                      : '-\$${(monthData['total'] as double).abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: monthData['total'] >= 0
                        ? const Color(0xFF22c55e)
                        : const Color(0xFFef4444),
                  ),
                ),
              ],
            ),
          ),

          // Transactions List
          Column(
            children: (monthData['transactions'] as List<Transaction>)
                .asMap()
                .entries
                .map((entry) {
                  int index = entry.key;
                  Transaction transaction = entry.value;

                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 600 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(30 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: _buildTransactionItem(transaction),
                        ),
                      );
                    },
                  );
                })
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isExpense = transaction.type == TransactionType.expense;
    final cat = transaction.category.value;
    final color = cat?.colorHex != null
        ? Color(int.parse(cat!.colorHex!))
        : Colors.grey;
    final icon = cat?.iconCodePoint != null
        ? IconData(cat!.iconCodePoint!, fontFamily: 'MaterialIcons')
        : Icons.help_outline;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: const Color(0xFFf8f9fa),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Icon(icon, color: color, size: 20)),
                ),

                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.note?.isNotEmpty == true
                            ? transaction.note!
                            : (cat?.name ?? 'Unknown'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat(
                              'MMM d, h:mm a',
                            ).format(transaction.date), // e.g., May 21, 6:20 PM
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (cat != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount
                Text(
                  isExpense
                      ? '-\$${transaction.amount.toStringAsFixed(2)}'
                      : '+\$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isExpense
                        ? const Color(0xFFef4444)
                        : const Color(0xFF22c55e),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
