import 'dart:convert';

import 'package:flutter/material.dart';

import 'category.model.dart';

@immutable
class CategoryUsage {
  final int activitiesCount;
  final int expensesCount;
  final Category category;

  CategoryUsage({
    required this.activitiesCount,
    required this.expensesCount,
    required this.category,
  });

  CategoryUsage copyWith({
    int? activitiesCount,
    int? expensesCount,
    Category? category,
  }) {
    return CategoryUsage(
      activitiesCount: activitiesCount ?? this.activitiesCount,
      expensesCount: expensesCount ?? this.expensesCount,
      category: category ?? this.category,
    );
  }

  factory CategoryUsage.fromMap(Map<String, dynamic> map) {
    print("bla!");
    return CategoryUsage(
      activitiesCount: map['activitiesCount']?.toInt() ?? 0,
      expensesCount: map['expensesCount']?.toInt() ?? 0,
      category: Category.fromMap(map['category']),
    );
  }

  factory CategoryUsage.fromJson(String source) => CategoryUsage.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryUsage(activitiesCount: $activitiesCount, expensesCount: $expensesCount, category: $category)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CategoryUsage &&
      other.activitiesCount == activitiesCount &&
      other.expensesCount == expensesCount &&
      other.category == category;
  }

  @override
  int get hashCode => activitiesCount.hashCode ^ expensesCount.hashCode ^ category.hashCode;
}
