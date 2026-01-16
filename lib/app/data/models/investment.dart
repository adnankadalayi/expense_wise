import 'package:isar_community/isar.dart';

part 'investment.g.dart';

@collection
class Investment {
  Id id = Isar.autoIncrement;

  /// Investment name (e.g., "Apple Inc.", "Bitcoin")
  late String name;

  /// Symbol/ticker (e.g., "AAPL", "BTC")
  late String symbol;

  /// Type of investment
  @enumerated
  late InvestmentType type;

  /// Number of shares/units owned
  late double quantity;

  /// Price per unit at purchase
  late double purchasePrice;

  /// Current market price per unit
  late double currentPrice;

  /// Date of purchase
  late DateTime purchaseDate;

  /// Optional notes
  String? notes;

  /// Total amount invested
  double get totalInvested => quantity * purchasePrice;

  /// Current total value
  double get currentValue => quantity * currentPrice;

  /// Profit or loss
  double get profitLoss => currentValue - totalInvested;

  /// Return percentage
  double get returnPercentage {
    if (totalInvested == 0) return 0;
    return ((currentValue - totalInvested) / totalInvested) * 100;
  }

  /// Is this investment profitable?
  bool get isProfitable => profitLoss > 0;
}

enum InvestmentType { stock, crypto, mutualFund, bond, etf, realEstate, other }

extension InvestmentTypeExtension on InvestmentType {
  String get displayName {
    switch (this) {
      case InvestmentType.stock:
        return 'Stock';
      case InvestmentType.crypto:
        return 'Cryptocurrency';
      case InvestmentType.mutualFund:
        return 'Mutual Fund';
      case InvestmentType.bond:
        return 'Bond';
      case InvestmentType.etf:
        return 'ETF';
      case InvestmentType.realEstate:
        return 'Real Estate';
      case InvestmentType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case InvestmentType.stock:
        return '📈';
      case InvestmentType.crypto:
        return '₿';
      case InvestmentType.mutualFund:
        return '📊';
      case InvestmentType.bond:
        return '📜';
      case InvestmentType.etf:
        return '📉';
      case InvestmentType.realEstate:
        return '🏠';
      case InvestmentType.other:
        return '💼';
    }
  }
}
