import 'package:isar_community/isar.dart';
import 'package:expense_wise/app/data/models/category.dart';

part 'budget.g.dart';

@collection
class Budget {
  Id id = Isar.autoIncrement;

  double amount = 0.0;

  @enumerated
  BudgetPeriod period = BudgetPeriod.monthly;

  final category = IsarLink<Category>();
}

enum BudgetPeriod { weekly, monthly, yearly }
