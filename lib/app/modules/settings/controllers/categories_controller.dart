import 'package:expense_wise/app/data/models/category.dart';
import 'package:flutter/material.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

class CategoriesController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  var expenseCategories = <Category>[].obs;
  var incomeCategories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() async {
    final categories = await _storageService.db.categorys.where().findAll();

    if (categories.isEmpty) {
      await _seedDefaultCategories();
      // Recursive call to load the newly seeded categories
      loadCategories();
      return;
    }

    expenseCategories.assignAll(
      categories.where((c) => c.type == CategoryType.expense).toList(),
    );
    incomeCategories.assignAll(
      categories.where((c) => c.type == CategoryType.income).toList(),
    );
  }

  Future<void> _seedDefaultCategories() async {
    final defaults = [
      // Expense Categories
      Category()
        ..name = 'Food'
        ..type = CategoryType.expense
        ..colorHex =
            '0xFFFF9800' // Orange
        ..iconCodePoint = Icons.restaurant.codePoint
        ..subCategories = ['Groceries', 'Restaurants', 'Snacks', 'Coffee']
        ..isCustom = false,
      Category()
        ..name = 'Transportation'
        ..type = CategoryType.expense
        ..colorHex =
            '0xFF2196F3' // Blue
        ..iconCodePoint = Icons.directions_car.codePoint
        ..subCategories = ['Fuel', 'Public Transport', 'Maintenance', 'Parking']
        ..isCustom = false,
      Category()
        ..name = 'Housing'
        ..type = CategoryType.expense
        ..colorHex =
            '0xFF795548' // Brown
        ..iconCodePoint = Icons.home.codePoint
        ..subCategories = ['Rent', 'Utilities', 'Internet', 'Maintenance']
        ..isCustom = false,
      Category()
        ..name = 'Entertainment'
        ..type = CategoryType.expense
        ..colorHex =
            '0xFF9C27B0' // Purple
        ..iconCodePoint = Icons.movie.codePoint
        ..subCategories = ['Movies', 'Games', 'Subscriptions', 'Hobbies']
        ..isCustom = false,
      Category()
        ..name = 'Health'
        ..type = CategoryType.expense
        ..colorHex =
            '0xFFF44336' // Red
        ..iconCodePoint = Icons.local_hospital.codePoint
        ..subCategories = ['Doctor', 'Pharmacy', 'Fitness', 'Insurance']
        ..isCustom = false,
      Category()
        ..name = 'Shopping'
        ..type = CategoryType.expense
        ..colorHex =
            '0xFFE91E63' // Pink
        ..iconCodePoint = Icons.shopping_bag.codePoint
        ..subCategories = ['Clothing', 'Electronics', 'Home & Garden']
        ..isCustom = false,

      // Income Categories
      Category()
        ..name = 'Salary'
        ..type = CategoryType.income
        ..colorHex =
            '0xFF4CAF50' // Green
        ..iconCodePoint = Icons.attach_money.codePoint
        ..subCategories = ['Full-time', 'Bonus', 'Commission']
        ..isCustom = false,
      Category()
        ..name = 'Freelance'
        ..type = CategoryType.income
        ..colorHex =
            '0xFF009688' // Teal
        ..iconCodePoint = Icons.computer.codePoint
        ..subCategories = ['Projects', 'Consulting']
        ..isCustom = false,
      Category()
        ..name = 'Investments'
        ..type = CategoryType.income
        ..colorHex =
            '0xFF3F51B5' // Indigo
        ..iconCodePoint = Icons.trending_up.codePoint
        ..subCategories = ['Dividends', 'Interest', 'Crypto']
        ..isCustom = false,
    ];

    await _storageService.db.writeTxn(() async {
      await _storageService.db.categorys.putAll(defaults);
    });
  }

  Future<void> addCategory({
    required String name,
    required CategoryType type,
    required String colorHex,
    required int iconCodePoint,
    List<String> subCategories = const [],
  }) async {
    final newCategory = Category()
      ..name = name
      ..type = type
      ..colorHex = colorHex
      ..iconCodePoint = iconCodePoint
      ..subCategories = subCategories
      ..isCustom = true;

    await _storageService.db.writeTxn(() async {
      await _storageService.db.categorys.put(newCategory);
    });
    loadCategories();
  }

  Future<void> updateCategory(
    Category category, {
    String? name,
    String? colorHex,
    int? iconCodePoint,
    List<String>? subCategories,
  }) async {
    await _storageService.db.writeTxn(() async {
      if (name != null) category.name = name;
      if (colorHex != null) category.colorHex = colorHex;
      if (iconCodePoint != null) category.iconCodePoint = iconCodePoint;
      if (subCategories != null) category.subCategories = subCategories;
      await _storageService.db.categorys.put(category);
    });
    loadCategories();
  }

  Future<void> deleteCategory(Category category) async {
    await _storageService.db.writeTxn(() async {
      await _storageService.db.categorys.delete(category.id);
    });
    loadCategories();
  }
}
