import 'package:expense_wise/app/modules/home/controllers/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expense_wise/app/modules/transactions/screens/recurring_view.dart';
import 'package:expense_wise/app/modules/settings/views/category_management_view.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: FadeTransition(
            opacity: controller.fadeInLeftAnimation,
            child: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SlideTransition(
          position: controller.slideUpAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF00BAF2), Color(0xFF002E6E)],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alex Johnson',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'alex@example.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/edit-profile');
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00BAF2).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFF00BAF2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00BAF2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return SlideTransition(
      position: controller.slideUpAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsSection(controller, 'Preferences', [
              Obx(
                () => _buildSettingItem(
                  controller,
                  index: 0,
                  icon: '💰',
                  iconColor: const Color(0xFFEF4444),
                  iconBackground: const Color(0xFFFEE2E2),
                  title: 'Currency',
                  subtitle:
                      '${controller.currencyCode.value} (${controller.currencySymbol.value})',
                  onTap: () => _showCurrencyPicker(context, controller),
                  action: const Text(
                    '›',
                    style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                  ),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 1,
                icon: '💳',
                iconColor: const Color(0xFF8B5CF6),
                iconBackground: const Color(0xFFF3E8FF),
                title: 'Accounts',
                subtitle: 'Manage your accounts',
                onTap: () => Get.toNamed('/accounts'),
                action: const Text(
                  '›',
                  style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 2,
                icon: '🏷️',
                iconColor: const Color(0xFFE91E63),
                iconBackground: const Color(0xFFFCE4EC),
                title: 'Categories',
                subtitle: 'Manage categories',
                onTap: () => Get.to(() => const CategoryManagementView()),
                action: const Text(
                  '›',
                  style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 2,
                icon: '🔄',
                iconColor: const Color(0xFF3B82F6),
                iconBackground: const Color(0xFFDBEAFE),
                title: 'Recurring',
                subtitle: 'Manage repeat transactions',
                action: GestureDetector(
                  onTap: () => Get.to(() => const RecurringTransactionsView()),
                  child: const Text(
                    '›',
                    style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                  ),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 3,
                icon: '🔔',
                iconColor: const Color(0xFF22C55E),
                iconBackground: const Color(0xFFDCFCE7),
                title: 'Daily Reminders',
                subtitle: 'Get reminded to track expenses',
                action: Obx(
                  () => _buildToggleSwitch(
                    controller.dailyReminders.value,
                    controller.toggleDailyReminders,
                  ),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 4,
                icon: '📱',
                iconColor: const Color(0xFFF59E0B),
                iconBackground: const Color(0xFFFEF3C7),
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                action: Obx(
                  () => _buildToggleSwitch(
                    controller.darkMode.value,
                    controller.toggleDarkMode,
                  ),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 5,
                icon: '🎯',
                iconColor: const Color(0xFF6366F1),
                iconBackground: const Color(0xFFE0E7FF),
                title: 'Budget Goals',
                subtitle: 'Set monthly spending limits',
                action: const Text(
                  '›',
                  style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                ),
              ),
            ]),
            const SizedBox(height: 32),
            _buildSettingsSection(controller, 'Data & Privacy', [
              _buildSettingItem(
                controller,
                index: 4,
                icon: '☁️',
                iconColor: const Color(0xFF8B5CF6),
                iconBackground: const Color(0xFFF3E8FF),
                title: 'Cloud Backup',
                subtitle: 'Auto-sync your data',
                action: Obx(
                  () => _buildToggleSwitch(
                    controller.cloudBackup.value,
                    controller.toggleCloudBackup,
                  ),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 5,
                icon: '📤',
                iconColor: const Color(0xFFEF4444),
                iconBackground: const Color(0xFFFECACA),
                title: 'Export Data',
                subtitle: 'Download your expense data',
                action: const Text(
                  '›',
                  style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 6,
                icon: '🔒',
                iconColor: const Color(0xFFE53E3E),
                iconBackground: const Color(0xFFFED7D7),
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                action: const Text(
                  '›',
                  style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                ),
              ),
            ]),
            const SizedBox(height: 32),
            _buildSettingsSection(controller, 'Support', [
              _buildSettingItem(
                controller,
                index: 7,
                icon: '❓',
                iconColor: const Color(0xFF3182CE),
                iconBackground: const Color(0xFFBEE3F8),
                title: 'Help Center',
                subtitle: 'Get help and tutorials',
                action: const Text(
                  '›',
                  style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 8,
                icon: '💬',
                iconColor: const Color(0xFF38A169),
                iconBackground: const Color(0xFFC6F6D5),
                title: 'Contact Us',
                subtitle: 'Send feedback or report issues',
                action: const Text(
                  '›',
                  style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                ),
              ),
              _buildSettingItem(
                controller,
                index: 9,
                icon: '⭐',
                iconColor: const Color(0xFFDD6B20),
                iconBackground: const Color(0xFFFAD8C7),
                title: 'Rate ExpenseWise',
                subtitle: 'Love the app? Leave a review',
                action: const Text(
                  '›',
                  style: TextStyle(fontSize: 16, color: Color(0xFFF7B500)),
                ),
              ),
            ]),
            // const SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: controller.fadeInAnimation,
                child: Container(
                  padding: const EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Version 2.1.0',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ExpenseWise',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF7B500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    SettingsController controller,
    String title,
    List<Widget> items,
  ) {
    return SlideTransition(
      position: controller.slideUpAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF666666),
              letterSpacing: 0.5,
            ),
          ),
          // const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    SettingsController controller, {
    required int index,
    required String icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
    required Widget action,
    VoidCallback? onTap,
  }) {
    // Calculate safe interval bounds to prevent exceeding 1.0
    final double startTime = 0.6 + (index * 0.03); // Reduced increment
    final double endTime = (startTime + 0.4).clamp(
      0.0,
      1.0,
    ); // Ensure it doesn't exceed 1.0

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller.animationController,
          curve: Interval(
            startTime.clamp(0.0, 1.0), // Ensure start doesn't exceed 1.0
            endTime,
            curve: Curves.easeOut,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: TextStyle(fontSize: 18, color: iconColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              action,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSwitch(bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF7B500) : const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: 2,
              left: isActive ? 20 : 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(
    BuildContext context,
    SettingsController controller,
  ) {
    final currencies = [
      {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
      {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
      {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
      {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
      {'code': 'JPY', 'symbol': '¥', 'name': 'Japanese Yen'},
      {'code': 'CNY', 'symbol': '¥', 'name': 'Chinese Yuan'},
      {'code': 'AUD', 'symbol': 'A\$', 'name': 'Australian Dollar'},
      {'code': 'CAD', 'symbol': 'C\$', 'name': 'Canadian Dollar'},
    ];

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF002E6E), Color(0xFF00BAF2)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Select Currency',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),

            // Currency List
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: currencies.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  final isSelected =
                      controller.currencyCode.value == currency['code'];

                  return GestureDetector(
                    onTap: () {
                      controller.changeCurrency(
                        currency['code']!,
                        currency['symbol']!,
                      );
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF00BAF2)
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Currency Symbol
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF002E6E),
                                        Color(0xFF00BAF2),
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
                            child: Center(
                              child: Text(
                                currency['symbol']!,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Currency Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currency['code']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? const Color(0xFF002E6E)
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currency['name']!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Check Icon
                          if (isSelected)
                            const Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: Color(0xFF00BAF2),
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
