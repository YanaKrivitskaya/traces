import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/trip_entity.dart';

@immutable
class Trip {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> photoUrls;
  final int peopleCount;

  Trip({
    this.id,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.photoUrls,
    this.peopleCount,
  });

 TripEntity toEntity(){
    return TripEntity(
      id: id, 
      name: name, 
      description: description, 
      startDate: startDate, 
      endDate: endDate, 
      photoUrls: photoUrls, 
      peopleCount: peopleCount
    );
  }

  static Trip fromEntity(TripEntity entity){
    return Trip(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      photoUrls: entity.photoUrls,
      peopleCount: entity.peopleCount
    );
  }
  @override
  String toString() {
    return 'Trip(id: $id, name: $name, description: $description, startDate: $startDate, endDate: $endDate, photoUrls: $photoUrls, peopleCount: $peopleCount)';
  }

}
