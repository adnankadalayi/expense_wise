import 'dart:math';

class FireData {
  final int currentAge;
  final int targetRetirementAge;
  final double currentNetWorth;
  final double monthlyExpenses;
  final double monthlySavings;
  final double expectedReturnRate; // Annual return rate (e.g., 0.07 for 7%)
  final double safeWithdrawalRate; // Typically 0.04 (4%)

  FireData({
    required this.currentAge,
    required this.targetRetirementAge,
    required this.currentNetWorth,
    required this.monthlyExpenses,
    required this.monthlySavings,
    this.expectedReturnRate = 0.07,
    this.safeWithdrawalRate = 0.04,
  });

  /// Annual expenses
  double get annualExpenses => monthlyExpenses * 12;

  /// Annual savings
  double get annualSavings => monthlySavings * 12;

  /// FIRE number (amount needed to retire)
  double get fireNumber => annualExpenses / safeWithdrawalRate;

  /// Current FIRE progress percentage
  double get fireProgress => (currentNetWorth / fireNumber) * 100;

  /// Savings rate percentage
  double get savingsRate {
    final monthlyIncome = monthlySavings + monthlyExpenses;
    if (monthlyIncome <= 0) return 0;
    return (monthlySavings / monthlyIncome) * 100;
  }

  /// Years to FIRE based on current savings rate
  double get yearsToFire {
    if (annualSavings <= 0) return double.infinity;
    if (currentNetWorth >= fireNumber) return 0;

    // Using compound interest formula
    // FV = PV(1+r)^n + PMT * [((1+r)^n - 1) / r]
    // Solving for n when FV = fireNumber

    final r = expectedReturnRate;
    final pv = currentNetWorth;
    final pmt = annualSavings;
    final fv = fireNumber;

    if (r == 0) {
      return (fv - pv) / pmt;
    }

    // Iterative approach for more accuracy
    double years = 0;
    double balance = pv;

    while (balance < fv && years < 100) {
      balance = balance * (1 + r) + pmt;
      years++;
    }

    return years;
  }

  /// Projected retirement date
  DateTime get projectedRetirementDate {
    final years = yearsToFire.isFinite ? yearsToFire.ceil() : 0;
    return DateTime.now().add(Duration(days: (years * 365).toInt()));
  }

  /// Required monthly savings to retire at target age
  double get requiredMonthlySavings {
    final yearsToTarget = targetRetirementAge - currentAge;
    if (yearsToTarget <= 0) return 0;

    final r = expectedReturnRate;
    final n = yearsToTarget.toDouble();
    final fv = fireNumber;
    final pv = currentNetWorth;

    if (r == 0) {
      return (fv - pv) / (n * 12);
    }

    // PMT = (FV - PV(1+r)^n) * r / ((1+r)^n - 1)
    final futureValueOfCurrentSavings = pv * pow(1 + r, n);
    final annualPayment =
        (fv - futureValueOfCurrentSavings) * r / (pow(1 + r, n) - 1);

    return annualPayment / 12;
  }

  /// Check if on track to retire at target age
  bool get isOnTrack {
    return monthlySavings >= requiredMonthlySavings;
  }

  /// FIRE level achieved
  FireLevel get fireLevel {
    final progress = fireProgress;
    if (progress >= 100) return FireLevel.fatFire;
    if (progress >= 75) return FireLevel.fire;
    if (progress >= 50) return FireLevel.baristaFire;
    if (progress >= 25) return FireLevel.coastFire;
    return FireLevel.building;
  }

  /// Lean FIRE number (minimal expenses)
  double get leanFireNumber => fireNumber * 0.7;

  /// Fat FIRE number (comfortable lifestyle)
  double get fatFireNumber => fireNumber * 1.5;

  /// Coast FIRE - amount needed to stop saving and let investments grow
  double coastFireAmount(int yearsToRetirement) {
    if (yearsToRetirement <= 0) return fireNumber;
    // PV = FV / (1 + r)^n
    return fireNumber / pow(1 + expectedReturnRate, yearsToRetirement);
  }
}

enum FireLevel { building, coastFire, baristaFire, fire, fatFire }

extension FireLevelExtension on FireLevel {
  String get displayName {
    switch (this) {
      case FireLevel.building:
        return 'Building Wealth';
      case FireLevel.coastFire:
        return 'Coast FIRE';
      case FireLevel.baristaFire:
        return 'Barista FIRE';
      case FireLevel.fire:
        return 'FIRE';
      case FireLevel.fatFire:
        return 'Fat FIRE';
    }
  }

  String get description {
    switch (this) {
      case FireLevel.building:
        return 'Building your foundation for financial independence';
      case FireLevel.coastFire:
        return 'Can stop saving - investments will grow to FIRE';
      case FireLevel.baristaFire:
        return 'Part-time work covers expenses';
      case FireLevel.fire:
        return 'Full financial independence achieved!';
      case FireLevel.fatFire:
        return 'Comfortable lifestyle with extra cushion';
    }
  }
}
