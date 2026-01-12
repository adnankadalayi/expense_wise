import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller
class AllTransactionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  RxString activeFilter = 'All'.obs;
  RxBool isSearchVisible = false.obs;
  RxString searchQuery = ''.obs;

  final List<String> filterTabs = ['All', 'Expenses', 'Income', 'This Month'];

  final List<Map<String, dynamic>> transactions = [
    // May 2025
    {
      'month': 'May 2025',
      'total': -514.55,
      'transactions': [
        {
          'icon': '🍕',
          'title': 'Pizza Express',
          'time': 'Today, 2:30 PM',
          'category': 'Food',
          'amount': -24.50,
          'bgColor': const Color(0xFFfee2e2),
        },
        {
          'icon': '💰',
          'title': 'Freelance Payment',
          'time': 'Yesterday, 4:15 PM',
          'category': 'Income',
          'amount': 450.00,
          'bgColor': const Color(0xFFdcfce7),
        },
        {
          'icon': '☕',
          'title': 'Coffee Shop',
          'time': 'Yesterday, 8:45 AM',
          'category': 'Food',
          'amount': -5.80,
          'bgColor': const Color(0xFFfef3c7),
        },
        {
          'icon': '🚗',
          'title': 'Gas Station',
          'time': 'May 21, 6:20 PM',
          'category': 'Transport',
          'amount': -45.00,
          'bgColor': const Color(0xFFe0e7ff),
        },
        {
          'icon': '🛒',
          'title': 'Grocery Store',
          'time': 'May 20, 3:15 PM',
          'category': 'Shopping',
          'amount': -89.25,
          'bgColor': const Color(0xFFf3e8ff),
        },
      ]
    },
    // April 2025
    {
      'month': 'April 2025',
      'total': 287.45,
      'transactions': [
        {
          'icon': '💼',
          'title': 'Salary',
          'time': 'Apr 30, 9:00 AM',
          'category': 'Income',
          'amount': 3200.00,
          'bgColor': const Color(0xFFdcfce7),
        },
        {
          'icon': '🏠',
          'title': 'Rent Payment',
          'time': 'Apr 29, 10:30 AM',
          'category': 'Housing',
          'amount': -1200.00,
          'bgColor': const Color(0xFFfee2e2),
        },
      ]
    }
  ];

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void setActiveFilter(String filter) {
    activeFilter.value = filter;
  }

  void toggleSearch() {
    isSearchVisible.value = !isSearchVisible.value;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}

// Main Widget
class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                            Row(
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
                        child: Row(
                          children: controller.filterTabs.map((tab) {
                            return Obx(() => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () =>
                                        controller.setActiveFilter(tab),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
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
                                ));
                          }).toList(),
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
                            child: Column(
                              children:
                                  controller.transactions.map((monthData) {
                                return _buildMonthSection(
                                    monthData, controller);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Search Overlay
              Obx(() => AnimatedContainer(
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
                                        decoration: InputDecoration(
                                          hintText: 'Search transactions...',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFf5f5f5),
                                              width: 2,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFf7b500),
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(16),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          'Food',
                                          'Transport',
                                          'Shopping',
                                          'Income'
                                        ]
                                            .map((tag) => Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFf7b500)
                                                            .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Text(
                                                    tag,
                                                    style: const TextStyle(
                                                      color: Color(0xFFf7b500),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  )),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white.withOpacity(0.95),
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(20),
      //       topRight: Radius.circular(20),
      //     ),
      //   ),
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           _buildNavItem(Icons.home, 'Home', false),
      //           _buildNavItem(Icons.list, 'Transactions', true),
      //           _buildNavItem(Icons.add_circle_outline, 'Add', false),
      //           _buildNavItem(Icons.bar_chart, 'Stats', false),
      //           _buildNavItem(Icons.person, 'Profile', false),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildMonthSection(
      Map<String, dynamic> monthData, AllTransactionController controller) {
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
                bottom: BorderSide(
                  color: Color(0xFFf5f5f5),
                  width: 2,
                ),
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
                      ? '+\$${monthData['total'].toStringAsFixed(2)}'
                      : '-\$${monthData['total'].abs().toStringAsFixed(2)}',
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
            children: (monthData['transactions'] as List)
                .asMap()
                .entries
                .map((entry) {
              int index = entry.key;
              Map<String, dynamic> transaction = entry.value;

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
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
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
                    color: transaction['bgColor'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      transaction['icon'],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['title'],
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
                            transaction['time'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFf7b500).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              transaction['category'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFf7b500),
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
                  transaction['amount'] >= 0
                      ? '+\$${transaction['amount'].toStringAsFixed(2)}'
                      : '-\$${transaction['amount'].abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: transaction['amount'] >= 0
                        ? const Color(0xFF22c55e)
                        : const Color(0xFFef4444),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          color: isActive ? const Color(0xFFf7b500) : const Color(0xFF999999),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFFf7b500) : const Color(0xFF999999),
          ),
        ),
      ],
    );
  }
}
