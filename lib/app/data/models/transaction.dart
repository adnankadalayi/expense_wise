import 'package:isar_community/isar.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/account.dart';

part 'transaction.g.dart';

@collection
class Transaction {
  Id id = Isar.autoIncrement;

  double amount = 0.0;

  String? note;

  /// For transfers: ID of the paired transfer transaction
  int? linkedTransactionId;

  /// For transfers: Optional transfer fee
  double? transferFee;

  String? subCategory;

  late DateTime date;

  @enumerated
  late TransactionType type;

  final category = IsarLink<Category>();

  final account = IsarLink<Account>();

  final transferAccount = IsarLink<Account>();
}

enum TransactionType { expense, income, transfer }
