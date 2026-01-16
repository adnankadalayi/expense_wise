import 'dart:math';
import 'package:intl/intl.dart';
import 'package:expense_wise/app/modules/home/controllers/categories_controller.dart';
import 'package:expense_wise/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesHeader extends StatelessWidget {
  const CategoriesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController());

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: SlideTransition(
        position: controller.headerSlideAnimation,
        child: FadeTransition(
          opacity: controller.headerFadeAnimation,
          child: Column(
            children: [
              // Top Row: Title + Edit Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed(Routes.CATEGORY_MANAGEMENT),
                    icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ],
              ),
              // Month Selector Row (Back in Header)
              Row(
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
                          ).format(controller.currentDate.value),
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
                        onPressed: () => controller.changeMonth(-1),
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => controller.changeMonth(1),
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.filter_list,
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
    );
  }
}

class CategoriesBody extends StatelessWidget {
  const CategoriesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController());

    return SlideTransition(
      position:
          controller.chartSlideAnimation, // Using chart logic for body slide
      child: FadeTransition(
        opacity: controller.chartFadeAnimation,
        child: Container(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChart(controller),
                const SizedBox(height: 32),
                _buildCategories(controller),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(CategoriesController controller) {
    return SlideTransition(
      position: controller.chartSlideAnimation,
      child: FadeTransition(
        opacity: controller.chartFadeAnimation,
        child: GestureDetector(
          onTap: controller.toggleType,
          child: Container(
            height: 250,
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  Obx(() {
                    final List<Map<String, dynamic>> segments = [];
                    double startAngle = -pi / 2;

                    for (var cat in controller.categoryData) {
                      final double rawPercentage = cat['rawPercentage'];
                      final sweepAngle = (rawPercentage / 100) * 2 * pi;

                      segments.add({
                        'color': cat['color'],
                        'startAngle': startAngle,
                        'sweepAngle': sweepAngle,
                      });

                      startAngle += sweepAngle;
                    }

                    if (segments.isEmpty) {
                      segments.add({
                        'color': Colors
                            .grey
                            .shade300, // Lighter grey for empty state
                        'startAngle': 0.0,
                        'sweepAngle': 2 * pi,
                      });
                    }

                    return CustomPaint(
                      size: const Size(200, 200),
                      painter: DonutChartPainter(segments: segments),
                    );
                  }),
                  Center(
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.isExpense.value ? 'Expense' : 'Income',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${(controller.isExpense.value ? controller.totalSpent.value : controller.totalIncome.value).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: controller.isExpense.value
                                  ? const Color(0xFFE57373)
                                  : const Color(0xFF81C784),
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

  Widget _buildCategories(CategoriesController controller) {
    return SlideTransition(
      position: controller.listSlideAnimation,
      child: FadeTransition(
        opacity: controller.listFadeAnimation,
        child: Obx(
          () => Column(
            children: [
              if (controller.categoryData.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'No transactions found for this period',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                )
              else
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
                            percentageText: category['percentageText'],
                            percentageDouble: category['percentageDouble'],
                            amount: category['amount'],
                            color: category['color'],
                          ),
                        ),
                      );
                    },
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String name;
  final String percentageText;
  final double percentageDouble;
  final String amount;
  final Color color;

  const _CategoryItem({
    required this.name,
    required this.percentageText,
    required this.percentageDouble,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1), // Light background for icon
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIconForCategory(name), color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333), // Dark text
                          ),
                        ),
                        Text(
                          amount,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Progress Bar Row
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentageDouble,
                              backgroundColor:
                                  Colors.grey.shade200, // Light grey background
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          percentageText.replaceAll('% of spending', '%'),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600, // Darker grey text
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'bills':
        return CupertinoIcons.doc_text;
      case 'debt':
        return CupertinoIcons.money_dollar_circle;
      case 'food & drinks':
        return CupertinoIcons.ticket_fill;
      case 'transport':
        return CupertinoIcons.bus;
      case 'shopping':
        return CupertinoIcons.bag_fill;
      case 'vehicle':
        return CupertinoIcons.car_detailed;
      case 'entertainment':
        return CupertinoIcons.film;
      case 'scram': // From screenshot
        return CupertinoIcons.tortoise;
      default:
        return CupertinoIcons.square_grid_2x2_fill;
    }
  }
}

class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> segments;

  DonutChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.butt;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
