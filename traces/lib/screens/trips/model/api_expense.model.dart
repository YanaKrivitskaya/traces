
import 'dart:convert';
import 'package:flutter/material.dart';
import 'expense.model.dart';

@immutable
class ApiExpenseModel {
  final int tripId;
  final Expense expense;  
  ApiExpenseModel({
    required this.tripId,
    required this.expense,
  });

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'expense': expense.toMap(),
    };
  }
  String toJson() => json.encode(toMap());
}
