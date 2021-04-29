import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String coverImageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> photoUrls;
  final int peopleCount;

  TripEntity({
    this.id,
    this.name,
    this.description,
    this.coverImageUrl,
    this.startDate,
    this.endDate,
    this.photoUrls,
    this.peopleCount,
  });

  @override
  List<Object> get props {
    return [id, name, description, coverImageUrl, startDate, endDate, photoUrls, peopleCount];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverImageUrl': coverImageUrl,
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
      coverImageUrl: map['coverImageUrl'],
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
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
      coverImageUrl: snap.data()['coverImageUrl'], 
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
      "coverImageUrl": coverImageUrl,
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
