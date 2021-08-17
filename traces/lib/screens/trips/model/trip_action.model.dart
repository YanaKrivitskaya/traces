import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class TripAction {
  final int? id;
  final String name;
  final String? description;
  final String? image;
  final bool? isPlanned;
  final bool? isCompleted;
  TripAction({
    this.id,
    required this.name,
    this.description,
    this.image,
    this.isPlanned,
    this.isCompleted,
  });

  TripAction copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    bool? isPlanned,
    bool? isCompleted,
  }) {
    return TripAction(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
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
      'image': image,
      'isPlanned': isPlanned,
      'isCompleted': isCompleted,
    };
  }

  factory TripAction.fromMap(Map<String, dynamic> map) {
    return TripAction(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      image: map['image'],
      isPlanned: map['isPlanned'],
      isCompleted: map['isCompleted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TripAction.fromJson(String source) => TripAction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TripAction(id: $id, name: $name, description: $description, image: $image, isPlanned: $isPlanned, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TripAction &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.image == image &&
      other.isPlanned == isPlanned &&
      other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      image.hashCode ^
      isPlanned.hashCode ^
      isCompleted.hashCode;
  }
}
