import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:traces/screens/trips/model/booking.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';

import '../../profile/model/group_user_model.dart';
import 'activity.model.dart';


class Trip {
  final int? id;  
  final int? createdBy;
  final String? name;
  final String? description;
  final Uint8List? coverImage;  
  final DateTime? startDate;
  final DateTime? endDate;
  List<GroupUser>? users;
  List<Activity>? activities;  
  List<Expense>? expenses;  
  List<Ticket>? tickets;  
  List<Booking>? bookings;  

  Trip({
    this.id,
    this.createdBy,
    this.name,
    this.description,
    this.coverImage,
    this.startDate,
    this.endDate,
    this.users,
    this.activities,
    this.expenses,
    this.tickets,
    this.bookings,
  });

  Trip copyWith({
    int? id,
    int? createdBy,
    String? name,
    String? description,
    Uint8List? coverImage,
    DateTime? startDate,
    DateTime? endDate,
    List<GroupUser>? users, 
    List<Activity>? activities,
    List<Expense>? expenses,
    List<Ticket>? tickets,  
    List<Booking>? bookings 
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
      activities: activities ?? this.activities,
      expenses: expenses ?? this.expenses,
      tickets: tickets ?? this.tickets,
      bookings: bookings ?? this.bookings
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdBy': createdBy,
      'name': name,
      'description': description,
      //'coverImage': coverImage,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'users': users?.map((x) => x.toMap()).toList()      
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    if(map['coverImage'] != null){
      var cover = map['coverImage']['data'];
      var coverArray = map['coverImage']['data'].cast<int>();
    }
    
    return Trip(
      id: map['id'],
      createdBy: map['createdBy'],
      name: map['name'],
      description: map['description'],
      coverImage: map['coverImage'] != null ? Uint8List.fromList(map['coverImage']['data'].cast<int>()) : null,
      startDate: DateTime.parse(map['startDate']).toLocal(),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']).toLocal() : null,
      users: map['users'] != null ? List<GroupUser>.from(map['users']?.map((x) => GroupUser.fromMap(x))) : null,
      activities: map['activities'] != null ? List<Activity>.from(map['activities']?.map((x) => Activity.fromMap(x))) : null,
      expenses: map['expenses'] != null ? List<Expense>.from(map['expenses']?.map((x) => Expense.fromMap(x))) : null,
      tickets: map['tickets'] != null ? List<Ticket>.from(map['tickets']?.map((x) => Ticket.fromMap(x))) : null,
      bookings: map['bookings'] != null ? List<Booking>.from(map['bookings']?.map((x) => Booking.fromMap(x))) : null,
      
    );
  }

  String toJson() => json.encode(toMap());

  factory Trip.fromJson(String source) => Trip.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Trip(id: $id, createdBy: $createdBy, name: $name, description: $description, coverImage: $coverImage, startDate: $startDate, endDate: $endDate, users: $users, activities: $activities)';
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
      listEquals(other.activities, activities);
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
      activities.hashCode;
  }
}


