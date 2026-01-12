import 'package:expense_wise/app/modules/home/controllers/home_controller.dart';
import 'package:expense_wise/app/modules/home/screens/home_screen.dart';
import 'package:expense_wise/app/modules/home/screens/settings_screen.dart';
import 'package:expense_wise/app/modules/home/screens/stat_screen.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/modules/accounts/views/accounts_view.dart';
import 'package:expense_wise/app/modules/budgets/views/budgets_view.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      extendBody: true,
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return IndexedStack(
            index: controller.selectedNavIndex.value,
            children: [
              const HomeScreen(),
              StatisticsScreen(),
              BudgetsView(),
              const SettingsScreen(),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(controller, 0, Icons.home_rounded, 'Home'),
                _buildNavItem(controller, 1, Icons.bar_chart_rounded, 'Stats'),
                _buildNavItem(
                  controller,
                  2,
                  Icons.account_balance_wallet_rounded,
                  'Budgets',
                ),
                _buildNavItem(
                  controller,
                  3,
                  Icons.settings_rounded,
                  'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    HomeController controller,
    int index,
    IconData icon,
    String label,
  ) {
    return GestureDetector(
      onTap: () {
        controller.updateNavIndex(index);
      },
      child: Obx(() {
        final isSelected = controller.selectedNavIndex.value == index;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: isSelected
                  ? BoxDecoration(
                      color: const Color(0xFFF7B500).withOpacity(0.2),
                      shape: BoxShape.circle,
                    )
                  : const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? const Color(0xFFF7B500) : Colors.black54,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFFF7B500) : Colors.black54,
              ),
            ),
          ],
        );
      }),
    );
  }
}
