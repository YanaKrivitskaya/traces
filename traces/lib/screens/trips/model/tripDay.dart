import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'package:traces/screens/trips/model/dayAction_entity.dart';
import 'package:traces/screens/trips/model/tripDay_entity.dart';

@immutable
class TripDay {
  final String id;
  final String description;
  final DateTime date;
  final int dayNumber;
  final List<DayActionEntity> dayActions;
  final List<String> photoUrls;

  TripDay({
    this.id,
    this.description,
    this.date,
    this.dayNumber,
    this.dayActions,
    this.photoUrls,
  });

  @override
  String toString() {
    return 'TripDay(id: $id, description: $description, date: $date, dayNumber: $dayNumber, dayActions: $dayActions, photoUrls: $photoUrls)';
  }

  TripDayEnity toEntity(){
    return TripDayEnity(
      id: id, 
      description: description, 
      date: date, 
      dayNumber: dayNumber,
      dayActions: dayActions,
      photoUrls: photoUrls
    );
  }

  static TripDay fromEntity(TripDayEnity entity){
    return TripDay(
      id: entity.id,
      description: entity.description,
      date: entity.date,
      dayNumber: entity.dayNumber,
      dayActions: entity.dayActions,
      photoUrls: entity.photoUrls
    );
  }
}
