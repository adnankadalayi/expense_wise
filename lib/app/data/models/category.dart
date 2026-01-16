import 'package:isar_community/isar.dart';

part 'category.g.dart';

@embedded
class SubCategory {
  late String name;
  int? iconCodePoint;
  String? colorHex;
}

@collection
class Category {
  Id id = Isar.autoIncrement;

  late String name;

  int? iconCodePoint;

  String? colorHex;

  @enumerated
  late CategoryType type;

  bool isCustom = false;

  List<SubCategory>? subCategories;
}

enum CategoryType { expense, income }
