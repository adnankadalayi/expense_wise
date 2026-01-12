import 'package:expense_wise/app/modules/home/controllers/home_controller.dart';
import 'package:expense_wise/app/modules/home/screens/add_transaction.dart';
import 'package:expense_wise/app/modules/home/screens/home_screen.dart';
import 'package:expense_wise/app/modules/home/screens/settings_screen.dart';
import 'package:expense_wise/app/modules/home/screens/stat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return IndexedStack(
            index: controller.selectedNavIndex.value,
            children: [
              const HomeScreen(),
              // const Center(
              //     child: Text('Stats Page', style: TextStyle(fontSize: 24))),
              StatisticsScreen(),
              AddTransactionScreen(),
              const SettingsScreen(),
              // Center(
              //     child: Text('Settings Page', style: TextStyle(fontSize: 24))),
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

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(controller, 0, '🏠', 'Home'),
            _buildNavItem(controller, 1, '📊', 'Stats'),
            _buildNavItem(controller, 2, '➕', 'Add'),
            _buildNavItem(controller, 3, '⚙️', 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      HomeController controller, int index, String icon, String label) {
    return GestureDetector(
      onTap: () {
        controller.updateNavIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 24,
              color: controller.selectedNavIndex.value == index
                  ? const Color(0xFFF7B500)
                  : const Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: controller.selectedNavIndex.value == index
                  ? const Color(0xFFF7B500)
                  : const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}
