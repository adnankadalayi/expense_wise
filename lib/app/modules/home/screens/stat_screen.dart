import 'package:expense_wise/app/modules/home/controllers/stats_screen_controller.dart';
import 'package:expense_wise/app/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          130,
        ), // Adjust height for header + month selector
        child: const StatsHeader(),
      ),
      body: const StatsBody(),
    );
  }
}

class StatsHeader extends StatelessWidget {
  const StatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatisticsController());

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
        child: SlideTransition(
          position: controller.headerSlideAnimation,
          child: FadeTransition(
            opacity: controller.headerFadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Analytics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        CupertinoIcons.pencil,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                // Month Selector Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.calendar,
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
                          onPressed: controller.previousMonth,
                          icon: const Icon(
                            CupertinoIcons.left_chevron,
                            color: Colors.white,
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: controller.nextMonth,
                          icon: const Icon(
                            CupertinoIcons.right_chevron,
                            color: Colors.white,
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {}, // Filter action
                          icon: const Icon(
                            CupertinoIcons.slider_horizontal_3,
                            color: Colors.white,
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatsBody extends StatelessWidget {
  const StatsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatisticsController());

    return SlideTransition(
      position: controller.contentSlideAnimation,
      child: FadeTransition(
        opacity: controller.contentFadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart Section
              _buildChartSection(controller),

              const SizedBox(height: 24),

              // Filter Pills
              Row(
                children: [
                  _buildPill('Income', false),
                  const SizedBox(width: 12),
                  _buildPill('Expenses', false),
                  const SizedBox(width: 12),
                  _buildPill('Total', true),
                  const Spacer(),
                  const Text(
                    'Day',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Cash Flow Card
              _buildCashFlowCard(controller),

              const SizedBox(height: 24),

              // Average Card
              _buildAverageCard(controller),

              const SizedBox(height: 24),

              // Compare Card (New)
              _buildCompareCard(controller),

              const SizedBox(height: 80), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPill(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryColor : AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey.shade400,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildChartSection(StatisticsController controller) {
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
      child: Obx(
        () => LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox.shrink();
                    if (value >= 1000) {
                      return Text(
                        '${(value / 1000).toStringAsFixed(0)}k',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      );
                    }
                    return Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    );
                  },
                  reservedSize: 30,
                  interval: controller.maxY.value > 0
                      ? controller.maxY.value / 4
                      : 100.0,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int day = value.toInt();
                    if (day % 5 == 0 && day > 0 && day <= 31) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          day.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  interval: 1,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            minX: 1,
            maxX: 31,
            minY: 0,
            maxY: controller.maxY.value,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => AppTheme.darkSurface,
              ),
            ),
            lineBarsData: [
              // Income Line (Green)
              LineChartBarData(
                spots: controller.incomeSpots,
                isCurved: true,
                color: AppTheme.incomeColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.incomeColor.withOpacity(0.1),
                ),
              ),
              // Expense Line (Red)
              LineChartBarData(
                spots: controller.expenseSpots,
                isCurved: true,
                color: AppTheme.expenseColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCashFlowCard(StatisticsController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cash flow',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              DateFormat('MMMM yyyy').format(controller.selectedDate.value),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Income Row
          _buildCashFlowRow(
            icon: CupertinoIcons.arrow_up_circle_fill,
            iconColor: AppTheme.incomeColor,
            label: 'Income',
            amount: controller.totalIncome,
            amountColor: AppTheme.incomeColor,
          ),
          const SizedBox(height: 16),

          // Expense Row
          _buildCashFlowRow(
            icon: CupertinoIcons.arrow_down_circle_fill,
            iconColor: AppTheme.expenseColor,
            label: 'Expenses',
            amount: controller.totalSpent,
            amountColor: AppTheme.expenseColor,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(height: 1, color: Colors.white10),
          ),

          // Total Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Obx(() {
                final val = controller.netSavings.value;
                return Text(
                  '${val >= 0 ? '+' : ''}${val.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: val >= 0
                        ? AppTheme.incomeColor
                        : AppTheme.expenseColor,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCashFlowRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required RxDouble amount,
    required Color amountColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Obx(
          () => Text(
            '${amount.value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAverageCard(StatisticsController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Average',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              DateFormat('MMMM yyyy').format(controller.selectedDate.value),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Averages
          _buildAverageRow('Day', controller.avgDayIncome, controller.avgDay),
          const SizedBox(height: 12),
          _buildAverageRow(
            'Week',
            controller.avgWeekIncome,
            controller.avgWeek,
          ),
          const SizedBox(height: 12),
          _buildAverageRow(
            'Month',
            controller.avgMonthIncome,
            controller.avgMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildAverageRow(String label, RxDouble income, RxDouble expense) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Obx(
          () => Text(
            '${income.value.toStringAsFixed(0)}',
            style: TextStyle(
              color: AppTheme.incomeColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Obx(
          () => Text(
            '${expense.value.toStringAsFixed(0)}',
            style: TextStyle(
              color: AppTheme.expenseColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompareCard(StatisticsController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Compare',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          // Comparison context - e.g., "vs Last Month"
          Text(
            'vs Last Month',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),

          // Dummy Comparison Bars for visual
          _buildCompareRow('Income', 0.8, 0.7, AppTheme.incomeColor),
          const SizedBox(height: 16),
          _buildCompareRow('Expense', 0.5, 0.6, AppTheme.expenseColor),
        ],
      ),
    );
  }

  Widget _buildCompareRow(
    String label,
    double currentProgress,
    double lastProgress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '${((currentProgress - lastProgress) * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: currentProgress >= lastProgress
                    ? AppTheme.incomeColor
                    : AppTheme.expenseColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            // Background
            Container(height: 6, width: double.infinity, color: Colors.white10),
            // Last Month (Greyed out or lighter)
            FractionallySizedBox(
              widthFactor: lastProgress,
              child: Container(height: 6, color: color.withOpacity(0.3)),
            ),
            // Current Month
            FractionallySizedBox(
              widthFactor: currentProgress,
              child: Container(height: 6, color: color),
            ),
          ],
        ),
      ],
    );
  }
}
