import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class ActivityCategory {
  final int? id;
  final String? name;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  ActivityCategory({
    this.id,
    this.name,
    this.createdDate,
    this.updatedDate,
  });


  ActivityCategory copyWith({
    int? id,
    String? name,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return ActivityCategory(
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

  factory ActivityCategory.fromMap(Map<String, dynamic> map) {
    return ActivityCategory(
      id: map['id'],
      name: map['name'],
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']).toLocal() : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']).toLocal() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityCategory.fromJson(String source) => ActivityCategory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ActivityCategory(id: $id, name: $name, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ActivityCategory &&
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
