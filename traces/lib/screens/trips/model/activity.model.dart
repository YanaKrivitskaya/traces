import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/expense.model.dart';

import 'category.model.dart';

@immutable
class Activity {
  final int? id;
  final int? expenseId;
  final String? name;
  final String? location;
  final DateTime? date;
  final String? description;
  final String? image;
  final bool? isPlanned;
  final bool? isCompleted;
  final Category? category;
  final Expense? expense;
  Activity({
    this.id,
    this.expenseId,
    this.name,
    this.location,   
    this.description,
    this.date,
    this.image,
    this.isPlanned,
    this.isCompleted,
    this.category,
    this.expense
  });

  Activity copyWith({
    int? id,
    int? expenseId,
    String? name,
    String? location,  
    String? description,
    DateTime? date,
    String? image,
    bool? isPlanned,
    bool? isCompleted,
    Category? category,
    Expense? expense
  }) {
    return Activity(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      date: date ?? this.date,
      image: image ?? this.image,
      isPlanned: isPlanned ?? this.isPlanned,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      expense: expense ?? this.expense
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'date': date?.toIso8601String(),
      'image': image,
      'isPlanned': isPlanned,
      'isCompleted': isCompleted,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      expenseId: map['expenseId'],
      name: map['name'],
      location: map['location'],
      description: map['description'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      image: map['image'],
      isPlanned: map['isPlanned'],
      isCompleted: map['isCompleted'],
      category: map['category'] != null ? Category.fromMap(map['activityCategory']) : null, 
      expense: map['expense'] != null ? Expense.fromMap(map['expense']) : null
    );
  }

  String toJson() => json.encode(toMap());

  factory Activity.fromJson(String source) => Activity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Activity(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Activity &&
      other.id == id &&
      other.expenseId == expenseId &&
      other.name == name &&
      other.location == location &&
      other.description == description &&
      other.date == date &&
      other.image == image &&
      other.isPlanned == isPlanned &&
      other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      expenseId.hashCode ^
      name.hashCode ^
      location.hashCode ^
      description.hashCode ^
      date.hashCode ^
      image.hashCode ^
      isPlanned.hashCode ^
      isCompleted.hashCode;
  }
}
