import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:traces/screens/settings/model/category.model.dart';

@immutable
class Expense {
  final int? id;
  final DateTime? date;
  final String? description;
  final double? amount;
  final String? currency;
  final double? amountUSD;
  final bool? isPaid;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final Category? category;
  Expense({
    this.id,
    this.date,    
    this.description,
    this.amount,
    this.currency,
    this.amountUSD,
    this.isPaid,
    this.createdDate,
    this.updatedDate,
    this.category
  });

  Expense copyWith({
    int? id,
    DateTime? date,    
    String? description,
    double? amount,
    String? currency,
    double? amountUSD,
    bool? isPaid,
    DateTime? createdDate,
    DateTime? updatedDate,
    Category? category
  }) {
    return Expense(
      id: id ?? this.id,
      date: date ?? this.date,      
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      amountUSD: amountUSD ?? this.amountUSD,
      isPaid: isPaid ?? this.isPaid,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      category: category ?? this.category
    );
  }

  Map<String, dynamic> toMap() {    
    return {
      'id': id,
      'date': date?.toIso8601String(),     
      'description': description,
      'amount': amount,
      'currency': currency,
      'amountUSD': amountUSD,
      'isPaid': isPaid,
      'category': category?.toMap()
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,    
      description: map['description'],
      amount: double.parse(map['amount']),
      currency: map['currency'],
      amountUSD: map['amountUSD'] != null ? double.parse(map['amountUSD']) : null,
      isPaid: map['isPaid'],
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
      category: map['expenseCategory'] != null ? Category.fromMap(map['expenseCategory']) : null
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) => Expense.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Expense(id: $id, date: $date, description: $description, amount: $amount, currency: $currency, amountUSD: $amountUSD, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Expense &&
      other.id == id &&
      other.date == date &&     
      other.description == description &&
      other.amount == amount &&
      other.currency == currency &&
      other.amountUSD == amountUSD &&
      other.isPaid == isPaid &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      date.hashCode ^   
      description.hashCode ^
      amount.hashCode ^
      currency.hashCode ^
      amountUSD.hashCode ^
      isPaid.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
 }
