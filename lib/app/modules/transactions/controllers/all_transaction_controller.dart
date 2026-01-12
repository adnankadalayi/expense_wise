import 'package:expense_wise/app/data/models/transaction.dart';
import 'package:expense_wise/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';

class AllTransactionController extends GetxController
    with GetTickerProviderStateMixin {
  final StorageService _storageService = Get.find<StorageService>();

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  RxString activeFilter = 'All'.obs;
  RxBool isSearchVisible = false.obs;
  RxString searchQuery = ''.obs;

  final List<String> filterTabs = ['All', 'Expenses', 'Income', 'This Month'];

  // Real Data: List of grouped transactions
  // Structure: [{'month': 'May 2025', 'total': 123.0, 'transactions': [Transaction objects...]}]
  var groupedTransactions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    setupAnimations();
    loadTransactions();
  }

  void setupAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        );
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void setActiveFilter(String filter) {
    activeFilter.value = filter;
    loadTransactions();
  }

  void toggleSearch() {
    isSearchVisible.value = !isSearchVisible.value;
    if (!isSearchVisible.value) {
      searchQuery.value = '';
      loadTransactions();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    // 1. Build Query
    QueryBuilder<Transaction, Transaction, QWhere> query = _storageService
        .db
        .transactions
        .where();

    // 2. Fetch all sorted by date descending
    var allTxs = await query.sortByDateDesc().findAll();

    // 3. Filter in memory (easier for complex logic like search text)
    // In production with huge data, build Isar query filters instead.

    if (activeFilter.value == 'Expenses') {
      allTxs = allTxs.where((t) => t.type == TransactionType.expense).toList();
    } else if (activeFilter.value == 'Income') {
      allTxs = allTxs.where((t) => t.type == TransactionType.income).toList();
    } else if (activeFilter.value == 'This Month') {
      final now = DateTime.now();
      allTxs = allTxs
          .where((t) => t.date.year == now.year && t.date.month == now.month)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      // pre-load categories to search names?
      allTxs = allTxs.where((t) {
        final noteMatch = t.note?.toLowerCase().contains(q) ?? false;
        final catMatch =
            t.category.value?.name.toLowerCase().contains(q) ?? false;
        return noteMatch || catMatch;
      }).toList();
    }

    // 4. Group by Month
    final grouped = <String, Map<String, dynamic>>{};

    for (var tx in allTxs) {
      await tx.category.load(); // Ensure loaded
      final monthKey = DateFormat('MMMM yyyy').format(tx.date);

      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = {
          'month': monthKey,
          'total': 0.0,
          'transactions': <Transaction>[],
          'sortDate': DateTime(
            tx.date.year,
            tx.date.month,
          ), // helper for sorting groups
        };
      }

      grouped[monthKey]!['transactions'].add(tx);

      // Calculate total for month (Net: Income - Expense)
      if (tx.type == TransactionType.income) {
        grouped[monthKey]!['total'] += tx.amount;
      } else {
        grouped[monthKey]!['total'] -= tx.amount;
      }
    }

    // Convert to list and sort groups descending
    final result = grouped.values.toList();
    result.sort(
      (a, b) =>
          (b['sortDate'] as DateTime).compareTo(a['sortDate'] as DateTime),
    );

    groupedTransactions.assignAll(result);
  }
}
