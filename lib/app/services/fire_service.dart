import 'dart:math';
import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/fire_data.dart';
import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class FireService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();

  /// Calculate projected net worth over time
  List<ProjectionPoint> calculateNetWorthProjection({
    required double currentNetWorth,
    required double annualSavings,
    required double returnRate,
    required int years,
  }) {
    final projections = <ProjectionPoint>[];
    double balance = currentNetWorth;

    projections.add(ProjectionPoint(year: 0, amount: balance));

    for (int year = 1; year <= years; year++) {
      balance = balance * (1 + returnRate) + annualSavings;
      projections.add(ProjectionPoint(year: year, amount: balance));
    }

    return projections;
  }

  /// Calculate different FIRE scenarios
  Map<String, double> calculateFireScenarios(double annualExpenses) {
    return {
      'Lean FIRE': annualExpenses * 0.7 / 0.04, // 70% of expenses
      'FIRE': annualExpenses / 0.04, // Standard 4% rule
      'Fat FIRE': annualExpenses * 1.5 / 0.04, // 150% of expenses
    };
  }

  /// Get FIRE data from current financial situation
  Future<FireData?> getCurrentFireData({
    required int currentAge,
    required int targetRetirementAge,
  }) async {
    final db = _storageService.db;

    // Calculate current net worth from accounts
    final accounts = await db.accounts.where().findAll();
    double currentNetWorth = 0;
    for (var account in accounts) {
      if (!account.excludeFromTotal) {
        currentNetWorth += account.balance;
      }
    }

    // Calculate average monthly expenses from last 3 months
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

    final transactions = await db.transactions
        .filter()
        .dateBetween(threeMonthsAgo, now)
        .findAll();

    double totalExpenses = 0;
    double totalIncome = 0;

    for (var tx in transactions) {
      if (tx.type == TransactionType.expense) {
        totalExpenses += tx.amount;
      } else if (tx.type == TransactionType.income) {
        totalIncome += tx.amount;
      }
    }

    final monthlyExpenses = totalExpenses / 3;
    final monthlyIncome = totalIncome / 3;
    final monthlySavings = monthlyIncome - monthlyExpenses;

    if (monthlyExpenses == 0) return null;

    return FireData(
      currentAge: currentAge,
      targetRetirementAge: targetRetirementAge,
      currentNetWorth: currentNetWorth,
      monthlyExpenses: monthlyExpenses,
      monthlySavings: monthlySavings > 0 ? monthlySavings : 0,
    );
  }

  /// Save FIRE settings
  Future<void> saveFireSettings({
    required int currentAge,
    required int targetRetirementAge,
    required double expectedReturnRate,
    required double safeWithdrawalRate,
  }) async {
    await _storageService.saveSetting(
      'fire_current_age',
      currentAge.toString(),
    );
    await _storageService.saveSetting(
      'fire_target_age',
      targetRetirementAge.toString(),
    );
    await _storageService.saveSetting(
      'fire_return_rate',
      expectedReturnRate.toString(),
    );
    await _storageService.saveSetting(
      'fire_withdrawal_rate',
      safeWithdrawalRate.toString(),
    );
  }

  /// Load FIRE settings
  Future<Map<String, dynamic>> loadFireSettings() async {
    return {
      'currentAge':
          int.tryParse(
            await _storageService.getSetting('fire_current_age') ?? '30',
          ) ??
          30,
      'targetRetirementAge':
          int.tryParse(
            await _storageService.getSetting('fire_target_age') ?? '65',
          ) ??
          65,
      'expectedReturnRate':
          double.tryParse(
            await _storageService.getSetting('fire_return_rate') ?? '0.07',
          ) ??
          0.07,
      'safeWithdrawalRate':
          double.tryParse(
            await _storageService.getSetting('fire_withdrawal_rate') ?? '0.04',
          ) ??
          0.04,
    };
  }

  /// Calculate savings rate needed for specific FIRE timeline
  double calculateRequiredSavingsRate({
    required double currentNetWorth,
    required double fireNumber,
    required int yearsToFire,
    required double annualIncome,
    required double returnRate,
  }) {
    if (yearsToFire <= 0 || annualIncome <= 0) return 0;

    final futureValueOfCurrentSavings =
        currentNetWorth * pow(1 + returnRate, yearsToFire);
    final additionalNeeded = fireNumber - futureValueOfCurrentSavings;

    if (additionalNeeded <= 0) return 0;

    // Calculate annual savings needed using future value of annuity formula
    final annualSavingsNeeded =
        additionalNeeded * returnRate / (pow(1 + returnRate, yearsToFire) - 1);

    return (annualSavingsNeeded / annualIncome) * 100;
  }
}

class ProjectionPoint {
  final int year;
  final double amount;

  ProjectionPoint({required this.year, required this.amount});
}
