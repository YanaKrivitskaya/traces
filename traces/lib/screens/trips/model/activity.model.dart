import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class Activity {
  final int? id;
  final int? expenseId;
  final String name;
  final DateTime? date;
  final String? description;
  final String? image;
  final bool? isPlanned;
  final bool? isCompleted;
  Activity({
    this.id,
    this.expenseId,
    required this.name,    
    this.description,
    this.date,
    this.image,
    this.isPlanned,
    this.isCompleted,
  });

  Activity copyWith({
    int? id,
    int? expenseId,
    String? name,    
    String? description,
    DateTime? date,
    String? image,
    bool? isPlanned,
    bool? isCompleted,
  }) {
    return Activity(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      name: name ?? this.name,     
      description: description ?? this.description,
      date: date ?? this.date,
      image: image ?? this.image,
      isPlanned: isPlanned ?? this.isPlanned,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
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
      description: map['description'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      image: map['image'],
      isPlanned: map['isPlanned'],
      isCompleted: map['isCompleted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Activity.fromJson(String source) => Activity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TripAction(id: $id, name: $name, description: $description, date: $date, image: $image, isPlanned: $isPlanned, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Activity &&
      other.id == id &&
      other.expenseId == expenseId &&
      other.name == name &&
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
      description.hashCode ^
      date.hashCode ^
      image.hashCode ^
      isPlanned.hashCode ^
      isCompleted.hashCode;
  }
}
