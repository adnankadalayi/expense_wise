class ReportData {
  final DateTime startDate;
  final DateTime endDate;
  final double totalIncome;
  final double totalExpense;
  final double netAmount;
  final Map<String, CategoryData> categoryBreakdown;
  final List<MonthlyData> monthlyTrends;
  final Map<String, double> accountBalances;

  ReportData({
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpense,
    required this.netAmount,
    required this.categoryBreakdown,
    required this.monthlyTrends,
    required this.accountBalances,
  });

  double get averageDailySpending {
    final days = endDate.difference(startDate).inDays + 1;
    return days > 0 ? totalExpense / days : 0;
  }

  double get savingsRate {
    if (totalIncome == 0) return 0;
    return ((totalIncome - totalExpense) / totalIncome) * 100;
  }
}

class CategoryData {
  final String categoryName;
  final String categoryId;
  final double amount;
  final int transactionCount;
  final double percentage;
  final int colorHex;
  final int iconCodePoint;

  CategoryData({
    required this.categoryName,
    required this.categoryId,
    required this.amount,
    required this.transactionCount,
    required this.percentage,
    required this.colorHex,
    required this.iconCodePoint,
  });
}

class MonthlyData {
  final int year;
  final int month;
  final double income;
  final double expense;
  final double net;

  MonthlyData({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
    required this.net,
  });

  String get monthName {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

enum ReportType { summary, detailed, categoryBreakdown, monthlyComparison }

enum DateRangePreset {
  thisMonth,
  lastMonth,
  last3Months,
  last6Months,
  thisYear,
  lastYear,
  custom,
}
