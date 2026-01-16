import 'package:expense_wise/app/data/models/investment.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class InvestmentService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();

  /// Get all investments
  Future<List<Investment>> getAllInvestments() async {
    final db = _storageService.db;
    return await db.investments.where().findAll();
  }

  /// Get total portfolio value
  Future<double> getTotalPortfolioValue() async {
    final investments = await getAllInvestments();
    double total = 0;
    for (var inv in investments) {
      total += inv.currentValue;
    }
    return total;
  }

  /// Get total invested amount
  Future<double> getTotalInvested() async {
    final investments = await getAllInvestments();
    double total = 0;
    for (var inv in investments) {
      total += inv.totalInvested;
    }
    return total;
  }

  /// Get total profit/loss
  Future<double> getTotalProfitLoss() async {
    final investments = await getAllInvestments();
    double total = 0;
    for (var inv in investments) {
      total += inv.profitLoss;
    }
    return total;
  }

  /// Get overall ROI percentage
  Future<double> getOverallROI() async {
    final totalInvested = await getTotalInvested();
    final totalValue = await getTotalPortfolioValue();

    if (totalInvested == 0) return 0;
    return ((totalValue - totalInvested) / totalInvested) * 100;
  }

  /// Get portfolio allocation by type
  Future<Map<InvestmentType, double>> getPortfolioAllocation() async {
    final investments = await getAllInvestments();
    final allocation = <InvestmentType, double>{};

    for (var investment in investments) {
      allocation[investment.type] =
          (allocation[investment.type] ?? 0) + investment.currentValue;
    }

    return allocation;
  }

  /// Get portfolio allocation percentages
  Future<Map<InvestmentType, double>> getPortfolioAllocationPercentage() async {
    final allocation = await getPortfolioAllocation();
    final totalValue = await getTotalPortfolioValue();

    if (totalValue == 0) return {};

    return allocation.map(
      (type, value) => MapEntry(type, (value / totalValue) * 100),
    );
  }

  /// Get top performing investments
  Future<List<Investment>> getTopPerformers({int limit = 5}) async {
    final investments = await getAllInvestments();
    investments.sort(
      (a, b) => b.returnPercentage.compareTo(a.returnPercentage),
    );
    return investments.take(limit).toList();
  }

  /// Get worst performing investments
  Future<List<Investment>> getWorstPerformers({int limit = 5}) async {
    final investments = await getAllInvestments();
    investments.sort(
      (a, b) => a.returnPercentage.compareTo(b.returnPercentage),
    );
    return investments.take(limit).toList();
  }

  /// Add new investment
  Future<void> addInvestment(Investment investment) async {
    final db = _storageService.db;
    await db.writeTxn(() async {
      await db.investments.put(investment);
    });
  }

  /// Update investment
  Future<void> updateInvestment(Investment investment) async {
    final db = _storageService.db;
    await db.writeTxn(() async {
      await db.investments.put(investment);
    });
  }

  /// Delete investment
  Future<void> deleteInvestment(int id) async {
    final db = _storageService.db;
    await db.writeTxn(() async {
      await db.investments.delete(id);
    });
  }

  /// Update current price for an investment
  Future<void> updateCurrentPrice(int id, double newPrice) async {
    final db = _storageService.db;
    final investment = await db.investments.get(id);

    if (investment != null) {
      investment.currentPrice = newPrice;
      await db.writeTxn(() async {
        await db.investments.put(investment);
      });
    }
  }

  /// Get investments by type
  Future<List<Investment>> getInvestmentsByType(InvestmentType type) async {
    final investments = await getAllInvestments();
    return investments.where((inv) => inv.type == type).toList();
  }

  /// Get investment count
  Future<int> getInvestmentCount() async {
    final db = _storageService.db;
    return await db.investments.count();
  }
}
