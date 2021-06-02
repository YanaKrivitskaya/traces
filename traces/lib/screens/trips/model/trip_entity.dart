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
  final List<String> tripMembers;

  TripEntity({
    this.id,
    this.name,
    this.description,
    this.coverImageUrl,
    this.startDate,
    this.endDate,
    this.photoUrls,
    this.tripMembers,
  });

  @override
  List<Object> get props {
    return [id, name, description, coverImageUrl, startDate, endDate, photoUrls, tripMembers];
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
      'tripMembers': tripMembers,
    };
  }

  factory TripEntity.fromMap(Map<String, dynamic> map, String documentId) {
    return TripEntity(
      id: documentId,
      name: map['name'],
      description: map['description'],
      coverImageUrl: map['coverImageUrl'],
      startDate: map['startDate'].toDate(),
      endDate: map['endDate'].toDate(),
      photoUrls: List<String>.from(map['photoUrls'] ?? <String>[]),
      tripMembers: List<String>.from(map['tripMembers'] ?? <String>[]),
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
      tripMembers: List<String>.from(snap.data()['tripMembers'] ?? <String>[]), 
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
      "tripMembers": tripMembers
    };
  }

  String toJson() => json.encode(toMap());

  //factory TripEntity.fromJson(String source) => TripEntity.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
