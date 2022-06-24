
import 'dart:convert';

import 'package:flutter/material.dart';

class ExpenseChartData {
  final String categoryName;
  final double amount;
  final String currency;
  final double amountPercent;
  final Color? color;
  ExpenseChartData({
    required this.categoryName,
    required this.amount,
    required this.currency,
    required this.amountPercent,
    this.color,
  });

  ExpenseChartData copyWith({
    String? categoryName,
    double? amount,
    String? currency,
    double? amountPercent,
    Color? color,
  }) {
    return ExpenseChartData(
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      amountPercent: amountPercent ?? this.amountPercent,
      color: color ?? this.color,
    );
  }  

  @override
  String toString() {
    return 'ExpenseChartModel(categoryName: $categoryName, amount: $amount, currency: $currency, amountPercent: $amountPercent, color: $color)';
  }


}
