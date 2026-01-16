import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<NotificationService> init() async {
    // Initialize notification settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
    return this;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // Navigate to relevant screen based on payload
    if (response.payload != null) {
      // Parse payload and navigate
      // e.g., Get.toNamed('/budgets');
    }
  }

  /// Show a budget limit notification
  Future<void> showBudgetNotification({
    required int budgetId,
    required String categoryName,
    required double spentAmount,
    required double budgetLimit,
    required double percentage,
  }) async {
    if (!_initialized) return;

    const androidDetails = AndroidNotificationDetails(
      'budget_alerts',
      'Budget Alerts',
      channelDescription: 'Notifications for budget limits and warnings',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = percentage >= 100 ? '⚠️ Budget Exceeded!' : '⚠️ Budget Alert';

    final body = percentage >= 100
        ? 'You\'ve exceeded your $categoryName budget! Spent: \$${spentAmount.toStringAsFixed(0)} of \$${budgetLimit.toStringAsFixed(0)}'
        : 'You\'ve reached ${percentage.toStringAsFixed(0)}% of your $categoryName budget (\$${spentAmount.toStringAsFixed(0)} of \$${budgetLimit.toStringAsFixed(0)})';

    await _notifications.show(
      budgetId,
      title,
      body,
      details,
      payload: 'budget:$budgetId',
    );
  }

  /// Show a recurring transaction reminder
  Future<void> showRecurringTransactionReminder({
    required int recurringId,
    required String title,
    required String description,
    required double amount,
  }) async {
    if (!_initialized) return;

    const androidDetails = AndroidNotificationDetails(
      'recurring_reminders',
      'Recurring Transaction Reminders',
      channelDescription: 'Reminders for upcoming recurring transactions',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      recurringId + 10000, // Offset to avoid ID conflicts
      '🔄 $title',
      '$description - \$${amount.toStringAsFixed(2)}',
      details,
      payload: 'recurring:$recurringId',
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
