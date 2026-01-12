import 'package:isar_community/isar.dart';
import 'package:expense_wise/app/data/models/category.dart';
import 'package:expense_wise/app/data/models/account.dart';
import 'package:expense_wise/app/data/models/transaction.dart';

part 'recurring_transaction.g.dart';

enum RecurringInterval { daily, weekly, monthly, yearly }

@collection
class RecurringTransaction {
  Id id = Isar.autoIncrement;

  double amount = 0.0;
  String? note;

  @enumerated
  TransactionType type = TransactionType.expense;

  @enumerated
  RecurringInterval interval = RecurringInterval.monthly;

  DateTime nextRunDate = DateTime.now();

  bool isActive = true;

  final category = IsarLink<Category>();
  final account = IsarLink<Account>();
}
