import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> photoUrls;
  final int peopleCount;

  TripEntity({
    this.id,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.photoUrls,
    this.peopleCount,
  });

  @override
  List<Object> get props {
    return [id, name, description, startDate, endDate, photoUrls, peopleCount];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'photoUrls': photoUrls,
      'peopleCount': peopleCount,
    };
  }

  factory TripEntity.fromMap(Map<String, dynamic> map) {
    print(inspect(map));
    return TripEntity(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      photoUrls: List<String>.from(map['photoUrls']),
      peopleCount: map['peopleCount'],
    );
  }

    static TripEntity fromSnapshot(DocumentSnapshot snap){
      print(inspect(snap.data()));
    return TripEntity(
      id: snap.id, 
      name: snap.data()['name'], 
      description: snap.data()['description'], 
      startDate: snap.data()['startDate'].toDate(), 
      endDate: snap.data()['endDate'].toDate(), 
      photoUrls: List<String>.from(snap.data()['photoUrls'] ?? <String>[]), 
      peopleCount: snap.data()['peopleCount']
    );
  }

  Map<String, Object> toDocument(){
    return{
      "name": name,
      "description": description!= '' ? description : 'No description',
      "startDate": startDate,
      "endDate": endDate,
      "photoUrls": photoUrls,
      "peopleCount": peopleCount
    };
  }

  String toJson() => json.encode(toMap());

  factory TripEntity.fromJson(String source) => TripEntity.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
