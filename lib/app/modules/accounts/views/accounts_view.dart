import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/modules/accounts/controllers/accounts_controller.dart';
import 'package:expense_wise/app/routes/app_pages.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:intl/intl.dart';

class AccountsView extends GetView<AccountsController> {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002E6E),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF002E6E), Color(0xFF00BAF2)],
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              // Custom Header
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Row
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              CupertinoIcons.back,
                              color: Colors.white,
                            ),
                            onPressed: () => Get.back(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Accounts',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Total Balance Card
                      _buildTotalBalanceCard(context),
                    ],
                  ),
                ),
              ),

              // White Card Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Obx(() {
                    if (controller.accounts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.creditcard,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No accounts yet',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap + to create your first account',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                      itemCount: controller.accounts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final account = controller.accounts[index];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Account Info Row
                              Row(
                                children: [
                                  // Icon Container with Gradient
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: account.colorHex != null
                                          ? LinearGradient(
                                              colors: [
                                                Color(
                                                  int.parse(account.colorHex!),
                                                ).withOpacity(0.15),
                                                Color(
                                                  int.parse(account.colorHex!),
                                                ).withOpacity(0.25),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : LinearGradient(
                                              colors: [
                                                Colors.grey[200]!,
                                                Colors.grey[300]!,
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      account.iconCodePoint != null
                                          ? IconData(
                                              account.iconCodePoint!,
                                              fontFamily: 'CupertinoIcons',
                                              fontPackage: 'cupertino_icons',
                                            )
                                          : CupertinoIcons.creditcard,
                                      color: account.colorHex != null
                                          ? Color(int.parse(account.colorHex!))
                                          : Colors.grey[600],
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Account Name & Type
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          account.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1A1A1A),
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          account.type.name.capitalizeFirst ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Balance
                                  Text(
                                    NumberFormat.currency(
                                      symbol: Get.find<StorageService>()
                                          .currencySymbol
                                          .value,
                                    ).format(account.balance),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: account.balance >= 0
                                          ? const Color(0xFF002E6E)
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),

                              // Toggles Row
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Row(
                                  children: [
                                    // Show on Home Toggle
                                    Expanded(
                                      child: _buildToggleChip(
                                        label: 'Show on Home',
                                        value: account.showOnHome,
                                        onChanged: () => controller
                                            .toggleShowOnHome(account),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Include in Total Toggle
                                    Expanded(
                                      child: _buildToggleChip(
                                        label: 'Include in Total',
                                        value: !account.excludeFromTotal,
                                        onChanged: () => controller
                                            .toggleExcludeFromTotal(account),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00BAF2).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.ADD_ACCOUNT),
          backgroundColor: const Color(0xFF00BAF2),
          elevation: 0,
          child: const Icon(CupertinoIcons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  NumberFormat.currency(
                    symbol: Get.find<StorageService>().currencySymbol.value,
                  ).format(controller.totalBalance.value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              CupertinoIcons.money_dollar_circle_fill,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool value,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value
              ? const Color(0xFF00BAF2).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: value ? const Color(0xFF00BAF2) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.circle,
              size: 16,
              color: value ? const Color(0xFF00BAF2) : Colors.grey[400],
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                  color: value ? const Color(0xFF002E6E) : Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
