import 'package:expense_wise/app/modules/home/controllers/stats_screen_controller.dart';
import 'package:expense_wise/app/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CategoryManagementView extends StatelessWidget {
  const CategoryManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    // We reuse StatisticsController for date selection and data aggregation logic
    // or create a dedicated CategoriesController if needed.
    // For now, StatisticsController is a good fit as it likely has 'grouped by category' logic or we can add it.
    // However, if StatisticsController is not initialized, we put it.
    final controller = Get.put(StatisticsController());

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to "Manage Categories" (Edit mode)
              // Since this IS CategoryManagementView file, we might need a separate "Edit" screen
              // or toggle a mode. For now, assuming this is the consumption view.
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Month Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Obx(
                        () => Text(
                          DateFormat(
                            'MMMM yyyy',
                          ).format(controller.selectedDate.value),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        onPressed: controller.previousMonth,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                        onPressed: controller.nextMonth,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Donut Chart Section
            SizedBox(
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Obx(() {
                    // Placeholder data or derived from controller
                    // We need a way to get "Category Spending" from controller.
                    // Assuming controller has a method or list for this.
                    // If not, we will use static/dummy data for the redesign visual first.
                    return PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 60,
                        sections: [
                          PieChartSectionData(
                            color: const Color(0xFF22C55E), // Bills/Green
                            value: 7411,
                            radius: 12,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            color: const Color(0xFFFF9800), // Debt/Orange
                            value: 5000,
                            radius: 12,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            color: const Color(0xFFF44336), // Food/Red
                            value: 3870,
                            radius: 12,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            color: const Color(0xFF2196F3), // Scram/Blue
                            value: 1911,
                            radius: 12,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            color: const Color(0xFF00BCD4), // Transport/Cyan
                            value: 630,
                            radius: 12,
                            showTitle: false,
                          ),
                        ],
                      ),
                    );
                  }),
                  // Center Text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total', // or Expense
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      Obx(
                        () => Text(
                          '${controller.totalSpent.value.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          '${controller.totalIncome.value.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Category List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildCategoryRow(
                    'Bills',
                    '7,411',
                    0.37,
                    const Color(0xFF22C55E),
                    Icons.calculate_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryRow(
                    'Debt',
                    '5,000',
                    0.25,
                    const Color(0xFFFF9800),
                    Icons.money_off,
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryRow(
                    'Food & Drinks',
                    '3,870',
                    0.19,
                    const Color(0xFFF44336),
                    Icons.restaurant,
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryRow(
                    'Scram',
                    '1,911',
                    0.09,
                    const Color(0xFF2196F3),
                    Icons.motorcycle,
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryRow(
                    'Transport',
                    '630',
                    0.03,
                    const Color(0xFF00BCD4),
                    Icons.directions_bus,
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryRow(
                    'Other',
                    '531',
                    0.03,
                    Colors.grey,
                    Icons.more_horiz,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(
    String name,
    String amount,
    double progress,
    Color color,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color:
                    color, // Screenshot shows amount colored same as category
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 8,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
