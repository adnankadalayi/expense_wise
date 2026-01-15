import 'package:expense_wise/app/modules/home/controllers/home_controller.dart';
import 'package:expense_wise/app/modules/home/screens/add_transaction.dart';
import 'package:expense_wise/app/modules/home/screens/home_screen.dart';
import 'package:expense_wise/app/modules/home/screens/stat_screen.dart';
import 'package:expense_wise/app/modules/home/screens/settings_screen.dart';
import 'package:expense_wise/app/modules/budgets/views/budgets_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is found
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: const Color(0xFF002E6E), // Fallback
      resizeToAvoidBottomInset: false, // Handle keyboard in stack if needed
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Shared Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF002E6E),
                  Color(0xFF00BAF2),
                ], // Paytm Dark Blue to Cyan
              ),
            ),
          ),

          // 2. Headers Layer (Top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Obx(
                () => IndexedStack(
                  index: controller.selectedNavIndex.value,
                  children: const [
                    HomeHeader(),
                    StatsHeader(),
                    BudgetsHeader(),
                    SettingsHeader(),
                  ],
                ),
              ),
            ),
          ),

          // 3. Animated Content Card (Bottom Stack)
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              top: controller.currentCardTop,
              left: 0,
              right: 0,
              bottom: 0, // Extends to bottom
              child: Container(
                clipBehavior: Clip.antiAlias, // Clip top corners
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: IndexedStack(
                  index: controller.selectedNavIndex.value,
                  children: const [
                    HomeBody(),
                    StatsBody(),
                    BudgetsBody(),
                    SettingsBody(),
                  ],
                ),
              ),
            ),
          ),

          // 4. Bottom Navigation Bar
          Positioned(bottom: 0, left: 0, right: 0, child: const BottomNavBar()),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 34),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: controller.selectedNavIndex.value == 0,
                onTap: () => controller.selectedNavIndex.value = 0,
              ),
            ),
            Obx(
              () => _buildNavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Stats',
                isSelected: controller.selectedNavIndex.value == 1,
                onTap: () => controller.selectedNavIndex.value = 1,
              ),
            ),
            GestureDetector(
              onTap: () => Get.to(() => const AddTransactionScreen()),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF00BAF2), // Paytm Cyan
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BAF2).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
            Obx(
              () => _buildNavItem(
                icon: Icons.account_balance_wallet_rounded,
                label: 'Budgets',
                isSelected: controller.selectedNavIndex.value == 2,
                onTap: () => controller.selectedNavIndex.value = 2,
              ),
            ),
            Obx(
              () => _buildNavItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                isSelected: controller.selectedNavIndex.value == 3,
                onTap: () => controller.selectedNavIndex.value = 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
