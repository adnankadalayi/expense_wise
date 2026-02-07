import 'package:expense_wise/app/modules/home/controllers/home_controller.dart';
import 'package:expense_wise/app/modules/home/screens/home_screen.dart';
import 'package:expense_wise/app/modules/home/screens/stat_screen.dart'; // Will be renamed/refactored to Analytics
import 'package:expense_wise/app/modules/settings/views/category_management_view.dart';
import 'package:expense_wise/app/modules/transactions/screens/all_transaction.dart';
import 'package:expense_wise/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedNavIndex.value,
          children: [
            // 0. Home
            const HomeBody(), // We need to check if HomeBody includes the header or if we need to restructure.
            // For now assuming HomeBody is the full page content for Home tab.

            // 1. Categories
            const CategoryManagementView(),

            // 2. Analytics (Stats)
            const StatsScreen(),
            // 3. Transactions
            AllTransactionsScreen(), // Verify if this is full screen
          ],
        ),
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

    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.selectedNavIndex.value,
        onTap: (index) => controller.selectedNavIndex.value = index,
        backgroundColor: AppTheme.darkBackground,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade600,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline), // Or a similar category icon
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded), // Or Icons.list_alt
            label: 'Transactions',
          ),
        ],
      ),
    );
  }
}

// Temporary placeholder wrappers if the original Body widgets were only partials
// logic to handle Headers vs Body from original code is simplified here.
// We will need to update the individual screens to be self-contained Scaffolds or Containers.
