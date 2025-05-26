import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String date;
  final double amount;
  final bool isExpense;
  final Color iconBackground;
  final String icon;

  Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.isExpense,
    required this.iconBackground,
    required this.icon,
  });
}
