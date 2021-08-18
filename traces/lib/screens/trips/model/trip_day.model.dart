import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:traces/screens/trips/model/trip_action.model.dart';

@immutable
class TripDay {
  final int? id;
  final DateTime? date;
  final String name;
  final String? description;
  final String? image;
  final int? dayNumber;
  final List<TripAction>? actions;
  
  TripDay({
    this.id,
    this.date,
    required this.name,
    this.description,
    this.image,
    this.dayNumber,
    this.actions,
  });

  TripDay copyWith({
    int? id,
    DateTime? date,
    String? name,
    String? description,
    String? image,
    int? dayNumber,
    List<TripAction>? actions,
  }) {
    return TripDay(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      dayNumber: dayNumber ?? this.dayNumber,
      actions: actions ?? this.actions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'name': name,
      'description': description,
      'image': image,
      'dayNumber': dayNumber,
      'actions': actions?.map((x) => x.toMap()).toList(),
    };
  }

  factory TripDay.fromMap(Map<String, dynamic> map) {
    return TripDay(
      id: map['id'],
      date: DateTime.parse(map['date']),
      name: map['name'],
      description: map['description'],
      image: map['image'],
      dayNumber: map['dayNumber'],
      actions: map['actions'] != null ? List<TripAction>.from(map['actions']?.map((x) => TripAction.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TripDay.fromJson(String source) => TripDay.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TripDay(id: $id, date: $date, name: $name, description: $description, image: $image, dayNumber: $dayNumber, actions: $actions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TripDay &&
      other.id == id &&
      other.date == date &&
      other.name == name &&
      other.description == description &&
      other.image == image &&
      other.dayNumber == dayNumber &&
      listEquals(other.actions, actions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      date.hashCode ^
      name.hashCode ^
      description.hashCode ^
      image.hashCode ^
      dayNumber.hashCode ^
      actions.hashCode;
  }
}
