import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class Category {
  final int? id;
  final String? name;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  Category({
    this.id,
    this.name,
    this.createdDate,
    this.updatedDate,
  });


  Category copyWith({
    int? id,
    String? name,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, name: $name, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Category &&
      other.id == id &&
      other.name == name &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
