import 'package:isar_community/isar.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  late String name;

  int? iconCodePoint;

  String? colorHex;

  @enumerated
  late CategoryType type;

  bool isCustom = false;
}

enum CategoryType { expense, income }
