import 'package:isar_community/isar.dart';
import 'package:expense_wise/app/data/models/category.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;

  /// The budget limit amount
  double amount = 0.0;

  /// Budget period (weekly, monthly, yearly)
  @enumerated
  BudgetPeriod period = BudgetPeriod.monthly;

  /// Notification threshold percentage (e.g., 80 means notify at 80% of budget)
  double notificationThreshold = 80.0;

  /// Whether notifications are enabled for this budget
  bool isNotificationEnabled = true;

  /// Whether this budget is active
  bool isActive = true;

  /// Linked category for this budget
  final category = IsarLink<Category>();

  /// Calculate budget progress percentage
  double getProgressPercentage(double currentSpending) {
    if (amount <= 0) return 0;
    return (currentSpending / amount) * 100;
  }

  /// Check if budget has exceeded the limit
  bool isExceeded(double currentSpending) {
    return currentSpending > amount;
  }

  /// Check if budget has reached notification threshold
  bool shouldNotify(double currentSpending) {
    if (!isNotificationEnabled) return false;
    final progress = getProgressPercentage(currentSpending);
    return progress >= notificationThreshold && progress < 100;
  }

  /// Check if budget is in warning state (exceeded or near limit)
  bool isInWarning(double currentSpending) {
    final progress = getProgressPercentage(currentSpending);
    return progress >= notificationThreshold;
  }
}

enum BudgetPeriod { weekly, monthly, yearly }
