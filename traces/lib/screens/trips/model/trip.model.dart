import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:traces/screens/profile/model/group_user_model.dart';
import 'package:traces/screens/trips/model/trip_action.model.dart';
import 'package:traces/screens/trips/model/trip_day.model.dart';

class Trip {
  final int? id;  
  final int? createdBy;
  final String? name;
  final String? description;
  final String? coverImage;  
  final DateTime? startDate;
  final DateTime? endDate;
  List<GroupUser>? users;  
  List<TripDay>? days;  
  List<TripAction>? actions;  

  Trip({
    this.id,
    this.createdBy,
    this.name,
    this.description,
    this.coverImage,
    this.startDate,
    this.endDate,
    this.users,
    this.days,
    this.actions,
  });

  Trip copyWith({
    int? id,
    int? createdBy,
    String? name,
    String? description,
    String? coverImage,
    DateTime? startDate,
    DateTime? endDate,
    List<GroupUser>? users,
    List<TripDay>? days,
    List<TripAction>? actions,
  }) {
    return Trip(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      users: users ?? this.users,
      days: days ?? this.days,
      actions: actions ?? this.actions
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'name': name,
      'description': description,
      'coverImage': coverImage,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'users': users?.map((x) => x.toMap()).toList(),
      'days': days?.map((x) => x.toMap()).toList(),
      'actions': actions?.map((x) => x.toMap()).toList(),
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      createdBy: map['createdBy'],
      name: map['name'],
      description: map['description'],
      coverImage: map['coverImage'],
      startDate: DateTime.parse(map['startDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      users: map['users'] != null ? List<GroupUser>.from(map['users']?.map((x) => GroupUser.fromMap(x))) : null,
      days: map['days'] != null ? List<TripDay>.from(map['days']?.map((x) => TripDay.fromMap(x))) : null,
      actions: map['actions'] != null ? List<TripAction>.from(map['actions']?.map((x) => TripAction.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Trip.fromJson(String source) => Trip.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Trip(id: $id, createdBy: $createdBy, name: $name, description: $description, coverImage: $coverImage, startDate: $startDate, endDate: $endDate, users: $users, days: $days, actions: $actions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Trip &&
      other.id == id &&
      other.createdBy == createdBy &&
      other.name == name &&
      other.description == description &&
      other.coverImage == coverImage &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      listEquals(other.users, users) &&
      listEquals(other.days, days) &&
      listEquals(other.actions, actions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      createdBy.hashCode ^
      name.hashCode ^
      description.hashCode ^
      coverImage.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      users.hashCode^
      days.hashCode^
      actions.hashCode;
  }
}


