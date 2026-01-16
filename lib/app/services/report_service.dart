import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/report_data.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class ReportService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();

  /// Generate report data for a given date range
  Future<ReportData> generateReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final db = _storageService.db;

    // Get all transactions in the date range
    final transactions = await db.transactions
        .filter()
        .dateBetween(startDate, endDate)
        .findAll();

    // Load category links
    for (var tx in transactions) {
      await tx.category.load();
      await tx.account.load();
    }

    // Calculate totals
    double totalIncome = 0;
    double totalExpense = 0;

    for (var tx in transactions) {
      if (tx.type == TransactionType.income) {
        totalIncome += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        totalExpense += tx.amount;
      }
    }

    // Calculate category breakdown
    final categoryMap = <String, CategoryData>{};
    final categoryTotals = <String, double>{};
    final categoryCounts = <String, int>{};

    for (var tx in transactions) {
      if (tx.type != TransactionType.expense) continue;

      final category = tx.category.value;
      if (category == null) continue;

      final catId = category.id.toString();
      categoryTotals[catId] = (categoryTotals[catId] ?? 0) + tx.amount;
      categoryCounts[catId] = (categoryCounts[catId] ?? 0) + 1;

      if (!categoryMap.containsKey(catId)) {
        categoryMap[catId] = CategoryData(
          categoryName: category.name,
          categoryId: catId,
          amount: 0,
          transactionCount: 0,
          percentage: 0,
          colorHex: category.colorHex != null
              ? int.parse(category.colorHex!)
              : 0xFF2196F3,
          iconCodePoint: category.iconCodePoint ?? 0,
        );
      }
    }

    // Calculate percentages
    final categoryBreakdown = <String, CategoryData>{};
    categoryMap.forEach((catId, catData) {
      final amount = categoryTotals[catId] ?? 0;
      final count = categoryCounts[catId] ?? 0;
      final percentage = totalExpense > 0 ? (amount / totalExpense) * 100 : 0;

      categoryBreakdown[catId] = CategoryData(
        categoryName: catData.categoryName,
        categoryId: catId,
        amount: amount,
        transactionCount: count,
        percentage: percentage as double,
        colorHex: catData.colorHex,
        iconCodePoint: catData.iconCodePoint,
      );
    });

    // Calculate monthly trends
    final monthlyTrends = _calculateMonthlyTrends(
      transactions,
      startDate,
      endDate,
    );

    // Get account balances
    final accounts = await db.accounts.where().findAll();
    final accountBalances = <String, double>{};
    for (var account in accounts) {
      accountBalances[account.name] = account.balance;
    }

    return ReportData(
      startDate: startDate,
      endDate: endDate,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netAmount: totalIncome - totalExpense,
      categoryBreakdown: categoryBreakdown,
      monthlyTrends: monthlyTrends,
      accountBalances: accountBalances,
    );
  }

  /// Calculate monthly trends from transactions
  List<MonthlyData> _calculateMonthlyTrends(
    List<Transaction> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final monthlyMap = <String, MonthlyData>{};

    for (var tx in transactions) {
      final key = '${tx.date.year}-${tx.date.month}';

      if (!monthlyMap.containsKey(key)) {
        monthlyMap[key] = MonthlyData(
          year: tx.date.year,
          month: tx.date.month,
          income: 0,
          expense: 0,
          net: 0,
        );
      }

      final current = monthlyMap[key]!;
      if (tx.type == TransactionType.income) {
        monthlyMap[key] = MonthlyData(
          year: current.year,
          month: current.month,
          income: current.income + tx.amount,
          expense: current.expense,
          net: current.net + tx.amount,
        );
      } else if (tx.type == TransactionType.expense) {
        monthlyMap[key] = MonthlyData(
          year: current.year,
          month: current.month,
          income: current.income,
          expense: current.expense + tx.amount,
          net: current.net - tx.amount,
        );
      }
    }

    final trends = monthlyMap.values.toList();
    trends.sort((a, b) {
      final aDate = DateTime(a.year, a.month);
      final bDate = DateTime(b.year, b.month);
      return aDate.compareTo(bDate);
    });

    return trends;
  }

  /// Get date range from preset
  Map<String, DateTime> getDateRangeFromPreset(DateRangePreset preset) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    switch (preset) {
      case DateRangePreset.thisMonth:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case DateRangePreset.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        startDate = lastMonth;
        endDate = DateTime(lastMonth.year, lastMonth.month + 1, 0, 23, 59, 59);
        break;
      case DateRangePreset.last3Months:
        startDate = DateTime(now.year, now.month - 2, 1);
        break;
      case DateRangePreset.last6Months:
        startDate = DateTime(now.year, now.month - 5, 1);
        break;
      case DateRangePreset.thisYear:
        startDate = DateTime(now.year, 1, 1);
        break;
      case DateRangePreset.lastYear:
        startDate = DateTime(now.year - 1, 1, 1);
        endDate = DateTime(now.year - 1, 12, 31, 23, 59, 59);
        break;
      case DateRangePreset.custom:
        startDate = DateTime(now.year, now.month, 1);
        break;
    }

    return {'start': startDate, 'end': endDate};
  }

  /// Get top spending categories
  List<CategoryData> getTopCategories(ReportData report, {int limit = 5}) {
    final categories = report.categoryBreakdown.values.toList();
    categories.sort((a, b) => b.amount.compareTo(a.amount));
    return categories.take(limit).toList();
  }
}
