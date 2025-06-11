import 'package:expense_wise/bottom_navigation/controllers/stats_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StatisticsController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF5C842), Color(0xFFF7B500)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              SlideTransition(
                position: controller.headerSlideAnimation,
                child: FadeTransition(
                  opacity: controller.headerFadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Statistics',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Obx(() => DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: controller.selectedPeriod.value,
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white, size: 16),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  dropdownColor: const Color(0xFFF7B500),
                                  items:
                                      controller.periods.map((String period) {
                                    return DropdownMenuItem<String>(
                                      value: period,
                                      child: Text(period),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.selectPeriod(newValue);
                                    }
                                  },
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content Area
              Expanded(
                child: SlideTransition(
                  position: controller.contentSlideAnimation,
                  child: FadeTransition(
                    opacity: controller.contentFadeAnimation,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Spending Overview
                            _buildSpendingOverview(controller),
                            const SizedBox(height: 24),

                            // Chart
                            _buildChart(controller),
                            const SizedBox(height: 24),

                            // Categories
                            _buildCategories(controller),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingOverview(StatisticsController controller) {
    return SlideTransition(
      position: controller.overviewSlideAnimation,
      child: FadeTransition(
        opacity: controller.overviewFadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF7B500).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'May 2025 Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    amount: '\$1,247',
                    label: 'Total Spent',
                  ),
                  _StatItem(
                    amount: '\$2,150',
                    label: 'Total Income',
                  ),
                  _StatItem(
                    amount: '\$903',
                    label: 'Net Savings',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(StatisticsController controller) {
    return SlideTransition(
      position: controller.chartSlideAnimation,
      child: FadeTransition(
        opacity: controller.chartFadeAnimation,
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(140, 140),
                    painter: DonutChartPainter(),
                  ),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$1,247',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(StatisticsController controller) {
    return SlideTransition(
      position: controller.categoriesSlideAnimation,
      child: FadeTransition(
        opacity: controller.categoriesFadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            ...controller.categoryData.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> category = entry.value;
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 600 + (index * 100)),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(30 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: _CategoryItem(
                        name: category['name'],
                        percentage: category['percentage'],
                        amount: category['amount'],
                        color: category['color'],
                        isLast: index == controller.categoryData.length - 1,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String amount;
  final String label;

  const _StatItem({
    required this.amount,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          amount,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF7B500),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String name;
  final String percentage;
  final String amount;
  final Color color;
  final bool isLast;

  const _CategoryItem({
    required this.name,
    required this.percentage,
    required this.amount,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  percentage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 30) / 2;

    // Define the segments with their colors and angles
    final segments = [
      {
        'color': const Color(0xFFF7B500),
        'startAngle': 0.0,
        'sweepAngle': 2.27
      }, // 36% -> 130°
      {
        'color': const Color(0xFFEF4444),
        'startAngle': 2.27,
        'sweepAngle': 1.22
      }, // 19% -> 70°
      {
        'color': const Color(0xFF22C55E),
        'startAngle': 3.49,
        'sweepAngle': 0.70
      }, // 12% -> 40°
      {
        'color': const Color(0xFF8B5CF6),
        'startAngle': 4.19,
        'sweepAngle': 0.87
      }, // 14% -> 50°
      {
        'color': const Color(0xFF06B6D4),
        'startAngle': 5.06,
        'sweepAngle': 1.22
      }, // 19% -> 70°
    ];

    for (final segment in segments) {
      paint.color = segment['color'] as Color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        segment['startAngle'] as double,
        segment['sweepAngle'] as double,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ExpenseWise Statistics',
      home: const StatisticsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
