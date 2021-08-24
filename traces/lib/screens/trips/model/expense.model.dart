import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class Expense {
  final int? id; 
  final DateTime? date;
  final String? name;
  final String? category;
  final String? description;
  final double? amount;
  final String? currency;
  final bool? isPaid;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  Expense({
    this.id,
    this.date,
    this.name,
    this.category,
    this.description,
    this.amount,
    this.currency,
    this.isPaid,
    this.createdDate,
    this.updatedDate
  });

  Expense copyWith({
    int? id,
    DateTime? date,
    String? name,
    String? category,
    String? description,
    double? amount,
    String? currency,
    bool? isPaid,
    DateTime? createdDate,
    DateTime? updatedDate
  }) {
    return Expense(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      isPaid: isPaid ?? this.isPaid,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'name': name,
      'category': category,
      'description': description,
      'amount': amount,
      'currency': currency,
      'isPaid': isPaid,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      date: map['date'] != null ? DateTime.parse(map['date']).toLocal() : null,
      name: map['name'],
      category: map['category'],
      description: map['description'],
      amount: double.parse(map['amount']),
      currency: map['currency'],
      isPaid: map['isPaid'],
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']).toLocal() : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']).toLocal() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) => Expense.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Expense(id: $id, date: $date, name: $name, category: $category, description: $description, amount: $amount, currency: $currency, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Expense &&
      other.id == id &&
      other.date == date &&
      other.name == name &&
      other.category == category &&
      other.description == description &&
      other.amount == amount &&
      other.currency == currency &&
      other.isPaid == isPaid &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      date.hashCode ^
      name.hashCode ^
      category.hashCode ^
      description.hashCode ^
      amount.hashCode ^
      currency.hashCode ^
      isPaid.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
 }
