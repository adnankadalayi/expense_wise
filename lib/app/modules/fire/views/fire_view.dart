import 'package:expense_wise/app/data/models/fire_data.dart';
import 'package:expense_wise/app/modules/fire/controllers/fire_controller.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class FireView extends GetView<FireController> {
  const FireView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF002E6E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'FIRE Calculator',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.settings, color: Colors.white),
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final fire = controller.fireData.value;
        if (fire == null) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildProgressCircle(fire),
              const SizedBox(height: 32),
              _buildFireStats(fire),
              const SizedBox(height: 24),
              _buildMilestones(fire),
              const SizedBox(height: 24),
              _buildProjectionChart(),
              const SizedBox(height: 24),
              _buildFireScenarios(fire),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.chart_bar_circle,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No financial data available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some transactions to calculate your FIRE progress',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(FireData fire) {
    final progress = fire.fireProgress.clamp(0.0, 100.0);
    final color = _getProgressColor(progress);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress / 100,
                    strokeWidth: 16,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${progress.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    const Text(
                      'to FIRE',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            fire.fireLevel.displayName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            fire.fireLevel.description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFireStats(FireData fire) {
    final currencySymbol = Get.find<StorageService>().currencySymbol.value;
    final yearsToFire = fire.yearsToFire.isFinite
        ? fire.yearsToFire.toStringAsFixed(1)
        : '∞';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'FIRE Number',
                '$currencySymbol${_formatNumber(fire.fireNumber)}',
                CupertinoIcons.flag_fill,
                const Color(0xFF00BAF2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Net Worth',
                '$currencySymbol${_formatNumber(fire.currentNetWorth)}',
                CupertinoIcons.money_dollar_circle_fill,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Years to FIRE',
                yearsToFire,
                CupertinoIcons.timer_fill,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Savings Rate',
                '${fire.savingsRate.toStringAsFixed(1)}%',
                CupertinoIcons.chart_bar_fill,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestones(FireData fire) {
    final milestones = [
      {
        'name': 'Coast FIRE',
        'percentage': 25.0,
        'achieved': fire.fireProgress >= 25,
      },
      {
        'name': 'Barista FIRE',
        'percentage': 50.0,
        'achieved': fire.fireProgress >= 50,
      },
      {'name': 'FIRE', 'percentage': 75.0, 'achieved': fire.fireProgress >= 75},
      {
        'name': 'Fat FIRE',
        'percentage': 100.0,
        'achieved': fire.fireProgress >= 100,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FIRE Milestones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          ...milestones.map((milestone) {
            final achieved = milestone['achieved'] as bool;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    achieved
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.circle,
                    color: achieved ? Colors.green : Colors.grey.shade300,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      milestone['name'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: achieved
                            ? const Color(0xFF333333)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Text(
                    '${milestone['percentage']}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: achieved ? Colors.green : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProjectionChart() {
    return Obx(() {
      if (controller.projections.isEmpty) return const SizedBox();

      final fire = controller.fireData.value!;
      final maxY = controller.projections
          .map((p) => p.amount)
          .reduce((a, b) => a > b ? a : b);

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Net Worth Projection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Y${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: math.max(maxY, fire.fireNumber) * 1.1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.projections
                          .map((p) => FlSpot(p.year.toDouble(), p.amount))
                          .toList(),
                      isCurved: true,
                      color: const Color(0xFF00BAF2),
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF00BAF2).withOpacity(0.1),
                      ),
                    ),
                  ],
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: fire.fireNumber,
                        color: Colors.green,
                        strokeWidth: 2,
                        dashArray: [5, 5],
                        label: HorizontalLineLabel(
                          show: true,
                          labelResolver: (line) => 'FIRE',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFireScenarios(FireData fire) {
    final currencySymbol = Get.find<StorageService>().currencySymbol.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FIRE Scenarios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          _buildScenarioRow(
            'Lean FIRE',
            fire.leanFireNumber,
            currencySymbol,
            Colors.orange,
          ),
          _buildScenarioRow(
            'FIRE',
            fire.fireNumber,
            currencySymbol,
            Colors.green,
          ),
          _buildScenarioRow(
            'Fat FIRE',
            fire.fatFireNumber,
            currencySymbol,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioRow(
    String label,
    double amount,
    String currency,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            '$currency${_formatNumber(amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 100) return Colors.green;
    if (progress >= 75) return const Color(0xFF00BAF2);
    if (progress >= 50) return Colors.orange;
    if (progress >= 25) return Colors.deepOrange;
    return Colors.red;
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(2)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  void _showSettingsSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FIRE Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            Obx(
              () => _buildSlider(
                'Current Age',
                controller.currentAge.value.toDouble(),
                18,
                80,
                (value) => controller.updateAge(value.toInt()),
              ),
            ),
            Obx(
              () => _buildSlider(
                'Target Retirement Age',
                controller.targetRetirementAge.value.toDouble(),
                controller.currentAge.value.toDouble() + 1,
                100,
                (value) => controller.updateTargetAge(value.toInt()),
              ),
            ),
            Obx(
              () => _buildSlider(
                'Expected Return Rate (%)',
                controller.expectedReturnRate.value,
                0,
                15,
                (value) => controller.updateReturnRate(value),
              ),
            ),
            Obx(
              () => _buildSlider(
                'Safe Withdrawal Rate (%)',
                controller.safeWithdrawalRate.value,
                2,
                6,
                (value) => controller.updateWithdrawalRate(value),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.saveSettings();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BAF2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              value.toStringAsFixed(label.contains('%') ? 1 : 0),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00BAF2),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * (label.contains('%') ? 10 : 1)).toInt(),
          activeColor: const Color(0xFF00BAF2),
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
