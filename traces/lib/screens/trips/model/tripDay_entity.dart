import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:traces/screens/trips/model/dayAction_entity.dart';

class TripDayEnity extends Equatable {
  final String id;
  final String description;
  final DateTime date;
  final int dayNumber;
  final List<DayActionEntity> dayActions;
  final List<String> photoUrls;

  TripDayEnity({
    this.id,
    this.description,
    this.date,
    this.dayNumber,
    this.dayActions,
    this.photoUrls,
  });

  @override
  List<Object> get props {
    return [id, description, date, dayNumber, dayActions, photoUrls];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'dayNumber': dayNumber,
      'dayActions': dayActions?.map((x) => x.toMap())?.toList(),
      'photoUrls': photoUrls
    };
  }

  factory TripDayEnity.fromMap(Map<String, dynamic> map) {
    return TripDayEnity(
      id: map['id'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      dayNumber: map['dayNumber'],
      dayActions: List<DayActionEntity>.from(map['dayActions']?.map((x) => DayActionEntity.fromMap(x))),
      photoUrls: List<String>.from(map['photoUrls'])
    );
  }

  static TripDayEnity fromSnapshot(DocumentSnapshot snap){
    return TripDayEnity(
      id: snap.id,
      description: snap.data()['description'], 
      date: DateTime.fromMillisecondsSinceEpoch(snap.data()['date']), 
      dayNumber: snap.data()['dayNumber'] as int, 
      dayActions: List<DayActionEntity>.from(snap.data()['dayActions']?.map((x) => DayActionEntity.fromMap(x))),
      photoUrls: List<String>.from(snap.data()['photoUrls'])
    );
  }

  Map<String, Object> toDocument(){
    return{      
      "description": description!= '' ? description : 'No description',
      "date": date,
      "dayNumber": dayNumber,
      "dayActions": dayActions,
      "photoUrls": photoUrls
    };
  }

  String toJson() => json.encode(toMap());

  factory TripDayEnity.fromJson(String source) => TripDayEnity.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
