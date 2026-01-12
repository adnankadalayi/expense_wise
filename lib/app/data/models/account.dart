import 'package:isar_community/isar.dart';

part 'account.g.dart';

@collection
class Account {
  Id id = Isar.autoIncrement;

  late String name;

  @enumerated
  late AccountType type;

  /// The current balance of the account.
  /// For manually tracked accounts, this is set by the user.
  double balance = 0.0;

  /// Currency code (e.g., USD, EUR).
  String currency = 'USD';

  /// Icon codepoint (to be used with IconData).
  int? iconCodePoint;

  /// Hex color string (e.g., '0xFF0000').
  String? colorHex;

  /// Whether to show this account on the Home screen.
  bool showOnHome = true;

  /// Whether to exclude this account's balance from the total balance calculation.
  bool excludeFromTotal = false;
}

enum AccountType { bank, wallet, ewallet, other }
