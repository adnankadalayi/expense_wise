import 'package:expense_wise/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  var balance = 2847.50.obs;
  var weeklyChange = 127.30.obs;
  final transactions = <Transaction>[
    Transaction(
      title: 'Pizza Express',
      date: 'Today, 2:30 PM',
      amount: -24.50,
      isExpense: true,
      iconBackground: const Color(0xFFFEE2E2),
      icon: '🍕',
    ),
    Transaction(
      title: 'Freelance Payment',
      date: 'Yesterday, 4:15 PM',
      amount: 450.00,
      isExpense: false,
      iconBackground: const Color(0xFFDCFCE7),
      icon: '💰',
    ),
    Transaction(
      title: 'Coffee Shop',
      date: 'Yesterday, 8:45 AM',
      amount: -5.80,
      isExpense: true,
      iconBackground: const Color(0xFFFEF3C7),
      icon: '☕',
    ),
    Transaction(
      title: 'Gas Station',
      date: 'May 21, 6:20 PM',
      amount: -45.00,
      isExpense: true,
      iconBackground: const Color(0xFFE0E7FF),
      icon: '🚗',
    ),
    Transaction(
      title: 'Grocery Store',
      date: 'May 20, 3:15 PM',
      amount: -89.25,
      isExpense: true,
      iconBackground: const Color(0xFFF3E8FF),
      icon: '🛒',
    ),
  ].obs;

  var selectedNavIndex = 0.obs;

  late AnimationController animationController;
  late Animation<double> fadeInLeftAnimation;
  late Animation<Offset> slideUpAnimation;
  late Animation<double> fadeInRightAnimation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    fadeInLeftAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    slideUpAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    fadeInRightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void updateNavIndex(int index) {
    selectedNavIndex.value = index;
    update();
  }

  void addExpense() {
    // Placeholder for adding expense
  }

  void addIncome() {
    // Placeholder for adding income
  }
}
